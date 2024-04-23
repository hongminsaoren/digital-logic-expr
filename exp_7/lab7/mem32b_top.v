`timescale 1ns / 1ps


module mem32b_top(
    output [6:0]SEG,     
    output [7:0]AN,              //��ʾ32λ�����ֵ
    output [15:0] dataout_L8b,   //������ݵ�16λ
    input CLK100MHZ,            //ϵͳʱ���ź�
    input BTNC,                 //��λ�����ź�
    input [2:0] MemOp,          //��д�ֽ��������ź�
    input we,                   //�洢��дʹ���źţ��ߵ�ƽʱ����д������
    input [3:0] addr_L4b,           //��ַλ��4λ����λ����ָ��Ϊ0����������ֵ
    input [7:0] datain_L8b          //�������ݵ�8λ�����ظ�4�Σ����λָ��Ϊ����ֵ
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
