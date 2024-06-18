`include "dut1.v"
`include "tester_dut1.v"

module testbench_dut1;
//wires del testbench
wire clk, reset;
wire mdio_start; 
wire mdio_in;
wire [31:0] t_data; //preguntar: ¿estp está bien como reg o mejor que sea wire?
wire [15:0] rd_data;
wire data_rdy, mdc, mdio_oe, mdio_out;

//se conecta el DUT
dut1 DUT (
    .clk(clk),
    .reset(reset),
    .mdio_start(mdio_start),
    .t_data(t_data[31:0]),
    .mdio_in(mdio_in),
    .rd_data(rd_data[15:0]),
    .data_rdy(data_rdy),
    .mdc(mdc),
    .mdio_oe(mdio_oe),
    .mdio_out(mdio_out)
);

tester_dut1 test (
    .clk(clk),
    .reset(reset),
    .mdio_start(mdio_start),
    .t_data(t_data[31:0]),
    .mdio_in(mdio_in),
    .rd_data(rd_data[15:0]),
    .data_rdy(data_rdy),
    .mdc(mdc),
    .mdio_oe(mdio_oe),
    .mdio_out(mdio_out)
);

//para monitorear las pruebas:
initial begin
    $dumpfile("tb.vcd");
    $dumpvars;
end
endmodule