`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/05 10:12:50
// Design Name: 
// Module Name: rv32m
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


module rv32m(
    output reg [31:0] rd,        //运算结果
    output reg out_valid,         //运算结束时，输出为1
    output wire in_error,          //运算出错时，输出为1
    input clk,               //时钟 
    input rst,               //复位信号，低有效
    input [31:0] rs1,          //操作数rs1
    input [31:0] rs2,          //操作数rs2
    input [2:0] funct3,        //3位功能选择码
    input in_valid           //输入为1时，表示数据就绪，开始除法运算
    );
    //add your code here
    wire [63:0] multi_sign, multi_unsign, multi_unsign2;
    wire [31:0] div, mod;
    wire out_div, out_mul;
    wire temp;
    assign temp = rs1[31] ? ~rs1+1'b1 : rs1;
    reg [63:0]xx;
    div_32u my_div(.Q(div),.R(mod),.out_valid(out_div),.in_error(in_error),.clk(clk),.rst(rst),.X(rs1),.Y(rs2),.in_valid(in_valid));
    mul_32b my_mulb(.clk(clk),.rst(rst),.in_valid(in_valid),.x(rs1),.y(rs2),.out_valid(out_mul),.p(multi_sign));
    mul_32k my_mulk(.X(rs1),.Y(rs2),.P(multi_unsign));
    mul_32k my_mulk_u(.X(temp),.Y(rs2),.P(multi_unsign2));
    //assign {multi_unsign,multi_sign,div,out_div,out_mul} = (!rst) ? 0:{multi_unsign,multi_sign,div,out_div,out_mul};
    
    always@(out_div or out_mul or funct3)begin
    if(!rst)
        {rd,out_valid} = 0;
    else if(!in_error) begin
    case(funct3)
    3'b000:if(out_mul)begin
            rd = multi_sign[31:0];
            out_valid = 1;
           end
    3'b001:if(out_mul)begin
            rd = multi_sign[63:32];
            out_valid = 1;
           end
    3'b010:begin
            rd = multi_sign[63:32];
            if(rs1[31] == 1)
                rd[31] = 1;
            out_valid = 1;
           end
    3'b011:begin    
            rd = multi_unsign[63:32];
            out_valid = 1;   
           end
    3'b100:if(out_div)begin
            rd = div;
            out_valid = 1;
           end
    3'b101:if(rs2 != 32'b0)begin
              rd = rs1 / rs2;
              out_valid = 1;
            end
    3'b110:if(rs2 != 32'b0)begin
              rd = mod;
              out_valid = 1;
            end
    3'b111:if(rs2 != 32'b0)begin
              rd = rs1 - (rs1 / rs2) * rs2;
              out_valid = 1;
            end
    endcase
    end
    end
    
    
endmodule
