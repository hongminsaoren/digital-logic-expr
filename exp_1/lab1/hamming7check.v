`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 21:27:45
// Design Name: 
// Module Name: hamming7check
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


module hamming7check(
   output reg [7:1] DC,    //纠错输出7位正确的结果
   output reg  NOERROR,    //校验结果正确标志位
   input  [7:1] DU         //输入7位汉明码
);
// add your code here
reg [2:0] S;
always @(*)
    begin
        S[0] = DU[1] ^ DU[3] ^ DU[5] ^ DU[7];
        S[1] = DU[2] ^ DU[3] ^ DU[6] ^ DU[7];
        S[2] = DU[4] ^ DU[5] ^ DU[6] ^ DU[7];
    end    

reg [7:0] code;
always @(S)
    begin
        case(S)
        3'b000: code = 8'b00000001;
        3'b001: code = 8'b00000010;
        3'b010: code = 8'b00000100;
        3'b011: code = 8'b00001000;
        3'b100: code = 8'b00010000;
        3'b101: code = 8'b00100000;
        3'b110: code = 8'b01000000;
        3'b111: code = 8'b10000000;
        endcase
     end
 
 integer i;    
 always @(code)
    begin
        NOERROR = code[0];
        for(i = 1; i <= 7; i = i + 1)
        begin
            DC[i] = DU[i] ^ code[i];
        end
    end  
endmodule
