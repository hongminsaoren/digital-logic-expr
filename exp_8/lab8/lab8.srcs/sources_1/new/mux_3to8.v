`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/14 16:11:03
// Design Name: 
// Module Name: mux_3to8
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


module mux_3to8 (
    input [2:0] sel,   // 3位选择信号
    input [31:0] data1,  // 8位输入数据
      input [31:0] data2,  // 8位输入数据
        input [31:0] data3,  // 8位输入数据
          input [31:0] data4,  // 8位输入数据
            input [31:0] data5,  // 8位输入数据
              input [31:0] data6,  // 8位输入数据
                input [31:0] data7,  // 8位输入数据
                  input [31:0] data8,  // 8位输入数据
    output reg[31:0] out     // 输出信号
);

always @* begin
    case(sel)
        3'b000: out = data1;
        3'b001: out = data2;
        3'b010: out = data3;
        3'b011: out = data4;
        3'b100: out = data5;
        3'b101: out = data6;
        3'b110: out = data7;
        3'b111: out = data8;
        //default: out = 1'bx; // 默认情况下输出未定义
        
    endcase
end

endmodule
