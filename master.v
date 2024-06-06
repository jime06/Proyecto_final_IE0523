module spi_master_dual (
    input wire clk,         // Clock input
    input wire rst_n,       // Reset input (active low)
    output reg [1:0] ss_n,  // Slave select outputs (active low)
    output reg sck,         // Serial clock output
    output reg mosi,        // Master output, slave input
    input wire [1:0] miso   // Master input, slave outputs
);

// Define states for the SPI state machine
parameter IDLE_STATE = 2'b00;
parameter TRANSFER_STATE = 2'b01;

// Internal state register
reg [1:0] state;

// Internal data register
reg [7:0] data_out;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset state machine and output signals
        state <= IDLE_STATE;
        ss_n <= 2'b11;  // Both slaves deselected
        sck <= 1'b0;    // Clock idle low
        mosi <= 1'b0;   // MOSI idle low
        data_out <= 8'h00; // Initialize data_out
    end
    else begin
        // State machine transitions
        case (state)
            IDLE_STATE: begin
                // Transition to transfer state on rising edge of slave select
                if (ss_n != 2'b11) begin
                    state <= TRANSFER_STATE;
                end
            end
            TRANSFER_STATE: begin
                // Output data on MOSI and shift data_out
                sck <= ~sck;    // Toggle clock
                mosi <= data_out[7]; // Output MSB
                data_out <= {data_out[6:0], 1'b0}; // Shift left
                // Return to idle state after 8 clocks
                if (sck == 1'b1) begin
                    state <= IDLE_STATE;
                end
            end
        endcase
    end
end

endmodule
