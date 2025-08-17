class adder_sequence extends uvm_sequence;
  `uvm_object_utils(adder_sequence)
  
  function new(string name="adder_sequence");
    super.new(name);
    `uvm_info("sequence class","constructor",UVM_MEDIUM)
    set_automatic_phase_objection(1);
  endfunction

task body();
  adder_seq_item req;
  repeat(10)
    begin
      req=adder_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      
      finish_item(req);
      
        end
endtask
endclass