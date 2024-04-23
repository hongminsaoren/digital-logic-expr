`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 21:43:49
// Design Name: 
// Module Name: KeyBoardReceiver_tb
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


module KeyBoardReceiver_tb ( );
 parameter [31:0] clock_period = 10; ////���ü��̿�������ʱ������Ϊ 10ns��
 reg clk;
 wire [31:0] data;
 wire ready,overflow;
 wire kbd_clk, kbd_data;
 KeyBoardSend KB_Send(.ps2_clk(kbd_clk),.ps2_data(kbd_data));
 KeyBoardReceiver KeyBoardReceiver_uut(.keycodeout(data),.ready(ready),.clk(clk),.kb_clk(kbd_clk),.kb_data(kbd_data));
initial begin /* clock driver */

 clk = 0;
forever
 #(clock_period/2) clk = ~clk;
 end
initial begin
 KB_Send.kbd_sendcode(8'h31); // press 'N'
#10 KB_Send.kbd_sendcode(8'hF0); // break code
#10 KB_Send.kbd_sendcode(8'h31); // release 'N'
#10 KB_Send.kbd_sendcode(8'h12); // ��� shiftj ��
#10 KB_Send.kbd_sendcode(8'h3B); // press 'J'
#10 KB_Send.kbd_sendcode(8'hF0); // break code
#10 KB_Send.kbd_sendcode(8'h3B); // release 'J'
#10 KB_Send.kbd_sendcode(8'h3C); // keep pressing 'U'
#10 KB_Send.kbd_sendcode(8'hF0); // break code
#10 KB_Send.kbd_sendcode(8'h3C); // release 'U'
#10 
$stop;
end
endmodule
