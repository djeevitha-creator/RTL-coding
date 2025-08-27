class my_monitor extends uvm_monitor;
  virtual fifo_if vif;

  `uvm_component_utils(my_monitor)

  uvm_analysis_port#(seq_item) ap;

  function new(string name="my_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

   function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Virtual interface not set")
  endfunction

   task run_phase(uvm_phase phase);
    forever begin
        seq_item seq;
      seq = seq_item::type_id::create("seq", this);
      seq.wr      = vif.wr;
      seq.rd      = vif.rd;
      seq.data_in = vif.data_in;
      #1;seq.data_out=vif.data_out;
      ap.write(seq);
    end
  endtask
endclass
