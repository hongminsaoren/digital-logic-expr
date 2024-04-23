`timescale 1ns / 1ps


module datamem(
   output reg [31:0] dataout,   //�������
   input clk,                   //ʱ���ź�
   input we,                   //�洢��дʹ���źţ��ߵ�ƽʱ����д������
   input [2:0] MemOp,          //��д�ֽ�������
   input [31:0] datain,        //����������
   input [15:0] addr           //�洢����ַ
);
(* ram_style="block" *)  reg [31:0] ram [2**16-1:0];  //����ʹ�ÿ�RAM�ۺϳɴ洢��
reg [31:0] intmp;           
reg [31:0] outtmp;          
always @(posedge clk)   begin
       outtmp <= ram[addr[15:2]]; //�����ض�ȡ�洢�����ݣ��ȶ�ȡ��ַ������
end
always @(negedge clk)  begin
    if (we) ram[addr[15:2]] <= intmp; //�½���д��洢�����ݣ�дʹ����Чʱ��д������
end
always @(*)
begin
   if (~we)  begin  //��ȡ����
            case (MemOp)
              3'b000: begin dataout = outtmp; end
              3'b001: begin dataout = {24'h000000, outtmp[7:0]}; end
              3'b010: begin dataout = {16'h0000, outtmp[15:0]}; end
              3'b101: begin dataout = {{24{outtmp[7]}}, outtmp[7:0]}; end
              3'b110: begin dataout = {{16{outtmp[15]}}, outtmp[15:0]}; end
              default:dataout = outtmp;
            endcase
        end
    else  begin  //д�����
            case (MemOp)
                3'b000: begin intmp = datain; end
                3'b101: begin intmp = {outtmp[31:8], datain[7:0]}; end
                3'b110: begin intmp = {outtmp[31:16], datain[15:0]}; end
               default:intmp = datain;
            endcase
        end
 end
endmodule
