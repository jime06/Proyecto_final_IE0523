module tester_mdio (
    output reg clk, reset, mdio_start, mdio_in,
    output reg [31:0] t_data,
    input mdc, mdio_out, mdio_oe,
    input [15:0] rd_data,
    input data_rdy
);

//acá se definen las pruebas que se van a realizar
always begin//inicializamos el clk
    #20 clk = ~clk;
end

initial begin
    clk = 0;
    reset = 0;

    #20 reset = 1;
    #40 reset = 0;
        mdio_start = 0;

        //para escritura
        t_data = 32'h55555555;
    #80 mdio_start = 1;
    #40 mdio_start= 0;
    #7800 t_data = 32'h65557777;
        
    #160 mdio_start = 1;
    #40 mdio_start = 0;

    //para lectura
    #15 mdio_in =1; //15  Acá se inicia la transacción de lectura
    #10 mdio_in =0;  //14
    #10 mdio_in =1;  //13
    #10 mdio_in =0;  //12
    #10 mdio_in =1;  //11
    #10 mdio_in =0;  //10
    #10 mdio_in =1;  //9
    #10 mdio_in =0;  //8
    #10 mdio_in =1;  //7
    #10 mdio_in =0;  //6
    #10 mdio_in =1;  //5
    #10 mdio_in =0;  //4
    #10 mdio_in =0;  //3
    #10 mdio_in =1;  //2
    #10 mdio_in =1;  //1
    #10 mdio_in =0;  //0
    //mdio_in = 32'h55555555;
    #8000; 
    $finish;
end
endmodule