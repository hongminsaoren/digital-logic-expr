`timescale 1ns / 1ps


module mem32b_top(
    output [6:0]SEG,     
    output [7:0]AN,              //显示32位输出数值
    output [15:0] dataout_L8b,   //输出数据低16位
    input CLK100MHZ,            //系统时钟信号
    input BTNC,                 //复位清零信号
    input [2:0] MemOp,          //读写字节数控制信号
    input we,                   //存储器写使能信号，高电平时允许写入数据
    input [3:0] addr_L4b,           //地址位低4位，高位可以指定为0或其他任意值
    input [7:0] datain_L8b          //输入数据低8位，可重复4次，或高位指定为任意值
 );
 // Add your code here 
wire [31:0] data_in;

assign data_in[7:0]=datain_L8b;
assign data_in[15:8]=datain_L8b;
assign data_in[23:16]=datain_L8b;
assign data_in[31:24]=datain_L8b;
wire [15:0] addr_in;
assign addr_in[15:4]=12'h000;
assign addr_in[3:0]=addr_L4b;
wire [31:0] data;
assign dataout_L8b=data[15:0];
mem32b Mem32b(
    .BTNC(BTNC),
   .dataout(data[31:0]),  
   .clk(CLK100MHZ),                  
   .we(we),                   
   .MemOp(MemOp[2:0]),      
   .datain(data_in[31:0]),        
   .addr(addr_in)           
);
seg7decimal sevenSeg (
.x(data[31:0]),
.clk(CLK100MHZ),
.seg(SEG[6:0]),
.an(AN[7:0])
);
endmodule
