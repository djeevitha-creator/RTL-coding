class apb_driver extends uvm_driver #(seq_item);
  `uvm_component_utils(apb_driver)

  virtual apb_if.drvr vif;
  seq_item req;

  function new(string name="apb_driver", uvm_component parent);
    super.new(name,parent);
    `uvm_info("driver class","constructor",UVM_MEDIUM)
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("driver class","build phase",UVM_MEDIUM);
    if (!uvm_config_db#(virtual apb_if.drvr)::get(this, "", "vif", vif))
      `uvm_fatal("DRIVER", "Virtual interface not set")
  endfunction

  task run_phase(uvm_phase phase);
    if(vif==null)
      `uvm_fatal("VIF_FAIL","Virtual interface in apb_driver is NULL ");

    forever begin
      seq_item_port.get_next_item(req);

      case(req.kind)
        STIMULUS : write_read(req);
        RESET: reset(req);
      endcase

      seq_item_port.item_done();
    end
  endtask
    
    task write_read(seq_item tr);
      write(tr);
      read(tr);
    endtask

    task write(seq_item tr);
      `uvm_info("Write","APB Write transaction started....",UVM_LOW);
    @(vif.cb);
    vif.cb.PSEL    <= 1;
    vif.cb.PWRITE  <= 1;
    vif.cb.PADDR   <= tr.PADDR;
    vif.cb.PWDATA  <= tr.PDATA;
    @(vif.cb);
      
    vif.cb.PENABLE <=1;
    //do @(vif.cb); while (!vif.cb.PREADY);
    wait(vif.cb.PREADY==1)
      
    vif.cb.PENABLE <=0;
    vif.cb.PSEL    <=0;
    vif.cb.PADDR   <='0;
    vif.cb.PWDATA  <='0;

      `uvm_info("Write",tr.convert2string(),UVM_LOW);
  endtask

    task read(seq_item tr);
      `uvm_info("Read","APB Read transaction started...",UVM_LOW);
      @(vif.cb);
      vif.cb.PSEL    <= 1;
      vif.cb.PWRITE  <= 0;
      vif.cb.PADDR   <= tr.PADDR;
      @(vif.cb);
      vif.cb.PENABLE <= 1;
      wait(vif.cb.PREADY == 1);
      vif.cb.PENABLE <= 0;
      vif.cb.PSEL    <= 0;
      vif.cb.PADDR   <='0;
      @(vif.cb);
      tr.PDATA = vif.cb.PRDATA;
      `uvm_info("Read",$sformatf("APB Read data=0x%0h at addr=0x%0x",tr.PDATA,tr.PADDR),UVM_LOW);
    endtask

    task reset(seq_item tr);
    `uvm_info("drv_reset","Applying reset to APB",UVM_MEDIUM);
    vif.cb.PSEL    <=0;
    vif.cb.PENABLE <=0;
    vif.cb.PADDR   <='0;
    vif.cb.PWDATA  <='0;
    vif.PRESETn <= 0;
    repeat (tr.reset_cycles) @(vif.cb);
      vif.PRESETn <= 1;
    repeat (2) @(vif.cb);

    `uvm_info("drv_reset","APB out of Reset ",UVM_MEDIUM);
  endtask

endclass
