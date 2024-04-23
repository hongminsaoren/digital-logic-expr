`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/05 10:13:11
// Design Name: 
// Module Name: rv32m_top
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


module rv32m_top(
    output wire [15:0] rd_l,        //�������ĵ�16λ
    output out_valid,         //�������ʱ�����Ϊ1
    output in_error,          //�������ʱ�����Ϊ1
    output reg [6:0] segs,        // 7����ֵ
    output reg [7:0] AN,         //�����ѡ��
    input clk,               //ʱ�� 
    input rst,               //��λ�źţ�����Ч
    input [3:0] x,           //������1���ظ�8�κ���Ϊrs1
    input [3:0] y,           //������2���ظ�8�κ���Ϊrs2
    input [2:0] funct3,        //3λ����ѡ����
    input in_valid          //����Ϊ1ʱ����ʾ���ݾ�������ʼ����
    );
    //add your code here
    wire [31:0] ans;
    rv32m my_rv32m (.rd(ans),.out_valid(out_valid),.in_error(in_error),.clk(clk),.rst(rst),.rs1({8{x[3:0]}}),.rs2({8{y[3:0]}}),.funct3(funct3),.in_valid(in_valid));
    assign rd_l = ans[15:0];
    
    //ɨ��Ƶ��:50Hz
parameter update_interval = 48000000 / 400 - 1; 
reg [4:0] dat; 
reg [2:0] cursel;
integer selcnt;
reg [3:0] d1, d2, d3,d4, d5, d6, d7, d8;//�����������ʾ 

//ɨ�������ѡ��λ
always @(posedge clk)
begin
	selcnt <= selcnt + 1;
	if (selcnt == update_interval)
		begin
			selcnt <= 0;
			cursel <= cursel + 1;
		end
end
//�л�ɨ��λѡ�ߺ�����
always @(posedge clk)
begin
	case (cursel)
		3'b000: begin dat = d1; AN = ~8'b00000001; end
		3'b001: begin dat = d2; AN = ~8'b00000010;end
		3'b010: begin dat = d3; AN = ~8'b00000100; end
		3'b011: begin dat = d4; AN = ~8'b00001000; end
		3'b100: begin dat = d5; AN = ~8'b00010000; end
		3'b101: begin dat = d6; AN = ~8'b00100000;end
		3'b110: begin dat = d7; AN = ~8'b01000000; end
		3'b111: begin dat = d8; AN = ~8'b10000000; end
	endcase
end

//���¶���
always @(posedge clk)
begin
	case (dat[3:0])
		0: segs = 7'b100_0000;
        1: segs = 7'b111_1001;
        2: segs = 7'b010_0100;
        3: segs = 7'b011_0000;
        4: segs = 7'b001_1001;
        5: segs = 7'b001_0010;
        6: segs = 7'b000_0010;
        7: segs = 7'b111_1000;
        8: segs = 7'b000_0000;
        9: segs = 7'b001_0000;
        10: segs = 7'b000_1000;
        11: segs = 7'b000_0011;
        12: segs = 7'b100_0110;
        13: segs = 7'b010_0001;
        14: segs = 7'b000_0110;
        15: segs = 7'b000_1110;
        default: segs = 7'b111_1111;
	endcase
end

always @(posedge clk)
begin
		//��ʾ��ֵ
		d1 <= ans[3:0];
		d2 <= ans[7:4];
		d3 <= ans[11:8];
		d4 <= ans[15:12];
		d5 <= ans[19:16];
		d6 <= ans[23:20];
		d7 <= ans[27:24]; 
		d8 <= ans[31:28]; 
end 
endmodule
