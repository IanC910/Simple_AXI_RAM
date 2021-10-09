

module tb_Simple_AXI_RAM;

    parameter NUM_SLOTS             = 5;
    parameter ADDR_WIDTH_BITS       = $clog2(NUM_SLOTS);

    parameter DATA_WIDTH_BYTES      = 4;
    parameter DATA_WIDTH_BITS       = DATA_WIDTH_BYTES * 8;


    // Interface Signals
	reg	                            clk;
	reg  	                        rst; // reset on high

	// AXI4-Lite Interface Signals

	// Read address channel
	reg								ARVALID;
	wire							ARREADY;
	reg	    [ADDR_WIDTH_BITS-1:0]	ARADDR;
	reg	    [3:0]					ARPROT; // Not used in this device

	// Read data channel
	wire							RVALID;
	reg								RREADY;
	wire    [DATA_WIDTH_BITS-1:0]	RDATA;
	wire    [1:0]					RRESP;

	// Write address channel
	reg 							AWVALID;
	wire 							AWREADY;
	reg     [ADDR_WIDTH_BITS-1:0] 	AWADDR;
	reg	    [3:0]					AWPROT; // Not used in this device
	
	// Write data channel
	reg 							WVALID;
	wire 							WREADY;
	reg 	[DATA_WIDTH_BITS-1:0]	WDATA;
	reg 	[DATA_WIDTH_BYTES-1:0]	WSTRB;

	// Write response channel
	wire 							BVALID;
	reg 							BREADY;
	wire	[1:0]					BRESP;

    // Other signals
    wire    [DATA_WIDTH_BITS-1:0]  stored_data [NUM_SLOTS-1:0];

    // DUT
    Simple_AXI_RAM #(.NUM_SLOTS(NUM_SLOTS), .DATA_WIDTH_BYTES(DATA_WIDTH_BYTES)) DUT
    (
    	.clk(clk),
        .rst(rst),
    	.ARVALID(ARVALID),
        .ARREADY(ARREADY),
        .ARADDR(ARADDR),
        .ARPROT(ARPROT),
    	.RVALID(RVALID),
        .RREADY(RREADY),
        .RDATA(RDATA),
        .RRESP(RRESP),
    	.AWVALID(AWVALID),
        .AWREADY(AWREADY),
        .AWADDR(AWADDR),
        .AWPROT(AWPROT),
    	.WVALID(WVALID),
        .WREADY(WREADY),
        .WDATA(WDATA),
        .WSTRB(WSTRB),
    	.BVALID(BVALID),
        .BREADY(BREADY),
        .BRESP(BRESP)
    );

    // Assignments to internal signals
    genvar i;
    generate
        for(i = 0; i < NUM_SLOTS; i = i + 1) begin: RAM_data
            assign stored_data[i] = DUT.RAM_unit.memory[i];
        end
    endgenerate


    always #5 clk = ~clk;

    initial begin
        
        clk     <= 0;
	    rst     <= 0;

	    ARVALID <= 0;
	    ARADDR  <= 0;
	    ARPROT  <= 0;

	    RREADY  <= 0;

	    AWVALID <= 0;
	    AWADDR  <= 0;
	    AWPROT  <= 0;

	    WVALID  <= 0;
	    WDATA   <= 0;
	    WSTRB   <= 0;

	    BREADY  <= 0;
        #5;

        rst <= 1;
        #10;

        rst <= 0;
        #10;

        // Write
        AWVALID <= 1;
        AWADDR <= 4;
        #10;

        AWVALID <= 0;
        AWADDR <= 0;

        WDATA <= 'h11223344;
        WSTRB <= 'b1101;
        #10;

        WVALID <= 1;
        #10;

        WVALID <= 0;
        WDATA <= 0;
        WSTRB <= 0;
        #20;

        BREADY <= 1;
        #10;

        BREADY <= 0;
        #20;

        // Read
        ARVALID <= 1;
        ARADDR <= 4;
        #10;

        ARVALID <= 0;
        ARADDR <= 0;
        #10;

        RREADY <= 1;
        #10;

        RREADY <= 0;
        #20;

        // Write
        AWVALID <= 1;
        AWADDR <= 4;
        #10;

        AWVALID <= 0;
        AWADDR <= 0;

        WVALID <= 1;
        WDATA <= 'h00003300;
        WSTRB <= 'b0010;
        #10;

        WVALID <= 0;
        WDATA <= 0;
        WSTRB <= 0;

        BREADY <= 1;
        #10;

        BREADY <= 0;
        #10;

        // Read
        ARVALID <= 1;
        ARADDR <= 4;
        #10;

        ARVALID <= 0;
        ARADDR <= 0;

        RREADY <= 1;
        #10;

        RREADY <= 0;
        #20;

    end

endmodule