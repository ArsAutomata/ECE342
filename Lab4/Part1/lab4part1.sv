module float_mult(
	input [31:0] x,
	input [31:0] y,
	output [31:0] result,
	output zero , underflow , overflow , nan
);
	logic sign;
	assign sign = x[31] ^ y[31];
	
	logic [7:0] exponent;
	logic [7:0] exponent_shift;
	assign exponent = x[30:23] + y[30:23] - 127;
	
	logic [23:0] op1;
	logic [23:0] op2;
	assign op1 = {1'b1, x[22:0]};
	assign op2 = {1'b1, y[22:0]};
	
	logic [24:0] mantissa_product;
	logic [24:0] mantissa_product_shift;
	assign mantissa_product = op1*op2;
	
	always_comb begin
		if(mantissa_product[24] == 1'b1)begin
			mantissa_product_shift = mantissa_product >> 1;
			exponent_shift = exponent + 1'b1;
		end
		else begin
			mantissa_product_shift = mantissa_product;
			exponent_shift = exponent;
		end
	end
	
	//assign result = /*{sign, exponent_shift,*/{ mantissa_product_shift[22:0]};
	assign result = mantissa_product;
endmodule