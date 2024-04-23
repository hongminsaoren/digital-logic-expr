module cache_top 
(
    input         rst, 
    input         clk,

    //------gpio-------
    output     [15:0] led,
    input      [15 :0] switch,       
    output reg [7 :0] AN,
    output reg [6 :0] SEG
);

// Add your code here

wire [31:0] data;
seg7decimal my_seg(
    .x(data[31:0]),
    .clk(clk),
    .seg(SEG[6:0]),
    .an(AN[7:0])
);
endmodule
