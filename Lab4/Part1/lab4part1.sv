module float_mult(
	input [31:0] x,
	input [31:0] y,
	output [31:0] result,
	output logic zero , underflow , overflow , nan
);
	logic sign;
	
	logic [7:0] exponent;
	logic [7:0] exponent_shift;
	
	logic [23:0] op1;
	logic [23:0] op2;
	
	logic [24:0] mantissa_product;
	logic [24:0] mantissa_product_shift;
	
	always_comb begin
		//reset bits
		/*underflow = 1'b0;
		overflow = 1'b0;
		zero = 1'b0;
		nan = 1'b0;
		/*if(x[30:23] == 8'b0) begin
			if(x[22:0] == 23'b0)begin//zero
				zero = 1'b1;
			end
			else begin//underflow
				nan = 1'b1;
			end
		end
		else if(y[22:0] == 23'b0) begin
			if(y[22:0] == 23'b0)begin//zero
				zero = 1'b1;
			end
			else begin//underflow
				nan = 1'b1;
			end
		end*/

		sign = x[31] ^ y[31];

		exponent = x[30:23] + y[30:23] - 127;

		//mantissa with appended hidden bit
		op1 = {1'b1, x[22:0]};
		op2 = {1'b1, y[22:0]};

		mantissa_product = {1'b1, x[22:0]} * {1'b1, y[22:0]}; //op1*op2;
	
		/* Normalize */
		if(mantissa_product[24] == 1'b1)begin //product larger than 1
			mantissa_product_shift = mantissa_product >> 1;
			exponent_shift = exponent + 1'b1;
		end
		else if(mantissa_product[23] == 1'b0) begin//product smaller than 1
			mantissa_product_shift = mantissa_product << 1;
			exponent_shift = exponent - 1'b1;
		end
		else begin //product is 1
			mantissa_product_shift = mantissa_product;
			exponent_shift = exponent;
		end
		
		/* Special Cases */
		if(mantissa_product_shift == 23'b0) begin//zero
			zero = 1'b1;
		end

		if(x[30:23] + y[30:23] < 8'b01111111) begin//underflow
			exponent_shift = 8'b00000000;
			underflow = 1'b1;
		end
		else if(x[30:23] + y[30:23] > 8'b11111110)begin //overflow
			exponent_shift = 8'b11111111;
			mantissa_product_shift = 23'b0;
			overflow = 1'b1;
		end
		//nan
		if ((x[30:23] == 8'b11111111 && y[30:0] == 31'b0) || (y[30:23] == 8'b11111111 && x[30:0] == 31'b0))begin
			exponent_shift = 8'b11111111;
			mantissa_product_shift = 23'b0;
			nan = 1'b1;
		end
		
	end
	
	//assign result = {sign, exponent_shift, mantissa_product_shift[22:0]};
	assign result = mantissa_product;
endmodule