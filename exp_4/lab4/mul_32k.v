`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/02 00:39:53
// Design Name: 
// Module Name: mul_32p
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


module mul_32k(
  input [31:0] X, Y,
  output reg [63:0] P       // output variable for assignment
  );
//add your code here  
reg [31:0] part [31:0];

integer i, j, x, y, num = 0;
always @(X or Y)
    for(i = 0; i < 32; i = i + 1)
        for(j = 0; j <32; j = j + 1)
            part[i][j] = Y[i] * X[j];

reg [63:0] cin;       
always @(i or j)begin
if(i == 32 && j == 32)
    for(x = 0; x < 63; x = x + 1)begin
        for(y = ((x < 32) ? 0 : (x - 31)); y < 32; y = y + 1)begin
            if(part[y][x - y] == 1) 
                num = num + 1;
        end     
        P[x] = num % 2;
        num = (num - P[x]) / 2; 
    end 
P[63] = num;
num = 0;
end

endmodule
