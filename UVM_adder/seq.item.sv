class adder_seq_item extends uvm_sequence_item;
  rand bit [2:0] a, b;       // Inputs to DUT
  bit [2:0] sum;    
  rand bit rst;
  `uvm_object_utils_begin(adder_seq_item)    // Expected output (can be used for checking)
  `uvm_field_int(a, UVM_DEFAULT + UVM_DEC)
  `uvm_field_int(b, UVM_DEFAULT + UVM_DEC)
  `uvm_field_int(sum, UVM_DEFAULT + UVM_DEC)
  `uvm_field_int(rst, UVM_DEFAULT + UVM_DEC)
  `uvm_object_utils_end
  

  
  function new(string name="adder_seq_item");
    super.new(name);
    `uvm_info("seq_item class","constructor",UVM_MEDIUM)
  endfunction
endclass