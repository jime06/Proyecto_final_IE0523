module dut1 (
  input clk,
  input reset,//cuando reset = 1 el generador funciona con normalidad.
              //si reset = 0, el generador vuelve a estado incial y todas las salidas a 0.
  input mdio_start,
  input [31:0] t_data,
  input mdio_in,
  output reg [15:0] rd_data,
  output reg data_rdy,
  output reg mdc,
  output reg mdio_oe,//indentifica el tipo de transacción (lectura o escritura)
  output reg mdio_out//salida serial se habilita cuando mdio_start = 1.
                     //por esta salida se envían los bits que se reciben por t_data.
);

//variables internas para la máquinas de estados
reg [2:0] state;
reg [2:0] next_state;

//variables internas para ka transacción
reg [N:0] almacenamiento; //guarda los bits obtenidos en MDIO_in *preguntar ¿no sería más bien los bits de t_data
reg [5:0] count; //contador
reg cout_freq = 0;//determina si la frecuencia de salida se coloca en alto o bajo
reg [7:0] almacenamiento_lectura;//guarda los valores que serán cargados a rd_data
reg [5:0] wrtcount;//cuenta los bits leídos cuando se comienza la transferencia por mdio_in

parameter freqdiv = 10'd2;//dividiremos la frecuencia por 2.


endmodule
