module AES_main(
	
       	input [127:0]  i_block,
       	input 	       clk,
	input [127:0]  init_key,
	input 	       reset, 
	output [127:0] o_block,
	output 	       block_finish
		);

   //parameters
   parameter TOTAL_ROUNDS = 4'b1010;
   parameter INIT_ROUND = 4'b0000;
   
   
   //registers
   reg [127:0] 	       block_reg;
   reg [127:0] 	       new_block_reg;
   reg [127:0] 	       o_block_reg;
   reg [127:0] 	       i_block_reg;
   reg [127:0] 	       BS_block, SR_block, MC_block;
   reg [127:0] 	       ARK_init_block, ARK_main_block, ARK_final_block;
   reg [127:0] 	       round_key_reg; //must find a way to update this reg
   reg [127:0] 	       round_key_old;
   reg [127:0] 	       init_key_reg;
   reg [3:0] 	       round;
   reg 		       rn_update;
   reg 		       ready;
   reg 		       finish;
      
   
   //wires
   wire [127:0]        round_key; //these wires are only useful if we plan on using a RoundKeyGenerator module.

      

   //assigning outputs
   assign o_block = o_block_reg;
   assign block_finish = finish;
      

   
   function [7:0] sbox (input [7:0] i_byte);

      //This module contains the S-box for the Byte Substitution step. 
      //Traditionally the S box would contain a 16x16 table of entries. 
      //Each entry in this table is obtained by by first taking the inverse of the input byte with respect to the Galois field G(2^8).
      //In the next step, the inverse is multiplied with a circularly rotated matrix and Exclusive OR-ed with the specific value 0x63.
      //For example, the S-Box entry of 0x00 is 0x63 since the inverse element of 0x00 is itself. 

      reg [7:0] o_byte;

      begin
	 case(i_byte)
	   8'h00: o_byte=8'h63;
	   8'h01: o_byte=8'h7c;
	   8'h02: o_byte=8'h77;
	   8'h03: o_byte=8'h7b;
	   8'h04: o_byte=8'hf2;
	   8'h05: o_byte=8'h6b;
	   8'h06: o_byte=8'h6f;
	   8'h07: o_byte=8'hc5;
	   8'h08: o_byte=8'h30;
	   8'h09: o_byte=8'h01;
	   8'h0a: o_byte=8'h67;
	   8'h0b: o_byte=8'h2b;
	   8'h0c: o_byte=8'hfe;
	   8'h0d: o_byte=8'hd7;
	   8'h0e: o_byte=8'hab;
	   8'h0f: o_byte=8'h76;
	   8'h10: o_byte=8'hca;
	   8'h11: o_byte=8'h82;
	   8'h12: o_byte=8'hc9;
	   8'h13: o_byte=8'h7d;
	   8'h14: o_byte=8'hfa;
	   8'h15: o_byte=8'h59;
	   8'h16: o_byte=8'h47;
	   8'h17: o_byte=8'hf0;
	   8'h18: o_byte=8'had;
	   8'h19: o_byte=8'hd4;
	   8'h1a: o_byte=8'ha2;
	   8'h1b: o_byte=8'haf;
	   8'h1c: o_byte=8'h9c;
	   8'h1d: o_byte=8'ha4;
	   8'h1e: o_byte=8'h72;
	   8'h1f: o_byte=8'hc0;
	   8'h20: o_byte=8'hb7;
	   8'h21: o_byte=8'hfd;
	   8'h22: o_byte=8'h93;
	   8'h23: o_byte=8'h26;
	   8'h24: o_byte=8'h36;
	   8'h25: o_byte=8'h3f;
	   8'h26: o_byte=8'hf7;
	   8'h27: o_byte=8'hcc;
	   8'h28: o_byte=8'h34;
	   8'h29: o_byte=8'ha5;
	   8'h2a: o_byte=8'he5;
	   8'h2b: o_byte=8'hf1;
	   8'h2c: o_byte=8'h71;
	   8'h2d: o_byte=8'hd8;
	   8'h2e: o_byte=8'h31;
	   8'h2f: o_byte=8'h15;
	   8'h30: o_byte=8'h04;
	   8'h31: o_byte=8'hc7;
	   8'h32: o_byte=8'h23;
	   8'h33: o_byte=8'hc3;
	   8'h34: o_byte=8'h18;
	   8'h35: o_byte=8'h96;
	   8'h36: o_byte=8'h05;
	   8'h37: o_byte=8'h9a;
	   8'h38: o_byte=8'h07;
	   8'h39: o_byte=8'h12;
	   8'h3a: o_byte=8'h80;
	   8'h3b: o_byte=8'he2;
	   8'h3c: o_byte=8'heb;
	   8'h3d: o_byte=8'h27;
	   8'h3e: o_byte=8'hb2;
	   8'h3f: o_byte=8'h75;
	   8'h40: o_byte=8'h09;
	   8'h41: o_byte=8'h83;
	   8'h42: o_byte=8'h2c;
	   8'h43: o_byte=8'h1a;
	   8'h44: o_byte=8'h1b;
	   8'h45: o_byte=8'h6e;
	   8'h46: o_byte=8'h5a;
	   8'h47: o_byte=8'ha0;
	   8'h48: o_byte=8'h52;
	   8'h49: o_byte=8'h3b;
	   8'h4a: o_byte=8'hd6;
	   8'h4b: o_byte=8'hb3;
	   8'h4c: o_byte=8'h29;
	   8'h4d: o_byte=8'he3;
	   8'h4e: o_byte=8'h2f;
	   8'h4f: o_byte=8'h84;
	   8'h50: o_byte=8'h53;
	   8'h51: o_byte=8'hd1;
	   8'h52: o_byte=8'h00;
	   8'h53: o_byte=8'hed;
	   8'h54: o_byte=8'h20;
	   8'h55: o_byte=8'hfc;
	   8'h56: o_byte=8'hb1;
	   8'h57: o_byte=8'h5b;
	   8'h58: o_byte=8'h6a;
	   8'h59: o_byte=8'hcb;
	   8'h5a: o_byte=8'hbe;
	   8'h5b: o_byte=8'h39;
	   8'h5c: o_byte=8'h4a;
	   8'h5d: o_byte=8'h4c;
	   8'h5e: o_byte=8'h58;
	   8'h5f: o_byte=8'hcf;
	   8'h60: o_byte=8'hd0;
	   8'h61: o_byte=8'hef;
	   8'h62: o_byte=8'haa;
	   8'h63: o_byte=8'hfb;
	   8'h64: o_byte=8'h43;
	   8'h65: o_byte=8'h4d;
	   8'h66: o_byte=8'h33;
	   8'h67: o_byte=8'h85;
	   8'h68: o_byte=8'h45;
	   8'h69: o_byte=8'hf9;
	   8'h6a: o_byte=8'h02;
	   8'h6b: o_byte=8'h7f;
	   8'h6c: o_byte=8'h50;
	   8'h6d: o_byte=8'h3c;
	   8'h6e: o_byte=8'h9f;
	   8'h6f: o_byte=8'ha8;
	   8'h70: o_byte=8'h51;
	   8'h71: o_byte=8'ha3;
	   8'h72: o_byte=8'h40;
	   8'h73: o_byte=8'h8f;
	   8'h74: o_byte=8'h92;
	   8'h75: o_byte=8'h9d;
	   8'h76: o_byte=8'h38;
	   8'h77: o_byte=8'hf5;
	   8'h78: o_byte=8'hbc;
	   8'h79: o_byte=8'hb6;
	   8'h7a: o_byte=8'hda;
	   8'h7b: o_byte=8'h21;
	   8'h7c: o_byte=8'h10;
	   8'h7d: o_byte=8'hff;
	   8'h7e: o_byte=8'hf3;
	   8'h7f: o_byte=8'hd2;
	   8'h80: o_byte=8'hcd;
	   8'h81: o_byte=8'h0c;
	   8'h82: o_byte=8'h13;
	   8'h83: o_byte=8'hec;
	   8'h84: o_byte=8'h5f;
	   8'h85: o_byte=8'h97;
	   8'h86: o_byte=8'h44;
	   8'h87: o_byte=8'h17;
	   8'h88: o_byte=8'hc4;
	   8'h89: o_byte=8'ha7;
	   8'h8a: o_byte=8'h7e;
	   8'h8b: o_byte=8'h3d;
	   8'h8c: o_byte=8'h64;
	   8'h8d: o_byte=8'h5d;
	   8'h8e: o_byte=8'h19;
	   8'h8f: o_byte=8'h73;
	   8'h90: o_byte=8'h60;
	   8'h91: o_byte=8'h81;
	   8'h92: o_byte=8'h4f;
	   8'h93: o_byte=8'hdc;
	   8'h94: o_byte=8'h22;
	   8'h95: o_byte=8'h2a;
	   8'h96: o_byte=8'h90;
	   8'h97: o_byte=8'h88;
	   8'h98: o_byte=8'h46;
	   8'h99: o_byte=8'hee;
	   8'h9a: o_byte=8'hb8;
	   8'h9b: o_byte=8'h14;
	   8'h9c: o_byte=8'hde;
	   8'h9d: o_byte=8'h5e;
	   8'h9e: o_byte=8'h0b;
	   8'h9f: o_byte=8'hdb;
	   8'ha0: o_byte=8'he0;
	   8'ha1: o_byte=8'h32;
	   8'ha2: o_byte=8'h3a;
	   8'ha3: o_byte=8'h0a;
	   8'ha4: o_byte=8'h49;
	   8'ha5: o_byte=8'h06;
	   8'ha6: o_byte=8'h24;
	   8'ha7: o_byte=8'h5c;
	   8'ha8: o_byte=8'hc2;
	   8'ha9: o_byte=8'hd3;
	   8'haa: o_byte=8'hac;
	   8'hab: o_byte=8'h62;
	   8'hac: o_byte=8'h91;
	   8'had: o_byte=8'h95;
	   8'hae: o_byte=8'he4;
	   8'haf: o_byte=8'h79;
	   8'hb0: o_byte=8'he7;
	   8'hb1: o_byte=8'hc8;
	   8'hb2: o_byte=8'h37;
	   8'hb3: o_byte=8'h6d;
	   8'hb4: o_byte=8'h8d;
	   8'hb5: o_byte=8'hd5;
	   8'hb6: o_byte=8'h4e;
	   8'hb7: o_byte=8'ha9;
	   8'hb8: o_byte=8'h6c;
	   8'hb9: o_byte=8'h56;
	   8'hba: o_byte=8'hf4;
	   8'hbb: o_byte=8'hea;
	   8'hbc: o_byte=8'h65;
	   8'hbd: o_byte=8'h7a;
	   8'hbe: o_byte=8'hae;
	   8'hbf: o_byte=8'h08;
	   8'hc0: o_byte=8'hba;
	   8'hc1: o_byte=8'h78;
	   8'hc2: o_byte=8'h25;
	   8'hc3: o_byte=8'h2e;
	   8'hc4: o_byte=8'h1c;
	   8'hc5: o_byte=8'ha6;
	   8'hc6: o_byte=8'hb4;
	   8'hc7: o_byte=8'hc6;
	   8'hc8: o_byte=8'he8;
	   8'hc9: o_byte=8'hdd;
	   8'hca: o_byte=8'h74;
	   8'hcb: o_byte=8'h1f;
	   8'hcc: o_byte=8'h4b;
	   8'hcd: o_byte=8'hbd;
	   8'hce: o_byte=8'h8b;
	   8'hcf: o_byte=8'h8a;
	   8'hd0: o_byte=8'h70;
	   8'hd1: o_byte=8'h3e;
	   8'hd2: o_byte=8'hb5;
	   8'hd3: o_byte=8'h66;
	   8'hd4: o_byte=8'h48;
	   8'hd5: o_byte=8'h03;
	   8'hd6: o_byte=8'hf6;
	   8'hd7: o_byte=8'h0e;
	   8'hd8: o_byte=8'h61;
	   8'hd9: o_byte=8'h35;
	   8'hda: o_byte=8'h57;
	   8'hdb: o_byte=8'hb9;
	   8'hdc: o_byte=8'h86;
	   8'hdd: o_byte=8'hc1;
	   8'hde: o_byte=8'h1d;
	   8'hdf: o_byte=8'h9e;
	   8'he0: o_byte=8'he1;
	   8'he1: o_byte=8'hf8;
	   8'he2: o_byte=8'h98;
	   8'he3: o_byte=8'h11;
	   8'he4: o_byte=8'h69;
	   8'he5: o_byte=8'hd9;
	   8'he6: o_byte=8'h8e;
	   8'he7: o_byte=8'h94;
	   8'he8: o_byte=8'h9b;
	   8'he9: o_byte=8'h1e;
	   8'hea: o_byte=8'h87;
	   8'heb: o_byte=8'he9;
	   8'hec: o_byte=8'hce;
	   8'hed: o_byte=8'h55;
	   8'hee: o_byte=8'h28;
	   8'hef: o_byte=8'hdf;
	   8'hf0: o_byte=8'h8c;
	   8'hf1: o_byte=8'ha1;
	   8'hf2: o_byte=8'h89;
	   8'hf3: o_byte=8'h0d;
	   8'hf4: o_byte=8'hbf;
	   8'hf5: o_byte=8'he6;
	   8'hf6: o_byte=8'h42;
	   8'hf7: o_byte=8'h68;
	   8'hf8: o_byte=8'h41;
	   8'hf9: o_byte=8'h99;
	   8'hfa: o_byte=8'h2d;
	   8'hfb: o_byte=8'h0f;
	   8'hfc: o_byte=8'hb0;
	   8'hfd: o_byte=8'h54;
	   8'hfe: o_byte=8'hbb;
	   8'hff: o_byte=8'h16;
	 endcase // case (i_byte)
	 
	 sbox = o_byte;
      end 
   endfunction // sbox

