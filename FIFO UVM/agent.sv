class my_agent extends uvm_agent;
  `uvm_component_utils(my_agent)

  // Declare sub-components
  my_driver    driv;
  my_monitor   mon;
  my_sequencer seqr;

  // Constructor
  function new(string name = "my_agent", uvm_component parent);
    super.new(name, parent);
    `uvm_info("AGENT", "Constructor", UVM_MEDIUM)
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT", "Build phase", UVM_LOW)

    // Create lower-level components
    driv = my_driver::type_id::create("driv", this);
    mon  = my_monitor::type_id::create("mon", this);
    seqr = my_sequencer::type_id::create("seqr", this);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT", "Connect phase", UVM_LOW)

    // Connect driver and sequencer using TLM ports
    driv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass
