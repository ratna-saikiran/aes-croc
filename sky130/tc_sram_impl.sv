// Sky130 tc_sram_impl for Croc: flip-flop based memory.
//
// Sky130 has no SRAM compiler output that drops in without PDN work, so this
// first port builds the memory from standard-cell flip-flops. It keeps Croc's
// interface and timing exactly: one request per cycle, byte enables, and read
// data valid in the cycle after the request (Latency = 1).
// sky130/tc_sram_impl_openram.sv holds the OpenRAM macro version for later.

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

  assign impl_o = ImplOutSim;

  // Croc only uses single-port, single-cycle-latency banks
  // synopsys translate_off
  initial begin
    if (NumPorts != 1 || Latency != 1)
      $fatal(1, "Sky130 tc_sram_impl supports NumPorts=1, Latency=1 only (%m)");
  end
  // synopsys translate_on

  data_t mem [NumWords];
  data_t rdata_q;

  always_ff @(posedge clk_i) begin
    if (req_i[0]) begin
      if (we_i[0]) begin
        for (int b = 0; b < BeWidth; b++) begin
          if (be_i[0][b]) mem[addr_i[0]][b*ByteWidth +: ByteWidth] <= wdata_i[0][b*ByteWidth +: ByteWidth];
        end
      end else begin
        rdata_q <= mem[addr_i[0]];
      end
    end
  end

  assign rdata_o[0] = rdata_q;

endmodule
