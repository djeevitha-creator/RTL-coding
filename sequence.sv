class my_sequence extends uvm_sequence #(seq_item);
  `uvm_object_utils(my_sequence)

  int unsigned pkt_count;
  seq_item seq;
  function new(string name="my_sequence");
    super.new(name);
    `uvm_info("sequence class","constructor",UVM_MEDIUM)
    set_automatic_phase_objection(1);
  endfunction
  
   task body();
     pkt_count=0;
   
     seq = seq_item::type_id::create("seq");
     seq.rst=1;
     assert(seq.randomize());
     start_item(seq);
     finish_item(seq);

   seq = seq_item::type_id::create("seq");
     seq.rst=0;
     assert(seq.randomize());
     start_item(seq);
     finish_item(seq);

    repeat (10) begin
     seq = seq_item::type_id::create("seq");
      seq.rst = 0;
      assert(seq.randomize());
      start_item(seq);
      finish_item(seq);
      pkt_count++;
      `uvm_info("SEQ", $sformatf("Transaction %0d generated: %s",
                                  pkt_count, seq.convert2string()), UVM_MEDIUM)
    end
    
  endtask
endclass
