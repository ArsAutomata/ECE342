module wallace_mult #(width=8) (
    input [7:0] x,
    input [7:0] y,
    output [15:0] out  	
);

	// Wires corresponding to each level of the WTM. 
	wire [15:0] s_lev[0:3][1:2];
	wire [15:0] c_lev[0:3][1:2];
	
	// Rest of your code goes here.
		logic [15:0] i[0:7];
		
		
		for(integer n = 0; n < 8; n++)begin
			if(y[n] == 1)begin
				i[n] = x << n; //<< is left shift
			end
			else begin
				i[n] = '0;
			end
		end
		
		CSA csa_01 (.w(i[0]), .x(i[1]), .y(i[2]), .z(8'b0), .cin(1'b0), .sum(s_lev[0][1]), .cout(c_lev[0][1]),);
		CSA csa_02 (.w(i[3]), .x(i[4]), .y(i[5]), .z(8'b0), .cin(1'b0), .sum(s_lev[0][2]), .cout(c_lev[0][1]),);		
		

endmodule

module CSA (
	input [7:0] w,
	input [7:0] x,
   input [7:0] y,
	input [7:0] z,
	input cin,
   output [8:0] sum,
	output cout
);
	wire [8:0] carry1;
	assign carry1[0] = 1'b0;
	
	wire [7:0] carry2;
	
	wire [7:0] carry3;
	assign carry3[0] = cin;
	
	wire [7:0] partial_sum1;
	wire [7:0] partial_sum2;
	
	genvar i;
	generate 
		for (i = 0; i < 8; i++) begin : csarow1	
			fa fa_inst ( .x(x[i]), .y(y[i]), .cin(z[i]), .s(partial_sum1[i]), .cout(carry1[i+1]) );
		end
	endgenerate 
	
	genvar j;
	generate 
		for (j = 0; j < 8; j++) begin : csarow2	
			fa fa_inst ( .x(partial_sum1[j]), .y(w[j]), .cin(carry1[j]), .s(partial_sum2[j]), .cout(carry2[j]) );
		end
	endgenerate 

	genvar k;
	generate 
		for (k = 0; k < 7; k++) begin : csarow3	
			fa fa_inst ( .x(partial_sum2[k+1]), .y(carry2[k]), .cin(carry3[k]), .s(sum[k+1]), .cout(carry3[k+1]) );
		end
	endgenerate 
	
	fa fa_inst ( .x(carry1[8]), .y(carry2[7]), .cin(carry3[7]), .s(sum[8]), .cout(cout) );
	assign sum[0] = partial_sum1[0];
	
endmodule


