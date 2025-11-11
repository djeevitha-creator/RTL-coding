class generator;
  rand transaction tr;
  mailbox gen2driv;
  
  
  
  function new(mailbox gen2driv);
    this.gen2driv = gen2driv;
  endfunction
  
  task write_adress;
    integer i;
    i=0;
    repeat (8) begin 
     tr=new();
     tr.randomize();
     tr.SDA=tr.wr_adress[i];
      $display ("[generator]sending write adress sda=%b",tr.SDA);
       gen2driv.put(tr);
      i=i+1;
    end
   
     
  endtask
  
   task write_data;
     integer i;
     i=0;
     repeat(8) begin 
       tr=new();
       tr.randomize();
       tr.SDA=tr.wr_data[i];
       $display ("[generator]sending write data sda=%b",tr.SDA);
       gen2driv.put(tr);
       i=i+1;
     end
  
      
  endtask
  
   task read_adress;
     integer i;
     i=0;
     repeat (8) begin
       tr=new();
       tr.randomize();
       tr.SDA=tr.rd_adress[i];
       $display ("sda=%b",tr.SDA);
       gen2driv.put(tr);
       i=i+1;
    end
  endtask
  
  task main();
    write_adress;
     write_data;
    read_adress;
    $display ("number of transaction",gen2driv.num);
  endtask

endclass