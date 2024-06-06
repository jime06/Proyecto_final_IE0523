module spi_slave (
    input wire clk,         // Clock input
    input wire rst_n,       // Reset input (active low)
    input wire ss_n,        // Slave select input (active low)
    input wire sck,         // Serial clock input
    input wire miso,        // Master input, slave output
    output reg [7:0] data_in // Data input from master
);

// Internal state register
reg [2:0] state;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset state machine and output register
        state <= 3'b000;
        data_in <= 8'b0;
    end
    else begin
        // State machine transitions
        case (state)
            3'b000: begin // Idle state
                if (ss_n == 1'b0 && sck == 1'b0) begin
                    state <= 3'b001; // Transition to receive state
                end
            end
            3'b001: begin // Receive state
                if (sck == 1'b1) begin
                    data_in <= {data_in[6:0], miso}; // Shift in received bit
                end
                if (ss_n == 1'b1) begin
                    state <= 3'b000; // Transition back to idle state
                end
            end
        endcase
    end
end

endmodule
