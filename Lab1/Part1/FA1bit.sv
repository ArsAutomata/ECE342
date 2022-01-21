/*module FA1bit(a, b, cin, s, cout);
    input  a, b, cin;  
    output  s, cout;
	
	assign {cout, s} = a + b + cin; 
endmodule*/

module FA1bit(a, b, cin, s, cout);
	input logic a, b, cin;  
	output logic s, cout;
	
	wire m = a ^ b;
	wire n = m & cin;
	wire o = a & b;
	assign cout = n | o;
	assign s = m ^ cin;
endmodule