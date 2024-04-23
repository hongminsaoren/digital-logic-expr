`timescale 1ns / 1ps

module ALU32(
   output reg [31:0] result,      //32位运算结果
   output reg zero,               //结果为0标志位
   input   [31:0] dataa,      //32位数据输入，送到ALU端口A   
   input   [31:0] datab,      //32位数据输入，送到ALU端口B  
   input   [3:0] aluctr      //4位ALU操作控制信号
); 
//add your code here
wire SUBctr,LRctr,SIGctr,ALctr;
wire[2:0]OPctr;
wire [31:0]result1;
wire OF,CF,ZF,SF;
wire [31:0]data5;
wire [31:0]data1;
reg [31:0]data7;

Adder32 my_adder(.x(dataa),.y(datab),.sub(SUBctr),.OF(OF),.SF(SF),.CF(CF),.ZF(ZF),.f(data1));

barrelsft32 my_barrel(.shamt(datab[4:0]),.din(dataa),.AL(ALctr),.LR(LRctr),.dout(data5));

ALUcontrol control(.SUBctr(SUBctr),.LRctr(LRctr),.SIGctr(SIGctr),.ALctr(ALctr),.OPctr(OPctr),.ALUctr(aluctr));
mux_3to8 m38(.sel(OPctr),.out(result1 ),.data2(dataa&datab),.data3(dataa|datab),.data4(dataa^datab),.data6(datab),.data5(data5),.data7(data7),.data1(data1));


always@(*)begin
if(SIGctr==1'd1)
  begin 
     if(OF^SF==1)
        data7=32'h1;
       if(OF^SF==0) data7=32'h00000000;
    end   
  if(SIGctr==1'd0) 
  begin
       if(CF==1) 
            data7=32'h1;
         if(CF==0) data7=32'h00000000;  
    end  
     result=result1;

zero = (ZF);
end
endmodule
