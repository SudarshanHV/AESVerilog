module ShiftRows(
		 input wire [127:0] i_block;
		 output wire [127:0] o_block;
		 );

   reg [31:0]            w0,w1,w2,w3;
   reg [31:0]            mw0,mw1,mw2,mw3;
   reg [127:0]           o_block_reg;

   assign o_block = o_block_reg;

   initial begin
	    w0 = block[127:96];
	    w1 = block[95:64];
	    w2 = block[63:32];
	    w3 = block[31:0];

	    mw0 = {{w0[31:24]},{w1[23:16]},{w2[15:8]},{w3[7:0]}};
	    mw1 = {{w1[31:24]},{w2[23:16]},{w3[15:8]},{w0[7:0]}};
	    mw2 = {{w2[31:24]},{w3[23:16]},{w0[15:8]},{w1[7:0]}};
	    mw3 = {{w3[31:24]},{w0[23:16]},{w1[15:8]},{w2[7:0]}};

	    o_block_reg = {mw0, mw1, mw2, mw3};
   end // initial begin

endmodule // ShiftRows
