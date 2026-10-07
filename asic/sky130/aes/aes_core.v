module aes_sbox (
	in_i,
	out_o
);
	reg _sv2v_0;
	input wire [7:0] in_i;
	output reg [7:0] out_o;
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		case (in_i)
			8'h00: out_o = 8'h63;
			8'h01: out_o = 8'h7c;
			8'h02: out_o = 8'h77;
			8'h03: out_o = 8'h7b;
			8'h04: out_o = 8'hf2;
			8'h05: out_o = 8'h6b;
			8'h06: out_o = 8'h6f;
			8'h07: out_o = 8'hc5;
			8'h08: out_o = 8'h30;
			8'h09: out_o = 8'h01;
			8'h0a: out_o = 8'h67;
			8'h0b: out_o = 8'h2b;
			8'h0c: out_o = 8'hfe;
			8'h0d: out_o = 8'hd7;
			8'h0e: out_o = 8'hab;
			8'h0f: out_o = 8'h76;
			8'h10: out_o = 8'hca;
			8'h11: out_o = 8'h82;
			8'h12: out_o = 8'hc9;
			8'h13: out_o = 8'h7d;
			8'h14: out_o = 8'hfa;
			8'h15: out_o = 8'h59;
			8'h16: out_o = 8'h47;
			8'h17: out_o = 8'hf0;
			8'h18: out_o = 8'had;
			8'h19: out_o = 8'hd4;
			8'h1a: out_o = 8'ha2;
			8'h1b: out_o = 8'haf;
			8'h1c: out_o = 8'h9c;
			8'h1d: out_o = 8'ha4;
			8'h1e: out_o = 8'h72;
			8'h1f: out_o = 8'hc0;
			8'h20: out_o = 8'hb7;
			8'h21: out_o = 8'hfd;
			8'h22: out_o = 8'h93;
			8'h23: out_o = 8'h26;
			8'h24: out_o = 8'h36;
			8'h25: out_o = 8'h3f;
			8'h26: out_o = 8'hf7;
			8'h27: out_o = 8'hcc;
			8'h28: out_o = 8'h34;
			8'h29: out_o = 8'ha5;
			8'h2a: out_o = 8'he5;
			8'h2b: out_o = 8'hf1;
			8'h2c: out_o = 8'h71;
			8'h2d: out_o = 8'hd8;
			8'h2e: out_o = 8'h31;
			8'h2f: out_o = 8'h15;
			8'h30: out_o = 8'h04;
			8'h31: out_o = 8'hc7;
			8'h32: out_o = 8'h23;
			8'h33: out_o = 8'hc3;
			8'h34: out_o = 8'h18;
			8'h35: out_o = 8'h96;
			8'h36: out_o = 8'h05;
			8'h37: out_o = 8'h9a;
			8'h38: out_o = 8'h07;
			8'h39: out_o = 8'h12;
			8'h3a: out_o = 8'h80;
			8'h3b: out_o = 8'he2;
			8'h3c: out_o = 8'heb;
			8'h3d: out_o = 8'h27;
			8'h3e: out_o = 8'hb2;
			8'h3f: out_o = 8'h75;
			8'h40: out_o = 8'h09;
			8'h41: out_o = 8'h83;
			8'h42: out_o = 8'h2c;
			8'h43: out_o = 8'h1a;
			8'h44: out_o = 8'h1b;
			8'h45: out_o = 8'h6e;
			8'h46: out_o = 8'h5a;
			8'h47: out_o = 8'ha0;
			8'h48: out_o = 8'h52;
			8'h49: out_o = 8'h3b;
			8'h4a: out_o = 8'hd6;
			8'h4b: out_o = 8'hb3;
			8'h4c: out_o = 8'h29;
			8'h4d: out_o = 8'he3;
			8'h4e: out_o = 8'h2f;
			8'h4f: out_o = 8'h84;
			8'h50: out_o = 8'h53;
			8'h51: out_o = 8'hd1;
			8'h52: out_o = 8'h00;
			8'h53: out_o = 8'hed;
			8'h54: out_o = 8'h20;
			8'h55: out_o = 8'hfc;
			8'h56: out_o = 8'hb1;
			8'h57: out_o = 8'h5b;
			8'h58: out_o = 8'h6a;
			8'h59: out_o = 8'hcb;
			8'h5a: out_o = 8'hbe;
			8'h5b: out_o = 8'h39;
			8'h5c: out_o = 8'h4a;
			8'h5d: out_o = 8'h4c;
			8'h5e: out_o = 8'h58;
			8'h5f: out_o = 8'hcf;
			8'h60: out_o = 8'hd0;
			8'h61: out_o = 8'hef;
			8'h62: out_o = 8'haa;
			8'h63: out_o = 8'hfb;
			8'h64: out_o = 8'h43;
			8'h65: out_o = 8'h4d;
			8'h66: out_o = 8'h33;
			8'h67: out_o = 8'h85;
			8'h68: out_o = 8'h45;
			8'h69: out_o = 8'hf9;
			8'h6a: out_o = 8'h02;
			8'h6b: out_o = 8'h7f;
			8'h6c: out_o = 8'h50;
			8'h6d: out_o = 8'h3c;
			8'h6e: out_o = 8'h9f;
			8'h6f: out_o = 8'ha8;
			8'h70: out_o = 8'h51;
			8'h71: out_o = 8'ha3;
			8'h72: out_o = 8'h40;
			8'h73: out_o = 8'h8f;
			8'h74: out_o = 8'h92;
			8'h75: out_o = 8'h9d;
			8'h76: out_o = 8'h38;
			8'h77: out_o = 8'hf5;
			8'h78: out_o = 8'hbc;
			8'h79: out_o = 8'hb6;
			8'h7a: out_o = 8'hda;
			8'h7b: out_o = 8'h21;
			8'h7c: out_o = 8'h10;
			8'h7d: out_o = 8'hff;
			8'h7e: out_o = 8'hf3;
			8'h7f: out_o = 8'hd2;
			8'h80: out_o = 8'hcd;
			8'h81: out_o = 8'h0c;
			8'h82: out_o = 8'h13;
			8'h83: out_o = 8'hec;
			8'h84: out_o = 8'h5f;
			8'h85: out_o = 8'h97;
			8'h86: out_o = 8'h44;
			8'h87: out_o = 8'h17;
			8'h88: out_o = 8'hc4;
			8'h89: out_o = 8'ha7;
			8'h8a: out_o = 8'h7e;
			8'h8b: out_o = 8'h3d;
			8'h8c: out_o = 8'h64;
			8'h8d: out_o = 8'h5d;
			8'h8e: out_o = 8'h19;
			8'h8f: out_o = 8'h73;
			8'h90: out_o = 8'h60;
			8'h91: out_o = 8'h81;
			8'h92: out_o = 8'h4f;
			8'h93: out_o = 8'hdc;
			8'h94: out_o = 8'h22;
			8'h95: out_o = 8'h2a;
			8'h96: out_o = 8'h90;
			8'h97: out_o = 8'h88;
			8'h98: out_o = 8'h46;
			8'h99: out_o = 8'hee;
			8'h9a: out_o = 8'hb8;
			8'h9b: out_o = 8'h14;
			8'h9c: out_o = 8'hde;
			8'h9d: out_o = 8'h5e;
			8'h9e: out_o = 8'h0b;
			8'h9f: out_o = 8'hdb;
			8'ha0: out_o = 8'he0;
			8'ha1: out_o = 8'h32;
			8'ha2: out_o = 8'h3a;
			8'ha3: out_o = 8'h0a;
			8'ha4: out_o = 8'h49;
			8'ha5: out_o = 8'h06;
			8'ha6: out_o = 8'h24;
			8'ha7: out_o = 8'h5c;
			8'ha8: out_o = 8'hc2;
			8'ha9: out_o = 8'hd3;
			8'haa: out_o = 8'hac;
			8'hab: out_o = 8'h62;
			8'hac: out_o = 8'h91;
			8'had: out_o = 8'h95;
			8'hae: out_o = 8'he4;
			8'haf: out_o = 8'h79;
			8'hb0: out_o = 8'he7;
			8'hb1: out_o = 8'hc8;
			8'hb2: out_o = 8'h37;
			8'hb3: out_o = 8'h6d;
			8'hb4: out_o = 8'h8d;
			8'hb5: out_o = 8'hd5;
			8'hb6: out_o = 8'h4e;
			8'hb7: out_o = 8'ha9;
			8'hb8: out_o = 8'h6c;
			8'hb9: out_o = 8'h56;
			8'hba: out_o = 8'hf4;
			8'hbb: out_o = 8'hea;
			8'hbc: out_o = 8'h65;
			8'hbd: out_o = 8'h7a;
			8'hbe: out_o = 8'hae;
			8'hbf: out_o = 8'h08;
			8'hc0: out_o = 8'hba;
			8'hc1: out_o = 8'h78;
			8'hc2: out_o = 8'h25;
			8'hc3: out_o = 8'h2e;
			8'hc4: out_o = 8'h1c;
			8'hc5: out_o = 8'ha6;
			8'hc6: out_o = 8'hb4;
			8'hc7: out_o = 8'hc6;
			8'hc8: out_o = 8'he8;
			8'hc9: out_o = 8'hdd;
			8'hca: out_o = 8'h74;
			8'hcb: out_o = 8'h1f;
			8'hcc: out_o = 8'h4b;
			8'hcd: out_o = 8'hbd;
			8'hce: out_o = 8'h8b;
			8'hcf: out_o = 8'h8a;
			8'hd0: out_o = 8'h70;
			8'hd1: out_o = 8'h3e;
			8'hd2: out_o = 8'hb5;
			8'hd3: out_o = 8'h66;
			8'hd4: out_o = 8'h48;
			8'hd5: out_o = 8'h03;
			8'hd6: out_o = 8'hf6;
			8'hd7: out_o = 8'h0e;
			8'hd8: out_o = 8'h61;
			8'hd9: out_o = 8'h35;
			8'hda: out_o = 8'h57;
			8'hdb: out_o = 8'hb9;
			8'hdc: out_o = 8'h86;
			8'hdd: out_o = 8'hc1;
			8'hde: out_o = 8'h1d;
			8'hdf: out_o = 8'h9e;
			8'he0: out_o = 8'he1;
			8'he1: out_o = 8'hf8;
			8'he2: out_o = 8'h98;
			8'he3: out_o = 8'h11;
			8'he4: out_o = 8'h69;
			8'he5: out_o = 8'hd9;
			8'he6: out_o = 8'h8e;
			8'he7: out_o = 8'h94;
			8'he8: out_o = 8'h9b;
			8'he9: out_o = 8'h1e;
			8'hea: out_o = 8'h87;
			8'heb: out_o = 8'he9;
			8'hec: out_o = 8'hce;
			8'hed: out_o = 8'h55;
			8'hee: out_o = 8'h28;
			8'hef: out_o = 8'hdf;
			8'hf0: out_o = 8'h8c;
			8'hf1: out_o = 8'ha1;
			8'hf2: out_o = 8'h89;
			8'hf3: out_o = 8'h0d;
			8'hf4: out_o = 8'hbf;
			8'hf5: out_o = 8'he6;
			8'hf6: out_o = 8'h42;
			8'hf7: out_o = 8'h68;
			8'hf8: out_o = 8'h41;
			8'hf9: out_o = 8'h99;
			8'hfa: out_o = 8'h2d;
			8'hfb: out_o = 8'h0f;
			8'hfc: out_o = 8'hb0;
			8'hfd: out_o = 8'h54;
			8'hfe: out_o = 8'hbb;
			8'hff: out_o = 8'h16;
			default: out_o = 8'h00;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module aes_core (
	clk_i,
	rst_ni,
	start_i,
	key_i,
	block_i,
	busy_o,
	done_o,
	block_o
);
	reg _sv2v_0;
	input wire clk_i;
	input wire rst_ni;
	input wire start_i;
	input wire [127:0] key_i;
	input wire [127:0] block_i;
	output wire busy_o;
	output wire done_o;
	output wire [127:0] block_o;
	reg [127:0] state_q;
	reg [127:0] state_d;
	reg [127:0] rkey_q;
	reg [127:0] rkey_d;
	reg [3:0] round_q;
	reg [3:0] round_d;
	reg [7:0] rcon_q;
	reg [7:0] rcon_d;
	reg done_d;
	reg done_q;
	function automatic [7:0] get_byte;
		input reg [127:0] w;
		input reg signed [31:0] n;
		get_byte = w[127 - (8 * n)-:8];
	endfunction
	function automatic [7:0] xtime;
		input reg [7:0] b;
		xtime = {b[6:0], 1'b0} ^ (b[7] ? 8'h1b : 8'h00);
	endfunction
	wire [127:0] sub_bytes;
	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < 16; _gv_i_1 = _gv_i_1 + 1) begin : gen_sbox
			localparam i = _gv_i_1;
			aes_sbox i_sbox(
				.in_i(state_q[127 - (8 * i)-:8]),
				.out_o(sub_bytes[127 - (8 * i)-:8])
			);
		end
	endgenerate
	reg [127:0] shift_rows;
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_1
			reg signed [31:0] c;
			for (c = 0; c < 4; c = c + 1)
				begin : sv2v_autoblock_2
					reg signed [31:0] r;
					for (r = 0; r < 4; r = r + 1)
						shift_rows[127 - (8 * (r + (4 * c)))-:8] = get_byte(sub_bytes, r + (4 * ((c + r) % 4)));
				end
		end
	end
	reg [127:0] mix_cols;
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_3
			reg signed [31:0] c;
			for (c = 0; c < 4; c = c + 1)
				begin : sv2v_autoblock_4
					reg [7:0] a0;
					reg [7:0] a1;
					reg [7:0] a2;
					reg [7:0] a3;
					a0 = get_byte(shift_rows, (4 * c) + 0);
					a1 = get_byte(shift_rows, (4 * c) + 1);
					a2 = get_byte(shift_rows, (4 * c) + 2);
					a3 = get_byte(shift_rows, (4 * c) + 3);
					mix_cols[127 - (8 * ((4 * c) + 0))-:8] = ((xtime(a0) ^ (xtime(a1) ^ a1)) ^ a2) ^ a3;
					mix_cols[127 - (8 * ((4 * c) + 1))-:8] = ((a0 ^ xtime(a1)) ^ (xtime(a2) ^ a2)) ^ a3;
					mix_cols[127 - (8 * ((4 * c) + 2))-:8] = ((a0 ^ a1) ^ xtime(a2)) ^ (xtime(a3) ^ a3);
					mix_cols[127 - (8 * ((4 * c) + 3))-:8] = (((xtime(a0) ^ a0) ^ a1) ^ a2) ^ xtime(a3);
				end
		end
	end
	wire [31:0] w0;
	wire [31:0] w1;
	wire [31:0] w2;
	wire [31:0] w3;
	wire [31:0] sub_rot;
	reg [127:0] next_rkey;
	assign {w0, w1, w2, w3} = rkey_q;
	genvar _gv_i_2;
	generate
		for (_gv_i_2 = 0; _gv_i_2 < 4; _gv_i_2 = _gv_i_2 + 1) begin : gen_key_sbox
			localparam i = _gv_i_2;
			aes_sbox i_sbox(
				.in_i(w3[31 - (8 * ((i + 1) % 4))-:8]),
				.out_o(sub_rot[31 - (8 * i)-:8])
			);
		end
	endgenerate
	always @(*) begin : sv2v_autoblock_5
		reg [31:0] n0;
		reg [31:0] n1;
		reg [31:0] n2;
		reg [31:0] n3;
		if (_sv2v_0)
			;
		n0 = (w0 ^ sub_rot) ^ {rcon_q, 24'h000000};
		n1 = w1 ^ n0;
		n2 = w2 ^ n1;
		n3 = w3 ^ n2;
		next_rkey = {n0, n1, n2, n3};
	end
	always @(*) begin
		if (_sv2v_0)
			;
		state_d = state_q;
		rkey_d = rkey_q;
		round_d = round_q;
		rcon_d = rcon_q;
		done_d = 1'b0;
		if (start_i && (round_q == 4'd0)) begin
			state_d = block_i ^ key_i;
			rkey_d = key_i;
			round_d = 4'd1;
			rcon_d = 8'h01;
		end
		else if (round_q != 4'd0) begin
			state_d = (round_q == 4'd10 ? shift_rows : mix_cols) ^ next_rkey;
			rkey_d = next_rkey;
			rcon_d = xtime(rcon_q);
			if (round_q == 4'd10) begin
				round_d = 4'd0;
				done_d = 1'b1;
			end
			else
				round_d = round_q + 4'd1;
		end
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			state_q <= 1'sb0;
			rkey_q <= 1'sb0;
			round_q <= 1'sb0;
			rcon_q <= 1'sb0;
			done_q <= 1'b0;
		end
		else begin
			state_q <= state_d;
			rkey_q <= rkey_d;
			round_q <= round_d;
			rcon_q <= rcon_d;
			done_q <= done_d;
		end
	assign busy_o = round_q != 4'd0;
	assign done_o = done_q;
	assign block_o = state_q;
	initial _sv2v_0 = 0;
endmodule
