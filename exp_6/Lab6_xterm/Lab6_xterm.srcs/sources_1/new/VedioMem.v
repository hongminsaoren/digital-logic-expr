`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 15:27:12
// Design Name: 
// Module Name: VedioMem
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


module VedioMem(
read_addr,
ascii_out,
instr_addr,
instr_out,
write_addr,
wren,
ascii_in,
VGA_CLK,
PS2_CLK
    );
input [11:0]read_addr; //显存的地址，640*480，从12'd0排到12'd2399
output reg [7:0]ascii_out;
input [11:0]instr_addr;
output reg [7:0]instr_out;
input [11:0]write_addr;
input [7:0]ascii_in;
input wren; //写使能
input VGA_CLK;
input PS2_CLK;
integer i;
reg [7:0] VMem[4095:0];// 显存容量为4KB，实际只需要2.4KB
initial begin
  for(i=0;i<=2399;i=i+1)begin
  VMem[i]=0;//空白
  end
  for(i=0;i<=79;i=i+1)begin
  VMem[i]=45;
  end
VMem[6]=8'h58;
VMem[7]=8'h74;
VMem[8]=8'h65;
VMem[9]=8'h72;
VMem[10]=8'h6d;
VMem[11]=105;
VMem[12]=110;
VMem[13]=97;
VMem[14]=108;
VMem[50]=50;
VMem[51]=50;
end
always@(posedge VGA_CLK)begin
    ascii_out<=VMem[read_addr];
    instr_out<=VMem[instr_addr];
end

always@(posedge PS2_CLK)begin
  if(wren && ascii_in!=8'h0d && ascii_in!=8'h08 && ascii_in!=8'hff && ascii_in!=8'hfe && ascii_in!=8'hfd && ascii_in!=8'hfc)begin //需要完善判断条件
     VMem[write_addr]<=ascii_in;
  end
end
endmodule
