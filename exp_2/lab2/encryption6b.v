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
reg [63:0] seed=64'ha845fd7183ad75c4;       //初始64比特seed=64'ha845fd7183ad75c4
reg [63:0] dout;

module encryption6b(
    output reg [7:0] dataout,    //输出加密或解密后的8比特ASCII数据。
    output reg ready,       //输出有效标识，高电平说明输出有效，第6周期高电平
    output reg [5:0] key,       //输出6位加密码
    input clk,             // 时钟信号，上升沿有效
    input load,            //载入seed指示，高电平有效
    input [7:0] datain       //输入数据的8比特ASCII码。
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

