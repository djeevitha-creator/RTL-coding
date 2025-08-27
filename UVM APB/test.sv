class test extends uvm_test;
  `uvm_component_utils(test)

  env envh;
  my_sequence seq;  
  int pkt_count = 10;

  function new(string name="test", uvm_component parent);
    super.new(name, parent);
  endfunction

  // build_phase: create env and sequence
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    envh = env::type_id::create("envh", this);
    seq = my_sequence::type_id::create("seq");  // create sequence instance
    uvm_config_db#(int)::set(this,"*.*","item_count",pkt_count);
  endfunction

  // run_phase: start the sequence on sequencer
  task run_phase(uvm_phase phase);
    super.run_phase(phase);  

    `uvm_info("TEST", "run_phase started", UVM_MEDIUM)
    phase.raise_objection(this);

    seq.start(envh.agt.seqr);  // start sequence on agent's sequencer

    phase.drop_objection(this);
  endtask

endclass
