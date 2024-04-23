`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:03:26
// Design Name: 
// Module Name: ALU32
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


module ALU32(
output  reg [31:0] result,       //32位运算结果
output  wire zero,             //结果为0标志位
input   [31:0] dataa,          //32位数据输入，送到ALU端口A   
input   [31:0] datab,          //32位数据输入，送到ALU端口B  
input   [3:0] aluctr        //4位ALU操作控制信号
); 
//add your code here
wire [31:0] calculate, move;
reg [31:0] temp;
reg SIG;
reg [3:0] compare;
reg[2:0] OPctr;
wire ZF, OF, SF, CF, cout;
integer sub, AL, LR;
always @ (aluctr) begin
    case(aluctr)
    4'b0000:begin sub = 0; OPctr = 3'b000;end
    4'b0001:begin LR = 1; OPctr = 3'b100;end
    4'b0010:begin sub = 1; SIG = 1; OPctr = 3'b110;end
    4'b0011:begin sub = 1; SIG = 0; OPctr = 3'b110;end
    4'b0100:begin temp = (dataa^datab);  OPctr = 3'b011;end
    4'b0101:begin LR = 0; AL = 0; OPctr = 3'b100; end
    4'b0110:begin temp = (dataa|datab);  OPctr = 3'b010;end
    4'b0111:begin temp = (dataa&datab);  OPctr = 3'b001;end
    4'b1000:begin sub = 1; OPctr = 3'b000;end
    4'b1101:begin LR = 0; AL = 1; OPctr = 3'b100; end
    4'b1111:begin temp = datab;  OPctr = 3'b101;end
    endcase
end

Adder32 my_adder(calculate, OF, ZF, SF, CF, cout, dataa, datab, sub);
barrelsft32 my_barrel(move, dataa, datab[4:0], LR, AL);
reg com = 0;

always@(OPctr)begin
if(dataa[31] == 0 && datab[31] == 0)
    com = (dataa[30:0] < datab[30:0]);
else if(dataa[31] == 0 && datab[31] == 1)
    com = 1'b0;
else if(dataa[31] == 1 && datab[31] == 0)
    com = 1'b1;
else
    com = (dataa[30:0] < datab[30:0]);
end

wire resuIt = (SIG== 1 && OPctr==3'b110) ? (OF ^ SF) : (CF ^ sub);

always @(move or calculate or aluctr)begin
    case(OPctr)
    3'b000: result = calculate;
    3'b100: result = move;
    3'b110: result = {31'b0, (SIG == 1) ? com:(dataa < datab)};
    default: result = temp;
    endcase
end
assign zero = (result == 0) ? 1 : 0;

endmodule
