`include "driver.sv"
`include "monitor.sv"
`include "sequencer.sv"
class adder_agent extends uvm_agent;
  `uvm_component_utils(adder_agent)

  // Declare sub-components
  adder_driver    driv;
  adder_monitor   mon;
  adder_sequencer seqr;

  // Constructor
  function new(string name = "adder_agent", uvm_component parent);
    super.new(name, parent);
    `uvm_info("AGENT", "Constructor", UVM_MEDIUM)
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT", "Build phase", UVM_LOW)

    // Create lower-level components
    driv = adder_driver::type_id::create("driv", this);
    mon  = adder_monitor::type_id::create("mon", this);
    seqr = adder_sequencer::type_id::create("seqr", this);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT", "Connect phase", UVM_LOW)

    // Connect driver and sequencer using TLM ports
    if(is_active==UVM_ACTIVE) begin
    driv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction

endclass
