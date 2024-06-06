module spi_master_dual_tb;

// Parameters
parameter CLK_PERIOD = 100;  // Clock period in ns

// Inputs
reg clk;
reg rst_n;

// Outputs
wire [1:0] ss_n;
wire sck;
wire mosi;
wire [1:0] miso;

// Instantiate SPI Master Dual module
spi_master_dual dut (
    .clk(clk),
    .rst_n(rst_n),
    .ss_n(ss_n),
    .sck(sck),
    .mosi(mosi),
    .miso(miso)
);

// Clock generation
always #((CLK_PERIOD / 2)) clk = ~clk;

// Reset generation
initial begin
    rst_n = 0;
    #10;
    rst_n = 1;
end

// Simulation process
initial begin
    // Wait for initial reset and stabilization
    #100;

    // Transmit data to first slave
    $display("Transmitting data to first slave...");
    ss_n[0] = 0;  // Select first slave
    #10;
    ss_n[0] = 1;  // Deselect first slave
    $display("Data transmission to first slave complete.");

    // Transmit data to second slave
    $display("Transmitting data to second slave...");
    ss_n[1] = 0;  // Select second slave
    #10;
    ss_n[1] = 1;  // Deselect second slave
    $display("Data transmission to second slave complete.");

    // End simulation
    $finish;
end

endmodule