//changes from Yashas starts

   function automatic [31:0] Rcon(input [3:0]rc1);
     	
	case(rc1)
		4'b0000: Rcon=32'h01_00_00_00;//Underscore used to improve readability of bytes.
		4'b0001: Rcon=32'h02_00_00_00;
		4'b0010: Rcon=32'h04_00_00_00;
		4'b0011: Rcon=32'h08_00_00_00;
		4'b0100: Rcon=32'h10_00_00_00;
		4'b0101: Rcon=32'h20_00_00_00;
		4'b0110: Rcon=32'h40_00_00_00;
		4'b0111: Rcon=32'h80_00_00_00;
		4'b1000: Rcon=32'h1b_00_00_00;//How to derive this?
		4'b1001: Rcon=32'h36_00_00_00;
	default: Rcon=32'h00_00_00_00;
      	endcase
  	endfunction

   // IMPORTANT!!! The following function needs to be updated!
   function [127:0] RoundKeyGenerator (
				       input [127:0] input_key,
				       input [3:0]   round_number
				       );

      reg [31:0] w0,w1,w2,w3,tem;
      reg [127:0]outkey_reg;

      begin
	
	w0=input_key[127:96];
        w1=input_key[95:64];
        w2=input_key[63:32];
        w3=input_key[31:0]; 
	 
	tem[31:24] = sbox s1(w0[7:0]);
  	tem[23:16] = sbox s2(w0[31:24]);
        tem[15:8] = sbox s3(w0[23:16]);
  	tem[7:0] = sbox s4(w0[15:8]);

	outkey_reg[31:0] = w3^tem^Rcon(rc);//The complicated one...
  	outkey_reg[63:32] = outkey_reg[31:0]^w2;//Simple ones
  	outkey_reg[95:64] = outkey_reg[63:32]^w1;
  	outkey_reg[127:96] = outkey_reg[95:64]^w0;

	RoundKeyGenerator = outkey_reg;
 
      	end
      
   endfunction // RoundKeyGenerator
   
