`timescale 1ns / 1ps

module mem32b(
   output reg [31:0] dataout,   //输出数据
   input clk,                   //时钟信号
   input we,                   //存储器写使能信号，高电平时允许写入数据
   input [2:0] MemOp,          //读写字节数控制信号
   input [31:0] datain,        //输入数据
   input [15:0] addr,           //16位存储器地址
   input BTNC
);
// Add your code here
wire [7:0] datain1;
wire [7:0] datain2;
wire [7:0] datain3;
wire [7:0] datain4;

reg [31:0] data_in;
assign datain1=data_in[7:0];
assign datain2=data_in[15:8];
assign datain3=data_in[23:16];
assign datain4=data_in[31:24];

wire [7:0] dataout1;
wire [7:0] dataout2;
wire [7:0] dataout3;
wire [7:0] dataout4;

wire [31:0] dataout_read;
assign dataout_read[7:0]=dataout1;
assign dataout_read[15:8]=dataout2;
assign dataout_read[23:16]=dataout3;
assign dataout_read[31:24]=dataout4;

always@(*)begin
    if(we==1'b0)begin
        case(MemOp)
            3'b010:dataout=dataout_read;//
            3'b100:dataout={24'h000000,dataout_read[7:0]};//
            3'b101:dataout={16'h0000,dataout_read[15:0]};//
            3'b000:dataout={{24{dataout_read[7]}},dataout_read[7:0]}; 
            3'b001:dataout={{16{dataout_read[15]}},dataout_read[15:0]}; 
            default:dataout=dataout_read;
        endcase
    end
    else begin
        case(MemOp)
            3'b010:data_in=datain;//
            3'b000:data_in={{24{datain[7]}},datain[7:0]}; 
            3'b001:data_in={{16{datain[15]}},datain[15:0]}; 
            default:data_in=datain;
        endcase
    end
end
mem8b ram1(
   .dataout(dataout1),   
   .cs(1'b1),                  
   .clk(clk),                  
   .we(we),                 
   .datain(datain1),        
   .addr(addr),         
   .BTNC(BTNC)
);
mem8b ram2(
   .dataout(dataout2),   
   .cs(1'b1),                  
   .clk(clk),                  
   .we(we),                 
   .datain(datain2),        
   .addr(addr),         
   .BTNC(BTNC)
);
mem8b ram3(
   .dataout(dataout3),   
   .cs(1'b1),                  
   .clk(clk),                  
   .we(we),                 
   .datain(datain3),        
   .addr(addr),         
   .BTNC(BTNC)
);
mem8b ram4(
   .dataout(dataout4),   
   .cs(1'b1),                  
   .clk(clk),                  
   .we(we),                 
   .datain(datain4),        
   .addr(addr),         
   .BTNC(BTNC)
);
endmodule
