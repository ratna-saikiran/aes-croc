// Self-checking testbench for aes_core: reads vectors.hex (key|pt|ct per line),
// runs every vector back to back and compares the ciphertext.
module tb_aes_core;
  localparam int MaxVec = 4096;

  logic         clk = 0, rst_n = 0, start = 0;
  logic [127:0] key, pt;
  logic         busy, done;
  logic [127:0] ct;
  logic [383:0] vec [MaxVec];
  int           n_vec, n_err, cycles, fd;

  always #5 clk = ~clk;

  aes_core dut (
    .clk_i(clk), .rst_ni(rst_n), .start_i(start),
    .key_i(key), .block_i(pt), .busy_o(busy), .done_o(done), .block_o(ct)
  );

  initial begin
    fd = $fopen("vectors.hex", "r");
    if (fd == 0) $fatal(1, "cannot open vectors.hex");
    n_vec = 0;
    while (n_vec < MaxVec && $fscanf(fd, "%h\n", vec[n_vec]) == 1) n_vec++;
    $fclose(fd);

    repeat (3) @(posedge clk);
    rst_n = 1;
    n_err = 0;
    for (int i = 0; i < n_vec; i++) begin
      @(negedge clk);
      key = vec[i][383:256];
      pt  = vec[i][255:128];
      start = 1;
      @(negedge clk);
      start = 0;
      cycles = 1;
      while (!done) begin @(negedge clk); cycles++; end
      if (ct !== vec[i][127:0]) begin
        n_err++;
        $display("FAIL vec %0d: key=%h pt=%h got=%h exp=%h", i, key, pt, ct, vec[i][127:0]);
      end
    end
    $display("aes_core: %0d vectors, %0d errors, %0d cycles per block", n_vec, n_err, cycles);
    if (n_err == 0) $display("PASS"); else $display("FAIL");
    $finish;
  end
endmodule
