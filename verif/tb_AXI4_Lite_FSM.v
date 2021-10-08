

module tb_AXI4_Lite_FSM;

    // Interface Signals
	reg		clk;
	reg  	rst; // reset on high

	// AXI4-Lite Interface Signals

	// Read address channel
	reg		ARVALID;
	wire	ARREADY;

	// Read data channel
	wire	RVALID;
	reg		RREADY;

	// Write address channel
	reg		AWVALID;
	wire	AWREADY;
	
	// Write data channel
	reg		WVALID;
	wire	WREADY;

	// Write response channel
	wire	BVALID;
	reg		BREADY;

	wire[3:0] state_out;

	// DUT
	AXI4_Lite_FSM DUT (
		.clk(clk), .rst(rst),
		.ARVALID(ARVALID), .ARREADY(ARREADY),
		.RVALID(RVALID), .RREADY(RREADY),
		.AWVALID(AWVALID), .AWREADY(AWREADY),
		.WVALID(WVALID), .WREADY(WREADY),
		.BVALID(BVALID), .BREADY(BREADY)
	);

	// Assignments to internal signals
	assign state_out = DUT.state;


	always #5 clk = ~clk;

	initial begin
		
		clk 	<= 0;
		rst 	<= 0;
		ARVALID <= 0;
		RREADY 	<= 0;
		AWVALID <= 0;
		WVALID 	<= 0;
		BREADY 	<= 0;
		#5;

		rst <= 1;
		#10;

		rst <= 0;
		#10;

		AWVALID <= 1;
		#10;

		AWVALID <= 0;
		#20;

		WVALID <= 1;
		#10;

		WVALID <= 0;
		#20;

		BREADY <= 1;
		#10;

		BREADY <= 0;
		#10;

	end

endmodule