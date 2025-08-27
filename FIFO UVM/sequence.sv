class my_sequence extends uvm_sequence#(seq_item);
  `uvm_object_utils(my_sequence)

  function new(string name = "my_sequence");
    super.new(name);
  endfunction
  seq_item seq;

  virtual task body();
      seq = seq_item::type_id::create("seq");   
      seq.rst = 1;
      start_item(seq);
      
      finish_item(seq);
      
      seq = seq_item::type_id::create("seq"); 
      seq.rst =0;
      start_item(seq);
     
      finish_item(seq);
    
      
    
    repeat (20) begin
      seq = seq_item::type_id::create("seq");    
      start_item(seq);
      assert(seq.randomize() with { !(seq.wr && seq.rd); });
      finish_item(seq);
    end
  endtask
endclass
