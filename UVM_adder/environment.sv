`include "agent.sv"
`include "scoreboard.sv"
class adder_env extends uvm_env;
  `uvm_component_utils(adder_env)

  adder_agent agent;
  adder_scoreboard scb;

  // Constructor
  function new(string name = "adder_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create sub-components 
    agent = adder_agent::type_id::create("agent", this);
    scb   = adder_scoreboard::type_id::create("scb", this);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  

    // Connect monitor's analysis port to scoreboard's analysis imp
    agent.mon.ap.connect(scb.aip);
  endfunction

endclass
