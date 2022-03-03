	component nios_system is
		port (
			clk_clk             : in  std_logic                    := 'X';             -- clk
			switches_pio_export : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			leds_pio_export     : out std_logic_vector(7 downto 0)                     -- export
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk             => CONNECTED_TO_clk_clk,             --          clk.clk
			switches_pio_export => CONNECTED_TO_switches_pio_export, -- switches_pio.export
			leds_pio_export     => CONNECTED_TO_leds_pio_export      --     leds_pio.export
		);

