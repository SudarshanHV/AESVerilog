module MixColumns(
		 input wire [127:0] i_block,
		 output wire [127:0] o_block
		 );
  
   wire [31:0] w0,w1,w2,w3;
   wire [31:0] mw0,mw1,mw2,mw3;
   //reg [127:0] o_block_reg;

	assign w0 = i_block[127:96];
	assign w1 = i_block[95:64];
	assign w2 = i_block[63:32];
	assign w3 = i_block[31:0];

	 MixWords m1(w0,mw0);
	 MixWords m2(w1,mw1);
	 MixWords m3(w2,mw2);
	 MixWords m4(w3,mw3);

	//o_block_reg = {mw0, mw1, mw2, mw3};
   assign o_block = {mw0, mw1, mw2, mw3};
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
   
   
   function [31:0] MixWords(input [31:0] col);
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

