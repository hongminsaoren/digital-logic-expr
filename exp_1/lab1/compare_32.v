`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/19 14:52:16
// Design Name: 
// Module Name: compare_32
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
/////////////////////////////////////////////////////////////////////////////////

module compare_32(
    output reg PBIG , SAME , QBIG ,
    input [31:0] P, Q
    );
    
always @(P or Q)
    begin
        if(P > Q)
        begin
            PBIG = 1'b1;
            SAME = 1'b0;
            QBIG = 1'b0;
        end
        else if(P == Q)
        begin
            PBIG = 1'b0;
            SAME = 1'b1;
            QBIG = 1'b0;
        end
        else
        begin
            PBIG = 1'b0;
            SAME = 1'b0;
            QBIG = 1'b1;
        end
    end
        
endmodule
