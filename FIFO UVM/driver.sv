class my_driver extends uvm_driver#(seq_item);
  virtual fifo_if vif;

  `uvm_component_utils(my_driver)

  function new(string name="my_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
 function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Virtual interface not found")
  endfunction

 task run_phase(uvm_phase phase);
    forever begin
      seq_item seq;
      seq_item_port.get_next_item(seq);
      vif.rst     <= seq.rst;
      vif.wr      <= seq.wr;
      vif.rd      <= seq.rd;
      vif.data_in <= seq.data_in;

      @(posedge vif.clk);

      seq_item_port.item_done();
    end
  endtask
endclass
