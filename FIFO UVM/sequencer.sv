class my_sequencer extends uvm_sequencer#(seq_item);
  `uvm_component_utils(my_sequencer)
  
  function new(string name="my_sequencer",uvm_component parent);
    super.new(name,parent);
    `uvm_info("sequencer class","constructor",UVM_MEDIUM)
  endfunction
endclass
    