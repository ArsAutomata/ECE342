`timescale 1ns/1ns
`define DELAY 100

module tb();

 // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
 reg [8-1:0] multicand; // To mul1 of cla_multiplier.v
 reg [8-1:0] multiplier; // To mul1 of cla_multiplier.v
 // End of automatics

 // Beginning of automatic wires (for undeclared instantiated-module outputs)
 wire [(8+8-1):0]product;// From mul1 of cla_multiplier.v
 // End of automatics

 mult_csm mul1(
    .out(product[15:0]),
    .x(multicand[7:0]),
    .y(multiplier[7:0])
);


	

// fpga4student.com FPGA projects, Verilog projects, VHDL projects  
	integer i;
	initial begin
	
		multicand = 8'd0;
		multiplier = 8'd0;
		
		for (i = 0; i < 256; i = i + 1) begin: W1
			#(`DELAY) 
			multicand = multicand + 1; 
			multiplier = multiplier + 1;
			
		end
 
		#(`DELAY) //correct
		multicand = 8'd6;
		multiplier = 8'd5;
	
		#(`DELAY) //correct
		multicand = 8'd12;
		multiplier = 8'd10;
 
		#(`DELAY) //correct
		multicand = 8'd10;
		multiplier = 8'd4;
 
		#(`DELAY) //correct
		multicand = 8'd6;
		multiplier = 8'd10;
 
		#(`DELAY) //correct
		multicand = 8'd12;
		multiplier = 8'd8;
	end
endmodule