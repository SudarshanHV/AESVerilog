`timescale 1ns / 1ps
module ByteSubstitution(data, scramble);

//Byte Substitution is the first step to encrypt the information.
//The 128 bit data is divided into a 4x4 matrix where each element has 1 byte i.e. 8 bis of information.

input [127:0] data;
output [127:0] scramble;

// The data is scrambled with respect to the S-Box byte-by-byte.
	sbox s0(.a(data[7:0]),.c(scramble[7:0]) );
	sbox s1(.a(data[15:8]),.c(scramble[15:8]) );
	sbox s2(.a(data[23:16]),.c(scramble[23:16]) );
	sbox s3(.a(data[31:24]),.c(scramble[31:24]) );
	sbox s4(.a(data[39:32]),.c(scramble[39:32]) );
	sbox s5(.a(data[47:40]),.c(scramble[47:40]) );
	sbox s6( .a(data[55:48]),.c(scramble[55:48]) );
	sbox s7( .a(data[63:56]),.c(scramble[63:56]) );
	sbox s8( .a(data[71:64]),.c(scramble[71:64]) );
	sbox s9( .a(data[79:72]),.c(scramble[79:72]) );
	sbox s10( .a(data[87:80]),.c(scramble[87:80]) );
	sbox s11( .a(data[95:88]),.c(scramble[95:88]) );
	sbox s12( .a(data[103:96]),.c(scramble[103:96]) );
	sbox s13( .a(data[111:104]),.c(scramble[111:104]) );
	sbox s14( .a(data[119:112]),.c(scramble[119:112]) );
	sbox s15( .a(data[127:120]),.c(scramble[127:120]) );


endmodule
