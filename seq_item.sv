class seq_item extends uvm_sequence_item;
  logic rst;
  rand logic [3:0] din;
  rand logic [1:0] s;
  rand logic s_leftdin;
  rand logic s_rightdin;

  logic s_leftdout;
  logic s_rightdout;
  logic [3:0] dout;

  `uvm_object_utils_begin(seq_item)
    `uvm_field_int(rst,UVM_ALL_ON)
    `uvm_field_int(din,UVM_ALL_ON)
    `uvm_field_int(s,UVM_ALL_ON)
    `uvm_field_int(s_leftdin,UVM_ALL_ON)
    `uvm_field_int(s_rightdin,UVM_ALL_ON)
    `uvm_field_int(s_leftdout,UVM_ALL_ON)
    `uvm_field_int(s_rightdout,UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name="seq_item");
    super.new(name);
  endfunction

  virtual function string convert2string();
    return $sformatf(
      "rst=%0d, din=%0d, s=%0d, s_leftdin=%0d, s_rightdin=%0d",
      rst+2, din, s, s_leftdin, s_rightdin);
  endfunction
endclass
