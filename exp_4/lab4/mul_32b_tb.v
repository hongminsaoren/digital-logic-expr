`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/05 09:53:25
// Design Name: 
// Module Name: mul_32b_tb
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


module mul_32b_tb(   );
  parameter N = 32;               // ����λ��
  parameter SEED = 1;              // ���岻ͬ���������
     reg clk, rst;
     reg [N-1:0] x, y;
     reg in_valid;
     wire [2*N-1:0] p;
     wire  out_valid;

  mul_32b my_mul_32u (.clk(clk),.rst(rst),.x(x),.y(y),.in_valid(in_valid),.p(p),.out_valid(out_valid)); // 
  
    reg [2*N-1:0] temp_P;
   integer i, errors;
  task checkP;
    begin
      temp_P = x*y;
      if (out_valid &&(temp_P !=p)) begin
        errors=errors+1;
        $display($time," Error: x=%8h, y=%8h, expected %16h (%d), got %16h (%d)",
                 x, y, temp_P, temp_P, p, p); 
        end
    end
  endtask


  initial begin : TB   // Start testing at time 0
     clk = 0;
	 forever 
	#2 clk = ~clk;	     //
  end

  initial 
   begin	
    errors = 0;
           x = $random(SEED);                        // Set pattern based on seed parameter
   for (i=0; i<10000; i=i+1) begin                //����10000��
        rst = 1'b0;
        #2
        rst = 1'b1;                             //�ϵ��1us��λ�ź�
	    x=$random; y=$random;
     	#2
    	//rst = 1'b0;	
	    in_valid=1'b1;                        //��ʼ������
	    #5
	    in_valid=1'b0;
	    #400;	                          // wait 150 ns, then check result
	     checkP;
      end  
    $display($time, " Multipler32U test end. Errors %d .",errors); 
    $stop(1);          // end test
  end


endmodule
