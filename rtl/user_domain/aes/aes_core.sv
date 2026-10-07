// AES-128 encryption core, iterative: one round per clock cycle.
//
// Pulse start_i with key_i and block_i valid. 11 cycles later done_o pulses
// and block_o holds the ciphertext (it stays valid until the next start).
// Byte order follows FIPS-197: byte 0 of the block/key is bits [127:120].
// The round keys are expanded on the fly, so no key RAM is needed.
module aes_core (
  input  logic         clk_i,
  input  logic         rst_ni,
  input  logic         start_i,
  input  logic [127:0] key_i,
  input  logic [127:0] block_i,
  output logic         busy_o,
  output logic         done_o,
  output logic [127:0] block_o
);

  logic [127:0] state_q, state_d;
  logic [127:0] rkey_q,  rkey_d;
  logic [3:0]   round_q, round_d;   // 0 = idle, 1..10 = round being computed
  logic [7:0]   rcon_q,  rcon_d;
  logic         done_d,  done_q;

  // Byte n of a 128-bit word in FIPS-197 order
  function automatic logic [7:0] get_byte(logic [127:0] w, int n);
    return w[127-8*n -: 8];
  endfunction

  // Multiply by x in GF(2^8)
  function automatic logic [7:0] xtime(logic [7:0] b);
    return {b[6:0], 1'b0} ^ (b[7] ? 8'h1b : 8'h00);
  endfunction

  //////////////
  // SubBytes //
  //////////////
  logic [127:0] sub_bytes;
  for (genvar i = 0; i < 16; i++) begin : gen_sbox
    aes_sbox i_sbox (
      .in_i  ( state_q[127-8*i -: 8]   ),
      .out_o ( sub_bytes[127-8*i -: 8] )
    );
  end

  ///////////////
  // ShiftRows //
  ///////////////
  // Byte n = row r + 4*column c. Row r is rotated left by r columns.
  logic [127:0] shift_rows;
  always_comb begin
    for (int c = 0; c < 4; c++) begin
      for (int r = 0; r < 4; r++) begin
        shift_rows[127-8*(r+4*c) -: 8] = get_byte(sub_bytes, r + 4*((c+r)%4));
      end
    end
  end

  ////////////////
  // MixColumns //
  ////////////////
  logic [127:0] mix_cols;
  always_comb begin
    for (int c = 0; c < 4; c++) begin
      logic [7:0] a0, a1, a2, a3;
      a0 = get_byte(shift_rows, 4*c+0);
      a1 = get_byte(shift_rows, 4*c+1);
      a2 = get_byte(shift_rows, 4*c+2);
      a3 = get_byte(shift_rows, 4*c+3);
      mix_cols[127-8*(4*c+0) -: 8] = xtime(a0) ^ (xtime(a1) ^ a1) ^ a2 ^ a3;
      mix_cols[127-8*(4*c+1) -: 8] = a0 ^ xtime(a1) ^ (xtime(a2) ^ a2) ^ a3;
      mix_cols[127-8*(4*c+2) -: 8] = a0 ^ a1 ^ xtime(a2) ^ (xtime(a3) ^ a3);
      mix_cols[127-8*(4*c+3) -: 8] = (xtime(a0) ^ a0) ^ a1 ^ a2 ^ xtime(a3);
    end
  end

  ////////////////////
  // Key expansion  //
  ////////////////////
  // Next round key from the current one: w4 = w0 ^ SubWord(RotWord(w3)) ^ Rcon, ...
  logic [31:0]  w0, w1, w2, w3, sub_rot;
  logic [127:0] next_rkey;
  assign {w0, w1, w2, w3} = rkey_q;

  for (genvar i = 0; i < 4; i++) begin : gen_key_sbox
    // RotWord: bytes [b1 b2 b3 b0]
    aes_sbox i_sbox (
      .in_i  ( w3[31-8*((i+1)%4) -: 8] ),
      .out_o ( sub_rot[31-8*i -: 8]    )
    );
  end

  always_comb begin
    logic [31:0] n0, n1, n2, n3;
    n0 = w0 ^ sub_rot ^ {rcon_q, 24'h0};
    n1 = w1 ^ n0;
    n2 = w2 ^ n1;
    n3 = w3 ^ n2;
    next_rkey = {n0, n1, n2, n3};
  end

  ///////////////////
  // Round control //
  ///////////////////
  always_comb begin
    state_d = state_q;
    rkey_d  = rkey_q;
    round_d = round_q;
    rcon_d  = rcon_q;
    done_d  = 1'b0;

    if (start_i && round_q == 4'd0) begin
      // Round 0: AddRoundKey with the cipher key
      state_d = block_i ^ key_i;
      rkey_d  = key_i;
      round_d = 4'd1;
      rcon_d  = 8'h01;
    end else if (round_q != 4'd0) begin
      // Round 10 skips MixColumns
      state_d = ((round_q == 4'd10) ? shift_rows : mix_cols) ^ next_rkey;
      rkey_d  = next_rkey;
      rcon_d  = xtime(rcon_q);
      if (round_q == 4'd10) begin
        round_d = 4'd0;
        done_d  = 1'b1;
      end else begin
        round_d = round_q + 4'd1;
      end
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state_q <= '0;
      rkey_q  <= '0;
      round_q <= '0;
      rcon_q  <= '0;
      done_q  <= 1'b0;
    end else begin
      state_q <= state_d;
      rkey_q  <= rkey_d;
      round_q <= round_d;
      rcon_q  <= rcon_d;
      done_q  <= done_d;
    end
  end

  assign busy_o  = (round_q != 4'd0);
  assign done_o  = done_q;
  assign block_o = state_q;

endmodule
