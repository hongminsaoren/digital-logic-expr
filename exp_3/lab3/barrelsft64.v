`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:02:49
// Design Name: 
// Module Name: barrelsft32
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


module barrelsft64(
      output reg [63:0] dout,
      input [63:0] din,
      input [5:0] shamt,     //移动位数
      input LR,           // LR=1时左移，LR=0时右移
      input AL            // AL=1时算术右移，AR=0时逻辑右移
	);
//add your code here
reg [63:0] temp;
always @ (din or shamt or LR or AL) 
begin
    temp = 64'b0;
    case(LR)
        1'b0: begin
            case(AL)
            1'b1:begin
             temp = shamt[0] ? {{din[63]}, din[63:1]} : din;
             temp = shamt[1] ? {{2{temp[63]}}, temp[63:2]} : temp;
             temp = shamt[2] ? {{4{temp[63]}}, temp[63:4]} : temp;
             temp = shamt[3] ? {{8{temp[63]}}, temp[63:8]} : temp;
             temp = shamt[4] ? {{16{temp[63]}}, temp[63:16]} : temp;
	         temp = shamt[5] ? {{32{temp[63]}}, temp[63:32]} : temp;
            end
           1'b0: begin
             temp = shamt[0] ? {1'b0, din[63:1]} : din;
             temp = shamt[1] ? {2'b0, temp[63:2]} : temp;
             temp = shamt[2] ? {4'b0, temp[63:4]} : temp;
             temp = shamt[3] ? {8'b0, temp[63:8]} : temp;
             temp = shamt[4] ? {16'b0, temp[63:16]} : temp;
             temp = shamt[5] ? {32'b0, temp[63:32]} : temp;
            end
            endcase
           end
        1'b1: begin
             temp = shamt[0] ? {{din[62:0]}, 1'b0} : din;
             temp = shamt[1] ? {{temp[61:0]}, 2'b0} : temp;
             temp = shamt[2] ? {{temp[59:0]}, 4'b0} : temp;
             temp = shamt[3] ? {{temp[55:0]}, 8'b0} : temp;
             temp = shamt[4] ? {{temp[47:0]}, 16'b0} : temp;
             temp = shamt[5] ? {{temp[31:0]}, 32'b0} : temp;
            end
    endcase
    dout = temp;
end
  
endmodule
