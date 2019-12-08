`timescale 1ns / 1ps

module AesCipher_tb;
   reg          clk;
   reg [127:0]  i_block, key;
   wire [127:0] o_block;
   AesCipher AES(.datain(i_block), .clk(clk), .key(key), .dataout(o_block));

   
   initial
     begin
	      i_block = 128'h10101010202020203030303040404040;
	      key = 128'h11111111222222223333333344444444;
     end

   always
     begin
        #1 i_block = i_block + 1'b1;
	$display("%lld",i_block);
	$display("%lld",o_block);
     end

endmodule
