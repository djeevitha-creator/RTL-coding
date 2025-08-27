class agent extends uvm_agent;
  `uvm_component_utils(agent)

  // Declare sub-components
  apb_driver    driv;
  monitor   mon;
  omonitor omon;
  sequencer seqr;
  

  // Constructor
  function new(string name = "agent", uvm_component parent);
    super.new(name, parent);
    `uvm_info("AGENT", "Constructor", UVM_MEDIUM)
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT", "Build phase", UVM_LOW)

    // Create lower-level components
    driv = apb_driver::type_id::create("driv", this);
    mon  = monitor::type_id::create("mon", this);
    omon  = omonitor::type_id::create("omon", this);
    seqr = sequencer::type_id::create("seqr", this);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT", "Connect phase", UVM_LOW)

    // Connect driver and sequencer using TLM ports
   
    driv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass
