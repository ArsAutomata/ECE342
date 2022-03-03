
module nios_system (
	clk_clk,
	switches_pio_export,
	leds_pio_export);	

	input		clk_clk;
	input	[7:0]	switches_pio_export;
	output	[7:0]	leds_pio_export;
endmodule
