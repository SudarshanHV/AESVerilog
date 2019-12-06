`timescale 1ns / 1ps
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

	 MixWords m1(.w(w0),.mw(mw0));
	 MixWords m2(.w(w1),.mw(mw1));
	 MixWords m3(.w(w2),.mw(mw2));
	 MixWords m4(.w(w3),.mw(mw3));

	//o_block_reg = {mw0, mw1, mw2, mw3};
   assign o_block = {mw0, mw1, mw2, mw3};
endmodule

