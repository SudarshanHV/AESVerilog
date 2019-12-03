//Currently, this module only contains code for ShiftRows and MixColumns.
//This code is currently for rounds 1-9 only
module aes_encryption(i_block, o_block);

   input wire [127:0] i_block;
   output reg [127:0] o_block;

   function [127:0] ShiftRows(input [127:0] block);
      reg [31:0] w0,w1,w2,w3;
      reg [31:0] mw0,mw1,mw2,mw3;

      begin

	 w0 = block[127:96];
	 w1 = block[95:64];
	 w2 = block[63:32];
	 w3 = block[31:0];

	 mw0 = {{w0[31:24]},{w1[23:16]},{w2[15:8]},{w3[7:0]}};
	 mw1 = {{w1[31:24]},{w2[23:16]},{w3[15:8]},{w0[7:0]}};
	 mw2 = {{w2[31:24]},{w3[23:16]},{w0[15:8]},{w1[7:0]}};
	 mw3 = {{w3[31:24]},{w0[23:16]},{w1[15:8]},{w2[7:0]}};

	 ShiftRows = {mw0, mw1, mw2, mw3};
      end
   endfunction // ShiftRows

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
      reg   [7:0] mb0, mb1, mb2, mb3;
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

   function [127:0] MixColumns(input [127:0] block);
      reg [31:0] w0,w1,w2,w3;
      reg [31:0] mw0,mw1,mw2,mw3;
      begin
	 w0 = block[127:96];
	 w1 = block[95:64];
	 w2 = block[63:32];
	 w3 = block[31:0];

	 mw0 = MixWords(w0);
	 mw1 = MixWords(w1);
	 mw2 = MixWords(w2);
	 mw3 = MixWords(w3);

	 MixColumns = {mw0, mw1, mw2, mw3};
	 
      end
   endfunction // MixColumns

   
   always@(i_block) begin

      o_block = MixColumns(ShiftRows(i_block));
      
   end

   
   //-----------------------------------------------
   //The following code is for testing purposes only
   //-----------------------------------------------
   
   reg [7:0] t;
   reg [31:0] w1,w2,w3,w4;
   reg [127:0] input_block, mc_out, sr_out;

   initial begin

      w1 = {8'h41,8'h11,8'h21,8'h31};
      w2 = {8'h02,8'h02,8'h02,8'h02};
      w3 = {8'h03,8'h03,8'h03,8'h03};
      w4 = {8'h04,8'h04,8'h04,8'h04};
      input_block = {w1,w2,w3,w4};
      mc_out=MixColumns(input_block);
      sr_out=ShiftRows(input_block);
      
      t = 8'b00000111;
                  
      $display ("Mix Columns Output = ");
      $display ("%b %b %b %b", mc_out[127:120], mc_out[95:88], mc_out[63:56], mc_out[31:24]);
      $display ("%b %b %b %b", mc_out[119:112], mc_out[87:80], mc_out[55:48], mc_out[23:16]);
      $display ("%b %b %b %b", mc_out[111:104], mc_out[79:72], mc_out[47:40], mc_out[15:8]);
      $display ("%b %b %b %b", mc_out[103:96], mc_out[71:64], mc_out[39:32], mc_out[7:0]);

      $display ("Shift Rows Output = ");
      $display ("%b %b %b %b", sr_out[127:120], sr_out[95:88], sr_out[63:56], sr_out[31:24]);
      $display ("%b %b %b %b", sr_out[119:112], sr_out[87:80], sr_out[55:48], sr_out[23:16]);
      $display ("%b %b %b %b", sr_out[111:104], sr_out[79:72], sr_out[47:40], sr_out[15:8]);
      $display ("%b %b %b %b", sr_out[103:96], sr_out[71:64], sr_out[39:32], sr_out[7:0]);

      /*
      $display ("Shift Rows Output = ");
      $display ("%b %b %b %b", sr_out[127:120], sr_out[119:112], sr_out[111:104], sr_out[103:96]);
      $display ("%b %b %b %b", sr_out[95:88], sr_out[87:80], sr_out[79:72], sr_out[71:64]);
      $display ("%b %b %b %b", sr_out[63:56], sr_out[55:48], sr_out[47:40], sr_out[39:32]);
      $display ("%b %b %b %b", sr_out[31:24], sr_out[23:16], sr_out[15:8], sr_out[7:0]);
       */
      
      $display ("gm2 output = %b", gm2(t));
   end
   
endmodule
