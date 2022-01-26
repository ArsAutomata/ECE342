`timescale 1ns/1ns
module tb12();
//Generates a 50MhZ clock.
logic clk; 
initial clk = 1'b0;
always #10 clk = ~clk; 

logic sreset; 
logic dut_enable; 
logic dut_last;
logic [3:0] dut_val; 
upcount #(.N(13)) count12 (.clk(clk), .sreset(sreset), .o_val(dut_val), .i_enable(dut_enable), .o_last(dut_last));

initial begin 

	dut_enable = 1'b0;
	sreset = 1'b1; 
	
	@(posedge clk);
	sreset = 1'b0; 
	
	@(posedge clk); 
		dut_enable = 1'b1; 
	
	wait(dut_last); 
	if (dut_val !== 4'd12) begin
		$display ("Error! Counter asserted o_last, but o_val was %d, instead of 13.", dut_val);
		$stop();
	end
	
	@(posedge clk);
	$stop();
	
	
end

endmodule 



