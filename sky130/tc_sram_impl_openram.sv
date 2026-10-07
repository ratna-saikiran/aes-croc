// Sky130 tc_sram_impl using OpenRAM macros (NOT used by default, kept for a later step).
//
// Maps each 512x32 Croc SRAM bank onto one sky130_sram_1rw1r_64x256_8 macro.
// Word address bit 0 picks the lower or upper 32-bit half of a macro row; the
// write mask enables only that half, and read data is selected with the
// registered address bit. The macro's read-only second port is unused.
// Before using it: the macro's vdd/gnd pins are small met3 shapes, so the PDN
// needs a macro grid that drops met4 straps onto them.

module tc_sram_blackbox #(
  parameter int unsigned NumWords     = 32'd0,
  parameter int unsigned DataWidth    = 32'd0,
  parameter int unsigned ByteWidth    = 32'd0,
  parameter int unsigned NumPorts     = 32'd0,
  parameter int unsigned Latency      = 32'd0,
  parameter              SimInit      = "none",
  parameter bit          PrintSimCfg  = 1'b0,
  parameter              ImplKey      = "none"
) ();
endmodule

module tc_sram_impl #(
  parameter int unsigned NumWords     = 32'd1024,
  parameter int unsigned DataWidth    = 32'd128,
  parameter int unsigned ByteWidth    = 32'd8,
  parameter int unsigned NumPorts     = 32'd2,
  parameter int unsigned Latency      = 32'd1,
  parameter              SimInit      = "none",
  parameter bit          PrintSimCfg  = 1'b0,
  parameter              ImplKey      = "none",
  parameter type         impl_in_t    = logic,
  parameter type         impl_out_t   = logic,
  parameter impl_out_t   ImplOutSim   = '0,
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth,
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,

  input  impl_in_t             impl_i,
  output impl_out_t            impl_o,

  input  logic  [NumPorts-1:0] req_i,
  input  logic  [NumPorts-1:0] we_i,
  input  addr_t [NumPorts-1:0] addr_i,
  input  data_t [NumPorts-1:0] wdata_i,
  input  be_t   [NumPorts-1:0] be_i,

  output data_t [NumPorts-1:0] rdata_o
);

  localparam bit P1L1 = (NumPorts == 1 && Latency == 1);

  assign impl_o = ImplOutSim;

  if (NumWords == 512 && DataWidth == 32 && ByteWidth == 8 && P1L1) begin : gen_512x32
    logic        half_q;
    logic [63:0] dout0, dout1;
    logic [7:0]  wmask;

    assign wmask = addr_i[0][0] ? {be_i[0], 4'b0} : {4'b0, be_i[0]};

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni)                     half_q <= 1'b0;
      else if (req_i[0] && !we_i[0])   half_q <= addr_i[0][0];
    end

    sky130_sram_1rw1r_64x256_8 i_cut (
      .clk0   ( clk_i                    ),
      .csb0   ( ~req_i[0]                ),
      .web0   ( ~we_i[0]                 ),
      .wmask0 ( wmask                    ),
      .addr0  ( addr_i[0][8:1]           ),
      .din0   ( {2{wdata_i[0]}}          ),
      .dout0  ( dout0                    ),
      .clk1   ( clk_i                    ),
      .csb1   ( 1'b1                     ),
      .addr1  ( 8'd0                     ),
      .dout1  ( dout1                    )
    );

    assign rdata_o[0] = half_q ? dout0[63:32] : dout0[31:0];

  end else begin : gen_blackbox
    // synopsys translate_off
    initial $fatal(1, "No Sky130 tc_sram for %m: NumWords %0d, DataWidth %0d, NumPorts %0d, Latency %0d",
                   NumWords, DataWidth, NumPorts, Latency);
    // synopsys translate_on
    tc_sram_blackbox #(
      .NumWords ( NumWords ), .DataWidth ( DataWidth ), .ByteWidth ( ByteWidth ),
      .NumPorts ( NumPorts ), .Latency   ( Latency   ), .SimInit   ( SimInit   ),
      .PrintSimCfg ( PrintSimCfg ), .ImplKey ( ImplKey )
    ) i_tc_sram_blackbox ();
    assign rdata_o = '0;
  end

endmodule
