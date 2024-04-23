`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 20:14:55
// Design Name: 
// Module Name: trans4to4
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


module trans4to4(
    output  [2:0] Y0,Y1,Y2,Y3,
    input   [2:0] D0,D1,D2,D3,
    input   [1:0] S
); 
// add your code here
reg [2:0]temp;
 always @(S)
    begin
        case(S)
        2'b00:temp = D0;
        2'b01:temp = D1; 
        2'b10:temp = D2; 
        2'b11:temp = D3;  
        endcase
     end
     
assign Y0 = ( ~S[1] & ~S[0] ) ? temp : 4 'bz;
assign Y1 = ( ~S[1] & S[0] ) ? temp : 4'bz;
assign Y2 = ( S[1] & ~S[0] ) ? temp : 4'bz;
assign Y3 = ( S[1] & S[0] ) ? temp : 4'bz;
     
endmodule
