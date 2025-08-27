// Code your design here
// Code your design here
module fifo (
  input clk, rst, wr, rd,
  input [7:0] data_in,
  output reg [7:0] data_out,
  output full, empty,
  output reg overflow, underflow   //  New signals for debug
);
  parameter depth = 8;
  reg [7:0] mem [0:depth-1];
  reg [2:0] wr_ptr, rd_ptr;
  reg [3:0] count;

  assign full  = (count == depth); //FIFO is full when count == 8.
  assign empty = (count == 0); //FIFO is empty when count == 0

  // Write logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      wr_ptr   <= 0;
      overflow <= 0;
    end else begin
      if (wr && !full) begin //if wr==1 and FIFO is not full,  
        mem[wr_ptr] <= data_in; //write data into memory
        wr_ptr <= (wr_ptr == depth-1) ? 0 : wr_ptr + 1; //at wr_ptr, then increment wr_ptr
        overflow <= 0;
      end else if (wr && full) begin
        overflow <= 1; //  Set overflow high when you try to write to a full FIFO.
      end else begin
        overflow <= 0;
      end
    end
  end

  // Read logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      rd_ptr    <= 0;
      data_out  <= 0;
      underflow <= 0;
    end else begin
      if (rd && !empty) begin // If rd==1 and FIFO is not empty
        data_out <= mem[rd_ptr]; //Read data from mem[rd_ptr] and store in data_out
        rd_ptr <= (rd_ptr == depth-1) ? 0 : rd_ptr + 1; //Increment rd_ptr
        underflow <= 0;
      end else if (rd && empty) begin //if rd==1 and FIFO is empty → set underflow=1
        underflow <= 1; //  Set underflow high when you try to read from an empty FIFO.
      end else begin
        underflow <= 0;
      end
    end
  end

  // Count logic
  always @(posedge clk or negedge rst) begin
    if (rst) begin
      count <= 0;
    end else begin
      case ({wr, rd})
        2'b10: if (!full)  count <= count + 1;
        2'b01: if (!empty) count <= count - 1;
        default: count <= count;
      endcase
    end
  end

endmodule 