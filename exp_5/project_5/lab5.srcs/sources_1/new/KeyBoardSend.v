`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 21:43:05
// Design Name: 
// Module Name: KeyBoardSend
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


module KeyBoardSend (
output reg ps2_clk,
output reg ps2_data
);
parameter [31:0] kbd_clk_period = 60; //����ģ������봫��ʱ������Ϊ 60ns��
initial ps2_clk = 1'b1;
task kbd_sendcode;
input [7:0] code; // 8 λ������

integer i;
reg[10:0] send_buffer;
begin
 send_buffer[0] = 1'b0; // start bit
 send_buffer[8:1] = code; // code
 send_buffer[9] = ~(^code); // odd parity bit
 send_buffer[10]= 1'b1; // stop bit
 i = 0;
while( i < 11) begin
 ps2_data = send_buffer[i]; // ��������λ
 #(kbd_clk_period/2) ps2_clk = 1'b0; // �½���
 #(kbd_clk_period/2) ps2_clk = 1'b1;
 i = i + 1;
 end
end
 endtask
endmodule
