interface fifo_if(input logic clk); 
  logic wr;
  logic rd;
  logic [7:0] data_in;
  logic [7:0] data_out;
  logic full;
  logic empty;
  logic overflow;
  logic underflow;
  logic rst;
endinterface
