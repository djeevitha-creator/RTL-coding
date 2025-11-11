interface i2c_intf(input bit clk,bit RESET_IN);
  logic SCL;
  logic SDA;
  logic [6:0] ADRESS_OUT;
  logic [7:0] DATA_OUT;
  
  //driver clocking block
  clocking driver_cb @(negedge clk);
    default input #0 output #0;
    inout SDA ;
    inout SCL;
    input ADRESS_OUT;
    input DATA_OUT;
  endclocking
  
  //monitor clocking block
  clocking monitor_cb @(negedge clk);
    default input #0 output #0;
    input SCL;
    input SDA;
    input ADRESS_OUT;
    input DATA_OUT;
  endclocking
  
  //driver modport
  modport DRIVER  (clocking driver_cb,input clk,RESET_IN);
  
  //monitor modport  
    modport MONITOR (clocking monitor_cb,input clk,RESET_IN);
  
endinterface