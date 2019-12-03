module MixColumns(
		 input wire [127:0] i_block;
		 output wire [127:0] o_block;
		 );
  
   reg [31:0] w0,w1,w2,w3;
   reg [31:0] mw0,mw1,mw2,mw3;
   reg [127:0] o_block_reg;

   assign o_block = o_block_reg;

   initial begin
	    w0 = block[127:96];
	    w1 = block[95:64];
	    w2 = block[63:32];
	    w3 = block[31:0];

	    mw0 = MixW(w0);
	    mw1 = MixW(w1);
	    mw2 = MixW(w2);
	    mw3 = MixW(w3);

	    o_block_reg = {mw0, mw1, mw2, mw3};
   end
   
   function [7:0] gm2(input [7:0] a);
      begin
	       gm2 = {a[6:0],1'b0} ^ (8'h1b & {8{a[7]}});
      end
   endfunction // gm2

   
   function [7:0] gm3(input a);
      begin
	       gm3 = gm2(a) ^ a;
      end
   endfunction // gm3
   
   
   function [31:0] MixW(input [31:0] col);
      reg   [7:0] b0,b1,b2,b3;
      reg [7:0]   mb0, mb1, mb2, mb3;
      begin
	       b0 = col[31:24];
	       b1 = col[23:16];
	       b2 = col[15:8];
	       b3 = col[7:0];

	       mb0 = gm2(b0) ^ gm3(b1) ^ b2 ^ b3;
	       mb1 = b0 ^ gm2(b1) ^ gm3(b2) ^ b3;
	       mb2 = b0 ^ b1 ^ gm2(b2) ^ gm3(b3);
	       mb3 = gm3(b0) ^ b1 ^ b2 ^ gm2(b3);

	       MixWords = {mb0, mb1, mb2, mb3};
      end
   endfunction // MixWords


endmodule

