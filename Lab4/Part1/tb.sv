`timescale 1ns/1ns
`define DELAY 100

module tb();
	reg [31:0] multiplicand;
	reg [31:0] multiplier;
	
	reg [31:0] product;
	
	float_mult mult(
		.x(multiplicand),
		.y(multiplier),
		.p(product)
	);

	initial begin
		multiplicand = 32'b11000001100100000000000000000000;
		multiplier =   32'b01000001000110000000000000000000;
		#(`DELAY);
	end
endmodule