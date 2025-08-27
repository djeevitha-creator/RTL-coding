class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  // Virtual interface to DUT
  virtual apb_if.Mon vif;

  // Analysis port to send collected transactions
  uvm_analysis_port #(seq_item) ap;

  // Constructor
  function new(string name = "monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
    `uvm_info("monitor class", "Constructor", UVM_MEDIUM)
  endfunction
  
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass 


// Build phase: get virtual interface
function void monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(virtual apb_if.Mon)::get(this, "", "vif", vif))
    `uvm_fatal("MONITOR", "Virtual interface not set")
endfunction


// Run phase: Sample interface signals and send transactions
task monitor::run_phase(uvm_phase phase);
  `uvm_info("monitor class", "Run phase started", UVM_MEDIUM)

  if (vif == null) begin
    `uvm_fatal("VIF_FAIL", "Monitor Virtual Interface is NULL in apb_monitor");
  end


  forever begin
    @(vif.cbm); // sample on clocking block edge

    // Detect valid transfer (PSEL & PENABLE & PREADY)
    if (vif.cbm.PSEL && vif.cbm.PENABLE && vif.cbm.PREADY) begin
      seq_item tr = seq_item::type_id::create("tr", this);
      tr.PADDR = vif.cbm.PADDR;
      if (vif.cbm.PWRITE == 1'b1)begin
        tr.PDATA = vif.cbm.PWDATA;
        ap.write(tr);
        `uvm_info("APB_MON", tr.convert2string(), UVM_MEDIUM)
      end
      else continue;
      
    end
  end
endtask
