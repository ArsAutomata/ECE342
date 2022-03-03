module avalon_fp_mult
(
	input clk,
	input reset,
	input [2:0] avs_s1_address,
	input avs_s1_read,
	input avs_s1_write,
	input [31:0] avs_s1_writedata,
	output logic [31:0] avs_s1_readdata,
	output logic avs_s1_waitrequest
);
	// 1. Create the signals to connect to the AVS peripheral registers. 	
	logic [31:0] op1;
	logic [31:0] op2;
	logic s; //start bit
	logic [31:0] result;
	logic [3:0] status; //special cases (nan, zero, etc)
	
	// 2. This instantiates your FP multiplier. Make sure the .qip file is added to your project. 
	fp_mult fpm
	(
		.clk_en(s) ,		
		.clock(clk) ,				
		.dataa(op1[31:0]) ,			
		.datab(op2[31:0]) ,			
		.nan(status[3]) ,			
		.overflow(status[0]) ,	
		.result(result[31:0]) ,			
		.underflow(status[1]) ,
		.zero(status[2]) 			
	);

	/* 3. Write code to handle the read and write operations.
		  It is best to start with write. Using the module signals,
		  you should determine when a write operation occurs and what 
		  register is being written to. 
	*/
	
	// Avalon write (recieve data)
	always_ff @ (posedge clk or posedge reset) begin
		if (reset) begin
			op1 <= 32'b00000000000000000000000000000000;
			op2 <= 32'b00000000000000000000000000000000;
			s <= 1'b0;
			result <= 32'b00000000000000000000000000000000;
			status <= 4'b0000;
			// Make sure to reset all your signals. 
		end
		if(avs_s1_write) begin
			if(avs_s1_address == 3'b000) begin //op1
				op1 <= avs_s1_writedata;
			end
			else if(avs_s1_address == 3'b001) begin //op2
				op2 <= avs_s1_writedata;
			end
			else if(avs_s1_address == 3'b010) begin //start bit
				s <= avs_s1_writedata[0];
			end
		end
			
	end

	/* 4. Now write the code for a read operation. 
		  This should be much simpler than write as 
		  you should just need a single mux. 
    */

	 //send data
	 always_comb begin
		if(avs_s1_address == 3'b000) begin //op1
			avs_s1_readdata = op1;
		end
		if(avs_s1_address == 3'b001) begin //op2
			avs_s1_readdata = op2;
		end
		if(avs_s1_address == 3'b010) begin //start
			avs_s1_readdata = s;
		end
		else if(avs_s1_address == 3'b011) begin //result
			avs_s1_readdata = clk;
			avs_s1_readdata = result;
		end
		else if(avs_s1_address == 3'b100) begin //status
			case(status)
				4'b0000: avs_s1_readdata = 4'b0000;
				4'b0001: avs_s1_readdata = 4'b0001; //overflow
				4'b0010: avs_s1_readdata = 4'b0010; //underflow
				4'b0100: avs_s1_readdata = 4'b0011; //zero
				4'b1000: avs_s1_readdata = 4'b0100; //nan
				default:avs_s1_readdata = 4'b0000;
			endcase
		end
	 end
	 
	/* 5. It is best to deal with the single cycle case first and then
	change your design to work with waitrequest. 
	*/


endmodule
