	component signaltap is
		port (
			acq_data_in    : in std_logic_vector(63 downto 0) := (others => 'X'); -- acq_data_in
			acq_trigger_in : in std_logic_vector(31 downto 0) := (others => 'X'); -- acq_trigger_in
			acq_clk        : in std_logic                     := 'X'              -- clk
		);
	end component signaltap;

	u0 : component signaltap
		port map (
			acq_data_in    => CONNECTED_TO_acq_data_in,    --     tap.acq_data_in
			acq_trigger_in => CONNECTED_TO_acq_trigger_in, --        .acq_trigger_in
			acq_clk        => CONNECTED_TO_acq_clk         -- acq_clk.clk
		);

