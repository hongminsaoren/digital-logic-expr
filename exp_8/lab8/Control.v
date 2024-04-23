`timescale 1ns / 1ps

module Control(
    output reg [2:0] ExtOp,
    output reg RegWr,
    output reg ALUASrc,
    output reg [1:0] ALUBSrc,
    output reg [3:0] ALUctr,
    output reg [2:0] Branch,
    output reg MemtoReg,
    output reg MemWr,
    output reg [2:0] MemOp,
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7    
   );
// Add your code here  
  always @(*)
   begin
       case(opcode)
           // R-Type Instructions
           7'b0110011: begin
               ExtOp <= 3'b000; // Zero Extend
               RegWr <= 1'b1;
               ALUASrc <= 1'b0;
               ALUBSrc <= 2'b00;
               
               Branch <= 3'b000;
               MemtoReg <= 1'b0;
               MemWr <= 1'b0;
               MemOp <= 3'b000;
               
               
               ALUctr <= {funct7[5],funct3}; // Add
           end
            7'b0010111: begin
               ExtOp <= 3'b001; // Zero Extend
               RegWr <= 1'b1;
               ALUASrc <= 1'b1;
               ALUBSrc <= 2'b10;
               ALUctr <= 4'b0000; // Add
               Branch <= 3'b000;
               MemtoReg <= 1'b0;
               MemWr <= 1'b0;
               MemOp <= 3'b000;
           end
           // I-Type Instructions
           7'b0010011: begin
               ExtOp <= 3'b000; // Zero Extend
               RegWr <= 1'b1;
               ALUASrc <= 1'b0;
               ALUBSrc <= 2'b10;
                Branch <= 3'b000;
                       MemtoReg <= 1'b0;
                       MemWr <= 1'b0;
                       MemOp <= 3'b000;
               case(funct3)
                   // Addi, Lw
                   3'b000: begin
                       ALUctr <= 4'b0000; // Add
                       Branch <= 3'b000;
                       MemtoReg <= 1'b0;
                       MemWr <= 1'b0;
                       MemOp <= 3'b000;
                   end
                   3'b010: begin
                       ALUctr <= 4'b0010; // Add
                       Branch <= 3'b000;
                       MemtoReg <= 1'b0;
                       MemWr <= 1'b0;
                       MemOp <= 3'b000;
                   end
                   // Slti
                   3'b011: begin
                       ALUctr <= 4'b0011; // Set Less Than
                       Branch <= 3'b000;
                       MemtoReg <= 1'b0;
                       MemWr <= 1'b0;
                       MemOp <= 3'b000;
                   end
                   // Andi
                   3'b111: begin
                       ALUctr <= 4'b0111; // And
                       Branch <= 3'b000;
                       MemtoReg <= 1'b0;
                       MemWr <= 1'b0;
                       MemOp <= 3'b000;
                   end
                   // Ori
                   3'b110: begin
                       ALUctr <= 4'b0110; // Or
                       Branch <= 3'b000;
                       MemtoReg <= 1'b0;
                       MemWr <= 1'b0;
                       MemOp <= 3'b000;
                   end
                   // Slli
                   3'b100: begin
                       ALUctr <= 4'b0100; // Shift Left Logical
                       Branch <= 3'b000;
                       MemtoReg <= 1'b0;
                       MemWr <= 1'b0;
                       MemOp <= 3'b000;
                   end
                     3'b001: begin
                       ALUctr <= 4'b0001; // Shift Left Logical
                       Branch <= 3'b000;
                       MemtoReg <= 1'b0;
                       MemWr <= 1'b0;
                       MemOp <= 3'b000;
                   end
                   // Srli, Srai
                   3'b101: begin
                       if (funct7[5] == 1'b0) begin // Srli
                           ALUctr <= 4'b0101; // Shift Right Logical
                       end else begin // Srai
                           ALUctr <= 4'b1101; // Shift Right Arithmetic
                       end
                      
                   end
               endcase
           end
           // S-Type Instructions
           7'b0100011: begin
               ExtOp <= 3'b010; // Zero Extend
               RegWr <= 1'b0;
               ALUASrc <= 1'b0;
               ALUBSrc <= 2'b10;
               ALUctr <= 4'b0000; // Add
               Branch <= 3'b000;
               MemtoReg <= 1'b0;
               MemWr <= 1'b1;
               MemOp <=funct3;
           end
           // SB-Type Instructions
           7'b1100011: begin
               ExtOp <= 3'b011; // Zero Extend
               RegWr <= 1'b0;
               ALUASrc <= 1'b0;
               ALUBSrc <= 2'b00;
              
               MemtoReg <= 1'b0;
               MemWr <= 1'b0;
               MemOp <= 3'b000; 
                     case(funct3)
                   // Addi, Lw
                   3'b000: begin
                       ALUctr <= 4'b0010; // Add
                       Branch <= 3'b100;                   
                   end
                    3'b001: begin
                       ALUctr <= 4'b0010; // Add
                       Branch <= 3'b101;                   
                   end
                    3'b100: begin
                       ALUctr <= 4'b0010; // Add
                       Branch <= 3'b110;                   
                   end
                    3'b101: begin
                       ALUctr <= 4'b0010; // Add
                       Branch <= 3'b111;                   
                   end
                    3'b110: begin
                       ALUctr <= 4'b0011; // Add
                       Branch <= 3'b110;                   
                   end
                    3'b111: begin
                       ALUctr <= 4'b0011; // Add
                       Branch <= 3'b111;                   
                   end
                  endcase
           end
           // U-Type Instructions
           7'b0110111: begin
               ExtOp <= 3'b001; // Zero Extend
               RegWr <= 1'b1;
               ALUASrc <= 1'b1;
               ALUBSrc <= 2'b10;
               ALUctr <= 4'b1111; // Add
               Branch <= 3'b000;
               MemtoReg <= 1'b0;
               MemWr <= 1'b0;
               MemOp <= 3'b000;
           end
           7'b0010111: begin
               ExtOp <= 3'b001; // Zero Extend
               RegWr <= 1'b1;
               ALUASrc <= 1'b1;
               ALUBSrc <= 2'b10;
               ALUctr <= 4'b0000; // Add
               Branch <= 3'b000;
               MemtoReg <= 1'b0;
               MemWr <= 1'b0;
               MemOp <= 3'b000;
           end
           // UJ-Type Instructions
           7'b1101111: begin
               ExtOp <= 3'b100; // Zero Extend
               RegWr <= 1'b1;
               ALUASrc <= 1'b1;
               ALUBSrc <= 2'b01;
               ALUctr <= 4'b0000; // Add
               Branch <= 3'b001;
               MemtoReg <= 1'b0;
               MemWr <= 1'b0;
               MemOp <= 3'b000;
           end
             7'b1100111: begin
               ExtOp <= 3'b000; // Zero Extend
               RegWr <= 1'b1;
               ALUASrc <= 1'b1;
               ALUBSrc <= 2'b01;
               ALUctr <= 4'b0000; // Add
               Branch <= 3'b010;
               MemtoReg <= 1'b0;
               MemWr <= 1'b0;
               MemOp <= 3'b000;
           end
                    7'b0000011: begin
               ExtOp <= 3'b000; // Zero Extend
               RegWr <= 1'b1;
               ALUASrc <= 1'b0;
               ALUBSrc <= 2'b10;
               ALUctr <= 4'b0000; // Add
               Branch <= 3'b000;
               MemtoReg <= 1'b1;
               MemWr <= 1'b0;
               MemOp <= funct3;
           end
           default: begin
               // Unknown opcode, set default control signals
               ExtOp <= 3'b000;
               RegWr <= 1'b1;
               ALUASrc <= 1'b0;
               ALUBSrc <= 2'b10;
               ALUctr <= 4'b0000;
               Branch <= 3'b000;
               MemtoReg <= 1'b0;
               MemWr <= 1'b0;
               MemOp <= 3'b000;
           end
       endcase
   end
endmodule
