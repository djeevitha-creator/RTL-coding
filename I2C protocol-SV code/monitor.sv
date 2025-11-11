
`define MON_IF i2c_vif.MONITOR.monitor_cb
class monitor;
  virtual i2c_intf i2c_vif;
  mailbox mon2scb;
  
  function new(virtual i2c_intf i2c_vif,mailbox mon2scb);
    this.i2c_vif = i2c_vif;
    this.mon2scb = mon2scb;
  endfunction
  
  
  task main;
   forever begin
     
      transaction tr;
      tr = new();
     wait(!i2c_vif.RESET_IN);  
     //Waits until reset is deasserted (RESET_IN = 0) before starting monitoring.
//Ensures monitor only samples valid bus activity after reset
     @(posedge i2c_vif.MONITOR.clk);
     @(negedge i2c_vif.MONITOR.clk);
     @(negedge i2c_vif.MONITOR.clk);
     repeat (8) @(negedge i2c_vif.MONITOR.clk);
      tr = new();
      tr.ADRESS_OUT = `MON_IF.ADRESS_OUT;
     $display ("MONITOR WRITE ADRESS=%b ",tr.ADRESS_OUT);
      mon2scb.put(tr);
     @(negedge i2c_vif.MONITOR.clk);
     
     repeat (8) @(negedge i2c_vif.MONITOR.clk);
     $display ("MONITOR GETTING WRITE DATA");
      mon2scb.put(tr);
     @(negedge i2c_vif.MONITOR.clk);
     
      
      repeat (8) @(negedge i2c_vif.MONITOR.clk);
      tr.ADRESS_OUT = `MON_IF.ADRESS_OUT;
     $display ("MONITOR READ  ADRESS=%b ",tr.ADRESS_OUT);
      mon2scb.put(tr);
     
     @(negedge i2c_vif.MONITOR.clk);
     @(negedge i2c_vif.MONITOR.clk);
     tr.DATA_OUT = `MON_IF.DATA_OUT;
     $display ("MONITOR GETTING READ DATA =%b",tr.DATA_OUT);
     mon2scb.put(tr);
    end
  endtask
  
endclass