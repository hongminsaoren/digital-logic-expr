`timescale 1ns / 1ps

module datamem128K #( 
parameter RAM_WIDTH = 32,
parameter RAM_ADDR_WIDTH = 16
)
(
   output reg [31:0] dataout,   //ʱ���½��أ�����д��ʹ��Ϊ�͵�ƽʱ���
   input clk,                   //ʱ���ź�
   input we,                   //�洢��дʹ���źţ��ߵ�ƽʱ����д������
   input [2:0] MemOp,          //��д�ֽ�������
   input [31:0] datain,        //�½���д������
   input [RAM_ADDR_WIDTH-1:0] addr      //д���ַ
//   input [RAM_ADDR_WIDTH-1:0] outaddr   //��ȡ ��ַ
);
(* ram_style="block" *)  reg [31:0] ram [2**RAM_ADDR_WIDTH-1:0];
reg [31:0] intmp;           //д������
reg [31:0] outtmp;           //��ȡ����
always @(posedge clk)       //�����ض�ȡ�洢�����ݣ��ȶ�ȡ��ַ������
begin
       outtmp <= ram[addr[RAM_ADDR_WIDTH-1:2]]; 
end
always @(negedge clk)     //�½���д��洢�����ݣ�дʹ����Чʱ��д������
begin
    if (we) begin ram[addr[RAM_ADDR_WIDTH-1:2]] <= intmp; end
end
always @(*)
begin
     if (~we)   //��ȡ����
        begin
            case (MemOp)
              3'b000: begin dataout = outtmp; end
              3'b001: begin dataout = {24'h000000, outtmp[7:0]}; end
              3'b010: begin dataout = {16'h0000, outtmp[15:0]}; end
              3'b101: begin dataout = {{24{outtmp[7]}}, outtmp[7:0]}; end
              3'b110: begin dataout = {{16{outtmp[15]}}, outtmp[15:0]}; end
              default:dataout = outtmp;
            endcase
        end
        else    //д�����
        begin
            case (MemOp)
                3'b000: begin intmp = datain; end
                3'b101: begin intmp = {outtmp[31:8], datain[7:0]}; end
                3'b110: begin intmp = {outtmp[31:16], datain[15:0]}; end
               default:intmp = datain;
            endcase
        end
 end
endmodule
