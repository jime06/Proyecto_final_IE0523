module tester_dut1(
    output reg clk,
    output reg reset,
    output reg mdio_start,
    output reg [31:0] t_data,
    output reg mdio_in,
    input rd_data,
    input data_rdy,
    input mdc,
    input mdio_oe,
    input mdio_out
);

//acá se definen las pruebas que se van a realizar
always begin//inicializamos el clk
    #5 clk = ~clk
end

//prueba de encendido
//preguntar: ¿pongo todas las pruebas en un solo intial begin? tengo un ejemplo en el que vene cada una en une indidtal begin por aparte.
initial  begin
    clk = 0;
    reset = 1;
    t_data = 32'b00101111111001011001010001101101;//esta señal no debería encender

    #20 reset = 0;
    #60 reset = 1;
end
endmodule