class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  `uvm_analysis_imp_decl(_inp)
  `uvm_analysis_imp_decl(_outp)

  // Analysis implementation port to receive data from monitor
  uvm_analysis_imp_inp#(seq_item, scoreboard) mon_inp;
  uvm_analysis_imp_outp#(seq_item, scoreboard) mon_outp;
  
  seq_item q_inp[$];
  bit [31:0] m_matches,m_mismatches;
  // Constructor
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("scoreboard class", "Constructor", UVM_MEDIUM)
    mon_inp = new("mon_inp", this);
    mon_outp = new("mon_outp",this);
  endfunction
  
  virtual function void write_inp(seq_item txn);
    seq_item txn_in;
    txn_in = txn;
    q_inp.push_back(txn_in);
  endfunction
  
  virtual function void write_outp(seq_item rcd_txn);
    seq_item ref_pkt;
    int get_index[$];
    int index;
    bit done;
    ref_pkt = new();
    get_index = q_inp.find_index() with (item.PADDR == rcd_txn.PADDR);

    foreach (get_index[i]) begin
        index=get_index[i];
        ref_pkt=q_inp[index];
      if(ref_pkt.compare(rcd_txn)) begin
                m_matches++;
                q_inp.delete(index);
            done=1;
            break;
           end 
           else done=0;
     end 

      if (!done) begin
        m_mismatches++;
        `uvm_error("SCB_NO_MATCH",$sformatf("****Matching Packet NOT Found"));
        `uvm_info("SCB",$sformatf("Expected::%0s ",ref_pkt.convert2string()),UVM_NONE);
        `uvm_info("SCB",$sformatf("Received::%0s ",rcd_txn.convert2string()),UVM_NONE);
        done=0;
     end

endfunction

virtual function void extract_phase(uvm_phase phase);
uvm_config_db#(int)::set(null,"uvm_test_top","matches",m_matches);
uvm_config_db#(int)::set(null,"uvm_test_top","mis_matches",m_mismatches);
endfunction

function void report_phase(uvm_phase phase);
  `uvm_info("SCB",$sformatf("Scoreboard completed  with matches=%0d mismatches=%0d ",m_matches,m_mismatches),UVM_NONE);
endfunction 
    
endclass


    
  
    