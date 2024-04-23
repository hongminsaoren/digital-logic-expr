`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/02 12:05:22
// Design Name: 
// Module Name: div_32u
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


module div_32u(
    output  [31:0] Q,          //商
    output  [31:0] R,          //余数
    output wire out_valid,        //除法运算结束时，输出为1
    output wire in_error,         //被除数或除数为0时，输出为1
    input clk,               //时钟 
    input rst,             //复位信号
    input [31:0] X,           //被除数
    input [31:0] Y,           //除数
    input in_valid          //输入为1时，表示数据就绪，开始除法运算
);
// add your code here
    wire ready;
    reg busy;
    reg [5:0] count;
    reg [31:00] reg_q;
    reg [31:00] reg_r;
    reg [31:00] reg_b;
    wire [31:00] reg_r2;
    reg busy2,r_sign,sign;
    assign ready=~busy&busy2;
    wire [32:0] sub_add=r_sign?({reg_r,reg_q[31]}+{1'b0,reg_b}):
                                ({reg_r,reg_q[31]}-{1'b0,reg_b});
    assign reg_r2=r_sign?reg_r+reg_b:reg_r;
    assign R=X[31]?(~reg_r2+1):reg_r2;
    assign Q=(Y[31]^X[31])?(~reg_q+1):reg_q;
    assign out_valid = ~busy;
    assign in_error = ((X == 0) || (Y == 0));
    always @(posedge clk or negedge rst)begin
    if(!rst)begin
        count<=0;
        busy<=0;
        busy2<=0;
    end
    else begin
        busy2<=busy;
        if(in_valid)begin
            reg_r<=32'b0;
            r_sign<=0;
            if(X[31]==1) begin
                reg_q<=~X+1;
            end
            else reg_q<=X;
            if(Y[31]==1)begin
                reg_b<=~Y+1;
            end
            else reg_b<=Y;
            count<=0;
            busy<=1;
        end
        else if(busy)begin
            reg_r<=sub_add[31:0];
            r_sign<=sub_add[32];
            reg_q<={reg_q[30:0],~sub_add[32]};
            count<=count+1;
            if(count==31)busy<=0;
        end
    end
    end    
endmodule
