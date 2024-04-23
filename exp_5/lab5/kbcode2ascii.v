`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/09 23:04:22
// Design Name: 
// Module Name: kbcode2ascii
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

module kbcode2ascii(
      output[7:0] asciicode,
      input [7:0] kbcode
);
    reg [7:0] kb_mem[255:0];
    initial
    begin
     $readmemh("S:/univer/sem2_1/digital_experiment/exp_5/lab5/scancode.txt", kb_mem, 0, 255);  //�޸�scancode.txt���·��
    end
    assign   asciicode = kb_mem[kbcode];
endmodule
