/*
Parte 2 Proyecto final. Circuitos Digitales 2. I Semestre 2024
Tester del receptor de transacciones MDIO
Aurora Matamoros Cuadra B84707
Kenneth Rojas Rivera B96890
Jimena Gonzalez Jiménez B83443
Profesora: Ana Eugenia Sanchez Villalobos
*/
`timescale 1ns/1ns
module tester(output reg rst, MDC, MDIO_OE, MDIO_OUT, // inputs y outputs del receptor de transacciones
    output reg [15:0] RD_DATA,
    input MDIO_IN, WR_STB, MDIO_DONE,
    input [4:0] ADDR,
    input [15:0] WR_DATA);
always begin
    #2 MDC = !MDC; // simulamos MDC
end
initial begin
    MDC = 0; // Flanco activo de MDC es el flanco creciente
    rst = 0; // Modo reset
    #2;
    rst = 1; 
    MDIO_OE = 1; // Simula generador, modo lectura
    MDIO_OUT = 1; // transmite los primeros 16 bits de t_data, se transmite cada flanco activo
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OE = 0;
    RD_DATA = 16'b1001010001101111;
    // t_data = 32'b01101111111001011001010001101111 (prueba) (lectura)
    // mdio in = 0110111111100101
    // data leida = 1001010001101111
    #72; // mdc en alto
    #4;
    MDIO_OE = 1;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OUT = 1;
    #4;
    MDIO_OUT = 0;
    #4;
    MDIO_OE = 0;
    // t_data = 32'b01011111111001011001010001101111 prueba escritura
    #80;
    $finish;
end

endmodule