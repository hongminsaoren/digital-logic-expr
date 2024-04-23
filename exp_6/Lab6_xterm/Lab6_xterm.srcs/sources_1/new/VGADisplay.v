`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 16:54:43
// Design Name: 
// Module Name: VGADisplay
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

module VGADisplay(
input wire CLK25MHZ,
input wire CLK100MHZ,
input PS2_CLK,
input rst,
input keyin,
input [7:0] keydatain,
output wire VGA_HS,
output wire VGA_VS,
output wire [11:0]color
    );
wire[11:0]pix_x;
wire[11:0]pix_y;
VGACtrl myctrl(
.pix_clk(CLK25MHZ)
,.pix_rst(rst)
,.pix_x(pix_x)
,.pix_y(pix_y)
,.hsync(VGA_HS)
,.vsync(VGA_VS)
,.pix_valid(pix_valid));


wire [11:0] read_addr;
wire[11:0] pix_h;
wire [11:0] pix_v;
Cal_Addr cal(
.pix_x(pix_x)
,.pix_y(pix_y)
,.pix_h(pix_h)
,.pix_v(pix_v)
,.VMemaddr(read_addr));
//wire [7:0]keyascii;
///////////////////////////////////////////////////////
wire [11:0]write_addr;
wire [7:0]ascii_in;
wire wren;
wire [3:0]instr;
wire [11:0]instr_addr;
wire [7:0] instr_ascii;
VMemCtrl myvc(
.CLK100MHZ(CLK100MHZ)
,.PS2_CLK(PS2_CLK)
,.keyin(keyin)
,.keyascii(keydatain)
,.write_addr(write_addr)
,.ascii_in(ascii_in)
,.instr(instr)
,.instr_ascii(instr_ascii)
,.instr_addr(instr_addr)
,.wren(wren));
wire [7:0]ascii_out;
//////////////////////////////////////////////////////

VedioMem myVMem(
.read_addr(read_addr)
,.ascii_out(ascii_out)
,.instr_addr(instr_addr)
,.instr_out(instr_ascii)
,.write_addr(write_addr)
,.wren(wren)
,.ascii_in(ascii_in)
,.VGA_CLK(CLK100MHZ)
,.PS2_CLK(PS2_CLK)
);

//////////////////////////////////////////////////////
reg [7:0] txtascii;
reg [7:0] Text[4095:0];
integer txtc;
initial begin
$readmemh("S:/univer/sem2_1/digital_experiment/exp_6/Lab6_xterm/Text.txt",Text,0,4095);
//for(txtc=0;txtc<=2399;txtc=txtc+1)begin
//Text[txtc]=0;
//end
//Text[0]=8'h57;
//Text[1]=8'h65;
//Text[2]=8'h6c;
//Text[3]=8'h63;
//Text[4]=8'h6f;
//Text[5]=8'h6d;
end
always@(posedge CLK100MHZ)begin
txtascii<=Text[read_addr];
end
////////////////////////////////////////////////////////////////////////////
wire [11:0]colorful;
VGADraw mydraw(.pix_clk(CLK100MHZ),.pix_x(pix_x),.pix_y(pix_y),.pix_valid(1'b1),.pix_data(colorful));
/////////////////////////////////////////////////////////////////////////////
wire [11:0]still;
wire [18:0] ram_addr;
assign ram_addr=pix_y*640+pix_x;
vga_mem my_pic(.clka(CLK25MHZ),.ena(1'b1),.wea(1'b0),.addra({ram_addr}),.dina(12'd0),.douta(still));
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////
//integer i;
//reg [7:0] VMem[4095:0];// 显存容量为4KB，实际只需要2.4KB
//initial begin
//  for(i=0;i<=2399;i=i+1)begin
//  VMem[i]=0;//空白
//  end
//  for(i=0;i<=79;i=i+1)begin
//  VMem[i]=45;
//  end
//VMem[6]=8'h58;
//VMem[7]=8'h74;
//VMem[8]=8'h65;
//VMem[9]=8'h72;
//VMem[10]=8'h6d;
//VMem[11]=105;
//VMem[12]=110;
//VMem[13]=97;
//VMem[14]=108;
//end
//assign ascii_out=VMem[read_addr];
/////////////////////////////////////////////////////
wire [11:0]fontaddr;
assign fontaddr=instr[2]?(txtascii*16+(pix_y%16)):((pix_y%16)+16*ascii_out);
wire [7:0]ldotmatrix;

FontLibrary_ASCII getfont(.address(fontaddr)
,.ldotmatrix(ldotmatrix));

wire [7:0]fontv=7-pix_x%8;//显示字是左右颠倒的 需要用7减 倒回来

//光标闪烁
reg clk2hz;
reg [31:0]togetclk;
always@(posedge CLK100MHZ)begin
    if(togetclk==0)begin
       togetclk<=25000000;
       clk2hz=~clk2hz;
    end
    else 
       togetclk<=togetclk-1;
end
reg blink;
always@(posedge clk2hz)begin
    if(blink)begin
    blink<=0;
    end
    else begin
    blink<=1;
    end
end 
assign color=instr[1]?(still):(instr[0]?colorful:((read_addr==write_addr)?(blink?12'hfff:12'h000):(ldotmatrix[fontv])?12'hfff:12'h000));
endmodule
