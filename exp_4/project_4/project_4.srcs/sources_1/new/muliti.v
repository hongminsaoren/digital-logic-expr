`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/11 19:55:47
// Design Name: 
// Module Name: muliti
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns/1ps
module mul_32b
# (parameter DATAWIDTH = 32)
(
  input       clk,
  input       rst,
  input       in_valid,
  input       [DATAWIDTH-1:0] y,                            
  input       [DATAWIDTH-1:0] x,
  output reg  out_valid,
  output reg  [2*DATAWIDTH-1:0] p
);


parameter   READ   = 2'b00,
            ADD    = 2'b01,
            SHIFT  = 2'b11,
            OUTPUT = 2'b10;

reg  [1:0]              current_state, next_state;  // state registers.
reg  [2*DATAWIDTH+1:0]  a_reg,s_reg;  // computational values.
reg  [2*DATAWIDTH+1:0] p_reg,sum_reg;
reg  [DATAWIDTH-1:0]    iter_cnt;                   // iteration count for determining when out_valid.
wire [DATAWIDTH:0]      y_neg;             // negative value of y


always @(posedge clk or negedge rst)
  if (!rst) current_state = READ;
  else current_state <= next_state;

// state transform
always @(*) begin
  next_state = 2'bx;
  case (current_state)
    READ  : if (in_valid == 0) next_state = ADD;
            else    next_state = READ;
    ADD   : next_state = SHIFT;
    SHIFT : if (iter_cnt==DATAWIDTH) next_state = OUTPUT;
            else            next_state = ADD;
    OUTPUT: next_state = OUTPUT;
  endcase
end

// negative value of y.
assign y_neg = -{y[DATAWIDTH-1],y}; 
// algorithm implemenation details.
always @(posedge clk or negedge rst) begin
  if (!rst) begin
    {a_reg,s_reg,p_reg,iter_cnt,out_valid,sum_reg,p} <= 0;
  end 
  else begin
  case (current_state)
    READ :  begin
      a_reg    <= {y[DATAWIDTH-1],y,{(DATAWIDTH+1){1'b0}}};
      s_reg    <= {y_neg,{(DATAWIDTH+1){1'b0}}};
      p_reg    <= {{(DATAWIDTH+1){1'b0}},x,1'b0};
      iter_cnt <= 0;
      out_valid     <= 1'b0;
    end
    ADD  :  begin
      case (p_reg[1:0])
        2'b01       : sum_reg <= p_reg+a_reg; // + y
        2'b10       : sum_reg <= p_reg+s_reg; // - y
        2'b00,2'b11 : sum_reg <= p_reg;       // nop
      endcase
      iter_cnt <= iter_cnt + 1;
    end
    SHIFT :  begin
      p_reg <= {sum_reg[2*DATAWIDTH+1],sum_reg[2*DATAWIDTH+1:1]}; // right shift 
    end
    OUTPUT : begin
      p <= p_reg[2*DATAWIDTH:1];
      out_valid <= 1'b1;
    end
  endcase
 end
end

endmodule


