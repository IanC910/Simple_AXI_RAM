

module tb_Simple_RAM;

    parameter DATA_WIDTH_BYTES 	= 4;
	parameter DATA_WIDTH_BITS 	= DATA_WIDTH_BYTES * 8;

	parameter NUM_SLOTS 	    = 5;
	parameter ADDR_WIDTH_BITS 	= $clog2(NUM_SLOTS);


    // Interface signals
    reg                             clk;
    reg                             rst;

    reg                             r_en;
    reg     [ADDR_WIDTH_BITS-1:0]   r_addr;
    wire    [DATA_WIDTH_BITS-1:0]   r_data;

    reg                             w_en;
    reg     [ADDR_WIDTH_BITS-1:0]   w_addr;
    reg     [DATA_WIDTH_BITS-1:0]   w_data;
    reg     [DATA_WIDTH_BYTES-1:0]  w_strb;

    // Other signals
    wire    [DATA_WIDTH_BITS-1:0]  stored_data [NUM_SLOTS-1:0];

    // DUT
    Simple_RAM #(.NUM_SLOTS(NUM_SLOTS), .DATA_WIDTH_BYTES(DATA_WIDTH_BYTES)) DUT
	(
		.clk(clk),
    	.rst(rst),
    	.r_en(r_en),
    	.r_addr(r_addr),
    	.r_data(r_data),
    	.w_en(w_en),
    	.w_addr(w_addr),
    	.w_data(w_data),
        .w_strb(w_strb)
	);

    // Assignments to internal signals
    genvar i;
    generate
        for(i = 0; i < NUM_SLOTS; i = i + 1) begin: RAM_data
            assign stored_data[i] = DUT.memory[i];
        end
    endgenerate
    

    always #5 clk = ~clk;
    
    initial begin
        
        clk     <= 0;
        rst     <= 0;
        r_en    <= 0;
        r_addr  <= 0;
        w_en    <= 0;
        w_addr  <= 0;
        w_data  <= 0;
        w_strb  <= 0;
        #5;

        rst <= 1;
        #10;

        rst <= 0;
        #10;

        w_en <= 1;
        w_addr <= 0;
        w_data <= 'h11223344;
        w_strb <= 'b1101;
        #10;

        w_en <= 0;
        w_addr <= 1;
        w_data <= 'hffffffff;
        w_strb <= 'b1111;
        #10;

        r_en <= 1;
        r_addr <= 0;
        #10;

        r_en <= 1;
        r_addr <= 1;
        #10;

        r_en <= 0;
        #10;

    end

endmodule