module AES_encry(input [127:0]i_block,input clk,input [127:0]key,output [127:0]o_block);

	reg [127:0]state, state_ByteSubs, state_ShiftRow, state_MixColumn, state_AddAroundRound, state_Key, state_RoundKeyGen;
	reg [3:0]count;

	assign count = 4'b0000;
	assign state_Key = key;

	parameter N=10;

//Generation of state array

	//AddAroundRound AAR1(.i_block(i_block),.key(state_Key),.o_block(state));
	assign state=i_block^state_Key;

//1st to 9th round on State Array

	always @(posedge clk) begin
	
		if( count < N-1 ) begin
		
			ByteSubstitution B1(.data(state), .scramble(state_ByteSubs));

			ShiftRows SR1(.i_block(state_ByteSubs), .o_block(state_ShiftRow));

			MixColumns MC1(.i_block(state_ShiftRow), .o_block(state_MixColumn));

			RoundKeyGenerator RKG1(.rc(count), .inkey(state_Key), .outkey(state_RoundKeyGen));

			//AddAroundRound AAR1(.i_block(state_MixColumn),.key(state_RoundKeyGen),.o_block(state));
			state=state_MixColumn^state_RoundKeyGen;

				   end

		assign state_Key = state_RoundKeyGen;
		assign count = count +4'b0001;

			       end

//10th round

	ByteSubstitution B2(.data(state), .scramble(state_ByteSubs));

	ShiftRows SR2(.i_block(state_ByteSubs), .o_block(state_ShiftRow));

	RoundKeyGenerator RKG2(.rc(count), .inkey(state_Key), .outkey(state_RoundKeyGen));

	//AddAroundRound AAR2(.i_block(state_ShiftRow),.key(state_RoundKeyGen),.o_block(state));
	state=state_ShiftRow^state_RoundKeyGen;

//Assigning the cypher state array to output

	assign o_block = state;

endmodule
