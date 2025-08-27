import uvm_pkg::*; 

`include "interface.sv"
`include "seq_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"
module tb;

  // Clock
  logic clk;
  initial clk = 0;
  always #5 clk = ~clk;  

  // Interface
  usr_if vif(clk);

  // DUT instance
  usr dut (
    .clk(clk),
    .rst(vif.rst),
    .din(vif.din),
    .s(vif.s),
    .s_leftdin(vif.s_leftdin),
    .s_rightdin(vif.s_rightdin),
    .s_leftdout(vif.s_leftdout),
    .s_rightdout(vif.s_rightdout),
    .dout(vif.dout)
  );

  // Connect virtual interface to UVM
  initial begin
    uvm_config_db#(virtual usr_if.drvr)::set(null, "*", "vif", vif);
    uvm_config_db#(virtual usr_if.mon)::set(null, "*", "vif", vif);
    run_test("test");  // Start UVM test
  end
initial begin
  $dumpfile("dump.vcd");
  $dumpvars();
end
endmodule
