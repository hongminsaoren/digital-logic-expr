`timescale 1ns / 1ps

module nextPC(
    output [31:0] nxtPC,     //��һ��ȡָ���ַ��32λ��ȡ��16λ
    input [31:0] BusA,       //BusA
    input [31:0] curPC,Imm,   //PCֵ��������
    input NxtASrc, NxtBSrc,   //ѡ���źţ��ɷ�֧���Ʋ�������
    input reset
    );
    wire [31:0] NxtA, NxtB;
    assign NxtA = NxtASrc ? BusA&32'hfffffffe:curPC;
    assign NxtB = NxtBSrc ? Imm&32'hfffffffe:32'd4;
   assign nxtPC=(NxtA+NxtB)&{32{reset}};
      // assign nxtPC=(curPC+32'd4)&{32{reset}};

endmodule
