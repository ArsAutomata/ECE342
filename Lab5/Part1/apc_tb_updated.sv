`timescale 1ns/1ns
module apc_tb();
    logic clock = 0;
    logic reset = 1;
    logic [2:0] avs_address = '0;
    logic avs_read = 0;
    logic avs_write = 0;    
    logic [31:0] avs_writedata = '0;
	
	logic [31:0] avs_readdata;
    logic avs_waitrequest;
	
	real start_time;
	real time_taken;

    avalon_fp_mult DUT
    (
        .clk(clock),
        .reset(reset),
        .avs_s1_address(avs_address),
        .avs_s1_read(avs_read),
        .avs_s1_write(avs_write),
        .avs_s1_writedata(avs_writedata),
        .avs_s1_readdata(avs_readdata),
        .avs_s1_waitrequest(avs_waitrequest)
    );

	// The clock is set this way so that the TB can change 
	// inputs independent of clock edges. This is to check
	// that readdata changes immediately and not just on 
	// a clock edge. 
	always #1 clock = ~clock;

	task automatic apc_test(
		input [31:0] op1,
		input [31:0] op2,
		input [31:0] result
	);
	begin			 
		
		#9.5
		avs_writedata = op1;     
		avs_write = 1;
		avs_address = 0;
		#2
		
		// Trying to read back op1. This should happen immediately, not on the next clock edge.
		// if you fail this, that means your read logic is sequential and not combinational. 
		avs_write = 0;
		avs_read = 1;
		if (avs_readdata != op1) begin
			$display("ERROR: read did not return immediately.");
			$stop;
		end
		
		#2
		avs_writedata = op2;     
		avs_write = 1;
		avs_address = 1;
		#2
		avs_write = 0;
		#2
		// Setting start bit to 1. 
		avs_writedata = 1;
		avs_write = 1;
		avs_address = 2;
		#2
		avs_write = 0;
		avs_read = 1;
				
		// Save the time the avs_read to the start bit was asserted. 
		start_time = $realtime;
		
		// This means 'wait until avs_readdata goes to 0'. 
		wait (avs_waitrequest == 0);
		
		// How long did it take for waitrequest to go to 0? 
		time_taken = $realtime - start_time;
			
		if (time_taken < 22) begin
			$display("ERROR: The waitrequest was de-asserted too soon.");
			$stop;
		end
			
		if (time_taken > 25) begin
			$display("ERROR: The waitrequest was held high for too long");
			$stop;
		end		
		
		#2//was 2 before
		avs_address = 3;
		#20
		#0.5
		if (avs_readdata != result) 
			$display("FAIL: %X * %X should be %X but got %X instead.", op1, op2, result, avs_readdata);
		else 
			$display("SUCCESS: %X * %X = %X", op1, op2, result);
		end
		avs_read = 0; 
	
	endtask        
    
    initial begin
        #11
        reset = 0;
		
		apc_test(32'h4059999A, 32'h4194CCCD, 32'h427CF5C3); // 3.4 * 18.6 = 63.24
		apc_test(32'h41200000, 32'h425E0000, 32'h440AC000); // 10.0 * 55.5 = 555.0 
		// Add test cases for special cases here. 
		
		$stop();

    end
endmodule