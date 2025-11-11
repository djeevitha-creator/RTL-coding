class environment;
  
  generator  gen;
  driver     driv;
  monitor    mon;
  scoreboard scb;
  
  mailbox gen2driv;
  mailbox mon2scb;
  
  virtual i2c_intf i2c_vif;
  

  function new(virtual i2c_intf i2c_vif);
    this.i2c_vif = i2c_vif;
    gen2driv = new();
    mon2scb  = new();
   
    gen  = new(gen2driv);
    driv = new(i2c_vif,gen2driv);
    mon  = new(i2c_vif,mon2scb);
    scb  = new(mon2scb);
    endfunction
  
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    gen.main();
    
    fork 
    driv.main();
    mon.main();  
    join_any
    
    scb.main();    
  endtask
  
  //run task
  task run;
    pre_test();
    test();
    $finish;
  endtask
  
endclass

