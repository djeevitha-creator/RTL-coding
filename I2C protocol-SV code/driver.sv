`define DRIV_IF i2c_vif.DRIVER.driver_cb
class driver;
  virtual i2c_intf i2c_vif;
  mailbox gen2driv;
   transaction tr;
  
  function new(virtual i2c_intf i2c_vif,mailbox gen2driv);
    this.i2c_vif = i2c_vif;
    this.gen2driv = gen2driv;
  endfunction
  
  //................................................................
     
  task reset;
    wait(i2c_vif.RESET_IN);
    $display("--------- [DRIVER] Reset Started ---------");
    `DRIV_IF.SDA<=1;
    wait(!i2c_vif.RESET_IN);
    $display("--------- [DRIVER] Reset Ended ---------");
  endtask
  // to start the transaction
   //................................................................
    
  task start;
    @(posedge i2c_vif.clk);
    #2;
    i2c_vif.SDA<=0;
    @(posedge i2c_vif.clk);
  endtask
   //................................................................
  // to stop the transaction
  task stop;
    i2c_vif.SDA<=0;
    @(posedge i2c_vif.clk);
    #2;
    i2c_vif.SDA<=1;
    //@(negedge i2c_vif.DRIVER.clk);
  endtask
 //................................................................
    
   // to get write adress
  task write_adress;
   repeat (8) begin
      tr=new();
      gen2driv.get(tr);
      @(negedge i2c_vif.DRIVER.clk);
      `DRIV_IF.SDA<=tr.SDA;
      $display ("driver sending serial write adress SDA=%b",tr.SDA); 
    end
    
    @(negedge i2c_vif.DRIVER.clk);
    tr.ADRESS_OUT=`DRIV_IF.ADRESS_OUT;
    
    $display ("driver  write adress=%b",tr.ADRESS_OUT);
    $display ("driver  getting ack SDA=%b",tr.SDA);
   
  endtask
 //................................................................
    
   // to get write data
  task write_data;
     
    repeat (8) begin 
      tr=new();
      gen2driv.get(tr);
      @(negedge i2c_vif.DRIVER.clk)
      `DRIV_IF.SDA<=tr.SDA;
     
       $display ("driver  sending serial write data SDA=%b",tr.SDA);
    end
    @(negedge i2c_vif.DRIVER.clk);
    $display ("driver  getting ack SDA=%b",tr.SDA);
              
  endtask
  
  //..............................................................
  // to get read adress
  task read_adress;
    repeat (8) begin
      tr=new();
      gen2driv.get(tr);
       @(negedge i2c_vif.DRIVER.clk);
      `DRIV_IF.SDA<=tr.SDA;
      $display ("driver  sending serial read adress SDA=%b",tr.SDA);
    end
     tr.ADRESS_OUT=`DRIV_IF.ADRESS_OUT;
    $display ("driver  read adress=%b",tr.ADRESS_OUT);
    $display ("driver  getting ack SDA=%b",tr.SDA);
    @(negedge i2c_vif.DRIVER.clk);
  endtask
  //................................................................
  // to get read data 
  task read_data;
    //repeat (1) begin
      tr=new();
      //@(posedge i2c_vif.DRIVER.clk);
   // end
    
    @(negedge i2c_vif.DRIVER.clk);
      
      tr.DATA_OUT=`DRIV_IF.DATA_OUT;
    $display ("driver  read adress=%b",tr.DATA_OUT);
    $display ("driver  getting ack SDA=%b",tr.SDA);
    repeat (8)@(negedge i2c_vif.DRIVER.clk);
  endtask
  //................................................................   
    
  task drive;
    start();
    write_adress;
    write_data;
    read_adress;
    read_data;   
  endtask
 //................. write task ...........................
  
  task main ;
   
      drive();
  endtask
    

endclass