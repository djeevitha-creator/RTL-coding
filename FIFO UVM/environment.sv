class my_env extends uvm_env;
  `uvm_component_utils(my_env)

  my_agent agent;
 my_scoreboard scb;

  // Constructor
  function new(string name = "my_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create sub-components 
    agent = my_agent::type_id::create("agent", this);
    scb   = my_scoreboard::type_id::create("scb", this);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  

    // Connect monitor's analysis port to scoreboard's analysis imp
    agent.mon.ap.connect(scb.aip);
  endfunction

endclass
