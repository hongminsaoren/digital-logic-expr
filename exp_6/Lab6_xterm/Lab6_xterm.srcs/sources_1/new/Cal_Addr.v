`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 16:28:39
// Design Name: 
// Module Name: Cal_Addr
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


module Cal_Addr(
input [11:0]pix_x,
input [11:0]pix_y,
output [11:0]pix_h,
output [11:0]pix_v,
output [11:0] VMemaddr
    );
//组合逻辑，输入像素坐标，输出所在位置坐标，80*30
//0<=x<=639 0<=y<=479
assign pix_v=pix_x/(12'd8);
assign pix_h=pix_y/(12'd16);
assign VMemaddr= pix_h*(12'd80)+pix_v;
endmodule
