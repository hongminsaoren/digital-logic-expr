`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/13 23:05:31
// Design Name: 
// Module Name: MouseReceiver
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


module MouseReceiver(
    output reg [6:0] SEG,
    output reg [7:0] AN,
    output reg DP,
    output reg LeftButton,
    output reg RightButton,
    output reg MiddleButton,
    input CLK100MHZ,
    input PS2_CLK,
    input PS2_DATA
    );
    wire PS2_DATAF,PS2_CLKF;
    wire [6:0]seg;
    wire [7:0]an;
    wire dp;
    reg [7:0]datacur; //当前扫描码
    reg [7:0]dataprev; //上一个扫描码
    reg [3:0]cnt; //收到串行位数
    reg [31:0]mousecode; //扫描码
    reg flag; //接受 1 帧数据
    reg readyflag;
    reg [31:0]mcode;
    reg CLK50MHZ=0;
    reg [7:0]xx;
    reg [7:0]yy;
    reg [2:0]zz;
    reg [2:0]sig;
    initial begin //初始化
    mousecode[7:0]<=8'b00000000;
    mcode<=0;
    cnt<=4'b0000;
    sig = 0;
    end
    always@(posedge CLK100MHZ)begin
        CLK50MHZ=~CLK50MHZ;
    end
    debouncer debounce( .clk(CLK50MHZ), .I0(PS2_CLK), .I1(PS2_DATA), .O0(PS2_CLKF), .O1(PS2_DATAF)); 
    always@(negedge(PS2_CLKF))begin
    case(cnt)
    0: readyflag<=1'b0; //开始位
    1:datacur[0]<=PS2_DATAF;
    2:datacur[1]<=PS2_DATAF;
    3:datacur[2]<=PS2_DATAF;
    4:datacur[3]<=PS2_DATAF;
    5:datacur[4]<=PS2_DATAF;
    6:datacur[5]<=PS2_DATAF;
    7:datacur[6]<=PS2_DATAF;
    8:datacur[7]<=PS2_DATAF;
    9:flag<=1'b1; //已接收 8 位有效数据
    10:flag<=1'b0; //结束位
 endcase
 if(cnt<=9) cnt<=cnt+1;
 else if(cnt==10) begin
 cnt<=0;
 if(sig<=2)sig<=sig+1;
 else sig=0;
 end
 end
 always @(posedge flag)begin
 if (dataprev!=datacur)begin //去除重复按键数据
 mousecode[31:24]<=mousecode[23:16];
 mousecode[23:16]<=mousecode[15:8];
 mousecode[15:8]<=dataprev;
 mousecode[7:0]<=datacur;
 dataprev<=datacur;
 readyflag<=1'b1; //数据就绪标志位置 1
    end
 end
 assign ready=readyflag; 
  always @(*)begin
    if(mousecode[28])begin
        xx=~(mousecode[23:16]-1);
    end
    else xx = mousecode[23:16];
    if(mousecode[29])begin
        yy=~(mousecode[15:8]-1);
    end
    else yy = mousecode[15:8];
    if(mousecode[3])begin
        zz=~(mousecode[2:0]-1);
    end
    else zz = mousecode[2:0];
    end
    always@(*)begin
    if(sig==0)mcode={3'b111,mousecode[28],xx,3'b111,mousecode[29],yy,3'b111,mousecode[3],1'b0,zz};
    end

    seg7decima sevenSeg (
    .x(mcode),
    .clk(CLK100MHZ),
    .seg(seg),
    .an(an),
    .dp(dp) );
always@(*)begin
SEG=seg;
AN=an;
DP=dp;
LeftButton=mousecode[24];
RightButton=mousecode[25];
MiddleButton=mousecode[26];
end
    
endmodule

module seg7decima(
	input [31:0] x,
    input clk,
    output reg [6:0] seg,
    output reg [7:0] an,
    output wire dp 
	 );
	 
	 
wire [2:0] s;	 
reg [4:0] digit;
wire [7:0] aen;
reg [19:0] clkdiv;
reg flag;
assign dp = 1;
assign s = clkdiv[19:17];
assign aen = 8'b11111111; // all turned off initially

// quad 4to1 MUX.


always @(posedge clk)// or posedge clr)
	
	case(s)
	0:digit <= {1'b0,x[3:0]};// s is 00 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
	1:digit <= {1'b1,x[7:4]}; // s is 01 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
	2:digit <= {1'b0,x[11:8]}; // s is 10 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8]
	3:digit <= {1'b0,x[15:12]}; // s is 11 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]
	4:digit <= {1'b1,x[19:16]}; // s is 00 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
    5:digit <= {1'b0,x[23:20]}; // s is 01 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
    6:digit <= {1'b0,x[27:24]}; // s is 10 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8
    7:digit <= {1'b1,x[31:28]}; // s is 11 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]

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
'h1F:seg = 7'b0111111;
default: seg = 7'b1111111;

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

module debouncer(
 input clk,
 input I0,
 input I1,
 output reg O0,
 output reg O1
 );
 reg [4:0]cnt0, cnt1;
 reg Iv0=0,Iv1=0;
 reg out0, out1;
 always@(posedge(clk))begin
 if (I0==Iv0)begin
 if (cnt0==19) O0<=I0; //接收到 20 次相同数据
 else cnt0<=cnt0+1;
 end
 else begin
 cnt0<="00000";
 Iv0<=I0;
 end
 if (I1==Iv1)begin
 if (cnt1==19) O1<=I1; //接收到 20 次相同数据
 else cnt1<=cnt1+1;
 end
 else begin
 cnt1<="00000";
 Iv1<=I1;
 end
 end
endmodule