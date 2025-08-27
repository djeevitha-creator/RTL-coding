class omonitor extends uvm_monitor;
  `uvm_component_utils(omonitor)

virtual apb_if.Mon vif;

// This TLM port connects to RAL Predictor
  uvm_analysis_port #(seq_item) ap;

  function new (string name="omonitor",uvm_component parent);
	super.new(name,parent);
endfunction

extern virtual task run_phase(uvm_phase phase);
extern virtual function void build_phase(uvm_phase phase);
endclass 

// Build phase: get virtual interface
function void omonitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  ap=new("ap",this);
  if (!uvm_config_db#(virtual apb_if.Mon)::get(this, "", "vif", vif))
    `uvm_fatal("MONITOR", "Virtual interface not set")
endfunction

 
task omonitor::run_phase(uvm_phase phase);
seq_item tr;
if (vif==null) begin
   `uvm_fatal("VIF_FAIL", "iMonitor Virtual Interface is NULL in apb_oMonitor");
end
forever begin

	@(vif.cbm.PRDATA);
	if(vif.cbm.PRDATA === 'z || vif.cbm.PRDATA === 'x) continue;
    
	tr = seq_item::type_id::create("tr",this);
        if(vif.cbm.PWRITE ==1'b0) begin//Collect only write transaction
           tr.PDATA = vif.cbm.PRDATA ;
      	   tr.PADDR = vif.cbm.PADDR;
           `uvm_info("oMon",tr.convert2string(),UVM_MEDIUM);
	       ap.write(tr);
	    end
end
endtask 
