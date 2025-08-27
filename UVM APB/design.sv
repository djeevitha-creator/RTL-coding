// Code your design here
module apb_slave(
  PCLK,PRESETn, 
  PADDR,PWDATA,PRDATA, 
  PSEL,PWRITE,PENABLE,PREADY
);
parameter WAIT_CYCLES_COUNT=2;
  input          PCLK;    // APB System Clock
  input          PRESETn; // APB Reset - Active low
  input [31:0]   PADDR;   // APB Address
  input [31:0]   PWDATA;  // Write data
  output[31:0]   PRDATA;  // Read data
  input          PWRITE;
  input          PSEL;
  input          PENABLE;
  output         PREADY;
  
  logic PREADY;


logic [31:0] ram [0:255];
reg read_en;
reg [31:0] rdata;
bit [3:0] wait_cycles;

assign PRDATA = (read_en & PREADY ) ? rdata: 'z;


always @ (posedge PCLK or negedge PRESETn)
begin
	if(PRESETn === 0) 
	    ram <= '{256{'b0}};
        else if (PWRITE && PSEL && PENABLE) 
	    ram[PADDR] <= PWDATA;
end


always @(posedge PCLK or negedge PRESETn) begin
    if (PRESETn == 0) 
      wait_cycles<=0;
  else if(PSEL && ~PREADY)
      wait_cycles <= wait_cycles+1;
  else if(PSEL && PREADY)
      wait_cycles <= 0;
end
assign read_en = ( PSEL && PENABLE && !PWRITE) ? 1'b1 : 1'b0;
assign rdata = ( PSEL && PENABLE && !PWRITE) ? ram[PADDR] : 'z;
assign PREADY = (wait_cycles==WAIT_CYCLES_COUNT) ? 1 : 0;
endmodule

/*
module apb_slave (
  PCLK,PRESETn, 
  PADDR,PWDATA,PRDATA, 
  PSEL,PWRITE,PENABLE,PREADY
);
parameter WAIT_CYCLES_COUNT=2;
  input          PCLK;    // APB System Clock
  input          PRESETn; // APB Reset - Active low
  input [31:0]   PADDR;   // APB Address
  input [31:0]   PWDATA;  // Write data
  output[31:0]   PRDATA;  // Read data
  input          PWRITE;
  input          PSEL;
  input          PENABLE;
  output         PREADY;
   
  logic PREADY;


logic [31:0] ram [0:255];
//reg read_en;
reg [31:0] rdata;
bit [3:0] wait_cycles;

  assign PRDATA = (  PSEL && PENABLE && !PWRITE && PREADY)  ? rdata: 'z;


always @ (posedge PCLK or negedge PRESETn)
begin
	if(PRESETn === 0) 
	    ram <= '{256{'b0}};
        else if (PWRITE && PSEL && PENABLE) 
	    ram[PADDR] <= PWDATA;
end

  always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn)
      wait_cycles <= 0;
    else if (PSEL && PENABLE && ~PREADY) begin
      if (wait_cycles < WAIT_CYCLES_COUNT)
        wait_cycles <= wait_cycles + 1;
      else
        wait_cycles <= 0;
    end
    else
      wait_cycles <= 0;

    PREADY<= (wait_cycles == WAIT_CYCLES_COUNT);
  end

  // Read data capture
  always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn)
      rdata <= 32'b0;
    else if (PSEL && PENABLE && !PWRITE && PREADY)
      rdata <= ram[PADDR];
  end

endmodule */