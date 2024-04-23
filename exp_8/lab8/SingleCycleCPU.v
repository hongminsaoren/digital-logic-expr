`timescale 1ns / 1ps

module SingleCycleCPU(
	input 	      clock,
	input 	      reset,
	output [31:0] InstrMemaddr,      //ָ��洢����ַ
	input  [31:0] InstrMemdataout,   //ָ������
	output        InstrMemclk,       // ָ��洢����ȡʱ�ӣ�Ϊ��ʵ���첽��ȡ�����ö�ȡʱ�Ӻ�д��ʱ�ӷ���
	output [31:0] DataMemaddr,       //���ݴ洢����ַ
	input  [31:0] DataMemdataout,   //���ݴ洢���������
	output [31:0] DataMemdatain,    //���ݴ洢��д������
	output 	      DataMemrdclk,     //���ݴ洢����ȡʱ�ӣ�Ϊ��ʵ���첽��ȡ�����ö�ȡʱ�Ӻ�д��ʱ�ӷ���
	output	      DataMemwrclk,      //���ݴ洢��д��ʱ��
	output [2:0]  DataMemop,         //���ݶ�д�ֽ��������ź�
	output        DataMemwe,         //���ݴ洢��д��ʹ���ź�
	output [15:0] dbgdata            //debug�����źţ����16λָ��洢����ַ��Ч��ַ
);
	
wire [4:0]rs1;//Դ�Ĵ���1
wire [4:0]rs2;//Դ�Ĵ���2
wire [4:0]rd;//Ŀ�ļĴ���
wire [2:0]Branch;
wire ALUAsrc;
wire [1:0]ALUBsrc;
wire [3:0]ALUctr;
wire MemtoReg;
wire MemWr;
wire RegWr;
wire [2:0]MemOP;
wire [31:0]rs1data;
wire [31:0]rs2data;
reg [31:0]wrdata;
wire [2:0]ExtOP;
wire [31:0]imm;
wire [31:0]aluresult;
reg [31:0]dataa;
reg [31:0]datab;
wire zero;
wire less;
wire [31:0]instr;
reg [31:0]PC;
wire [31:0]NextPC;
wire[31:0]code;
wire [6:0]opcode;
wire [2:0]funct3;
wire [6:0]funct7;
wire [31:0]datain;
wire [31:0]dout;
wire NxtASrc;
wire NxtBSrc;
initial
begin
	PC=32'b0;
end

/*assign rs1 =  InstrMemdataout[19:15];
assign rs2 =  InstrMemdataout[24:20];
assign rd =  InstrMemdataout[11:7];*/

assign InstrMemclk=clock;//ָ�� �½��ض�ȡ
assign DataMemrdclk=clock;//���� �����ض�ȡ
assign DataMemwrclk=clock;//���� �½���д��
Control A( .opcode(opcode),.funct3(funct3),.funct7(funct7),.MemOp(MemOP),.MemWr(MemWr),.MemtoReg(MemtoReg),.RegWr(RegWr),.ExtOp(ExtOP),.ALUASrc(ALUAsrc),.ALUBSrc(ALUBsrc),.ALUctr(ALUctr),.Branch(Branch) );
//DataMem Data(.clk(clock),.we(MemWr),.MemOp(MemOP),.datain(datain),.addr(aluresult[17:2]),.dataout(DataMemdataout));
 BranchControl bra(.Branch(Branch),.zero(zero),.result0(aluresult[0]),.NxtASrc(NxtASrc),.NxtBSrc(NxtBSrc));
regfile32 myregfile(.ra(rs1),.rb(rs2),.rw(rd),.busw(wrdata),.we(RegWr),.clk(~clock),.busa(rs1data),.busb(rs2data));//�½���д�� ��ȡ
InstrToImm B( .instr(InstrMemdataout),.ExtOp(ExtOP),.imm(imm));
InstrParse igr(.funct3(funct3),.funct7(funct7),.opcode(opcode),.instr(InstrMemdataout),.rs1(rs1),.rs2(rs2),.rd(rd));
ALU32 D(.dataa(dataa),.datab(datab),.aluctr(ALUctr),.zero(zero),.result(aluresult));
nextPC nxt(.NxtASrc(NxtASrc),.NxtBSrc(NxtBSrc),.nxtPC(NextPC),.BusA(rs1data),.Imm(imm),.curPC(PC),.reset(~reset));
//InstrMem inss(.instr(instr),.addr(PC),.InstrMemEn(~reset),.clk(clock));
//assign instr=32'd06400313;
always @(negedge clock)
	PC<=NextPC;

always @(*)
begin
if(MemtoReg)
	wrdata=DataMemdataout;
else
	wrdata=aluresult;
if(ALUAsrc==0)
	dataa=rs1data;
else
	dataa=PC;
if(ALUBsrc==2'b00)
	datab=rs2data;
else if(ALUBsrc==2'b10)
	datab=imm;
else if(ALUBsrc==2'b01)
	datab=32'h4;
end

assign InstrMemaddr=PC;
assign dbgdata=PC;
assign DataMemwe=MemWr;
assign DataMemop=MemOP;
assign DataMemdatain=rs2data;
assign DataMemaddr=aluresult;
endmodule
