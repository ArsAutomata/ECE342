module wallace_mult #(width=8) (
    input [7:0] x,
    input [7:0] y,
    output [15:0] out  	
);

	// Wires corresponding to each level of the WTM. 
	wire [15:0] s_lev[0:3][1:2];
	wire [15:0] c_lev[0:3][1:2];
	
	// Rest of your code goes here.
		wire [15:0] i[0:7];
		
		
		
		
		genvar n;
		generate
			for(n = 0; n < 8; n = n+1)begin
				assign i[n] = y[n] ? x << n : '0; //<< is left shift
				
			end
		endgenerate
		
		
		/*if(y[0] == 1)begin
			assign i[0] = x; //<< is left shift
		end
		else begin
			assign i[0] = '0;
		end

		if(y[1] == 1)begin
			assign i[1] = x << 1; //<< is left shift
		end
		else begin
			assign i[1] = '0;
		end

		if(y[2] == 1)begin
			assign i[2] = x << 2; //<< is left shift
		end
		else begin
			assign i[2] = '0;
		end

		if(y[3] == 1)begin
			assign i[3] = x << 3; //<< is left shift
		end
		else begin
			assign i[3] = '0;
		end

		if(y[4] == 1)begin
			assign i[4] = x << 4; //<< is left shift
		end
		else begin
			assign i[4] = '0;
		end

		if(y[5] == 1)begin
			assign i[5] = x << 5; //<< is left shift
		end
		else begin
			assign i[5] = '0;
		end

		if(y[6] == 1)begin
			assign i[6] = x << 6; //<< is left shift
		end
		else begin
			assign i[6] = '0;
		end

		if(y[7] == 1)begin
			assign i[7] = x << 7; //<< is left shift
		end
		else begin
			assign i[7] = '0;
		end*/
		//end

		CSA csa_01 (.w(i[0]), .x(i[1]), .y(i[2]), .cin(1'b0), .sum(s_lev[0][1]), .cout(c_lev[0][1]));		
		
		CSA csa_02 (.w(i[3]), .x(i[4]), .y(i[5]), .cin(1'b0), .sum(s_lev[0][2]), .cout(c_lev[0][2]));
		
		assign c_lev[0][1] = c_lev[0][1] << 1;
		CSA csa_11 (.w(s_lev[0][1]), .x(c_lev[0][1]), .y(s_lev[0][2]), .cin(1'b0), .sum(s_lev[1][1]), .cout(c_lev[1][1]));
		
		assign c_lev[0][2] = c_lev[0][2] << 1;
		CSA csa_12 (.w(c_lev[0][2]), .x(i[6]), .y(i[7]), .cin(1'b0), .sum(s_lev[1][2]), .cout(c_lev[1][2]));	
		
		assign c_lev[1][1] = c_lev[1][1] << 1;
		CSA csa_21 (.w(c_lev[1][1]), .x(s_lev[1][1]), .y(s_lev[1][2]), .cin(1'b0), .sum(s_lev[2][1]), .cout(c_lev[2][1]));	
		
		assign c_lev[2][1] = c_lev[2][1] << 1;
		assign c_lev[1][2] = c_lev[1][2] << 1;
		CSA csa_31 (.w(s_lev[2][1]), .x(c_lev[2][1]), .y(c_lev[1][2]), .cin(1'b0), .sum(s_lev[3][1]), .cout(c_lev[3][1]));
		
		assign c_lev[3][1] = c_lev[1][2] << 1;
		CSA csa_41 (.w(s_lev[3][1]), .x(c_lev[3][1]), .y(16'b0), .cin(1'b0), .sum(out), .cout(c_lev[3][2]));		
		

endmodule

module CSA (
	input [15:0] w,
	input [15:0] x,
   input [15:0] y,
	input cin,
   output [16:0] sum,
	output cout
);
	wire [16:0] carry1;
	assign carry1[0] = 1'b0;
	
	wire [15:0] carry2;
	
	wire [15:0] carry3;
	assign carry3[0] = cin;
	
	wire [15:0] partial_sum1;
	wire [15:0] partial_sum2;
	
	genvar i;
	generate 
		for (i = 0; i < 16; i++) begin : csarow1	
			fa fa_inst ( .x(x[i]), .y(y[i]), .cin(1'b0), .s(partial_sum1[i]), .cout(carry1[i+1]) );
		end
	endgenerate 
	
	genvar j;
	generate 
		for (j = 0; j < 16; j++) begin : csarow2	
			fa fa_inst ( .x(partial_sum1[j]), .y(w[j]), .cin(carry1[j]), .s(partial_sum2[j]), .cout(carry2[j]) );
		end
	endgenerate 

	genvar k;
	generate 
		for (k = 0; k < 15; k++) begin : csarow3	
			fa fa_inst ( .x(partial_sum2[k+1]), .y(carry2[k]), .cin(carry3[k]), .s(sum[k+1]), .cout(carry3[k+1]) );
		end
	endgenerate 

	fa fa_inst ( .x(carry1[16]), .y(carry2[15]), .cin(carry3[15]), .s(sum[16]), .cout(cout) );
	assign sum[0] = partial_sum1[0];
	
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

