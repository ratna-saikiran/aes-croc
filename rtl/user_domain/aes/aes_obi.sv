// AES-128 encryption accelerator as an OBI subordinate for the Croc user domain.
//
// Register map (32-bit words, offsets from the peripheral base):
//   0x00 CTRL    W   bit0: start (ignored while busy)
//   0x04 STATUS  R   bit0: busy, bit1: done (sticky; cleared by start or by writing 1)
//   0x10-0x1C KEY0..3   RW  cipher key
//   0x20-0x2C DIN0..3   RW  plaintext block
//   0x30-0x3C DOUT0..3  R   ciphertext block
// Word i holds bytes 4i..4i+3 little-endian, so copying a uint8_t[16] into the
// four registers gives the byte order FIPS-197 expects.
// irq_o is high while the sticky done flag is set.
module aes_obi #(
  parameter type obi_req_t = logic,
  parameter type obi_rsp_t = logic
) (
  input  logic     clk_i,
  input  logic     rst_ni,
  input  obi_req_t obi_req_i,
  output obi_rsp_t obi_rsp_o,
  output logic     irq_o
);

  localparam logic [11:0] CtrlOffset   = 12'h000;
  localparam logic [11:0] StatusOffset = 12'h004;
  localparam logic [11:0] KeyOffset    = 12'h010;
  localparam logic [11:0] DinOffset    = 12'h020;
  localparam logic [11:0] DoutOffset   = 12'h030;

  logic [3:0][31:0] key_d,  key_q;
  logic [3:0][31:0] din_d,  din_q;
  logic             done_d, done_q;
  logic             start;

  obi_req_t    obi_req_q;
  logic        err_d,   err_q;
  logic [31:0] rdata_d, rdata_q;

  logic         core_busy, core_done;
  logic [127:0] core_key, core_din, core_dout;
  logic [3:0][31:0] dout;

  // Register words (little-endian bytes) <-> FIPS-197 byte order of the core
  for (genvar n = 0; n < 16; n++) begin : gen_byte_map
    assign core_key[127-8*n -: 8]   = key_q[n/4][8*(n%4) +: 8];
    assign core_din[127-8*n -: 8]   = din_q[n/4][8*(n%4) +: 8];
    assign dout[n/4][8*(n%4) +: 8] = core_dout[127-8*n -: 8];
  end

  aes_core i_aes_core (
    .clk_i,
    .rst_ni,
    .start_i ( start     ),
    .key_i   ( core_key  ),
    .block_i ( core_din  ),
    .busy_o  ( core_busy ),
    .done_o  ( core_done ),
    .block_o ( core_dout )
  );

  // bit enable mask: defines which bits are written to by wdata of the OBI request
  logic [31:0] be_mask;
  for (genvar i = 0; i < 4; i++) begin : gen_write_mask
    assign be_mask[8*i +: 8] = {8{obi_req_i.a.be[i]}};
  end

  always_comb begin : obi_response
    obi_rsp_o         = '0;
    obi_rsp_o.gnt     = 1'b1;
    obi_rsp_o.rvalid  = obi_req_q.req;
    obi_rsp_o.r.err   = err_q;
    obi_rsp_o.r.rid   = obi_req_q.a.aid;
    obi_rsp_o.r.rdata = rdata_q;
  end

  always_comb begin
    logic [11:0] offset;
    offset  = {obi_req_i.a.addr[11:2], 2'b00};
    key_d   = key_q;
    din_d   = din_q;
    done_d  = done_q | core_done;
    start   = 1'b0;
    err_d   = 1'b0;
    rdata_d = '0;

    if (obi_req_i.req) begin
      if (obi_req_i.a.we) begin : write
        if (offset == CtrlOffset) begin
          if (obi_req_i.a.wdata[0] && be_mask[0] && !core_busy) begin
            start  = 1'b1;
            done_d = 1'b0;
          end
        end else if (offset == StatusOffset) begin
          if (obi_req_i.a.wdata[1] && be_mask[1]) done_d = 1'b0;
        end else if (offset[11:4] == KeyOffset[11:4]) begin
          key_d[offset[3:2]] = (key_q[offset[3:2]] & ~be_mask) | (obi_req_i.a.wdata & be_mask);
        end else if (offset[11:4] == DinOffset[11:4]) begin
          din_d[offset[3:2]] = (din_q[offset[3:2]] & ~be_mask) | (obi_req_i.a.wdata & be_mask);
        end else begin
          err_d = 1'b1;
        end
      end else begin : read
        if (offset == CtrlOffset) begin
          rdata_d = '0;
        end else if (offset == StatusOffset) begin
          rdata_d = {30'h0, done_q, core_busy};
        end else if (offset[11:4] == KeyOffset[11:4]) begin
          rdata_d = key_q[offset[3:2]];
        end else if (offset[11:4] == DinOffset[11:4]) begin
          rdata_d = din_q[offset[3:2]];
        end else if (offset[11:4] == DoutOffset[11:4]) begin
          rdata_d = dout[offset[3:2]];
        end else begin
          rdata_d = 32'hBADCAB1E;
          err_d   = 1'b1;
        end
      end
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      key_q     <= '0;
      din_q     <= '0;
      done_q    <= 1'b0;
      obi_req_q <= '0;
      err_q     <= 1'b0;
      rdata_q   <= '0;
    end else begin
      key_q     <= key_d;
      din_q     <= din_d;
      done_q    <= done_d;
      obi_req_q <= obi_req_i;
      err_q     <= err_d;
      rdata_q   <= rdata_d;
    end
  end

  assign irq_o = done_q;

endmodule
