`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:35:58
// Design Name: 
// Module Name: ALU32_tb
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


module ALU32_tb(    );
wire [31:0] result; //8位运算结果
wire zero; //结果为0标志位
reg [31:0] a, b; 
reg [3:0] aluctr;
//32位数据输入,送到ALU端口A
//32位数据输入,送到ALU端口B
//4位ALU操作控制信号
ALU32 ALU32_inst(.result(result),.zero(zero),.dataa(a),.datab(b),.aluctr(aluctr));
     initial begin
         #10 begin a=$random; b=$random; aluctr=4'b0000;end
         #20 aluctr=4'b0001;
         #20 aluctr=4'b0010;
         #20 aluctr=4'b0011;
         #20 aluctr=4'b0100;
         #20 aluctr=4'b0101;
         #20 aluctr=4'b0110;
         #20 aluctr=4'b0111;
         #20 aluctr=4'b1000;
         #20 aluctr=4'b1101;
         #20 aluctr=4'b1111;
         #50 begin a=32'h80000000; b=32'h7fffffff; aluctr=4'b0010; end
         #20 aluctr=4'b0011; 
         #20 aluctr=4'b0100;
         #20 aluctr=4'b0101;
         #20 aluctr=4'b0110;
         #20 aluctr=4'b0111;
         #20 aluctr=4'b1000;
         #50 begin a=32'h00000000; b=32'hffffffff; aluctr=4'b0010; end
         #20 aluctr=4'b0011; 
         #20 aluctr=4'b0100;
         #20 aluctr=4'b0101;
         #20 aluctr=4'b0110;
         #20 aluctr=4'b0111;
         #20 aluctr=4'b1000;
         #20  $stop;
 end

endmodule
