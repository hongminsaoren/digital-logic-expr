`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 16:33:34
// Design Name: 
// Module Name: encryption6b
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
integer i = 0;
reg [63:0] seed=64'ha845fd7183ad75c4;       //��ʼ64����seed=64'ha845fd7183ad75c4
reg [63:0] dout;

module encryption6b(
    output reg [7:0] dataout,    //������ܻ���ܺ��8����ASCII���ݡ�
    output reg ready,       //�����Ч��ʶ���ߵ�ƽ˵�������Ч����6���ڸߵ�ƽ
    output reg [5:0] key,       //���6λ������
    input clk,             // ʱ���źţ���������Ч
    input load,            //����seedָʾ���ߵ�ƽ��Ч
    input [7:0] datain       //�������ݵ�8����ASCII�롣
);
//add your code here

always @(i)
begin
    if(i % 6 == 0)
    begin
        ready = 1;
        key = seed[63:58];
        dataout = {datain[7:6],datain[5:0] ^ key};
    end
    else
        ready = 0;
end

always @ (posedge clk)
begin
 if (load == 1'b1) 
    dout <= seed;
 else 
    seed <= {seed[4]^seed[3]^seed[1]^seed[0], seed[63:1]};
 i <= i + 1;   
end
endmodule

