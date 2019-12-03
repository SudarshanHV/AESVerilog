module AES_main_tb;
   reg          reset, clk;
   reg [127:0]  i_block, key;
   wire [127:0] o_block;
   wire         ready;


   AES_main AES(.i_block(i_block), .clk(clk), .init_key(key), .reset(reset), .o_block(o_block), .ready_for_input(ready));
   initial
     begin
        reset = 1;
	      clk=0;

        $dumpfile("AES_main_tb");
        $dumpvars;
        #20 $finish;
     end

   always
     begin
        #1 clk = ~clk;
     end

   always
     begin
        #2 i_block = i_block + 1'b1;
     end

   initial
     begin
        #1 reset=0;
        #1 reset=1;
	      #1 i_block = 128'h10101010202020203030303040404040;
	      key = 128'h11111111222222223333333344444444;
     end
endmodule

