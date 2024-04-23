`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/19 17:02:23
// Design Name: 
// Module Name: xterm
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


module xterm(
    input CLK100MHZ,   //系统时钟信号
    input PS2_CLK,    //来自键盘的时钟信号
    input PS2_DATA,  //来自键盘的串行数据位
    input BTNC,      //Reset
    output [6:0]SEG,
    output [7:0]AN,     //显示扫描码和ASCII码
    output [15:0] LED,   //显示键盘状态
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output  VGA_HS,
    output  VGA_VS
);
// Add your code here
wire [7:0]keydatain;
//////////////////////////////
keyboard mykey(
.CLK100MHZ(CLK100MHZ)
,.PS2_CLK(PS2_CLK)
,.PS2_DATA(PS2_DATA)
,.BTNC(BTNC)
,.ascii_key(keydatain)
,.SEG(SEG)
,.AN(AN)
,.LED(LEd));
////////////////////////////////
wire [11:0] color;
assign VGA_R=color[11:8];
assign VGA_G=color[7:4];
assign VGA_B=color[3:0];
//reg CLK25MHZ;
//wire locked;
//clk_wiz_0 myvgaclk(.clk_in1(CLK100MHZ),.reset(BTNC),.locked(locked),.CLK25MHZ(CLK25MHZ));
reg cnt;
reg CLK25MHZ;
always@(posedge CLK100MHZ )begin//如果在敏感列表中加上清零信号就不能输出正确时序 
   if(cnt==0||BTNC)begin
       cnt<=1'b1;
       CLK25MHZ<=~CLK25MHZ;
   end
   else
       cnt<=cnt-1'b1;
end

VGADisplay myvga(
.CLK25MHZ(CLK25MHZ)
,.CLK100MHZ(CLK100MHZ)
,.PS2_CLK(PS2_CLK)
,.rst(BTNC)
,.keydatain(keydatain)
,.VGA_HS(VGA_HS)
,.VGA_VS(VGA_VS)
,.color(color));

endmodule

