`timescale 1ns / 1ps


module registerfile(
	output wire [31:0] busa,   //�Ĵ���ra�������
	output wire [31:0] busb,   //�Ĵ���rb�������
	input clk,
	input [4:0] ra,           //���Ĵ������ra
	input [4:0] rb,          //���Ĵ������rb
	input [4:0] rw,          //д�Ĵ������rw
	input [31:0] busw,       //д�����ݶ˿�
	input we	             //дʹ�ܶˣ�Ϊ1ʱ����д��
	);
  (* ram_style="registers" *) reg [31:0] regfiles[0:31];      //�ۺ�ʱʹ�üĴ���ʵ�ּĴ�����
	always @(posedge clk)  begin      
		if((we==1'b1))	 regfiles[rw]<=busw;             //д�˿�
	 end
    assign 	busa=(ra==5'b0) ? 32'b0 : regfiles[ra];     //���˿�ra
    assign 	busb=(rb==5'b0) ? 32'b0 : regfiles[rb];     //���˿�rb
endmodule
