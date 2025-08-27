class seq_item extends uvm_sequence_item;
  rand logic [31:0] PADDR;
  rand  logic [31:0] PDATA;
  
  kind_e   kind;
  bit [7:0] reset_cycles;
  
  constraint valid {
    PADDR inside {[0:255]};
   PDATA inside {[10:1000]};
}

`uvm_object_utils_begin(seq_item)
  `uvm_field_int(PADDR,UVM_ALL_ON  )
  `uvm_field_int(PDATA,UVM_ALL_ON )
`uvm_object_utils_end

  function new(string name="seq_item");
	super.new(name);
endfunction

virtual function string convert2string();
  return $sformatf("PADDR=%0h,PDATA=%oh",PADDR,PDATA);
endfunction

endclass


