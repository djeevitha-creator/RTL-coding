module usr(
  input clk,
  input rst,
  input [3:0] din,
  input [1:0] s,
  input s_leftdin,
  input s_rightdin,
  output reg s_leftdout,
  output reg s_rightdout,
  output reg [3:0] dout
);

  // Main shift register logic
  always @(posedge clk) begin
    if (rst) begin
      dout <= 4'b0000;
    end
    else begin
      case(s)
        2'b00: dout <= din;                          // Parallel load
        2'b01: dout <= dout;                         // Hold (redundant but fine)
        2'b10: dout <= {s_rightdin, dout[3:1]};      // Shift right
        2'b11: dout <= {dout[2:0], s_leftdin};       // Shift left
      endcase
    end
  end

  // Serial outputs (only here, not in reset block above)
  always @(posedge clk) begin
    s_leftdout  <= dout[0];   // LSB output
    s_rightdout <= dout[3];   // MSB output 
  end

endmodule
