class test extends uvm_test;
  `uvm_component_utils(test)

  my_env env;
  my_sequence seq;  

  function new(string name="test", uvm_component parent);
    super.new(name, parent);
  endfunction

  // build_phase: create env and sequence
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = my_env::type_id::create("env", this);
    seq = my_sequence::type_id::create("seq");  // create sequence instance
  endfunction

  // run_phase: start the sequence on sequencer
  task run_phase(uvm_phase phase);
    super.run_phase(phase);  

    `uvm_info("TEST", "run_phase started", UVM_MEDIUM)
    phase.raise_objection(this);

    seq.start(env.agent.seqr);  // start sequence on agent's sequencer

    phase.drop_objection(this);
  endtask

endclass
