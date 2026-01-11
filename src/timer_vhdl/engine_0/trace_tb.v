`ifndef VERILATOR
module testbench;
  reg [4095:0] vcdfile;
  reg clock;
`else
module testbench(input clock, output reg genclock);
  initial genclock = 1;
`endif
  reg genclock = 1;
  reg [31:0] cycle = 0;
  reg [0:0] PI_clk_i;
  reg [0:0] PI_start_i;
  reg [0:0] PI_arst_i;
  timer_wrapper UUT (
    .clk_i(PI_clk_i),
    .start_i(PI_start_i),
    .arst_i(PI_arst_i)
  );
`ifndef VERILATOR
  initial begin
    if ($value$plusargs("vcd=%s", vcdfile)) begin
      $dumpfile(vcdfile);
      $dumpvars(0, testbench);
    end
    #5 clock = 0;
    while (genclock) begin
      #5 clock = 0;
      #5 clock = 1;
    end
  end
`endif
  initial begin
`ifndef VERILATOR
    #1;
`endif
    // UUT.dut.$auto$ghdl.\cc:825:import_module$20  = 2'b01;
    // UUT.dut.$auto$ghdl.\cc:825:import_module$26  = 4'b0001;
    // UUT.dut.$auto$ghdl.\cc:825:import_module$38  = 8'b00000001;
    UUT.dut._witness_.anyinit__112 = 1'b0;
    UUT.dut._witness_.anyinit__114 = 1'b0;
    UUT.dut._witness_.anyinit__126 = 1'b0;
    UUT.dut._witness_.anyinit__129 = 1'b0;
    UUT.dut.count_r = 31'b0000000000000000000000000000000;
    UUT.dut.done_o = 1'b0;
    UUT.dut.state = 2'b00;

    // state 0
    PI_clk_i = 1'b0;
    PI_start_i = 1'b0;
    PI_arst_i = 1'b1;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_clk_i <= 1'b0;
      PI_start_i <= 1'b0;
      PI_arst_i <= 1'b0;
    end

    genclock <= cycle < 1;
    cycle <= cycle + 1;
  end
endmodule
