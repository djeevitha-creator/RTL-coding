class adder_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(adder_scoreboard)

  // Analysis implementation port to receive data from monitor
  uvm_analysis_imp#(adder_seq_item, adder_scoreboard) aip;

  // Constructor
  function new(string name = "adder_scoreboard", uvm_component parent);
    super.new(name, parent);
    // UVM needs these two arguments to register and build the component in the testbench hierarchy
    `uvm_info("scoreboard class", "Constructor", UVM_MEDIUM)
    aip = new("aip", this);
    // This connects the analysis port; otherwise, write() won’t be called
  endfunction

  // Analysis write function – automatically called when monitor writes data
  function void write(adder_seq_item txn);
    bit [7:0] expected_sum;

    // Predict the correct output
    expected_sum = txn.a + txn.b;

    // Compare expected vs actual DUT result
    if ((txn.rst) || (txn.sum == expected_sum)) begin
      `uvm_info("SCOREBOARD", $sformatf(" PASS: a=%0d, b=%0d sum=%0d",
                                        txn.a, txn.b, txn.sum),UVM_LOW)
    end else begin
      `uvm_error("SCOREBOARD", $sformatf(" MISMATCH: a=%0d, b=%0d, Expected sum=%0d, DUT sum=%0d",
                                         txn.a, txn.b, expected_sum, txn.sum))
    end
  endfunction

endclass
