`include "DUT.v"

module TransMDIO_tb;
reg clk, reset;
wire mdc;

wire MDIO_start;
reg [N:0] T_data1;
reg [N:0] T_data2;
reg [N:0] T_data3;
wire MDIO_out; 
wire MDIO_oe;

reg MDIO_in;
wire [(N-1)/2 : 0] RD_data;
wire data_RDY;


    parameter N = 31;

initial begin
	$dumpfile("MDIO_tb.vcd");
	$dumpvars(-1, PruebaEncendido);
	$dumpvars(-1, PruebaEscritura);
	$dumpvars(-1, PruebaLectura);
end


TransMDIO PruebaEncendido (

.clk            (clk),
.reset          (reset),
.mdc            (mdc),
.MDIO_start     (MDIO_start),
.T_data         (T_data1),
.MDIO_out       (MDIO_out),
.MDIO_oe        (MDIO_oe),
.MDIO_in        (MDIO_in),
.RD_data        (RD_data),
.data_RDY       (data_RDY)

);

TransMDIO PruebaEscritura (

.clk            (clk),
.reset          (reset),
.mdc            (mdc),
.MDIO_start     (MDIO_start),
.T_data         (T_data2),
.MDIO_out       (MDIO_out),
.MDIO_oe        (MDIO_oe),
.MDIO_in        (MDIO_in),
.RD_data        (RD_data),
.data_RDY       (data_RDY)

);


TransMDIO PruebaLectura (

.clk            (clk),
.reset          (reset),
.mdc            (mdc),
.MDIO_start     (MDIO_start),
.T_data         (T_data3),
.MDIO_out       (MDIO_out),
.MDIO_oe        (MDIO_oe),
.MDIO_in        (MDIO_in),
.RD_data        (RD_data),
.data_RDY       (data_RDY)

);



always begin
 #5 clk = ~clk; //Se define un periodo de 10 unidades de tiempo
end


//testbench encendido
//---------------------------------------------------------------------------------------------------
initial begin
clk = 0;
reset = 1;
T_data1 = 32'b00101111111001011001010001101101; //Esta señal no debe encender

#20 reset = 0; //Acá las salidas deben colocarse en 0, y almc = T_data
#60 reset = 1; //Acá vuelve a funcionar el circuito
#70 ; //Termina en 150 unidades de tiempo
end
//---------------------------------------------------------------------------------------------------


//Testbench escritura
//---------------------------------------------------------------------------------------------------
initial begin
clk = 0;
reset = 1;
T_data2 = 32'b01011111110010110010100011011011; //Esta señal debe encender y colocarse en modo escritura

#10 reset = 0; //Acá las salidas deben colocarse en 0, y almc = T_data
#60 reset = 1; //Acá vuelve a funcionar el circuito
#370 ; //Termina en 650 unidades de tiempo
end
//---------------------------------------------------------------------------------------------------


//Testbench lectura
//---------------------------------------------------------------------------------------------------
initial begin
clk = 0;
MDIO_in =0;
reset = 1;
T_data3 = 32'b01101111110010110010100011011011; //Esta señal debe encender y colocarse en modo lectura

#20 reset = 0; //Acá las salidas deben colocarse en 0, y almc = T_data
#60 reset = 1; //Acá vuelve a funcionar el circuito

#175 MDIO_in =0; //15  Acá se inicia la transacción de lectura
#10 MDIO_in =0;  //14
#10 MDIO_in =0;  //13
#10 MDIO_in =0;  //12
#10 MDIO_in =1;  //11
#10 MDIO_in =1;  //10
#10 MDIO_in =1;  //9
#10 MDIO_in =0;  //8
#10 MDIO_in =1;  //7
#10 MDIO_in =1;  //6
#10 MDIO_in =0;  //5
#10 MDIO_in =0;  //4
#10 MDIO_in =0;  //3
#10 MDIO_in =1;  //2
#10 MDIO_in =1;  //1
#10 MDIO_in =0;  //0

#70 $finish; //Termina el testbech
end







endmodule