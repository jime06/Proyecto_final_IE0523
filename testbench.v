/*
Parte 2 Proyecto final. Circuitos Digitales 2. I Semestre 2024
Testbench del receptor de transacciones MDIO
Aurora Matamoros Cuadra B84707
Kenneth Rojas Rivera B96890
Jimena Gonzalez Jiménez B83443
Profesora: Ana Eugenia Sanchez Villalobos
*/
`include "mdio_rec.v"
`include "tester.v"
module testbench;
wire rst, MDC, MDIO_OE, MDIO_OUT, MDIO_IN, WR_STB, MDIO_DONE;
wire [15:0] RD_DATA, WR_DATA;
wire [4:0] ADDR;
receptor DUT (.rst(rst),
    .MDC(MDC), .MDIO_OE(MDIO_OE), .MDIO_OUT(MDIO_OUT),
    .RD_DATA(RD_DATA[15:0]),
    .MDIO_IN(MDIO_IN), .WR_STB(WR_STB), .MDIO_DONE(MDIO_DONE),
    .ADDR(ADDR),
    .WR_DATA(WR_DATA[15:0]));
tester tester (.rst(rst), .MDC(MDC), .MDIO_OE(MDIO_OE), .MDIO_OUT(MDIO_OUT),
    .RD_DATA(RD_DATA[15:0]),
    .MDIO_IN(MDIO_IN), .WR_STB(WR_STB), .MDIO_DONE(MDIO_DONE),
    .ADDR(ADDR),
    .WR_DATA(WR_DATA[15:0]));
initial begin
    $dumpfile("tb.vcd");
    $dumpvars;
end
endmodule