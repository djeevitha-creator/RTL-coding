// Code your testbench here
// or browse Examples
`include "header.svh"
module tbench_top;
  bit clk;
  bit reset;
  bit sda;
  wire SDA;
  
  always #5 clk = ~clk;
  
  initial begin
    reset = 1'b1;
    repeat(2) @(negedge clk);
    
    reset =1'b0;
  end
  
  i2c_intf intf(clk,reset);
  test t1(intf);
  
 assign SDA=DUT.dir_en?1'bz:intf.SDA;
  assign intf.SCL =intf.clk;

  
//I2C_slave(RESET_IN,SCL,SDA,DATA_OUT,ADRESS_OUT);  
  I2C_slave DUT (
    .SCL(intf.clk),
    .RESET_IN(reset),
    .SDA(SDA),
    .DATA_OUT(intf.DATA_OUT),
    .ADRESS_OUT(intf.ADRESS_OUT)
   );
  initial begin
    #1000;
    $finish;
  end
  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule