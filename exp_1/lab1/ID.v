`timescale 1ns / 1ps
module scrolling_id(
    output   [6:0] O_seg,  //7位显示段输出
    output   [7:0] O_led, //8个数码管输出控制
    input  clk
);
reg [3:0] start=4'd0;
reg [3:0] now;
wire [3:0] tmp;
reg [26:0] cnt;
reg [3:0] sel;
integer count=1;
led led1(tmp,O_seg);
id id1(now,tmp);
assign O_led=~(1<<sel);
initial begin
    sel=4'd7;
    now=4'd0;
end
always @ (posedge clk)
    if (count==17'd100000) count<=17'd1;
    else count<=count+17'd1;
always @ (posedge clk)
    if(count==17'd100000)begin
        if (sel==0)
        sel<=4'd7;
        else sel<=sel-4'd1;
    end
always @ (posedge clk)
    if (count==17'd100000) begin
        if (sel==0) now<=start;
        else if (now==4'd8) now<=4'd0;
        else now<=now+4'd1;
    end
always @ (posedge clk)
    if (cnt==27'd99999999)begin
        cnt<=0;
        if (start==4'd8) start<=4'd0;
        else start<=start+4'd1;
    end
    else cnt<=cnt+1;



endmodule

module id(
    input [3:0] in,
    output reg [3:0] out);
    always @ (*)
    case(in)
    4'd0:out=4'd2;
    4'd1:out=4'd2;
    4'd2:out=4'd1;
    4'd3:out=4'd9;
    4'd4:out=4'd0;
    4'd5:out=4'd0;
    4'd6:out=4'd3;
    4'd7:out=4'd3;
    4'd8:out=4'd2;
    endcase
endmodule

module led(
    input [3:0]in,
    output reg [6:0] out);//7位显示段输出
    always @ (*)
    case(in)
        4'b0000: out = 7'b1000000;
        4'b0001: out = 7'b1111001;
        4'b0010: out = 7'b0100100;
        4'b0011: out = 7'b0110000;
        4'b0100: out = 7'b0011001;
        4'b0101: out = 7'b0010010;
        4'b0110: out = 7'b0000010;
        4'b0111: out = 7'b1111000;
        4'b1000: out = 7'b0000000;
        4'b1001: out = 7'b0010000;
        4'b1010: out = 7'b0001000;
        4'b1011: out = 7'b0000011;
        4'b1100: out = 7'b1000110;
        4'b1101: out = 7'b0100001;
        4'b1110: out = 7'b0000110;
        4'b1111: out = 7'b0001110;
    endcase

endmodule
