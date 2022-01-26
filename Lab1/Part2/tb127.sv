`timescale 1ns/1ns
module tb117();
//Generates a 50MhZ clock.
logic clk; 
initial clk = 1'b0;
always #10 clk = ~clk; 

logic sreset; 
logic dut_enable; 
logic dut_last;
logic [6:0] count12_val; 
upcount #(118) count118 (.clk(clk), .sreset(sreset), .o_val(count12_val), .i_enable(dut_enable), .o_last(dut_last));

initial begin 

	dut_enable = 1'b0;
	sreset = 1'b1; 
	
	@(posedge clk);
	sreset = 1'b0; 
	
	@(posedge clk); 
		dut_enable = 1'b1; 
	
	wait(dut_last); 
	if (count12_val !== 7'd117) begin
		$display ("Error! Counter asserted o_last, but o_val was %d, instead of 117.", count12_val);
		$stop();
	end
	
	@(posedge clk);
	$stop();
	
	
end

endmodule 



