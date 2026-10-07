// Sky130 (sky130_fd_sc_hd) implementation of the tech_cells_generic clock cells.

module tc_clk_inverter (
  input  logic clk_i,
  output logic clk_o
);
  (* keep *)(* dont_touch = "true" *)
  sky130_fd_sc_hd__clkinv_1 i_inv (
    .A ( clk_i ),
    .Y ( clk_o )
  );
endmodule

module tc_clk_buffer (
  input  logic clk_i,
  output logic clk_o
);
  (* keep *)(* dont_touch = "true" *)
  sky130_fd_sc_hd__clkbuf_1 i_buf (
    .A ( clk_i ),
    .X ( clk_o )
  );
endmodule

module tc_clk_mux2 (
  input  logic clk0_i,
  input  logic clk1_i,
  input  logic clk_sel_i,
  output logic clk_o
);
  (* keep *)(* dont_touch = "true" *)
  sky130_fd_sc_hd__mux2_1 i_mux (
    .A0 ( clk0_i    ),
    .A1 ( clk1_i    ),
    .S  ( clk_sel_i ),
    .X  ( clk_o     )
  );
endmodule

module tc_clk_xor2 (
  input  logic clk0_i,
  input  logic clk1_i,
  output logic clk_o
);
  (* keep *)(* dont_touch = "true" *)
  sky130_fd_sc_hd__xor2_1 i_xor (
    .A ( clk0_i ),
    .B ( clk1_i ),
    .X ( clk_o  )
  );
endmodule

module tc_clk_gating #(
  parameter bit IS_FUNCTIONAL = 1'b1
)(
  input  logic clk_i,
  input  logic en_i,
  input  logic test_en_i,
  output logic clk_o
);
  if (IS_FUNCTIONAL || `ifdef USE_CLKGATE 1 `else 0 `endif) begin : gen_clkgate
    (* keep *)(* dont_touch = "true" *)
    sky130_fd_sc_hd__sdlclkp_1 i_clkgate (
      .GATE ( en_i      ),
      .SCE  ( test_en_i ),
      .CLK  ( clk_i     ),
      .GCLK ( clk_o     )
    );
  end else begin : gen_no_clkgate
    assign clk_o = clk_i;
  end
endmodule
