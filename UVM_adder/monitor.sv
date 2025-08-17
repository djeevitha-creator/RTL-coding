class adder_monitor extends uvm_monitor;
  `uvm_component_utils(adder_monitor)

  // Virtual interface to DUT
  virtual adder_intf vif;
  bit received;

  // Analysis port to send collected data to scoreboard or other components
  uvm_analysis_port #(adder_seq_item) ap;

  // Constructor
  function new(string name = "adder_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
    `uvm_info("monitor class", "Constructor", UVM_MEDIUM)
  endfunction

  // Build phase: get virtual interface
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual adder_intf)::get(this, "", "vif", vif))
      `uvm_fatal("MONITOR", "Virtual interface not set")
  endfunction

  // Run phase: Sample interface signals and send transactions
  task run_phase(uvm_phase phase);
    adder_seq_item req;
    `uvm_info("monitor class", "Run phase started", UVM_MEDIUM)

    forever begin
      @(posedge vif.clk);
     
      req = adder_seq_item::type_id::create("req", this);
       // small delay to simulate timing
      
      // Sample interface signals
      req.a   = vif.a;
      req.b   = vif.b;
      req.rst = vif.rst;
      #1; req.sum = vif.sum; // important Capture DUT output
      req.print();
        ap.write(req); // Send to scoreboard or collector

    end
  endtask
endclass
