// Code your testbench here
// or browse Examples

`include "environement.sv"


//`include "sequence_item.sv"
`include "sequence.sv"
//`include "sequencer.sv"

`include "uvm_macros.svh" // contains all uvm macros
import uvm_pkg::*;        // contains all the uvm base classes
`include "interface.sv"   
module top;
  logic clk;
  `include "test.sv"

  // Instantiate the interface
  adder_intf vif(clk); 
  // Instantiate the DUT (Design Under Test)
  adder dut (
    .clk(clk),
    .rst(vif.rst),  
    .a(vif.a),
    .b(vif.b),
    .sum(vif.sum));
 
initial begin
  uvm_config_db#(virtual adder_intf)::set(null,"*","vif",vif);
end
  // Clock generation
  initial clk = 0;
  always #10 clk = ~clk;

  // Simulation control
  initial begin
    //$monitor("%0t: clk = %0b", $time, clk); 
    run_test();
    #100;
    $finish;
  end
endmodule

