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
    #2 clk = ~clk;
end

//prueba de encendido
//preguntar: ¿pongo todas las pruebas en un solo intial begin? tengo un ejemplo en el que vene cada una en une indidtal begin por aparte.
initial  begin
    clk = 0;
    reset = 0;

    #10 reset = 1;

    //se prueba la máquina de estados
    #10 t_data = 32'b01101111111001011001010001101111;//con este número deberia pasar al 2do estado

    #10 t_data = 32'b01001111111001011001010001101111;//con este número pasa al tercer estado
    
    #10 t_data = 32'b01100111111001011001010001101111;
    mdio_start = 1;
    #4 mdio_start = 0;

    #70;

    //se prueba el modo escritura
    //reset = 1;
    #10 t_data = 32'b01011111110010110010100011011011;

    #70;

    //se prueba el modo lectura
    #10 t_data = 32'b01101111110010110010100011011011;

    #15 mdio_in =0; //15  Acá se inicia la transacción de lectura
    #10 mdio_in =0;  //14
    #10 mdio_in =0;  //13
    #10 mdio_in =0;  //12
    #10 mdio_in =1;  //11
    #10 mdio_in =1;  //10
    #10 mdio_in =1;  //9
    #10 mdio_in =0;  //8
    #10 mdio_in =1;  //7
    #10 mdio_in =1;  //6
    #10 mdio_in =0;  //5
    #10 mdio_in =0;  //4
    #10 mdio_in =0;  //3
    #10 mdio_in =1;  //2
    #10 mdio_in =1;  //1
    #10 mdio_in =0;  //0
    
    #100;
    $finish;
end
endmodule