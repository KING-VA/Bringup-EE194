	component platform_uart_to_serializedtl_0 is
		port (
			clock                   : in  std_logic                     := 'X';             -- clk
			reset                   : in  std_logic                     := 'X';             -- reset
			axi_ios_0_aw_ready      : in  std_logic                     := 'X';             -- awready
			axi_ios_0_w_ready       : in  std_logic                     := 'X';             -- wready
			axi_ios_0_b_valid       : in  std_logic                     := 'X';             -- bvalid
			axi_ios_0_b_bits_id     : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- bid
			axi_ios_0_b_bits_resp   : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- bresp
			axi_ios_0_ar_ready      : in  std_logic                     := 'X';             -- arready
			axi_ios_0_r_valid       : in  std_logic                     := 'X';             -- rvalid
			axi_ios_0_r_bits_id     : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- rid
			axi_ios_0_r_bits_data   : in  std_logic_vector(63 downto 0) := (others => 'X'); -- rdata
			axi_ios_0_r_bits_resp   : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- rresp
			axi_ios_0_r_bits_last   : in  std_logic                     := 'X';             -- rlast
			axi_ios_0_aw_valid      : out std_logic;                                        -- awvalid
			axi_ios_0_aw_bits_id    : out std_logic_vector(3 downto 0);                     -- awid
			axi_ios_0_aw_bits_addr  : out std_logic_vector(36 downto 0);                    -- awaddr
			axi_ios_0_aw_bits_len   : out std_logic_vector(7 downto 0);                     -- awlen
			axi_ios_0_aw_bits_size  : out std_logic_vector(2 downto 0);                     -- awsize
			axi_ios_0_aw_bits_burst : out std_logic_vector(1 downto 0);                     -- awburst
			axi_ios_0_aw_bits_lock  : out std_logic;                                        -- awlock
			axi_ios_0_aw_bits_cache : out std_logic_vector(3 downto 0);                     -- awcache
			axi_ios_0_aw_bits_prot  : out std_logic_vector(2 downto 0);                     -- awprot
			axi_ios_0_aw_bits_qos   : out std_logic_vector(3 downto 0);                     -- awqos
			axi_ios_0_w_valid       : out std_logic;                                        -- wvalid
			axi_ios_0_w_bits_data   : out std_logic_vector(63 downto 0);                    -- wdata
			axi_ios_0_w_bits_strb   : out std_logic_vector(7 downto 0);                     -- wstrb
			axi_ios_0_w_bits_last   : out std_logic;                                        -- wlast
			axi_ios_0_b_ready       : out std_logic;                                        -- bready
			axi_ios_0_ar_valid      : out std_logic;                                        -- arvalid
			axi_ios_0_ar_bits_id    : out std_logic_vector(3 downto 0);                     -- arid
			axi_ios_0_ar_bits_addr  : out std_logic_vector(36 downto 0);                    -- araddr
			axi_ios_0_ar_bits_len   : out std_logic_vector(7 downto 0);                     -- arlen
			axi_ios_0_ar_bits_size  : out std_logic_vector(2 downto 0);                     -- arsize
			axi_ios_0_ar_bits_burst : out std_logic_vector(1 downto 0);                     -- arburst
			axi_ios_0_ar_bits_lock  : out std_logic;                                        -- arlock
			axi_ios_0_ar_bits_cache : out std_logic_vector(3 downto 0);                     -- arcache
			axi_ios_0_ar_bits_prot  : out std_logic_vector(2 downto 0);                     -- arprot
			axi_ios_0_ar_bits_qos   : out std_logic_vector(3 downto 0);                     -- arqos
			axi_ios_0_r_ready       : out std_logic;                                        -- rready
			io_uart_txd             : out std_logic;                                        -- writeresponsevalid_n
			io_uart_rxd             : in  std_logic                     := 'X';             -- beginbursttransfer
			io_serial_in_ready      : out std_logic;                                        -- serial_in_ready
			io_serial_out_valid     : out std_logic;                                        -- serial_out_valid
			io_serial_out_bits      : out std_logic;                                        -- serial_out
			io_dropped              : out std_logic;                                        -- led
			io_serial_in_valid      : in  std_logic                     := 'X';             -- serial_in_valid
			io_serial_in_bits       : in  std_logic                     := 'X';             -- serial_in
			io_serial_out_ready     : in  std_logic                     := 'X'              -- serial_out_ready
		);
	end component platform_uart_to_serializedtl_0;

	u0 : component platform_uart_to_serializedtl_0
		port map (
			clock                   => CONNECTED_TO_clock,                   --        clock_reset.clk
			reset                   => CONNECTED_TO_reset,                   --              reset.reset
			axi_ios_0_aw_ready      => CONNECTED_TO_axi_ios_0_aw_ready,      -- altera_axi4_master.awready
			axi_ios_0_w_ready       => CONNECTED_TO_axi_ios_0_w_ready,       --                   .wready
			axi_ios_0_b_valid       => CONNECTED_TO_axi_ios_0_b_valid,       --                   .bvalid
			axi_ios_0_b_bits_id     => CONNECTED_TO_axi_ios_0_b_bits_id,     --                   .bid
			axi_ios_0_b_bits_resp   => CONNECTED_TO_axi_ios_0_b_bits_resp,   --                   .bresp
			axi_ios_0_ar_ready      => CONNECTED_TO_axi_ios_0_ar_ready,      --                   .arready
			axi_ios_0_r_valid       => CONNECTED_TO_axi_ios_0_r_valid,       --                   .rvalid
			axi_ios_0_r_bits_id     => CONNECTED_TO_axi_ios_0_r_bits_id,     --                   .rid
			axi_ios_0_r_bits_data   => CONNECTED_TO_axi_ios_0_r_bits_data,   --                   .rdata
			axi_ios_0_r_bits_resp   => CONNECTED_TO_axi_ios_0_r_bits_resp,   --                   .rresp
			axi_ios_0_r_bits_last   => CONNECTED_TO_axi_ios_0_r_bits_last,   --                   .rlast
			axi_ios_0_aw_valid      => CONNECTED_TO_axi_ios_0_aw_valid,      --                   .awvalid
			axi_ios_0_aw_bits_id    => CONNECTED_TO_axi_ios_0_aw_bits_id,    --                   .awid
			axi_ios_0_aw_bits_addr  => CONNECTED_TO_axi_ios_0_aw_bits_addr,  --                   .awaddr
			axi_ios_0_aw_bits_len   => CONNECTED_TO_axi_ios_0_aw_bits_len,   --                   .awlen
			axi_ios_0_aw_bits_size  => CONNECTED_TO_axi_ios_0_aw_bits_size,  --                   .awsize
			axi_ios_0_aw_bits_burst => CONNECTED_TO_axi_ios_0_aw_bits_burst, --                   .awburst
			axi_ios_0_aw_bits_lock  => CONNECTED_TO_axi_ios_0_aw_bits_lock,  --                   .awlock
			axi_ios_0_aw_bits_cache => CONNECTED_TO_axi_ios_0_aw_bits_cache, --                   .awcache
			axi_ios_0_aw_bits_prot  => CONNECTED_TO_axi_ios_0_aw_bits_prot,  --                   .awprot
			axi_ios_0_aw_bits_qos   => CONNECTED_TO_axi_ios_0_aw_bits_qos,   --                   .awqos
			axi_ios_0_w_valid       => CONNECTED_TO_axi_ios_0_w_valid,       --                   .wvalid
			axi_ios_0_w_bits_data   => CONNECTED_TO_axi_ios_0_w_bits_data,   --                   .wdata
			axi_ios_0_w_bits_strb   => CONNECTED_TO_axi_ios_0_w_bits_strb,   --                   .wstrb
			axi_ios_0_w_bits_last   => CONNECTED_TO_axi_ios_0_w_bits_last,   --                   .wlast
			axi_ios_0_b_ready       => CONNECTED_TO_axi_ios_0_b_ready,       --                   .bready
			axi_ios_0_ar_valid      => CONNECTED_TO_axi_ios_0_ar_valid,      --                   .arvalid
			axi_ios_0_ar_bits_id    => CONNECTED_TO_axi_ios_0_ar_bits_id,    --                   .arid
			axi_ios_0_ar_bits_addr  => CONNECTED_TO_axi_ios_0_ar_bits_addr,  --                   .araddr
			axi_ios_0_ar_bits_len   => CONNECTED_TO_axi_ios_0_ar_bits_len,   --                   .arlen
			axi_ios_0_ar_bits_size  => CONNECTED_TO_axi_ios_0_ar_bits_size,  --                   .arsize
			axi_ios_0_ar_bits_burst => CONNECTED_TO_axi_ios_0_ar_bits_burst, --                   .arburst
			axi_ios_0_ar_bits_lock  => CONNECTED_TO_axi_ios_0_ar_bits_lock,  --                   .arlock
			axi_ios_0_ar_bits_cache => CONNECTED_TO_axi_ios_0_ar_bits_cache, --                   .arcache
			axi_ios_0_ar_bits_prot  => CONNECTED_TO_axi_ios_0_ar_bits_prot,  --                   .arprot
			axi_ios_0_ar_bits_qos   => CONNECTED_TO_axi_ios_0_ar_bits_qos,   --                   .arqos
			axi_ios_0_r_ready       => CONNECTED_TO_axi_ios_0_r_ready,       --                   .rready
			io_uart_txd             => CONNECTED_TO_io_uart_txd,             --               uart.writeresponsevalid_n
			io_uart_rxd             => CONNECTED_TO_io_uart_rxd,             --                   .beginbursttransfer
			io_serial_in_ready      => CONNECTED_TO_io_serial_in_ready,      --             serial.serial_in_ready
			io_serial_out_valid     => CONNECTED_TO_io_serial_out_valid,     --                   .serial_out_valid
			io_serial_out_bits      => CONNECTED_TO_io_serial_out_bits,      --                   .serial_out
			io_dropped              => CONNECTED_TO_io_dropped,              --                   .led
			io_serial_in_valid      => CONNECTED_TO_io_serial_in_valid,      --                   .serial_in_valid
			io_serial_in_bits       => CONNECTED_TO_io_serial_in_bits,       --                   .serial_in
			io_serial_out_ready     => CONNECTED_TO_io_serial_out_ready      --                   .serial_out_ready
		);

