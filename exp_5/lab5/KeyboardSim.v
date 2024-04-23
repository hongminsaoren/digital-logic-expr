`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/10 09:38:14
// Design Name: 
// Module Name: KeyboardSim
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


module KeyboardSim(
    input CLK100MHZ,   //系统时钟信号
    input PS2_CLK,    //来自键盘的时钟信号
    input PS2_DATA,  //来自键盘的串行数据位
    input BTNC,      //Reset
    output [6:0]SEG,
    output [7:0]AN,
    output [15:0] LED   //显示
    );
    
// Add your code here
wire ready;
wire [31:0]seg7_data ;
reg CLK50MHZ=0;    
wire [31:0]keycode;
wire  [7:0]count;
reg  [7:0]trans;

always @(posedge(CLK100MHZ))begin
    CLK50MHZ<=~CLK50MHZ;
end

KeyBoardReceiver keyboard_uut(.keycodeout(keycode[31:0]),.ready(ready),.clk(CLK50MHZ),.kb_clk(PS2_CLK),.kb_data(PS2_DATA),.count(count));


assign seg7_data[31:24]=count[7:0];
assign seg7_data[23:16]= keycode[15:8];
assign seg7_data[15:8]=keycode[7:0];
assign seg7_data[7:0]=trans[7:0];
kbcode2ascii tt(.kbcode(keycode[7:0]),.asciicode(trans));

seg7decimal sevenSeg (
.x(seg7_data[31:0]),
.clk(CLK100MHZ),
.seg(SEG[6:0]),
.an(AN[7:0]),
.dp(0) 
);




endmodule
