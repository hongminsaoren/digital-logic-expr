`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/15 09:57:44
// Design Name: 
// Module Name: VGASim
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


module VGASim(
    input CLK100MHZ,        //ϵͳʱ���ź�
    input  BTNC,           // ��λ�ź�
    output [3:0] VGA_R,    //��ɫ�ź�ֵ
    output [3:0] VGA_G,    //��ɫ�ź�ֵ
    output [3:0] VGA_B,     //��ɫ�ź�ֵ
    output  VGA_HS,         //��ͬ���ź�
    output  VGA_VS          //֡ͬ���ź�
 );
wire [11:0] vga_data;
wire valid;
wire [11:0] h_addr;
wire [11:0] v_addr;
reg cnt;
reg CLK25MHZ;
always@(posedge CLK100MHZ)begin
  if(cnt==0)begin
     cnt<=1;
     CLK25MHZ<=~CLK25MHZ;
  end
  else 
     cnt<=cnt-1;
end

VGACtrl vgactrl(.pix_x(h_addr),.pix_y(v_addr),.hsync(VGA_HS),.vsync(VGA_VS),.pix_valid(valid),.pix_clk(CLK25MHZ),.pix_rst(BTNC));
VGADraw vgadraw(.pix_data(vga_data),.pix_x(h_addr),.pix_y(v_addr),.pix_valid(valid),.pix_clk(CLK25MHZ));
assign VGA_R=vga_data[11:8];
assign VGA_G=vga_data[7:4];
assign VGA_B=vga_data[3:0];
endmodule
