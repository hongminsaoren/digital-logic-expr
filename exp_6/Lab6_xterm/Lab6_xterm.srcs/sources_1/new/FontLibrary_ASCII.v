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
input [11:0]address;     //12λ��ַ��256*16=2^12���ɵ�ַ���Եõ�ĳ���ַ�����һ�е���Ϣ
output [7:0]ldotmatrix;  //�ַ������һ�У��ַ�����Ϊ16*8��ÿһ��һ���ֽڣ�8bit
reg [7:0] dotmatrix[4095:0];
initial  begin
$readmemh("S:/univer/sem2_1/digital_experiment/exp_6/Lab6_xterm/ASCout.txt",dotmatrix,0,4095);//б�ܷ������Ҫ
end
assign ldotmatrix=dotmatrix[address];
endmodule
