`timescale 1ns / 1ps

module DataMem(
   output [31:0] dataout,   //�������
   input clk,                   //ʱ���ź�
   input we,                   //�洢��дʹ���źţ��ߵ�ƽʱ����д������
   input [2:0] MemOp,          //��д�ֽ�������
   input [31:0] datain,        //����������
   input [15:0] addr           //�洢����ַ
);
(* ram_style="block" *)  reg [31:0] ram [2**16-1:0];  //����ʹ�ÿ�RAM�ۺϳɴ洢��
wire [31:0] intmp;
wire [31:0] outtmp;
assign outtmp = ram[addr[15:2]];

wire [15:0] houttmp = addr[1] ? outtmp[31:16] : outtmp[15:0];
wire [7:0] bouttmp = addr[1:0] == 2'b11 ? outtmp[31:24]
                   : addr[1:0] == 2'b10 ? outtmp[23:16]
                   : addr[1:0] == 2'b01 ? outtmp[15:8]
                   : outtmp[7:0];

/*
always @(posedge clk)   begin
       outtmp <= ram[addr[15:2]]; //�����ض�ȡ�洢�����ݣ��ȶ�ȡ��ַ������
end
*/
always @(negedge clk)  begin
    if (we) ram[addr[15:2]] <= intmp; //�½���д��洢�����ݣ�дʹ����Чʱ��д������
end

/*
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
*/
/*
assign dataout = MemOp == 3'b000 ? outtmp
               : MemOp == 3'b001 ? {24'h000000, outtmp[7:0]}
               : MemOp == 3'b010 ? {16'h0000, outtmp[15:0]}
               : MemOp == 3'b101 ? {{24{outtmp[7]}}, outtmp[7:0]}
               : MemOp == 3'b110 ? {{16{outtmp[15]}}, outtmp[15:0]}
               : 32'h00000000;

assign intmp = MemOp == 3'b000 ? datain
             : MemOp == 3'b101 ? {outtmp[31:8], datain[7:0]}
             : MemOp == 3'b110 ? {outtmp[31:16], datain[15:0]}
             : 32'h00000000;
*/
/*
assign dataout = MemOp == 3'b000 ? {{24{outtmp[7]}}, outtmp[7:0]}
               : MemOp == 3'b001 ? {{16{outtmp[15]}}, outtmp[15:0]}
               : MemOp == 3'b010 ? outtmp
               : MemOp == 3'b100 ? {24'h000000, outtmp[7:0]}
               : MemOp == 3'b101 ? {16'h0000, outtmp[15:0]}
               : 32'h00000000;
*/
assign dataout = MemOp == 3'b000 ? {{24{bouttmp[7]}}, bouttmp}
               : MemOp == 3'b001 ? {{16{houttmp[15]}}, houttmp}
               : MemOp == 3'b010 ? outtmp
               : MemOp == 3'b100 ? {24'h000000, bouttmp}
               : MemOp == 3'b101 ? {16'h0000, houttmp}
               : 32'h00000000;

assign intmp = MemOp == 3'b000 ? 
                    (addr[1:0] == 2'b00 ? {outtmp[31:8], datain[7:0]}
                   : addr[1:0] == 2'b01 ? {outtmp[31:16], datain[7:0], outtmp[7:0]}
                   : addr[1:0] == 2'b10 ? {outtmp[31:24], datain[7:0], outtmp[15:0]}
                   :{datain[7:0], outtmp[23:0]})
             : MemOp == 3'b001 ? 
                    (addr[1] ? {datain[15:0], outtmp[15:0]} : {outtmp[31:16], datain[15:0]})
             : MemOp == 3'b010 ? datain
             : 32'h00000000;
endmodule
