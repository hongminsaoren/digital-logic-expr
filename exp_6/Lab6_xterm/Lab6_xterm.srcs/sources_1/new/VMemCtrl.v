`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/29 23:45:57
// Design Name: 
// Module Name: VMemCtrl
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


module VMemCtrl(
input CLK100MHZ,
input PS2_CLK,
input keyin,
input [7:0]keyascii,
input [7:0] instr_ascii,
output reg[3:0]instr,
output [11:0]write_addr,
output [7:0]ascii_in,
output reg [11:0]instr_addr,
output wren
    );
    reg writein;
    
assign wren=writein?((keyascii>31&&keyascii<127||keyascii==8)?1:0):1; //除去控制和通讯字符，写使能
reg [11:0] ptraddr;//光标地址
assign write_addr=ptraddr;
reg cnt;
reg [7:0]ptrascii;
assign ascii_in=(keyascii!=8)?keyascii:32;
initial begin
ptraddr=80;
end

reg[3:0]count;
reg [11:0] enters[31:0];//记录回车的位置
reg [7:0] enterptr;//回车指针
//////////////////////////////////////////////////////////////////
initial begin
enterptr=0;
instr=4'b0000;
end
always@(posedge CLK100MHZ)begin
if(instr_ascii==84)begin
instr<=4'b0100;
end
else if(instr_ascii==71)begin
instr<=4'b0001;
end
else if(instr_ascii==73)begin
instr<=4'b0010;
end
else
instr<=4'b0000;
end
///////////////////////////////////////////////////////////////////
always@(posedge PS2_CLK)begin
if(count==10)begin
   count<=0;
      if(keyascii>31&&keyascii<127)begin
        if(ptraddr<2399)
           ptraddr<=ptraddr+1;
           writein=1;
      end
      else if(keyascii==8)begin//back
         if(ptraddr>80)begin
           if(ptraddr%80==0&&enterptr)begin
             if(enterptr>0)begin
           enterptr=enterptr-1;
           ptraddr=enters[enterptr];
           end
           end
           else begin
            ptraddr<=ptraddr-1;
            end
         end
            writein=0;
      end
      else if(keyascii==13)begin//enter
         if(ptraddr<2320)begin
            ptraddr<=(ptraddr/80+1)*80;
            enters[enterptr]=ptraddr;
            enterptr=enterptr+1;
            writein=1;
            instr_addr<=(ptraddr/80)*80;
         end
      end
      else
      writein=0;
end
else
   count<=count+1;
end

endmodule
