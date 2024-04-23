`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:03:05
// Design Name: 
// Module Name: barrelsft32_tb
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


module barrelsft32_tb(    );
wire [31:0] dout;
reg [31:0] din;
reg [4:0] shamt;
//移动位数
reg LR;
// LR=1 时左移,LR=0 时右移
reg AL;
// AL=1 时算术右移,AR=0 时逻辑右移
barrelsft32 barrelsft32_inst(dout,din,shamt,LR,AL);
initial begin
#20 begin din=$random; shamt=$random; end
#20 begin LR=0; AL=1; end
#20 begin LR=1; AL=1; end
#20 begin LR=0; AL=0; end
#20 begin LR=1; AL=0; end
#20 begin shamt=5'h3; LR=0; AL=1; end
#20 begin shamt=5'h3; LR=0; AL=0; end
#20 begin shamt=5'h3; LR=1; AL=0; end
#20 begin shamt=5'h15; LR=0; AL=1; end
#20 begin shamt=5'h15; LR=0; AL=0; end
#20 begin shamt=5'h15; LR=1; AL=0; end
#20 $stop;
end

endmodule
