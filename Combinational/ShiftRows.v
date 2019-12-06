module ShiftRows(
		 input wire [127:0] i_block,
		 output wire [127:0] o_block
		 );

   wire [31:0]            w0,w1,w2,w3;
   wire [31:0]            mw0,mw1,mw2,mw3;
	   assign w0 = i_block[127:96];
	   assign w1 = i_block[95:64];
	   assign w2 = i_block[63:32];
	   assign w3 = i_block[31:0];

	   assign mw0 = {{w0[31:24]},{w1[23:16]},{w2[15:8]},{w3[7:0]}};
	   assign mw1 = {{w1[31:24]},{w2[23:16]},{w3[15:8]},{w0[7:0]}};
	   assign mw2 = {{w2[31:24]},{w3[23:16]},{w0[15:8]},{w1[7:0]}};
	   assign mw3 = {{w3[31:24]},{w0[23:16]},{w1[15:8]},{w2[7:0]}};

	    assign o_block = {mw0, mw1, mw2, mw3};
endmodule // ShiftRows
