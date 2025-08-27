class my_sequence extends uvm_sequence;
  `uvm_object_utils(my_sequence)
    int unsigned pkt_count;
  
    function new(string name="my_sequence");
    super.new(name);
    `uvm_info("sequence class","constructor",UVM_MEDIUM)
    set_automatic_phase_objection(1);
  endfunction
    
    virtual task pre_start();
if(!uvm_config_db#(int)::get(m_sequencer,"","item_count",pkt_count)) begin
    `uvm_warning("BASE_SEQ","item_count is not set in sequence")
    pkt_count=2;
end
endtask


task body();
  seq_item req;
  req=seq_item::type_id::create("req");
  req.kind = RESET;
  start_item(req);
  finish_item(req);
  /*
  req=seq_item::type_id::create("req");
  assert(req.randomize());
  req.kind = WRITE;
  req.PADDR = 'h2;
  start_item(req);
  finish_item(req);
  
 
  
  req=seq_item::type_id::create("req");
  assert(req.randomize());
  req.kind = WRITE;
  req.PADDR = 'h4;
  start_item(req);
  finish_item(req);
  
  req=seq_item::type_id::create("req");
  req.kind = READ;
  req.PADDR = 'h4;
  start_item(req);
  finish_item(req);
  
  req=seq_item::type_id::create("req");
  req.kind = READ;
  req.PADDR = 'h2;
  start_item(req);
  finish_item(req);
  
*/  
  repeat(pkt_count)
    begin
      req=seq_item::type_id::create("req");
      req.kind = STIMULUS;
      assert(req.randomize());
      start_item(req);
      finish_item(req);
    end
endtask
endclass