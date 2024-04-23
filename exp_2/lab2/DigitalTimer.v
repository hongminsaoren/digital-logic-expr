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


module DigitalTimer(  //�˿�����
  input clk,
  input rst,            //��λ����Ч��00:00:00
  input [1:0] s,        // =00ʱ�����뼼����01������Сʱ��10�����÷��ӣ�11��������
  input [3:0] data_h,   //���ó�ֵ��λ��ʹ��BCD���ʾ
  input [3:0] data_l,   //���ó�ֵ��λ��ʹ��BCD���ʾ
  output reg [6:0] O_seg,   //�߶����������ֵ����ʾ����
  output reg [7:0] an,     //�߶�����ܿ���λ������ʱ���֡��� 
  output reg [2:0] ledout   //���3ɫָʾ��
); 
// Add your code
//1S��ʱʱ�Ӳ���
reg [31:0]	count;
reg clk_1s; //0��1 һ����
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

reg [3:0] dout1,dout2,dout3,dout4,dout5,dout6;//�롢ʱ���ֵĸ�λ��ʮλ
reg co_1;//��ĸ�λ��ʮλ�Ľ�λ
reg co_2;//���ʮλ��ֵĸ�λ�Ľ�λ
reg co_3;//�ֵĸ�λ��ʮλ�Ľ�λ
reg co_4;//�ֵ�ʮλ��ʱ�Ľ�λ
reg co_5;//ʱ�ĸ�λ��ʮλ�Ľ�λ
reg co_6;//��ĸ���

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
	if(rst)     //���SW1�ر�ʱ�Ӹ�λ
 		dout1<=0;
    else if(sw[1])
        begin
            dout1 <= data_l;
        end
 	else 	//SW1�򿪽��м�ʱ��0-9��
 		begin
 		    if(co_4 == 1 && xy != 23)
 		         light <=5;
 		    else if(co_4 == 1 && xy == 23)
 		         light<=10;
 		    else
 		         light<=0;     
   			if(dout1<9)
				begin
					dout1 <= dout1 +1;	//���м�1����
	  				co_1<=0;  			//��ʱ��λ��Ϊ0��
				end
			else   						//��ĸ�λΪ9ʱ
				begin
	  				dout1 <= 0;	 	//���¸�ֵΪ0
	  				co_1<=1;        //��ʱ��λ��Ϊ1
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
 	else        //SW1�򿪲�ִ�����´���
 		begin 
 			if(sw[2])  //SW2��ִ�����´��룬��������ʱ
	  			 begin
                    dout3 <= data_l;
                    co_3 <= 0;
                 end
    		else //SW2�ر�ִ�����´��룬�������֣�������ʱ
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
        if(sw[2])  //SW2��ִ�����´��룬��������ʱ
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
 	else   //SW1��ִ�����´���
 		begin
   			if(sw[3])  //SW3��ʱִ��������룬��Ҫ��ʱ
				begin
	  				dout5<=data_l; //��xn1����10ȡ�ำֵ��ʱ�ĸ�λ
	  				dout6<=data_h;//��xn1����10ȡ����ֵ��ʱ��ʮλ
	  				xy<= (data_l + data_h * 10 + 1)%24;
				end
   			else //SW3�ر�ִ�����´���
	  			begin
			  		if(xy<23)
	          			xy<=xy+1;
		        	else
	          			xy<=0;
                    dout5<=xy%10;//��xy����10ȡ�ำֵ��ʱ�ĸ�λ
                    dout6<=xy/10;//��xy����10ȡ����ֵ��ʱ��ʮλ
      			end
		end	
  end


//ɨ��Ƶ��:50Hz
parameter update_interval = 48000000 / 400 - 1; 
reg [4:0] dat; 
reg [2:0] cursel;
integer selcnt;
reg [3:0] d1, d2, d4, d5, d7, d8;//�����������ʾ 
reg [3:0] d3, d6;//�����������ʾ

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

//���¶���
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
		//��ʾ��ֵ
		d1 <= dout1; //��ĸ�λ
		d2 <= dout2; //���ʮλ 
		d3 <= 4'b1010;
		d4 <= dout3; //�ֵĸ�λ
		d5 <= dout4; //�ֵ�ʮλ 
		d6 <= 4'b1010;
		d7 <= dout5; //ʱ�ĸ�λ
		d8 <= dout6; //ʱ��ʮλ 
end 


endmodule





