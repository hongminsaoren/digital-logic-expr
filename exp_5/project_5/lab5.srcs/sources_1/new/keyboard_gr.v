`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 23:05:22
// Design Name: 
// Module Name: keyboard_gr
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


module keyboard(input clk,
 input CLK100MHZ,   //系统时钟信号
    input PS2_CLK,    //来自键盘的时钟信号
    input PS2_DATA,  //来自键盘的串行数据位
 input BTNC,      //Reset
	    output [6:0]SEG,
    output [7:0]AN,
    output [15:0] LED   //显示
);
   

// add your definitions here
	 reg [7:0] key_count;
	 reg [7:0] cur_key;
	wire [7:0] ascii_key;
    reg flag_ctrl;
    reg flag_shift;
    reg flag_cur;
	 reg flag_caps;
	  reg flag_alt;
	   reg flag_num;
	wire [31:0]seg7_data ;
reg CLK50MHZ=0;    

reg [7:0] lastdata;
wire [7:0] keydata;
wire ready;
reg nextdata_n;
wire overflow; 
assign seg7_data[31:24]= key_count;
assign seg7_data[23:16]= lastdata;
assign seg7_data[15:8]=cur_key;
assign seg7_data[7:0]= ascii_key;
assign LED[15]=flag_caps;
assign LED[14]=flag_num;
assign LED[13]=flag_shift;
assign LED[12]=flag_ctrl;
assign LED[11]=flag_alt;
assign LED[10]=overflow;
assign LED[9]=ready;

assign LED[7:0]=ascii_key;

seg7decimal sevenSeg (
.x(seg7_data[31:0]),
.clk(CLK100MHZ),
.seg(SEG[6:0]),
.an(AN[7:0]),
.dp(0) 
);
always @(posedge(CLK100MHZ))begin
    CLK50MHZ<=~CLK50MHZ;
end


//----DO NOT CHANGE BEGIN----
//scancode to ascii conversion, will be initialized by the testbench
scancode_ram myram(CLK50MHZ, cur_key, flag_shift,flag_caps,ascii_key);
//PS2 interface, you may need to specify the inputs and outputs
ps2_keyboard mykey(CLK50MHZ,  ~BTNC, PS2_CLK, PS2_DATA, keydata, ready, nextdata_n, overflow);
//---DO NOT CHANGE END-----

// add you code here
reg flag=0;
always @(posedge PS2_CLK)
begin
if(BTNC==1)
flag=0;
else if(flag==0)//初始化
	begin
	cur_key=0;
	lastdata=0;
	flag=1;
	flag_cur=0;
	flag_caps=0;
	flag_ctrl=0;
	flag_alt=0;
	flag_num=0;
	flag_shift=0;
	end
else if(ready&&nextdata_n)//&& nextdata_n
	begin
	lastdata=cur_key;
	cur_key=keydata;
	nextdata_n=0;
	
	

	  if(lastdata!=cur_key && lastdata!=8'hf0 && cur_key!=8'hf0)
	     begin
        key_count=key_count+1;
	     if(cur_key==8'h12)
		  flag_shift=1;
		  if(cur_key==8'h14)
		  flag_ctrl=1;
		   if(cur_key==8'h11)
		  flag_alt=1;
		   if(cur_key==8'h77)
		  flag_num=1;
		  if(cur_key==8'h58)
		  flag_caps=1-flag_caps;
		  
		  if(cur_key!=8'h12 && cur_key!=8'h14 && cur_key!=8'h58)
		  flag_cur=1;
		  end
		  
	 else if(lastdata==8'hf0 && cur_key!=0 ) //
        begin
		  if(cur_key==8'h12)flag_shift=0;
		  if(cur_key==8'h14)flag_ctrl=0;
		     if(cur_key==8'h11)
		  flag_alt=0;
		   if(cur_key==8'h77)
		  flag_num=0;
		  if(cur_key!=8'h12 && cur_key!=8'h14) 
		  flag_cur=0;
        lastdata=cur_key;
        cur_key=0;
        end
	
	end
else
	begin
	nextdata_n=1;
	end
    key_count=key_count&{8{~BTNC}};
    lastdata=lastdata&{8{~BTNC}};
end
always @(posedge PS2_CLK)
begin

/*if(BTNC==1)//初始化
	begin
		key_count=0;

	cur_key=0;
	lastdata=0;
	flag=0;
	//flag_cur=0;
	flag_caps=0;
	flag_ctrl=0;
	flag_shift=0;
	end*/
end

endmodule


//standard ps2 interface, you can keep this
module ps2_keyboard(clk, BTNC,PS2_CLK,PS2_DATA,data,ready,nextdata_n,overflow);
    input clk, BTNC,PS2_CLK,PS2_DATA;
	 input nextdata_n;
    output [7:0] data;
    output reg ready;
    output reg overflow;     // fifo overflow  
    // internal signal, for test
    reg [9:0] buffer;        // ps2_data bits
    reg [7:0] fifo[7:0];     // data fifo
	 reg [2:0] w_ptr,r_ptr;   // fifo write and read pointers	
    reg [3:0] count;  // count ps2_data bits
    // detect falling edge of PS2_CLK
    reg [2:0] PS2_CLK_sync;
    
    always @(posedge clk) begin
        PS2_CLK_sync <=  {PS2_CLK_sync[1:0],PS2_CLK};
    end

    wire sampling = PS2_CLK_sync[2] & ~PS2_CLK_sync[1];
    
    always @(posedge clk) begin
        if ( BTNC == 0) begin // reset 
           count <= 0; w_ptr <= 0; r_ptr <= 0; overflow <= 0; ready<= 0;buffer<=0;fifo[0]=0;fifo[1]=0;fifo[2]=0;fifo[3]=0;fifo[4]=0;fifo[5]=0;fifo[6]=0;fifo[7]=0;
        end 
		else
		 if (sampling) begin
            if (count == 4'd10) begin
                if ((buffer[0] == 0) &&  // start bit
                    (PS2_DATA)       &&  // stop bit
                    (^buffer[9:1])) begin      // odd  parity
                    fifo[w_ptr] <= buffer[8:1];  // kbd scan code
                    w_ptr <= w_ptr+3'b1;
                    ready <= 1'b1;
                    overflow <= overflow | (r_ptr == (w_ptr + 3'b1));
                end
                count <= 0;     // for next
            end else begin
                buffer[count] <= PS2_DATA;  // store ps2_data 
                count <= count + 3'b1;
            end      
        end
        if ( ready ) begin // read to output next data
				if(nextdata_n == 1'b0) //read next data
				begin
				   r_ptr <= r_ptr + 3'b1; 
					if(w_ptr==(r_ptr+1'b1)) //empty
					     ready <= 1'b0;
				end           
        end
    end
    assign data = fifo[r_ptr];
endmodule 

//simple scancode converter
module scancode_ram(clk, addr,flag_shift,flag_caps,outdata);
input clk;
input [7:0] addr;
input flag_shift;
input flag_caps;
output reg [7:0] outdata;
//Do not change the name of this ram, testbench will initialize this
//reg [7:0] ascii_tab[255:0];




always @(posedge clk)
begin
    if(flag_shift==1||flag_caps==1)
	  case (addr)		//键值转换为ASCII码				  	

		
8'h00: outdata <= 8'h00;
8'h01: outdata <= 8'h00;
8'h02: outdata <= 8'h00;
8'h03: outdata <= 8'h00;
8'h04: outdata <= 8'h00;
8'h05: outdata <= 8'h00;
8'h06: outdata <= 8'h00;
8'h07: outdata <= 8'h00;
8'h08: outdata <= 8'h00;
8'h09: outdata <= 8'h00;
8'h0A: outdata <= 8'h00;
8'h0B: outdata <= 8'h00;
8'h0C: outdata <= 8'h00;
8'h0D: outdata <= 8'h20;
8'h0E: outdata <= 8'h60;
8'h0F: outdata <= 8'h00;
8'h10: outdata <= 8'h00;
8'h11: outdata <= 8'h00;
8'h12: outdata <= 8'h00;
8'h13: outdata <= 8'h00;
8'h14: outdata <= 8'h00;
8'h15: outdata <= 8'h51;
8'h16: outdata <= 8'h31;
8'h17: outdata <= 8'h00;
8'h18: outdata <= 8'h00;
8'h19: outdata <= 8'h00;
8'h1A: outdata <= 8'h5A;
8'h1B: outdata <= 8'h53;
8'h1C: outdata <= 8'h41;
8'h1D: outdata <= 8'h57;
8'h1E: outdata <= 8'h32;
8'h1F: outdata <= 8'h00;
8'h20: outdata <= 8'h00;
8'h21: outdata <= 8'h43;
8'h22: outdata <= 8'h58;
8'h23: outdata <= 8'h44;
8'h24: outdata <= 8'h45;
8'h25: outdata <= 8'h34;
8'h26: outdata <= 8'h33;
8'h27: outdata <= 8'h00;
8'h28: outdata <= 8'h00;
8'h29: outdata <= 8'h20;
8'h2A: outdata <= 8'h56;
8'h2B: outdata <= 8'h46;
8'h2C: outdata <= 8'h54;
8'h2D: outdata <= 8'h52;
8'h2E: outdata <= 8'h35;
8'h2F: outdata <= 8'h00;
8'h30: outdata <= 8'h00;
8'h31: outdata <= 8'h4E;
8'h32: outdata <= 8'h42;
8'h33: outdata <= 8'h48;
8'h34: outdata <= 8'h47;
8'h35: outdata <= 8'h59;
8'h36: outdata <= 8'h36;
8'h37: outdata <= 8'h00;
8'h38: outdata <= 8'h00;
8'h39: outdata <= 8'h00;
8'h3A: outdata <= 8'h4D;
8'h3B: outdata <= 8'h4A;
8'h3C: outdata <= 8'h55;
8'h3D: outdata <= 8'h37;
8'h3E: outdata <= 8'h38;
8'h3F: outdata <= 8'h00;
8'h40: outdata <= 8'h00;
8'h41: outdata <= 8'h2C;
8'h42: outdata <= 8'h4B;
8'h43: outdata <= 8'h49;
8'h44: outdata <= 8'h4F;
8'h45: outdata <= 8'h30;
8'h46: outdata <= 8'h39;
8'h47: outdata <= 8'h00;
8'h48: outdata <= 8'h00;
8'h49: outdata <= 8'h2E;
8'h4A: outdata <= 8'h2F;
8'h4B: outdata <= 8'h4C;
8'h4C: outdata <= 8'h3B;
8'h4D: outdata <= 8'h50;
8'h4E: outdata <= 8'h2D;
8'h4F: outdata <= 8'h00;
8'h50: outdata <= 8'h00;
8'h51: outdata <= 8'h00;
8'h52: outdata <= 8'h27;
8'h53: outdata <= 8'h00;
8'h54: outdata <= 8'h5B;
8'h55: outdata <= 8'h3D;
8'h56: outdata <= 8'h00;
8'h57: outdata <= 8'h00;
8'h58: outdata <= 8'h00;
8'h59: outdata <= 8'h00;
8'h5A: outdata <= 8'h0D;
8'h5B: outdata <= 8'h5D;
8'h5C: outdata <= 8'h00;
8'h5D: outdata <= 8'h5C;
8'h5E: outdata <= 8'h00;
8'h5F: outdata <= 8'h00;
8'h60: outdata <= 8'h00;
8'h61: outdata <= 8'h00;
8'h62: outdata <= 8'h00;
8'h63: outdata <= 8'h00;
8'h64: outdata <= 8'h00;
8'h65: outdata <= 8'h00;
8'h66: outdata <= 8'h08;
8'h67: outdata <= 8'h00;
8'h68: outdata <= 8'h00;
8'h69: outdata <= 8'h31;
8'h6A: outdata <= 8'h00;
8'h6B: outdata <= 8'h34;
8'h6C: outdata <= 8'h37;
8'h6D: outdata <= 8'h00;
8'h6E: outdata <= 8'h00;
8'h6F: outdata <= 8'h00;
8'h70: outdata <= 8'h30;
8'h71: outdata <= 8'h2E;
8'h72: outdata <= 8'h32;
8'h73: outdata <= 8'h35;
8'h74: outdata <= 8'h36;
8'h75: outdata <= 8'h38;
8'h76: outdata <= 8'h00;
8'h77: outdata <= 8'h00;
8'h78: outdata <= 8'h00;
8'h79: outdata <= 8'h2B;
8'h7A: outdata <= 8'h33;
8'h7B: outdata <= 8'h2C;
8'h7C: outdata <= 8'h2A;
8'h7D: outdata <= 8'h39;
8'h7E: outdata <= 8'h00;
8'h7F: outdata <= 8'h00;
8'h80: outdata <= 8'h00;
8'h81: outdata <= 8'h00;
8'h82: outdata <= 8'h00;
8'h83: outdata <= 8'h00;
8'h84: outdata <= 8'h00;
8'h85: outdata <= 8'h00;
8'h86: outdata <= 8'h00;
8'h87: outdata <= 8'h00;
8'h88: outdata <= 8'h00;
8'h89: outdata <= 8'h00;
8'h8A: outdata <= 8'h00;
8'h8B: outdata <= 8'h00;
8'h8C: outdata <= 8'h00;
8'h8D: outdata <= 8'h00;
8'h8E: outdata <= 8'h00;
8'h8F: outdata <= 8'h00;
8'h90: outdata <= 8'h00;
8'h91: outdata <= 8'h00;
8'h92: outdata <= 8'h00;
8'h93: outdata <= 8'h00;
8'h94: outdata <= 8'h00;
8'h95: outdata <= 8'h00;
8'h96: outdata <= 8'h00;
8'h97: outdata <= 8'h00;
8'h98: outdata <= 8'h00;
8'h99: outdata <= 8'h00;
8'h9A: outdata <= 8'h00;
8'h9B: outdata <= 8'h00;
8'h9C: outdata <= 8'h00;
8'h9D: outdata <= 8'h00;
8'h9E: outdata <= 8'h00;
8'h9F: outdata <= 8'h00;
8'hA0: outdata <= 8'h00;
8'hA1: outdata <= 8'h00;
8'hA2: outdata <= 8'h00;
8'hA3: outdata <= 8'h00;
8'hA4: outdata <= 8'h00;
8'hA5: outdata <= 8'h00;
8'hA6: outdata <= 8'h00;
8'hA7: outdata <= 8'h00;
8'hA8: outdata <= 8'h00;
8'hA9: outdata <= 8'h00;
8'hAA: outdata <= 8'h00;
8'hAB: outdata <= 8'h00;
8'hAC: outdata <= 8'h00;
8'hAD: outdata <= 8'h00;
8'hAE: outdata <= 8'h00;
8'hAF: outdata <= 8'h00;
8'hB0: outdata <= 8'h00;
8'hB1: outdata <= 8'h00;
8'hB2: outdata <= 8'h00;
8'hB3: outdata <= 8'h00;
8'hB4: outdata <= 8'h00;
8'hB5: outdata <= 8'h00;
8'hB6: outdata <= 8'h00;
8'hB7: outdata <= 8'h00;
8'hB8: outdata <= 8'h00;
8'hB9: outdata <= 8'h00;
8'hBA: outdata <= 8'h00;
8'hBB: outdata <= 8'h00;
8'hBC: outdata <= 8'h00;
8'hBD: outdata <= 8'h00;
8'hBE: outdata <= 8'h00;
8'hBF: outdata <= 8'h00;
8'hC0: outdata <= 8'h00;
8'hC1: outdata <= 8'h00;
8'hC2: outdata <= 8'h00;
8'hC3: outdata <= 8'h00;
8'hC4: outdata <= 8'h00;
8'hC5: outdata <= 8'h00;
8'hC6: outdata <= 8'h00;
8'hC7: outdata <= 8'h00;
8'hC8: outdata <= 8'h00;
8'hC9: outdata <= 8'h00;
8'hCA: outdata <= 8'h00;
8'hCB: outdata <= 8'h00;
8'hCC: outdata <= 8'h00;
8'hCD: outdata <= 8'h00;
8'hCE: outdata <= 8'h00;
8'hCF: outdata <= 8'h00;
8'hD0: outdata <= 8'h00;
8'hD1: outdata <= 8'h00;
8'hD2: outdata <= 8'h00;
8'hD3: outdata <= 8'h00;
8'hD4: outdata <= 8'h00;
8'hD5: outdata <= 8'h00;
8'hD6: outdata <= 8'h00;
8'hD7: outdata <= 8'h00;
8'hD8: outdata <= 8'h00;
8'hD9: outdata <= 8'h00;
8'hDA: outdata <= 8'h00;
8'hDB: outdata <= 8'h00;
8'hDC: outdata <= 8'h00;
8'hDD: outdata <= 8'h00;
8'hDE: outdata <= 8'h00;
8'hDF: outdata <= 8'h00;
8'hE0: outdata <= 8'h00;
8'hE1: outdata <= 8'h00;
8'hE2: outdata <= 8'h00;
8'hE3: outdata <= 8'h00;
8'hE4: outdata <= 8'h00;
8'hE5: outdata <= 8'h00;
8'hE6: outdata <= 8'h00;
8'hE7: outdata <= 8'h00;
8'hE8: outdata <= 8'h00;
8'hE9: outdata <= 8'h00;
8'hEA: outdata <= 8'h00;
8'hEB: outdata <= 8'h00;
8'hEC: outdata <= 8'h00;
8'hED: outdata <= 8'h00;
8'hEE: outdata <= 8'h00;
8'hEF: outdata <= 8'h00;
8'hF0: outdata <= 8'h00;
8'hF1: outdata <= 8'h00;
8'hF2: outdata <= 8'h00;
8'hF3: outdata <= 8'h00;
8'hF4: outdata <= 8'h00;
8'hF5: outdata <= 8'h00;
8'hF6: outdata <= 8'h00;
8'hF7: outdata <= 8'h00;
8'hF8: outdata <= 8'h00;
8'hF9: outdata <= 8'h00;
8'hFA: outdata <= 8'h00;
8'hFB: outdata <= 8'h00;
8'hFC: outdata <= 8'h00;
8'hFD: outdata <= 8'h00;
8'hFE: outdata <= 8'h00;
8'hFF: outdata <= 8'h00;		

		
		default: ;
	  endcase
	 else
	   case (addr)		//键值转换为ASCII码
8'h00: outdata <= 8'h00;
8'h01: outdata <= 8'h00;
8'h02: outdata <= 8'h00;
8'h03: outdata <= 8'h00;
8'h04: outdata <= 8'h00;
8'h05: outdata <= 8'h00;
8'h06: outdata <= 8'h00;
8'h07: outdata <= 8'h00;
8'h08: outdata <= 8'h00;
8'h09: outdata <= 8'h00;
8'h0A: outdata <= 8'h00;
8'h0B: outdata <= 8'h00;
8'h0C: outdata <= 8'h00;
8'h0D: outdata <= 8'h20;
8'h0E: outdata <= 8'h60;
8'h0F: outdata <= 8'h00;
8'h10: outdata <= 8'h00;
8'h11: outdata <= 8'h00;
8'h12: outdata <= 8'h00;
8'h13: outdata <= 8'h00;
8'h14: outdata <= 8'h00;
8'h15: outdata <= 8'h71;
8'h16: outdata <= 8'h31;
8'h17: outdata <= 8'h00;
8'h18: outdata <= 8'h00;
8'h19: outdata <= 8'h00;
8'h1A: outdata <= 8'h7A;
8'h1B: outdata <= 8'h73;
8'h1C: outdata <= 8'h61;
8'h1D: outdata <= 8'h77;
8'h1E: outdata <= 8'h32;
8'h1F: outdata <= 8'h00;
8'h20: outdata <= 8'h00;
8'h21: outdata <= 8'h63;
8'h22: outdata <= 8'h78;
8'h23: outdata <= 8'h64;
8'h24: outdata <= 8'h65;
8'h25: outdata <= 8'h34;
8'h26: outdata <= 8'h33;
8'h27: outdata <= 8'h00;
8'h28: outdata <= 8'h00;
8'h29: outdata <= 8'h20;
8'h2A: outdata <= 8'h76;
8'h2B: outdata <= 8'h66;
8'h2C: outdata <= 8'h74;
8'h2D: outdata <= 8'h72;
8'h2E: outdata <= 8'h35;
8'h2F: outdata <= 8'h00;
8'h30: outdata <= 8'h00;
8'h31: outdata <= 8'h6E;
8'h32: outdata <= 8'h62;
8'h33: outdata <= 8'h68;
8'h34: outdata <= 8'h67;
8'h35: outdata <= 8'h79;
8'h36: outdata <= 8'h36;
8'h37: outdata <= 8'h00;
8'h38: outdata <= 8'h00;
8'h39: outdata <= 8'h00;
8'h3A: outdata <= 8'h6D;
8'h3B: outdata <= 8'h6A;
8'h3C: outdata <= 8'h75;
8'h3D: outdata <= 8'h37;
8'h3E: outdata <= 8'h38;
8'h3F: outdata <= 8'h00;
8'h40: outdata <= 8'h00;
8'h41: outdata <= 8'h2C;
8'h42: outdata <= 8'h6B;
8'h43: outdata <= 8'h69;
8'h44: outdata <= 8'h6F;
8'h45: outdata <= 8'h30;
8'h46: outdata <= 8'h39;
8'h47: outdata <= 8'h00;
8'h48: outdata <= 8'h00;
8'h49: outdata <= 8'h2E;
8'h4A: outdata <= 8'h2F;
8'h4B: outdata <= 8'h6C;
8'h4C: outdata <= 8'h3B;
8'h4D: outdata <= 8'h70;
8'h4E: outdata <= 8'h2D;
8'h4F: outdata <= 8'h00;
8'h50: outdata <= 8'h00;
8'h51: outdata <= 8'h00;
8'h52: outdata <= 8'h27;
8'h53: outdata <= 8'h00;
8'h54: outdata <= 8'h5B;
8'h55: outdata <= 8'h3D;
8'h56: outdata <= 8'h00;
8'h57: outdata <= 8'h00;
8'h58: outdata <= 8'h00;
8'h59: outdata <= 8'h00;
8'h5A: outdata <= 8'h0D;
8'h5B: outdata <= 8'h5D;
8'h5C: outdata <= 8'h00;
8'h5D: outdata <= 8'h5C;
8'h5E: outdata <= 8'h00;
8'h5F: outdata <= 8'h00;
8'h60: outdata <= 8'h00;
8'h61: outdata <= 8'h00;
8'h62: outdata <= 8'h00;
8'h63: outdata <= 8'h00;
8'h64: outdata <= 8'h00;
8'h65: outdata <= 8'h00;
8'h66: outdata <= 8'h08;
8'h67: outdata <= 8'h00;
8'h68: outdata <= 8'h00;
8'h69: outdata <= 8'h31;
8'h6A: outdata <= 8'h00;
8'h6B: outdata <= 8'h34;
8'h6C: outdata <= 8'h37;
8'h6D: outdata <= 8'h00;
8'h6E: outdata <= 8'h00;
8'h6F: outdata <= 8'h00;
8'h70: outdata <= 8'h30;
8'h71: outdata <= 8'h2E;
8'h72: outdata <= 8'h32;
8'h73: outdata <= 8'h35;
8'h74: outdata <= 8'h36;
8'h75: outdata <= 8'h38;
8'h76: outdata <= 8'h00;
8'h77: outdata <= 8'h00;
8'h78: outdata <= 8'h00;
8'h79: outdata <= 8'h2B;
8'h7A: outdata <= 8'h33;
8'h7B: outdata <= 8'h2C;
8'h7C: outdata <= 8'h2A;
8'h7D: outdata <= 8'h39;
8'h7E: outdata <= 8'h00;
8'h7F: outdata <= 8'h00;
8'h80: outdata <= 8'h00;
8'h81: outdata <= 8'h00;
8'h82: outdata <= 8'h00;
8'h83: outdata <= 8'h00;
8'h84: outdata <= 8'h00;
8'h85: outdata <= 8'h00;
8'h86: outdata <= 8'h00;
8'h87: outdata <= 8'h00;
8'h88: outdata <= 8'h00;
8'h89: outdata <= 8'h00;
8'h8A: outdata <= 8'h00;
8'h8B: outdata <= 8'h00;
8'h8C: outdata <= 8'h00;
8'h8D: outdata <= 8'h00;
8'h8E: outdata <= 8'h00;
8'h8F: outdata <= 8'h00;
8'h90: outdata <= 8'h00;
8'h91: outdata <= 8'h00;
8'h92: outdata <= 8'h00;
8'h93: outdata <= 8'h00;
8'h94: outdata <= 8'h00;
8'h95: outdata <= 8'h00;
8'h96: outdata <= 8'h00;
8'h97: outdata <= 8'h00;
8'h98: outdata <= 8'h00;
8'h99: outdata <= 8'h00;
8'h9A: outdata <= 8'h00;
8'h9B: outdata <= 8'h00;
8'h9C: outdata <= 8'h00;
8'h9D: outdata <= 8'h00;
8'h9E: outdata <= 8'h00;
8'h9F: outdata <= 8'h00;
8'hA0: outdata <= 8'h00;
8'hA1: outdata <= 8'h00;
8'hA2: outdata <= 8'h00;
8'hA3: outdata <= 8'h00;
8'hA4: outdata <= 8'h00;
8'hA5: outdata <= 8'h00;
8'hA6: outdata <= 8'h00;
8'hA7: outdata <= 8'h00;
8'hA8: outdata <= 8'h00;
8'hA9: outdata <= 8'h00;
8'hAA: outdata <= 8'h00;
8'hAB: outdata <= 8'h00;
8'hAC: outdata <= 8'h00;
8'hAD: outdata <= 8'h00;
8'hAE: outdata <= 8'h00;
8'hAF: outdata <= 8'h00;
8'hB0: outdata <= 8'h00;
8'hB1: outdata <= 8'h00;
8'hB2: outdata <= 8'h00;
8'hB3: outdata <= 8'h00;
8'hB4: outdata <= 8'h00;
8'hB5: outdata <= 8'h00;
8'hB6: outdata <= 8'h00;
8'hB7: outdata <= 8'h00;
8'hB8: outdata <= 8'h00;
8'hB9: outdata <= 8'h00;
8'hBA: outdata <= 8'h00;
8'hBB: outdata <= 8'h00;
8'hBC: outdata <= 8'h00;
8'hBD: outdata <= 8'h00;
8'hBE: outdata <= 8'h00;
8'hBF: outdata <= 8'h00;
8'hC0: outdata <= 8'h00;
8'hC1: outdata <= 8'h00;
8'hC2: outdata <= 8'h00;
8'hC3: outdata <= 8'h00;
8'hC4: outdata <= 8'h00;
8'hC5: outdata <= 8'h00;
8'hC6: outdata <= 8'h00;
8'hC7: outdata <= 8'h00;
8'hC8: outdata <= 8'h00;
8'hC9: outdata <= 8'h00;
8'hCA: outdata <= 8'h00;
8'hCB: outdata <= 8'h00;
8'hCC: outdata <= 8'h00;
8'hCD: outdata <= 8'h00;
8'hCE: outdata <= 8'h00;
8'hCF: outdata <= 8'h00;
8'hD0: outdata <= 8'h00;
8'hD1: outdata <= 8'h00;
8'hD2: outdata <= 8'h00;
8'hD3: outdata <= 8'h00;
8'hD4: outdata <= 8'h00;
8'hD5: outdata <= 8'h00;
8'hD6: outdata <= 8'h00;
8'hD7: outdata <= 8'h00;
8'hD8: outdata <= 8'h00;
8'hD9: outdata <= 8'h00;
8'hDA: outdata <= 8'h00;
8'hDB: outdata <= 8'h00;
8'hDC: outdata <= 8'h00;
8'hDD: outdata <= 8'h00;
8'hDE: outdata <= 8'h00;
8'hDF: outdata <= 8'h00;
8'hE0: outdata <= 8'h00;
8'hE1: outdata <= 8'h00;
8'hE2: outdata <= 8'h00;
8'hE3: outdata <= 8'h00;
8'hE4: outdata <= 8'h00;
8'hE5: outdata <= 8'h00;
8'hE6: outdata <= 8'h00;
8'hE7: outdata <= 8'h00;
8'hE8: outdata <= 8'h00;
8'hE9: outdata <= 8'h00;
8'hEA: outdata <= 8'h00;
8'hEB: outdata <= 8'h00;
8'hEC: outdata <= 8'h00;
8'hED: outdata <= 8'h00;
8'hEE: outdata <= 8'h00;
8'hEF: outdata <= 8'h00;
8'hF0: outdata <= 8'h00;
8'hF1: outdata <= 8'h00;
8'hF2: outdata <= 8'h00;
8'hF3: outdata <= 8'h00;
8'hF4: outdata <= 8'h00;
8'hF5: outdata <= 8'h00;
8'hF6: outdata <= 8'h00;
8'hF7: outdata <= 8'h00;
8'hF8: outdata <= 8'h00;
8'hF9: outdata <= 8'h00;
8'hFA: outdata <= 8'h00;
8'hFB: outdata <= 8'h00;
8'hFC: outdata <= 8'h00;
8'hFD: outdata <= 8'h00;
8'hFE: outdata <= 8'h00;
8'hFF: outdata <= 8'h00;
		default: ;
	  endcase
	  
	  
	  



     // outdata <= ascii_tab[addr];
end

endmodule