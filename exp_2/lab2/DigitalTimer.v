`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 13:48:41
// Design Name: 
// Module Name: DigitalTimer
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


module DigitalTimer(  //端口声明
  input clk,
  input rst,            //复位，有效后00:00:00
  input [1:0] s,        // =00时，进入技术；01：设置小时；10：设置分钟；11：设置秒
  input [3:0] data_h,   //设置初值高位，使用BCD码表示
  input [3:0] data_l,   //设置初值低位，使用BCD码表示
  output reg [6:0] O_seg,   //七段数码管输入值，显示数字
  output reg [7:0] an,     //七段数码管控制位，控制时、分、秒 
  output reg [2:0] ledout   //输出3色指示灯
); 
// Add your code
//1S定时时钟产生
reg [31:0]	count;
reg clk_1s; //0，1 一秒钟
always @(posedge clk)  
	if(count==24_000_000-1)
	begin
		count <= count+1;
		clk_1s <= 0;
	end
	else if(count<48_000_000-1)
		count <= count+1;
	else 
	begin
		count <= 0;
		clk_1s <= 1;		
	end

reg [3:0] dout1,dout2,dout3,dout4,dout5,dout6;//秒、时、分的个位和十位
reg co_1;//秒的个位向十位的进位
reg co_2;//秒的十位向分的个位的进位
reg co_3;//分的个位向十位的进位
reg co_4;//分的十位向时的进位
reg co_5;//时的个位向十位的进位
reg co_6;//天的更新

reg [3:0]sw;
always @(s)
begin
case(s)

   2'b00:sw = 4'b0001;
   2'b11:sw = 4'b0010;
   2'b10:sw = 4'b0100;
   2'b01:sw = 4'b1000;
   endcase
end

integer light;
reg[6:0] xy;
always@(posedge clk_1s,posedge rst)
begin
	if(rst)     //如果SW1关闭时钟复位
 		dout1<=0;
    else if(sw[1])
        begin
            dout1 <= data_l;
        end
 	else 	//SW1打开进行计时（0-9）
 		begin
 		    if(co_4 == 1 && xy != 23)
 		         light <=5;
 		    else if(co_4 == 1 && xy == 23)
 		         light<=10;
 		    else
 		         light<=0;     
   			if(dout1<9)
				begin
					dout1 <= dout1 +1;	//进行加1操作
	  				co_1<=0;  			//此时进位数为0；
				end
			else   						//秒的个位为9时
				begin
	  				dout1 <= 0;	 	//重新赋值为0
	  				co_1<=1;        //此时进位数为1
	 			end
		end
end	
always@(posedge clk_1s)
begin
    if(dout1 < 10 && dout2 == 0 && dout3 == 0 && dout4 == 0 && dout5==0 && dout6 == 0)
        ledout <= ledout % 6 + 1;
    else if(dout1 < 5 && dout2 == 0 && dout3 == 0 && dout4 == 0)
        ledout <= ledout % 6 + 1;
    else 
        ledout<= 0;
    
end        


always @(posedge co_1,posedge rst,posedge sw[1])
begin
	if(rst)
		dout2<=0;
	else 
        begin
            if(sw[1])
            begin
                dout2 <= data_h;
                co_2<=0;
            end	
	        else
            begin
                if(dout2<5)
                    begin
                        dout2 <= dout2 +1;	
                        co_2<=0;
                    end
                else 
                    begin
                        dout2 <= 0;	 	
                        co_2<=1;
                    end
            end
      end
end 

always @(posedge co_2,posedge rst,posedge sw[2])
begin
	if(rst)
 		dout3<=0;
 	else        //SW1打开才执行以下代码
 		begin 
 			if(sw[2])  //SW2打开执行以下代码，即调分钟时
	  			 begin
                    dout3 <= data_l;
                    co_3 <= 0;
                 end
    		else //SW2关闭执行以下代码，即不调分，正常计时
				begin
	    			if(dout3<9)
	     				begin
	     					dout3 <= dout3 +1;	
	     					co_3<=0;
	     				end
	   				else 
	    				begin
	      					dout3 <= 0;	 	
	      					co_3<=1;
	    				end
       			end	
  		end
 end
 
always @(posedge co_3,posedge rst,posedge sw[2])
begin
	if(rst)
 		dout4<=0;
 	else 
 	begin
        if(sw[2])  //SW2打开执行以下代码，即调分钟时
            begin
                dout4 <= data_h;
                co_4 <= 0;
            end
 	    else
 		begin
   			if(dout4<5)
				begin
	 				dout4 <= dout4 +1;	
	  				co_4<=0;
				end
			else 
				begin
	  				dout4 <= 0;	 	
	  				co_4<=1;
	 			end
 		end	
 	end
 end

always @(posedge co_4,posedge rst,posedge sw[3])
begin
	if(rst)
	begin
 		dout5<=0;
 		dout6<=0;
 		xy<=7'b0000001;
 	end
 	else   //SW1打开执行以下代码
 		begin
   			if(sw[3])  //SW3打开时执行下面代码，即要调时
				begin
	  				dout5<=data_l; //将xn1除以10取余赋值给时的个位
	  				dout6<=data_h;//将xn1除以10取整赋值给时的十位
	  				xy<= (data_l + data_h * 10 + 1)%24;
				end
   			else //SW3关闭执行以下代码
	  			begin
			  		if(xy<23)
	          			xy<=xy+1;
		        	else
	          			xy<=0;
                    dout5<=xy%10;//将xy除以10取余赋值给时的个位
                    dout6<=xy/10;//将xy除以10取整赋值给时的十位
      			end
		end	
  end


//扫描频率:50Hz
parameter update_interval = 48000000 / 400 - 1; 
reg [4:0] dat; 
reg [2:0] cursel;
integer selcnt;
reg [3:0] d1, d2, d4, d5, d7, d8;//定义数码管显示 
reg [3:0] d3, d6;//定义数码管显示

//扫描计数，选择位
always @(posedge clk)
begin
	selcnt <= selcnt + 1;
	if (selcnt == update_interval)
		begin
			selcnt <= 0;
			cursel <= cursel + 1;
		end
end
 
//切换扫描位选线和数据
always @(posedge clk)
begin
	case (cursel)
		3'b000: begin dat = d1; an = ~8'b00000001; end
		3'b001: begin dat = d2; an = ~8'b00000010;end
		3'b010: begin dat = d3; an = ~8'b00000100; end
		3'b011: begin dat = d4; an = ~8'b00001000; end
		3'b100: begin dat = d5; an = ~8'b00010000; end
		3'b101: begin dat = d6; an = ~8'b00100000;end
		3'b110: begin dat = d7; an = ~8'b01000000; end
		3'b111: begin dat = d8; an = ~8'b10000000; end
	endcase
end

//更新段码
always @(posedge clk)
begin
	case (dat[3:0])
		0: O_seg = 7'b100_0000;
        1: O_seg = 7'b111_1001;
        2: O_seg = 7'b010_0100;
        3: O_seg = 7'b011_0000;
        4: O_seg = 7'b001_1001;
        5: O_seg = 7'b001_0010;
        6: O_seg = 7'b000_0010;
        7: O_seg = 7'b111_1000;
        8: O_seg = 7'b000_0000;
        9: O_seg = 7'b001_0000;
        10: O_seg = 7'b111_1111;
	endcase
end

always @(posedge clk)
begin
		//显示赋值
		d1 <= dout1; //秒的个位
		d2 <= dout2; //秒的十位 
		d3 <= 4'b1010;
		d4 <= dout3; //分的个位
		d5 <= dout4; //分的十位 
		d6 <= 4'b1010;
		d7 <= dout5; //时的个位
		d8 <= dout6; //时的十位 
end 


endmodule





