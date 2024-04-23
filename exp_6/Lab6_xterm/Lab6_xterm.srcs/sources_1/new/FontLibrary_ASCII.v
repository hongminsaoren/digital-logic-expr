`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 15:00:10
// Design Name: 
// Module Name: FontLibrary_ASCII
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


module FontLibrary_ASCII(
address,
ldotmatrix
    );
input [11:0]address;     //12位地址，256*16=2^12，由地址可以得到某个字符点阵一行的信息
output [7:0]ldotmatrix;  //字符点阵的一行，字符点阵为16*8，每一行一个字节，8bit
reg [7:0] dotmatrix[4095:0];
initial  begin
$readmemh("S:/univer/sem2_1/digital_experiment/exp_6/Lab6_xterm/ASCout.txt",dotmatrix,0,4095);//斜杠方向很重要
end
assign ldotmatrix=dotmatrix[address];
endmodule
