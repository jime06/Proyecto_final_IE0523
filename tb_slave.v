module spi_slave_tb;

// Parameters
parameter CLK_PERIOD = 100;  // Clock period in ns

// Inputs
reg clk;
reg rst_n;
reg ss_n;
reg sck;
reg miso;

// Outputs
wire [7:0] data_in;

// Instantiate SPI Slave module
spi_slave dut (
    .clk(clk),
    .rst_n(rst_n),
    .ss_n(ss_n),
    .sck(sck),
    .miso(miso),
    .data_in(data_in)
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

    // Simulation scenario
    // Wait for slave select and clock to go low
    #10;
    ss_n = 1'b0;
    sck = 1'b0;

    // Receive data from master
    #10;
    miso = 1'b1; // Simulate received data from master
    #10;
    miso = 1'b0;
    #10;
    miso = 1'b1;
    #10;
    miso = 1'b0;
    #10;
    miso = 1'b1;
    #10;
    miso = 1'b0;
    #10;
    miso = 1'b1;
    #10;
    miso = 1'b0;

    // Deselect slave
    #10;
    ss_n = 1'b1;

    // End simulation
    $finish;
end

endmodule
