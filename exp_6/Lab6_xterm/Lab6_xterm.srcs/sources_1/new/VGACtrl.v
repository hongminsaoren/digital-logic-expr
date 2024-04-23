`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 16:16:21
// Design Name: 
// Module Name: VGACtrl
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

module VGACtrl(
    input   wire            pix_clk,     //����ʱ���ź�
    input   wire            pix_rst,     //��λ�ź�
    output  wire  [11:0]    pix_x,      //�����ڿ���ʾ�����е�ˮƽλ��
    output  wire  [11:0]    pix_y,      //�����ڿ���ʾ�����еĴ�ֱλ��
    output  wire            hsync,      //ˮƽͬ���ź�
    output  wire            vsync,      //��ֱͬ���ź�
    output wire             pix_valid    //�����ڿ���ʾ�����־
);
//hsync800 	640*480@60Hz
   parameter    H_Sync_Width = 96;
   parameter    H_Back_Porche = 48;
   parameter    H_Active_Pixels = 640;
   parameter    H_Front_Porch = 16;
   parameter    H_Totals = 800;
 //vsync525
   parameter    V_Sync_Width = 2;
   parameter    V_Back_Porche = 33;
   parameter    V_Active_Pixels =480;
   parameter    V_Front_Porch = 10;
   parameter    V_Totals = 525;
   reg [11:0]   cnt_h       ;
   reg [11:0]   cnt_v       ;
   wire         rgb_valid   ;
  //�͵�ƽ��Ч   
assign hsync = ((cnt_h >= H_Sync_Width)) ? 1'b0 : 1'b1;  //����ˮƽͬ�����أ�hsync=0
assign vsync = ((cnt_v >= V_Sync_Width)) ? 1'b0 : 1'b1;  //����֡ͬ�����أ�vsync=0
//cnt_h��cnt_v����λ�ü���
always@(posedge pix_clk) begin
         if (pix_rst) begin
            cnt_h <= 0;
            cnt_v <= 0;
        end
       if (cnt_h == (H_Totals-1)) begin               // �����ؽ���
            cnt_h <= 0;
            cnt_v <= (cnt_v == (V_Totals-1)) ? 0 : cnt_v + 1;  // ֡���ؽ���
          end 
        else begin
               cnt_h <= cnt_h + 1;
            end
 end
//pix_valid=1����ʾ���ش�����Ч��ʾ���� //����Ӧ�øĳ�����ҿ������ұգ�����ʾ�źŵ����Ӱ�첻�󣬵���Ӱ���������
assign  pix_valid = (((cnt_h >= H_Sync_Width +H_Back_Porche)
                    && (cnt_h < H_Totals- H_Front_Porch))
                    &&((cnt_v >= V_Sync_Width +V_Back_Porche)
                    && (cnt_v < V_Totals - V_Front_Porch)))
                    ? 1'b1 : 1'b0;
//Hsync,Vsync active�����������ڿ���ʾ�����λ�� ��Χ��x[0,639] y[0,479]
   assign pix_x = (pix_valid==1) ? (cnt_h - (H_Sync_Width + H_Back_Porche)):12'h0;
   assign pix_y = (pix_valid==1) ? (cnt_v - (V_Sync_Width + V_Back_Porche)):12'h0;
endmodule