//changes from Yashas ends
   
   function [127:0] ByteSubstitution(input [127:0] data);
      
      //Byte Substitution is the first step to encrypt the information. 
      //The 128 bit data is divided into a 4x4 matrix where each element has 1 byte i.e. 8 bis of information.
      

      reg [127:0] sdata;

      begin
	 // The data is scrambled with respect to the S-Box byte-by-byte.
	 sdata[7:0] = sbox(data[7:0]);
	 sdata[15:8] = sbox(data[15:8]);
	 sdata[23:16] = sbox(data[23:16]);	
	 sdata[31:24] = sbox(data[31:24]);	
	 sdata[39:32] = sbox(data[39:32]); 
	 sdata[47:40] = sbox(data[47:40]);	
	 sdata[55:48] = sbox(data[55:48]);	
	 sdata[63:56] = sbox(data[63:56]);	
	 sdata[71:64] = sbox(data[71:64]);	
	 sdata[79:72] = sbox(data[79:72]);	
	 sdata[87:80] = sbox(data[87:80]);	
	 sdata[95:88] = sbox(data[95:88]);	
	 sdata[103:96] = sbox(data[103:96]);
	 sdata[111:104] = sbox(data[111:104]);
	 sdata[119:112] = sbox(data[119:112]);
	 sdata[127:120] = sbox(data[127:120]);
	 
	 ByteSubstitution = sdata;
      end   
   endfunction // ByteSubstitution
   

   function [127:0] ShiftRows(input [127:0] block);
      reg [31:0]  w0, w1, w2, w3;
      reg [31:0]  mw0, mw1, mw2, mw3;

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

   function [7:0] gm3(input [7:0] a);
      begin
	 gm3 = gm2(a) ^ a;
      end
   endfunction // gm3
   
   
   function [31:0] MixWords(input [31:0] col);
      reg   [7:0] b0, b1, b2, b3;
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

   function [127:0] AddRoundKey(
	    input [127:0] block,
	    input [127:0] key); //must modify this function such that it responds to round number
            
      begin
	 AddRoundKey = block^key;
      end
   endfunction // AddRoundKey

   always@(posedge clk or negedge reset)
     begin
	if (reset == 1'b0) //resets the outputs when reset=LOW
	  begin
	     o_block_reg <= 0;
	     rn_update <= 1'b0;
	     finish <= 1'b0;
	     ready <= 1'b1; //Nowhere except for here is ready set to 1
	     
	  end
	if (ready == 1'b1) //ready=HIGH indicates ready for next input block
	  begin
	     i_block_reg <= i_block;
	     block_reg <= i_block;
	     init_key_reg <= init_key;
	     ready <= 1'b0;
	     
	  end
     end // always@ (posedge clk or negedge reset)

   always@*
     begin : round_block_update
	BS_block = ByteSubstitution(block_reg);
	SR_block = ShiftRows(BS_block);
	MC_block = MixColumns(SR_block);
	
	ARK_init_block = AddRoundKey(i_block_reg, init_key_reg); //change key
	ARK_main_block = AddRoundKey(MC_block, round_key_reg);
	ARK_final_block = AddRoundKey(SR_block, round_key_reg);

	if (round == INIT_ROUND)
	  begin
	     new_block_reg = ARK_init_block;
	     rn_update = 1'b1; //initiates the next always block
	  end
	
	else if (round < TOTAL_ROUNDS)
	  begin
	     new_block_reg = ARK_main_block;
	     rn_update = 1'b1; //initiates the next always block
	  end
	
	else if (round == TOTAL_ROUNDS)
	  begin
	     new_block_reg = ARK_final_block;
	     rn_update = 1'b1; //initiates the next always block
	     finish = 1'b1;
	     
	  end
		
	
     end

   always@*
     begin : all_updates
	if (rn_update) //This is probably not required
	  begin
	     round = round + 4'b0001;
	     round_key_old = round_key_reg;
	     round_key_reg = RoundKeyGenerator(round_key_old, round);
	     block_reg = new_block_reg;
	     	     
	     rn_update = 1'b0;
	  end
	
	if (finish)
	  o_block_reg = new_block_reg;
	
	
     end
   
	
endmodule
