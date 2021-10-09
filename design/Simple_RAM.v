

module Simple_RAM #(parameter NUM_SLOTS = 6, parameter DATA_WIDTH_BYTES = 4)
(
    clk, rst,
    r_en, r_addr, r_data,
    w_en, w_addr, w_data, w_strb
);

    parameter ADDR_WIDTH_BITS = $clog2(NUM_SLOTS);
    parameter DATA_WIDTH_BITS = DATA_WIDTH_BYTES * 8;

    // Interface Signals
    input   clk;
    input   rst; // resets on high

    // Read signals
    input                           r_en;
    input   [ADDR_WIDTH_BITS-1:0]   r_addr;
    output  [DATA_WIDTH_BITS-1:0]   r_data;

    // Write signals
    input                           w_en;
    input   [ADDR_WIDTH_BITS-1:0]   w_addr;
    input   [DATA_WIDTH_BITS-1:0]   w_data;
    input   [DATA_WIDTH_BYTES-1:0]  w_strb;


    // Internal logic
    reg [DATA_WIDTH_BITS-1:0] memory [NUM_SLOTS-1:0];
    

    // Read logic
    assign r_data = (r_en & (r_addr < NUM_SLOTS)) ? memory[r_addr] : 0;
    
    // Write logic
    genvar slot;
    genvar byte_sel;
    generate
        for(slot = 0; slot < NUM_SLOTS; slot = slot + 1) begin: connect_data_to_memory_by_slot
            for(byte_sel = 0; byte_sel < DATA_WIDTH_BYTES; byte_sel = byte_sel + 1) begin: connect_data_to_memory_by_byte
                
                always @ (posedge clk or posedge rst) begin
                    if(rst) begin
                        memory[slot][byte_sel*8 +: 8] <= 0;
                    end
                    else if (w_en & w_addr == slot & w_strb[byte_sel]) begin
                        memory[slot][byte_sel*8 +: 8] <= w_data[byte_sel*8 +: 8] & {8{w_strb[byte_sel]}};
                    end
                end

            end
        end
    endgenerate

endmodule