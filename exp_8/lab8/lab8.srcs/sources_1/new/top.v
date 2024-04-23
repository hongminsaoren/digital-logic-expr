`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/21 19:50:00
// Design Name: 
// Module Name: top
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


module top(
   output [6:0]SEG,     
    output [7:0]AN,              //显示32位输出数值
    output [15:0] dataout_L8b,   //输出数据低16位
    input CLK100MHZ  ,         //系统时钟信号
        input CLK  ,         //系统时钟信号

    input BTNC
    );
    wire [31:0]data;
   wire [31:0] iaddr,idataout;
wire iclk;
wire [31:0] daddr,ddataout,ddatain;
wire drdclk, dwrclk, dwe;
wire [2:0]  dop;
wire [15:0] cpudbgdata; 
    SingleCycleCPU  mycpu(.clock(CLK), 
                 .reset(BTNC), 
				 .InstrMemaddr(iaddr), .InstrMemdataout(idataout), .InstrMemclk(iclk), 
				 .DataMemaddr(daddr), .DataMemdataout(ddataout), .DataMemdatain(ddatain), .DataMemrdclk(drdclk),
				  .DataMemwrclk(dwrclk), .DataMemop(dop), .DataMemwe(dwe),  .dbgdata(cpudbgdata));

			  
 nstrMem myinstrmem(.instr(idataout),.addr(iaddr),.InstrMemEn(~BTNC),.clk(iclk)	);
			DataMem mydatamem(.dataout(ddataout), .clk(dwrclk),  .we(dwe),  .MemOp(dop), .datain(ddatain),.addr(daddr));
assign data=mycpu.myregfile.regfiles[1];assign dataout_L8b=data ;

seg7decimal sevenSeg (
.x(data),
.clk(CLK100MHZ),
.seg(SEG[6:0]),
.an(AN[7:0])
);

endmodule

module seg7decimal(
	input [31:0] x,
    input clk,
    output reg [6:0] seg,
    output reg [7:0] an,
    output wire dp 
	 );
	 
	 
wire [2:0] s;	 
reg [3:0] digit;
wire [7:0] aen;
reg [19:0] clkdiv;

assign dp = 1;
assign s = clkdiv[19:17];
assign aen = 8'b11111111; // all turned off initially

// quad 4to1 MUX.


always @(posedge clk)// or posedge clr)
	
	case(s)
	0:digit = x[3:0]; // s is 00 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
	1:digit = x[7:4]; // s is 01 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
	2:digit = x[11:8]; // s is 10 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8
	3:digit = x[15:12]; // s is 11 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]
	4:digit = x[19:16]; // s is 00 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
    5:digit = x[23:20]; // s is 01 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
    6:digit = x[27:24]; // s is 10 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8
    7:digit = x[31:28]; // s is 11 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]

	default:digit = x[3:0];
	
	endcase
	
	//decoder or truth-table for 7seg display values
	always @(*)

case(digit)


//////////<---MSB-LSB<---
//////////////gfedcba////////////////////////////////////////////           a
0:seg = 7'b1000000;////0000												   __					
1:seg = 7'b1111001;////0001												f/	  /b
2:seg = 7'b0100100;////0010												  g
//                                                                       __	
3:seg = 7'b0110000;////0011										 	 e /   /c
4:seg = 7'b0011001;////0100										       __
5:seg = 7'b0010010;////0101                                            d  
6:seg = 7'b0000010;////0110
7:seg = 7'b1111000;////0111
8:seg = 7'b0000000;////1000
9:seg = 7'b0010000;////1001
'hA:seg = 7'b0001000; 
'hB:seg = 7'b0000011; 
'hC:seg = 7'b1000110;
'hD:seg = 7'b0100001;
'hE:seg = 7'b0000110;
'hF:seg = 7'b0001110;

default: seg = 7'b0000000; // U

endcase


always @(*)begin
an=8'b11111111;
if(aen[s] == 1)
an[s] = 0;
end


//clkdiv

always @(posedge clk) begin
clkdiv <= clkdiv+1;
end
endmodule
module nstrMem(
    output reg [31:0] instr, //输出32位指令
    input [31:0] addr,       //32位地址数据，实际有效字长根据指令存储器容量来确定
    input InstrMemEn,        //指令存储器片选信号
    input clk               //时钟信号，下降沿有效    
 );
   (* ram_style="distributed" *) reg [31:0] ram[16384:0];//64KB的存储器空间，可存储16k条指令，地址有效长度16位
 initial  $readmemh( "C:/Users/HP/Desktop/lab8/lab8.sim/sim_1/behav/xsim/gr.hex",ram,0,16384);

    //always @ (*) instr = ram[0];
    wire [31:0]add;
    assign add=32'h0000007c;
    always @ (*) begin
       if (InstrMemEn) instr =ram[addr[15:2]];
       else instr=32'b0;
    end
endmodule
module ataMem(
   output [31:0] dataout,   //输出数据
   input clk,                   //时钟信号
   input we,                   //存储器写使能信号，高电平时允许写入数据
   input [2:0] MemOp,          //读写字节数控制
   input [31:0] datain,        //下输入数据
   input [15:0] addr           //存储器地址
);
(* ram_style="block" *)  reg [31:0] ram [2**16-1:0];  //设置使用块RAM综合成存储器
initial begin
	     $readmemh( "C:/Users/HP/Desktop/lab8/lab8.sim/sim_1/behav/xsimrv32ui-p-sub_d.hex",ram,0,2**16-1);
end

wire [31:0] intmp;
wire [31:0] outtmp;
assign outtmp = ram[addr[15:2]];

wire [15:0] houttmp = addr[1] ? outtmp[31:16] : outtmp[15:0];
wire [7:0] bouttmp = addr[1:0] == 2'b11 ? outtmp[31:24]
                   : addr[1:0] == 2'b10 ? outtmp[23:16]
                   : addr[1:0] == 2'b01 ? outtmp[15:8]
                   : outtmp[7:0];

/*
always @(posedge clk)   begin
       outtmp <= ram[addr[15:2]]; //上升沿读取存储器数据，先读取地址中数据
end
*/
always @(negedge clk)  begin
    if (we) ram[addr[15:2]] <= intmp; //下降沿写入存储器数据，写使能有效时，写入数据
end

/*
always @(*)
begin
   if (~we)  begin  //读取操作
            case (MemOp)
              3'b000: begin dataout = outtmp; end
              3'b001: begin dataout = {24'h000000, outtmp[7:0]}; end
              3'b010: begin dataout = {16'h0000, outtmp[15:0]}; end
              3'b101: begin dataout = {{24{outtmp[7]}}, outtmp[7:0]}; end
              3'b110: begin dataout = {{16{outtmp[15]}}, outtmp[15:0]}; end
              default:dataout = outtmp;
            endcase
        end
    else  begin  //写入操作
            case (MemOp)
                3'b000: begin intmp = datain; end
                3'b101: begin intmp = {outtmp[31:8], datain[7:0]}; end
                3'b110: begin intmp = {outtmp[31:16], datain[15:0]}; end
               default:intmp = datain;
            endcase
        end
 end
*/
/*
assign dataout = MemOp == 3'b000 ? outtmp
               : MemOp == 3'b001 ? {24'h000000, outtmp[7:0]}
               : MemOp == 3'b010 ? {16'h0000, outtmp[15:0]}
               : MemOp == 3'b101 ? {{24{outtmp[7]}}, outtmp[7:0]}
               : MemOp == 3'b110 ? {{16{outtmp[15]}}, outtmp[15:0]}
               : 32'h00000000;

assign intmp = MemOp == 3'b000 ? datain
             : MemOp == 3'b101 ? {outtmp[31:8], datain[7:0]}
             : MemOp == 3'b110 ? {outtmp[31:16], datain[15:0]}
             : 32'h00000000;
*/
/*
assign dataout = MemOp == 3'b000 ? {{24{outtmp[7]}}, outtmp[7:0]}
               : MemOp == 3'b001 ? {{16{outtmp[15]}}, outtmp[15:0]}
               : MemOp == 3'b010 ? outtmp
               : MemOp == 3'b100 ? {24'h000000, outtmp[7:0]}
               : MemOp == 3'b101 ? {16'h0000, outtmp[15:0]}
               : 32'h00000000;
*/
assign dataout = MemOp == 3'b000 ? {{24{bouttmp[7]}}, bouttmp}
               : MemOp == 3'b001 ? {{16{houttmp[15]}}, houttmp}
               : MemOp == 3'b010 ? outtmp
               : MemOp == 3'b100 ? {24'h000000, bouttmp}
               : MemOp == 3'b101 ? {16'h0000, houttmp}
               : 32'h00000000;

assign intmp = MemOp == 3'b000 ? 
                    (addr[1:0] == 2'b00 ? {outtmp[31:8], datain[7:0]}
                   : addr[1:0] == 2'b01 ? {outtmp[31:16], datain[7:0], outtmp[7:0]}
                   : addr[1:0] == 2'b10 ? {outtmp[31:24], datain[7:0], outtmp[15:0]}
                   :{datain[7:0], outtmp[23:0]})
             : MemOp == 3'b001 ? 
                    (addr[1] ? {datain[15:0], outtmp[15:0]} : {outtmp[31:16], datain[15:0]})
             : MemOp == 3'b010 ? datain
             : 32'h00000000;
endmodule