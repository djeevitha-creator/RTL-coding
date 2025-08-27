class driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)

  
  virtual usr_if.drvr vif;
  seq_item req;

  // Constructor
  function new(string name="driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info("DRIVER", "constructor", UVM_MEDIUM)
  endfunction

  // Build phase get interface from config DB
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRIVER", "build_phase", UVM_MEDIUM);

    if (!uvm_config_db#(virtual usr_if.drvr)::get(this, "", "vif", vif))
      `uvm_fatal("DRIVER", "Virtual interface not set for driver");
  endfunction

  // Run phase - fetch items from sequencer and drive DUT
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      @(vif.cbd); 
      // Drive DUT inputs using driver clocking block (cbd)
      vif.cbd.rst        <= req.rst;
      vif.cbd.din        <= req.din;
      vif.cbd.s          <= req.s;
      vif.cbd.s_leftdin  <= req.s_leftdin;
      vif.cbd.s_rightdin <= req.s_rightdin;
      // Wait for one clock cycle
      // @(posedge vif.clk);
      
      seq_item_port.item_done();

      `uvm_info("DRIVER", $sformatf("Driven: %s", req.convert2string()), UVM_MEDIUM)
    end
  endtask

endclass

      