module mult_csm
(
	input [7:0] x,
	input [7:0] y,
	output [15:0] out
);
	logic [7:0] hp [7:0];
	logic  [7:0] pp [7:0];
	
	logic  [7:0] cin;

	// Write your nested generate for loops here.
	genvar i, j;
	
	generate
		//first row
		for (j = 0; j<8; j = j + 1) begin: genHA 
			assign hp[j] = x & {8{y[j]}};
		end 
		
		assign pp[0] = hp[0];
		assign cin[0] = 1'b0; 
		assign out[0] = pp[0][0];
		
		//remaining rows 
		for (i = 1; i<8; i = i + 1) begin: genCSA
			CSA C1(
				.s(pp[i]),
				.cout(cin[i]),
				.cin(1'b0),
				.x(hp[i]),
				.y({cin[i-1], pp[i-1][7-:7]})
			);
			 
			assign out[i] = pp[i][0];
		end
	// the final row of the multiplier to get out[16:8].
	
   	// Set the upper 8-bits of the final multiplier output. 
		assign out[15:8] = {cin[7],pp[7][7-:7]};
	endgenerate
endmodule

// Full adder cell
module fa
(
	input x, y, cin,
	output s, cout
);
	assign s = x ^ y ^ cin;
	assign cout = x&y | x&cin | y&cin;
endmodule


//referenced from https://www.fpga4student.com/2016/11/verilog-code-for-carry-look-ahead-multiplier.html
module CSA
(
	input x, y, cin,
	output s, cout
);

	input [7:0] x;
	input [7:0] y;
	input cin;
	output [7:0] s;
	output cout;
	
	wire [7:0] gen;
	wire [7:0] pro; 
	wire [8:0] ctemp; 
	
	genvar j, i; 
	generate
		assign ctemp[0] = cin; 
		
		//find the carry output 
		for (j = 0; j < 8; j = j+1) begin: cgen
			assign gen[j] = x[j] & y[j];
			assign pro[j] = x[j] | y[j]; 
			assign ctemp[j+1] = gen[j] | pro[j] & ctemp[j]; 
		end
		
		assign cout = ctemp[8]; 
		
		//find the remaining sum 
		for (i = 0; i < 8; i = i + 1) begin: sgen
			assign s[i] = x[i] ^ y[i] ^ ctemp[i];
		end
	endgenerate
endmodule
		