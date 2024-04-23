`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/29 18:18:51
// Design Name: 
// Module Name: 64_memory
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


module shrg64u(
 output reg [63:0] data,
 input CLK, CLR, S0, S1, RIN, LIN, [63:0]seed
);
 always @ (posedge CLK)
 if (CLR == 1'b1) data <= 64'b0;
 else case ({S1,S0})
 2'b00: ; // Hold
 2'b01: data <= {RIN,data[63:1]}; // Shift right
 2'b10: data <= {data[62:0],LIN}; // Shift left
 2'b11: data <= seed; // Load
 default: data <= 64'bx; // should not occur
 endcase
 
endmodule
