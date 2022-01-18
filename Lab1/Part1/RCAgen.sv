module RCAgen
(
	input [7:0] x,
	input [7:0] y, 
	output [8:0] sum
);

logic [8:0] cin; 
assign cin[0] = 1'b0;
assign sum[8] = cin[8];

genvar i; 
generate 
	for (i = 0; i < 8; i++) begin : adders
		FA1bit fa_inst ( .a(x[i]), .b(y[i]), .cin(cin[i]), .s(sum[i]), .cout(cin[i+1]) );
	end
endgenerate 
endmodule 