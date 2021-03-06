`timescale 1ns / 1ps

module rounds1to9(clk,rc,data,keyin,keyout,rndout);
input clk;
input [3:0]rc;
input [127:0]data;
input [127:0]keyin;
output [127:0]keyout;
output [127:0]rndout;

wire [127:0] sb,sr,mcl;

RoundKeyGenerator t0(.rc(rc),.inkey(keyin),.outkey(keyout));
//initial begin
//$monitor("%d ",keyout);
//end
ByteSubstitution t1(.data(data),.scramble(sb));
ShiftRows t2(.i_block(sb),.o_block(sr));
MixColumns t3(.i_block(sr),.o_block(mcl));
assign rndout= keyout^mcl;

endmodule
