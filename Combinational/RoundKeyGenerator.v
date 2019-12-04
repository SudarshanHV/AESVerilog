module RoundKeyGenerator(rc,inkey,outkey);
  input [3:0] rc;
  input [127:0] inkey;
  output [127:0] outkey;

  //Assigning words according to grouping.
  wire [31:0] w0,w1,w2,w3,tem;
  assign w0=inkey[127:96];
  assign w1=inkey[95:64];
  assign w2=inkey[63:32];
  assign w3=inkey[31:0];
  
  //Taking from reverse.
  //rc represents the round number.
  //There are three steps to calculate first part of outkey:
  //One: Left shift w3 by one byte.
  //Two: Byte Substitution and xor with w0
  //Three: XOR with round constant.

//Function to generate round constant depending on the round number.
//Can be created as a separate module.

  function automatic [31:0] Rcon;
     input [3:0] rc1;
     case(rc1)
	4'h0: Rcon=32'h01_00_00_00;//Underscore used to improve readability of bytes.
	4'h1: Rcon=32'h02_00_00_00;
	4'h2: Rcon=32'h04_00_00_00;
	4'h3: Rcon=32'h08_00_00_00;
	4'h4: Rcon=32'h10_00_00_00;
	4'h5: Rcon=32'h20_00_00_00;
	4'h6: Rcon=32'h40_00_00_00;
	4'h7: Rcon=32'h80_00_00_00;
	4'h8: Rcon=32'h1b_00_00_00;//How to derive this?
	4'h9: Rcon=32'h36_00_00_00;
	default: Rcon=32'h00_00_00_00;
      endcase

  endfunction

  //Step one and two.
  sbox s1(.a(w0[7:0]),.c(tem[31:24]));
  sbox s2(.a(w0[31:24]),.c(tem[23:16]));
  sbox s3(.a(w0[23:16]),.c(tem[15:8]));
  sbox s4(.a(w0[15:8]),.c(tem[7:0]));


  //Step three and further progress.
  assign outkey[31:0]   = w3^tem^Rcon(rc);//The complicated one...
  assign outkey[63:32]  = w3^tem^Rcon(rc)^w2;//Simple ones
  assign outkey[95:64]  = w3^tem^Rcon(rc)^w2^w1;
  assign outkey[127:96] = w3^tem^Rcon(rc)^w2^w1^w0;

endmodule