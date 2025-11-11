class transaction;
  rand bit SDA;
  
  bit[7:0] DATA_OUT;
  bit[6:0] ADRESS_OUT;
  
  rand bit [7:0] wr_adress;
  rand bit [7:0] rd_adress;
  rand bit [7:0] wr_data;
  
  constraint c1 {wr_adress==8'b0011_1010;}
  constraint c2 {rd_adress==8'b0011_1011;}
  constraint c3 {wr_data==8'b 1101_1100;}
  
  function void display ( string class_name);
    $write (class_name);
    $display (" ADRESS OUT=%b,DATA_OUT=%b",ADRESS_OUT,DATA_OUT);
  endfunction
  
   function void check;
     if (( ADRESS_OUT==wr_adress[7:1]) && ( DATA_OUT==wr_data))
       $display (" DESIGN PASSED");
     else 
       $display ("DESIGN FAILED");
  endfunction
 
 
  
endclass
