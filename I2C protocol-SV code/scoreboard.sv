class scoreboard;
  mailbox mon2scb;
  
  bit [31:0] mem[64];
  
  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction
  
  task main;
    transaction tr;
      tr=new();
      mon2scb.get(tr);
      tr.display ("SCOREBOARD");
    tr.randomize;
       tr.check;
  endtask
  
endclass