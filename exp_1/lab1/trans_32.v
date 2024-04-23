`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/19 15:27:19
// Design Name: 
// Module Name: trans_32
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


module trans_32(
    input[4:0] X,
    output [31:0] Y,
    input En
    );
    
    assign Y =En ? (1<<X) : 0;
endmodule
