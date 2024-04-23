`timescale 1ns / 1ps

module BranchControl(
    output reg NxtASrc, NxtBSrc,
    input zero, result0,
    input [2:0] Branch
   );
    always @ (*) begin
        case (Branch)
            3'b000: begin NxtASrc = 1'b0; NxtBSrc = 1'b0; end //����תָ��
            3'b001: begin NxtASrc = 1'b0; NxtBSrc = 1'b1; end //jal: ��������תPCĿ��
            3'b010: begin NxtASrc = 1'b1; NxtBSrc = 1'b1; end //jalr: ��������ת�Ĵ���Ŀ��
            3'b100: begin NxtASrc = 1'b0; NxtBSrc = (zero===1'bx)?1'b1:zero; end //beq: ������֧������
            3'b101: begin NxtASrc = 1'b0; NxtBSrc = (zero===1'bx)?1'b1:~zero; end //bne: ������֧��������
            3'b110: begin NxtASrc = 1'b0; NxtBSrc = (result0===1'bx)?1'b1:result0; end //blt, bltu: ������֧��С��
            3'b111: begin NxtASrc = 1'b0; NxtBSrc = (result0===1'bx)?1'b1:~result0; end //bge, bgeu: ������֧�����ڵ���
            default: begin NxtASrc = 1'b0; NxtBSrc = 1'b0; end
        endcase
    end
endmodule
