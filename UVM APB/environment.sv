class env extends uvm_env;
  `uvm_component_utils(env)

  agent agt;
  scoreboard scb;

  // Constructor
  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create sub-components 
    agt = agent::type_id::create("agt", this);
    scb   = scoreboard::type_id::create("scb", this);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  

    // Connect monitor's analysis port to scoreboard's analysis imp
    agt.mon.ap.connect(scb.mon_inp);
    agt.omon.ap.connect(scb.mon_outp);
  endfunction

endclass
