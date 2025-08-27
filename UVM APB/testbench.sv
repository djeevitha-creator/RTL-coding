// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*; 

  // interface definitions
    // optional packages
typedef enum {RESET, STIMULUS} kind_e;
`include "interface.sv"
`include "seq_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "omonitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "environment.sv"
module top;

  bit PCLK = 0;

  // Clock generator
  always #10 PCLK = ~PCLK;

  // Interface instance
  apb_if vif(PCLK);

  // DUT instance
  apb_slave dut (
    .PCLK   (PCLK),
    .PRESETn(vif.PRESETn),
    .PSEL   (vif.PSEL),
    .PADDR  (vif.PADDR),
    .PWDATA (vif.PWDATA),
    .PRDATA (vif.PRDATA),
    .PENABLE(vif.PENABLE),
    .PREADY (vif.PREADY),
    .PWRITE (vif.PWRITE)
  );
  `include "test.sv"

  // Pass interface handle into UVM
  initial begin
    uvm_config_db#(virtual apb_if.drvr)::set(null, "*", "vif", vif);
    uvm_config_db#(virtual apb_if.Mon)::set(null, "*", "vif", vif);
  end

  // Start UVM test
  initial begin
    run_test("test");
  end

  // Waveform dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
  end

endmodule
