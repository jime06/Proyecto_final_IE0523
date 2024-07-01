`include "generador_mdio.v"
`include "tester_mdio.v"

module mdio_tb;

wire clk, reset, mdio_start;
wire [31:0] t_data;
wire        mdc, mdio_out, mdio_oe, mdio_in, data_rdy;
wire [15:0] rd_data;

generador_mdio DUT (
    .clk(clk),
    .reset(reset),
    .mdio_start(mdio_start),
    .t_data(t_data[31:0]),
    .mdc(mdc),
    .mdio_out(mdio_out),
    .mdio_oe(mdio_oe),
    .mdio_in(mdio_in),
    .rd_data(rd_data[15:0]),
    .data_rdy(data_rdy)
);

tester_mdio test (
    .clk(clk),
    .reset(reset),
    .mdio_start(mdio_start),
    .t_data(t_data[31:0]),
    .mdc(mdc),
    .mdio_out(mdio_out),
    .mdio_oe(mdio_oe),
    .mdio_in(mdio_in),
    .rd_data(rd_data[15:0]),
    .data_rdy(data_rdy)
);

initial begin
    $dumpfile("mdio.vcd");
    $dumpvars;
end
endmodule