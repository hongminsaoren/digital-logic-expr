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


module barrelsft32(
      output reg [31:0] dout,
      input [31:0] din,
      input [4:0] shamt,     //�ƶ�λ��
      input LR,           // LR=1ʱ���ƣ�LR=0ʱ����
      input AL            // AL=1ʱ�������ƣ�AR=0ʱ�߼�����
	);
//add your code here
reg [31:0] temp;
always @ (din or shamt or LR or AL) 
begin
    temp = 32'b0;
    case(LR)
        1'b0: begin
            case(AL)
            1'b1:begin
             temp = shamt[0] ? {{din[31]}, din[31:1]} : din;
             temp = shamt[1] ? {{2{temp[31]}}, temp[31:2]} : temp;
             temp = shamt[2] ? {{4{temp[31]}}, temp[31:4]} : temp;
             temp = shamt[3] ? {{8{temp[31]}}, temp[31:8]} : temp;
             temp = shamt[4] ? {{16{temp[31]}}, temp[31:16]} : temp;
            end
           1'b0: begin
             temp = shamt[0] ? {1'b0, din[31:1]} : din;
             temp = shamt[1] ? {2'b0, temp[31:2]} : temp;
             temp = shamt[2] ? {4'b0, temp[31:4]} : temp;
             temp = shamt[3] ? {8'b0, temp[31:8]} : temp;
             temp = shamt[4] ? {16'b0, temp[31:16]} : temp;
            end
            endcase
           end
        1'b1: begin
             temp = shamt[0] ? {{din[30:0]}, 1'b0} : din;
             temp = shamt[1] ? {{temp[29:0]}, 2'b0} : temp;
             temp = shamt[2] ? {{temp[27:0]}, 4'b0} : temp;
             temp = shamt[3] ? {{temp[23:0]}, 8'b0} : temp;
             temp = shamt[4] ? {{temp[15:0]}, 16'b0} : temp;
            end
    endcase
    dout = temp;
end
  
endmodule
