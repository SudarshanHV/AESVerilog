`timescale 1ns / 1ps

module roundlast(clk,rc,rin,keylastin,fout);
input clk;
input [3:0]rc;
input [127:0]rin;
input [127:0]keylastin;
output [127:0]fout;

wire [127:0] sb,sr,mcl,keyout;

RoundKeyGenerator t0(.rc(rc),.inkey(keylastin),.outkey(keyout));
ByteSubstitution t1(.data(rin),.scramble(sb));
ShiftRows t2(.i_block(sb),.o_block(sr));
assign fout= keyout^sr;

endmodule
