class seq_item extends uvm_sequence_item;
  
  rand bit wr;
  rand bit rd;
  rand bit [7:0] data_in;
  bit [7:0]data_out;
  bit rst;
  `uvm_object_utils_begin(seq_item)
  `uvm_field_int(wr,UVM_ALL_ON)
  `uvm_field_int(rd,UVM_ALL_ON)
  `uvm_field_int(data_in,UVM_ALL_ON)
  `uvm_field_int(data_out,UVM_ALL_ON)
  `uvm_object_utils_end
  

  function new(string name = "seq_item");
    super.new(name);
  endfunction

  function string convert2string();
    return $sformatf("wr=%0b rd=%0b data_in=%0h", wr, rd, data_in);
  endfunction
endclass 
