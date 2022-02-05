

module Simple_AXI_RAM #(parameter NUM_SLOTS = 6, parameter DATA_WIDTH_BYTES = 4)
(
	clk, rst,
	ARVALID, ARREADY, ARADDR, ARPROT,
	RVALID, RREADY, RDATA, RRESP,
	AWVALID, AWREADY, AWADDR, AWPROT,
	WVALID, WREADY, WDATA, WSTRB,
	BVALID, BREADY, BRESP
);

	parameter ADDR_WIDTH_BITS 	= $clog2(NUM_SLOTS);
	parameter DATA_WIDTH_BITS	= DATA_WIDTH_BYTES * 8;

	
	// Interface Signals
	input	clk;
	input  	rst; // reset on high

	// AXI4-Lite Interface Signals

	// Read address channel
	input								ARVALID;
	output								ARREADY;
	input	[ADDR_WIDTH_BITS-1:0]		ARADDR;
	input	[3:0]						ARPROT; // Not used in this device

	// Read data channel
	output								RVALID;
	input								RREADY;
	output	[DATA_WIDTH_BITS-1:0]		RDATA;
	output	[1:0]						RRESP;

	// Write address channel
	input 								AWVALID;
	output 								AWREADY;
	input	[ADDR_WIDTH_BITS-1:0] 		AWADDR;
	input	[3:0]						AWPROT; // Not used in this device
	
	// Write data channel
	input 								WVALID;
	output 								WREADY;
	input 	[DATA_WIDTH_BITS-1:0]		WDATA;
	input 	[DATA_WIDTH_BYTES-1:0]		WSTRB;

	// Write response channel
	output 								BVALID;
	input 								BREADY;
	output	[1:0]						BRESP;


	// Internal logic
	wire 							rst_RAM;

	wire 							r_en;
	reg		[ADDR_WIDTH_BITS-1:0]	r_addr;
	wire 	[DATA_WIDTH_BITS-1:0]	r_data;

	wire 							w_en;
	reg		[ADDR_WIDTH_BITS-1:0]	w_addr;
	wire 	[DATA_WIDTH_BITS-1:0] 	w_data;
	wire	[DATA_WIDTH_BYTES-1:0]	w_strb;


	assign r_en = RVALID;
	assign w_en = WVALID & WREADY;

	assign RDATA = r_data;
	assign w_data = WDATA;
	assign w_strb = WSTRB;

	assign RRESP = (RVALID & (r_addr >= NUM_SLOTS)) ? 3 : 0; // Code 3 is DECERR
	assign BRESP = (BVALID & (w_addr >= NUM_SLOTS)) ? 3 : 0;

	always @ (posedge clk) begin
		if(ARVALID & ARREADY) begin
			r_addr <= ARADDR;
		end
		
		else if(AWVALID & AWREADY) begin
			w_addr <= AWADDR;
		end
	end

	
	AXI4_Lite_Slave_FSM axi_fsm
	(
		.clk(clk),
		.rst(rst),
		.rst_RAM(rst_RAM),
		.ARVALID(ARVALID),
		.ARREADY(ARREADY),
		.RVALID(RVALID),
		.RREADY(RREADY),
		.AWVALID(AWVALID),
		.AWREADY(AWREADY),
		.WVALID(WVALID),
		.WREADY(WREADY),
		.BVALID(BVALID),
		.BREADY(BREADY)
	);

	Simple_RAM #(.NUM_SLOTS(NUM_SLOTS), .DATA_WIDTH_BYTES(DATA_WIDTH_BYTES)) RAM_unit
	(
		.clk(clk),
    	.rst(rst_RAM),
    	.r_en(r_en),
    	.r_addr(r_addr),
    	.r_data(r_data),
    	.w_en(w_en),
    	.w_addr(w_addr),
    	.w_data(w_data),
		.w_strb(w_strb)
	);
	

endmodule