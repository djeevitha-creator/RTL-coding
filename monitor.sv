class monitor extends uvm_component;
  `uvm_component_utils(monitor)

  
  virtual usr_if.mon vif;

  uvm_analysis_port#(seq_item) ap; // analysis port to send observed transactions

  // Constructor
  function new(string name="monitor", uvm_component parent=null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  // Build phase - get interface
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual usr_if.mon)::get(this, "", "vif", vif))
      `uvm_fatal("MONITOR", "Virtual interface not set for monitor");
  endfunction

 
  task run_phase(uvm_phase phase);
    seq_item item;

    forever begin
     
      item = seq_item::type_id::create("item");

      // Sample DUT signals every clock cycle
      //@(vif.cbm);
      item.rst        = vif.cbm.rst;
      item.din        = vif.cbm.din;
      item.s          = vif.cbm.s;
      item.s_leftdin  = vif.cbm.s_leftdin;
      item.s_rightdin = vif.cbm.s_rightdin;
      @( vif.cbm);
      item.dout       = vif.cbm.dout;
      item.s_leftdout = vif.cbm.s_leftdout;
      item.s_rightdout= vif.cbm.s_rightdout;

      // Send observed transaction to analysis port
      if(item.rst !==1 && item.rst !== 'x && item.rst !== 'z) ap.write(item);
     
      $display("item.rst=%d", item.rst);
      //item.print();
      `uvm_info(get_full_name(),$sformatf(item.convert2string()),UVM_LOW)
      
       `uvm_info(get_full_name(), $sformatf("item.s_leftdout=%0d,item.s_rightdout=%0d",item.s_leftdout,item.s_rightdout), UVM_LOW)
    end
  endtask

endclass 

/*class monitor extends uvm_component;
  `uvm_component_utils(monitor)

  virtual usr_if.mon vif;
  uvm_analysis_port#(seq_item) ap;

  function new(string name="monitor", uvm_component parent=null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual usr_if.mon)::get(this, "", "vif", vif))
      `uvm_fatal("MONITOR", "Virtual interface not set for monitor");
  endfunction

  task run_phase(uvm_phase phase);
    // Wait until reset is deasserted once before starting
    // (assumes active-high reset)
    @(vif.cbm); 
    while (vif.cbm.rst) @(vif.cbm);

    forever begin
      seq_item item;

      // Sample **all** signals on the same clocking event
      @(vif.cbm);

      if (!vif.cbm.rst) begin
        item = seq_item::type_id::create("item", this);

        // Inputs to the DUT (as seen by monitor)
        item.rst         = vif.cbm.rst;
        item.din         = vif.cbm.din;
        item.s           = vif.cbm.s;
        item.s_leftdin   = vif.cbm.s_leftdin;
        item.s_rightdin  = vif.cbm.s_rightdin;

        // Outputs from the DUT (same sampled event)
        item.dout        = vif.cbm.dout;
        item.s_leftdout  = vif.cbm.s_leftdout;
        item.s_rightdout = vif.cbm.s_rightdout;

        ap.write(item);
        `uvm_info(get_full_name(),
                  $sformatf("Observed: s_leftdout=%0d s_rightdout=%0d",
                            item.s_leftdout, item.s_rightdout),
                  UVM_LOW)
      end
    end
  endtask
endclass*/

