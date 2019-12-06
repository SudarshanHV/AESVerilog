module MixWords(w,mw);
input [31:0] w;
output [31:0] mw;
wire[7:0] b0,b1,b2,b3;
wire[7:0] mb0,mb1,mb2,mb3;

function [7:0] gm2(input [7:0] a);
      
      begin
	 gm2 = {a[6:0],1'b0} ^ (8'h1b & {8{a[7]}});
      end
endfunction // gm2

function [7:0] gm3(input [7:0] a);
      begin
	 gm3 = gm2(a) ^ a;
      end
endfunction // gm3


	 assign b0 = w[31:24];
	 assign b1 = w[23:16];
	 assign b2 = w[15:8];
	 assign b3 = w[7:0];

	 assign mb0 = gm2(b0) ^ gm3(b1) ^ b2 ^ b3;
	 assign mb1 = b0 ^ gm2(b1) ^ gm3(b2) ^ b3;
	 assign mb2 = b0 ^ b1 ^ gm2(b2) ^ gm3(b3);
	 assign mb3 = gm3(b0) ^ b1 ^ b2 ^ gm2(b3);

	 assign mw = {mb0, mb1, mb2, mb3};
	 

endmodule
