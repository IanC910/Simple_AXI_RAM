

module AXI4_Lite_FSM (
	clk, rst, rst_RAM,
	ARVALID, ARREADY,
	RVALID, RREADY,
	AWVALID, AWREADY,
	WVALID, WREADY,
	BVALID, BREADY
);

	// Interface Signals
	input	clk;
	input  	rst; // reset on high
    output  rst_RAM; // rest on high

	// AXI4-Lite Interface Signals

	// Read address channel
	input   ARVALID;
	output  ARREADY;

	// Read data channel
	output	RVALID;
	input	RREADY;

	// Write address channel
	input 	AWVALID;
	output 	AWREADY;
	
	// Write data channel
	input 	WVALID;
	output 	WREADY;

	// Write response channel
	output 	BVALID;
	input 	BREADY;


    // Internal logic
    reg[3:0] state;
	// States:
	// 0: Reset
	// 1: Ready
	// 2:	Accepted read transaction, ready to send RDATA and RRESP
	// 3: 	Accepted write transaction, awaiting write data
	// 4: 		Received write data, ready to send BRESP


    assign rst_RAM = rst & (state == 0 | state == 1);

	assign AWREADY = (state == 1);
	assign ARREADY = (state == 1);

	assign RVALID = (state == 2);
	assign WREADY = (state == 3);
    assign BVALID = (state == 4);


    always @ (posedge clk) begin

		if(rst == 1 & state <= 1) begin
			state <= 0;
		end

        // Reset
		else if (state == 0) begin
			state <= 1;
		end

		// Ready
		else if (state == 1) begin
			
			if(ARVALID == 1) begin
				// Accepting read transaction
				state <= 2;
			end
			
			else if(AWVALID == 1) begin
				// Accepting write transaction
				state <= 3;
			end
		end

		// Accepted read transaction, ready to send RDATA and RRESP
		else if (state == 2) begin

			if(RREADY == 1) begin
				// Send RDATA and RRESP, transaction done, back to ready
				state <= 1;
			end
		end

		// Accepted write transaction, awaiting write data
		else if (state == 3) begin
			
			if(WVALID == 1) begin
				// Accept write data, now ready to send BRESP
				state <= 4;
			end
		end

		// Accepted write data, ready to send BRESP
		else if (state == 4) begin
			
			if(BREADY == 1) begin
				// Send BRESP, transaction done, back to ready
				state <= 1;
			end
		end

        // Unused or unassigned
        else begin
            state <= 0;
        end

	end



endmodule