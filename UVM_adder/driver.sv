`include "sequence_item.sv"
class adder_driver extends uvm_driver#(adder_seq_item);
  `uvm_component_utils(adder_driver)
  virtual adder_intf vif;
  
  function new(string name="adder_driver",uvm_component parent);
    super.new(name,parent);
    `uvm_info("driver class","constructor",UVM_MEDIUM)
  endfunction


    function void build_phase(uvm_phase phase);
  super.build_phase (phase);
      `uvm_info("driver class","build phase",UVM_MEDIUM);
      if (!uvm_config_db#(virtual adder_intf)::get(this, "", "vif", vif))
            `uvm_fatal("DRIVER", "Virtual interface not set")
   endfunction
        
   task run_phase(uvm_phase phase);
     
      req = adder_seq_item::type_id::create("req");
      forever
        begin
          seq_item_port.get_next_item(req);
          
          vif.a<=req.a;
          vif.b<=req.b;
          vif.rst <= req.rst;
          @(posedge vif.clk);
          seq_item_port.item_done();
        end
  endtask
endclass
      