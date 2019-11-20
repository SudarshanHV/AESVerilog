module AddAroundRound(input wire [127:0]i_block,input wire [127:0]key,output reg [127:0]o_block);

assign o_block = i_block^key;

endmodule