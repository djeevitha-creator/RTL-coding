class my_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(my_scoreboard)
  bit [7:0] model[$];
  bit[7:0] expected;
  bit[7:0]actual;
  
  uvm_analysis_imp#(seq_item,my_scoreboard)aip;
  
  function new(string name="my_scoreboard",uvm_component parent);
    super.new(name,parent);
    `uvm_info("my_scoreboard class","constructor",UVM_MEDIUM)
    aip=new("aip",this);
  endfunction
  
  function void write(seq_item txn);
  if (txn.wr && !txn.rd)
    model.push_back(txn.data_in);

  else if (!txn.wr && txn.rd && model.size() > 0) begin
    expected = model.pop_front();
    
    actual = txn.data_out;
  end
    if (expected !== actual)
      `uvm_error("SCOREBOARD", $sformatf("Mismatch! Expected: %0b, Got: %0b", expected, actual))
    else
      `uvm_info("SCOREBOARD", $sformatf("PASS: %0b", actual), UVM_MEDIUM)
  
endfunction
      endclass
