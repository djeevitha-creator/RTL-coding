// Code your testbench here
// or browse Examples
/*import uvm_pkg::*;
`include "uvm_macros.svh"
`include "interface.sv"
`include "package.sv" */
`include "uvm_macros.svh"
import uvm_pkg::*; 

  // interface definitions
    // optional packages
`include "interface.sv"
`include "seq_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "environment.sv"


module tb;
  logic clk;
  logic rst;

  fifo_if vif(.clk(clk));


  fifo dut (
    .clk(clk),
    .rst(vif.rst),
    .wr(vif.wr),
    .rd(vif.rd),
    .data_in(vif.data_in),
    .data_out(vif.data_out),
    .full(vif.full),
    .empty(vif.empty),
    .overflow(vif.overflow),
    .underflow(vif.underflow)
  );
  `include "test.sv"
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", vif);
    run_test("test");
    #100;
      $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
endmodule
