interface usr_if(input logic clk);
  logic rst;
  logic [3:0] din;
  logic [1:0] s;
  logic s_leftdin;
  logic s_rightdin;
  logic s_leftdout;
  logic s_rightdout;
  logic [3:0] dout;

  // Clocking block for driver
  clocking cbd @(posedge clk);
    output rst;
    output din;
    output s;
    output s_leftdin;
    output s_rightdin;

    input  s_leftdout;
    input  s_rightdout;
    input  dout;
  endclocking

  // Clocking block for monitor
  clocking cbm @(posedge clk);
    input rst;
    input din;
    input s;
    input s_leftdin;
    input s_rightdin;
    input s_leftdout;
    input s_rightdout;
    input dout;
  endclocking

  // Modports
  modport drvr (clocking cbd);  
  modport mon  (clocking cbm);  
endinterface
