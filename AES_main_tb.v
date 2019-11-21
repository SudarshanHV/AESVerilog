module AES_main_tb;
   reg          reset, clk;
   reg [127:0] 	i_block, key;
   wire [127:0] o_block;
   wire 	finish;
      
   
   AES_main AES(.i_block(i_block), .clk(clk), .init_key(key), .reset(reset), .o_block(o_block), .block_finish(finish));
   initial
     begin
        reset = 0;
	i_block = 128'h10101010202020203030303040404040;
	key = 128'h11111111222222223333333344444444;
	clk=0;
	
        $dumpfile("AES_main_tb");
        $dumpvars;
        #10000 $finish;
     end
 
   always
     begin
        #1 clk = ~clk;
     end
   
   initial
     begin
        #2 reset=1;
     end
endmodule

