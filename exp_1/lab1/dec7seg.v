`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 21:13:09
// Design Name: 
// Module Name: dec7seg
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



module dec7seg(
//端口声明
output  reg  [6:0] O_seg,  //7位显示段输出
output  reg  [7:0] O_led,  //8个数码管输出控制
input   [3:0] I,           //4位数据输入，需要显示的数字   
input   [2:0] S          //3位译码选择指定数码管显示
); 
// add your code here
always @(I)
    begin
        case(I)
        0: O_seg = 7'b100_0000;
        1: O_seg = 7'b111_1001;
        2: O_seg = 7'b010_0100;
        3: O_seg = 7'b011_0000;
        4: O_seg = 7'b001_1001;
        5: O_seg = 7'b001_0010;
        6: O_seg = 7'b000_0010;
        7: O_seg = 7'b111_1000;
        8: O_seg = 7'b000_0000;
        9: O_seg = 7'b001_0000;
        10: O_seg = 7'b000_1000;
        11: O_seg = 7'b000_0011;
        12: O_seg = 7'b100_0110;
        13: O_seg = 7'b010_0001;
        14: O_seg = 7'b000_0110;
        15: O_seg = 7'b000_1110;
        default: O_seg = 7'b111_1111;
        endcase
    end
   
 integer i;
always @ (S)
    begin
        for (i=0; i<=7; i=i+1)
            if(i == S)
                O_led[i]=0;
            else
                O_led[i]=1;
    end        
endmodule
