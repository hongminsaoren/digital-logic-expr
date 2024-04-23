`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/14 16:12:03
// Design Name: 
// Module Name: ALUcontrol
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


module ALUcontrol(
input  [3:0]ALUctr,
output reg SUBctr,LRctr,SIGctr,ALctr,
output reg[2:0]OPctr
    );
    
        always @(*) 
        begin
        case (ALUctr)
        
            4'b0000: begin
                SUBctr = 1'b0;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b000;
            end
            4'b0001: begin
                SUBctr = 1'b0;
                LRctr = 1'b1;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b100;
            end
            4'b0010: begin
                SUBctr = 1'b1;
                LRctr = 1'b0;
                SIGctr = 1'b1;
                ALctr = 1'b0;
                OPctr = 3'b110;
            end
            4'b0011: begin
                SUBctr = 1'b1;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b110;
            end
              4'b0100: begin
                SUBctr = 1'b0;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b011;
            end
              4'b0101: begin
                SUBctr = 1'b0;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b100;
            end
              4'b0110: begin
                SUBctr = 1'b0;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b010;
            end
              4'b0111: begin
                SUBctr = 1'b0;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b001;
            end
            4'b1000: begin
                SUBctr = 1'b1;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b000;
            end
         4'b1001: begin
                SUBctr = 1'b0;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b000;
            end
     4'b1010: begin
                SUBctr = 1'b0;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b000;
            end
              4'b1100: begin
                SUBctr = 1'b0;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b000;
            end
     4'b1011: begin
                SUBctr = 1'b0;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b000;
            end
             4'b1110: begin
                SUBctr = 1'b0;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b000;
            end
     4'b1101: begin
                SUBctr = 1'b0;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b1;
                OPctr = 3'b100;
            end
                4'b1111: begin
                SUBctr = 1'b0;
                LRctr = 1'b0;
                SIGctr = 1'b0;
                ALctr = 1'b0;
                OPctr = 3'b101;
            end
    endcase
    end
    
endmodule
