class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  bit expected_s_leftdout;
  bit expected_s_rightdout;
  bit [3:0] prev_dout;
  bit [3:0] expected_dout;
  // Analysis implementation port to receive data from monitor
  uvm_analysis_imp#(seq_item, scoreboard) aip;

  // Constructor
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("scoreboard class", "Constructor", UVM_MEDIUM)
    aip = new("aip", this);
    prev_dout = 4'b0000; 
  endfunction

  
  function void write(seq_item txn);
    
    
    // outputs are based on previous dout
    expected_s_leftdout  = prev_dout[0]; // LSB
    expected_s_rightdout = prev_dout[3]; // MSB
    
    // compute next dout
    expected_dout = prev_dout; // default hold
    if (txn.s == 2'b00) begin
      expected_dout = txn.din;                       
    end
    else if (txn.s == 2'b01) begin
      expected_dout = prev_dout;                     
    end
    else if (txn.s == 2'b10) begin
      expected_dout = {txn.s_rightdin, prev_dout[3:1]}; // shift right
    end
    else if (txn.s == 2'b11) begin
      expected_dout = {prev_dout[2:0], txn.s_leftdin};  // shift left
    end

    // compare
    if (txn.dout == expected_dout)
      `uvm_info("SCOREBOARD", $sformatf("PASS: din=%0b, s=%0b, dout=%0b, expected_dout=%0b", 
                                        txn.din, txn.s, txn.dout, expected_dout), UVM_LOW)
    else
      `uvm_error("SCOREBOARD", $sformatf("DOUT mismatch: expected_dout=%0b, txn.dout=%0b",
                                         expected_dout, txn.dout))
    
    if (txn.s_leftdout != expected_s_leftdout)
      `uvm_error("SCOREBOARD", $sformatf("s_leftdout mismatch: expected_s_leftdout=%0b, txn.s_leftdout=%0b",
                                         expected_s_leftdout, txn.s_leftdout))
  
    if (txn.s_rightdout != expected_s_rightdout)
      `uvm_error("SCOREBOARD", $sformatf("s_rightdout mismatch: expected_s_rightdout=%0b, txn.s_rightdout=%0b",
                                         expected_s_rightdout, txn.s_rightdout))
                                          
    // update for next cycle
    prev_dout = expected_dout;
  endfunction

endclass
