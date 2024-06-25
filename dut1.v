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
reg [31:0] almacen; //agregado por auro para lo de lecrura/escritura
//variables internas para la transacción
reg [15:0] almacenamiento; //guarda los bits obtenidos en MDIO_in *preguntar ¿no sería más bien los bits de t_data
reg [5:0] count; //contador
reg cout_freq = 0;//determina si la frecuencia de salida se coloca en alto o bajo
reg [7:0] almacenamiento_lectura;//guarda los valores que serán cargados a rd_data
reg [5:0] wrtcount;//cuenta los bits leídos cuando se comienza la transferencia por mdio_in

parameter freqdiv = 10'd2;//dividiremos la frecuencia por 2.
//linea de arriba no se usa 
//se genera el mdc:
always @(posedge clk) begin
  if (!reset)begin
    count <= 0;
    mdc <= 0;
  end

  else begin
    count <= count + 0.5;
    if(count == 1) begin
      count <= 0;
      mdc <= ~mdc;
      //$display("mdc");
    end
  end 
    
  /*else begin
    mdc = 0;
    $display("mdc_else %d", count);
  end*/
end

always @(posedge clk) begin
//efecto del reset:
  if (reset == 0)begin //cuando reset esté en bajo se regresa al estado inicial y todas las salidas se ponene en 0
    mdio_out = 0;
    almacenamiento = t_data;
    count = 0;
    mdc = 0;
    mdio_oe = 0;
    rd_data = 0;
    data_rdy = 0;
    almacenamiento_lectura = 0;
    wrtcount = 0;
  end 
  else begin //funcionaminento normal
    mdio_out = mdio_out;
    almacenamiento = almacenamiento;
    mdio_oe = mdio_oe;
    rd_data = rd_data;
    data_rdy = data_rdy;
    almacenamiento_lectura = almacenamiento_lectura;
    wrtcount = wrtcount;
  end
end

//entrada de salida paralela a salida parcial
always @(*)begin
  if (~reset)
    state = 3'b001; //cuando reset = 0, se vuelve al estado idle
  else
    next_state = state;
end

always @(*)begin
  //$display("%d", t_data[31]);
  //$display("%d", t_data[30]);
  case (state)
    3'b001: begin
      if(t_data[31] == 0)//el último bit de t_data es 0
        state = 3'b010;
      else
        state = 3'b001;
    end

    3'b010: begin
      if(t_data[30] == 1)
        state = 3'b100;
      else 
        state = 3'b010;
    end

    3'b100: begin
      //se envía la señal para iniciar la transmisión de datos
      if(mdio_start == 1) begin
        mdio_out = t_data; //mdio_out agarra el valor de t_data
        $display("%b", t_data);
      end
    end

    default: next_state = 3'b001; //si se recibe un valor no definido se vuelve a idle
  endcase
end

always @(posedge clk)begin
  if ((t_data[31:0] == almacen[31:0])&&(mdio_start == 1))begin
      mdio_out = almacen[31];
      almacen = {almacen[31-1],1'b0};
      count =count +1;
  end else if ((t_data[31:0]!= almacen[31:0])&& (mdio_start ==1))begin
      mdio_out = almacen[31];
      almacen = {almacen[31-1],1'b0};
      count =count +1;
  end else 
  mdio_out = mdio_out;

//escritura
if (({t_data[29],t_data[28]} == 2'b01) && (count>=1) && (count<=31))
  mdio_oe <=1;
else mdio_oe = 0;

//lectura
if (({t_data[30],t_data[29]} == 2'b10) && (count>=1) && (count<=31))
  mdio_oe <=1;
else mdio_oe = 0;

if ((mdio_oe == 0)&&(count >=17))
  wrtcount = wrtcount+1;
else wrtcount = wrtcount;

if ((mdio_oe == 0)&& (wrtcount <=17))
  data_rdy = 1;
else data_rdy = 0;

if ((mdio_oe == 0) && (data_rdy == 0) && (1 <=wrtcount) && (wrtcount <= 16))
  almacenamiento_lectura = {mdio_in,almacenamiento_lectura[(32-1)/2 : 1]};
else almacenamiento_lectura = almacenamiento_lectura;

if (data_rdy == 1)
  rd_data <= almacenamiento_lectura;
else rd_data = rd_data;
end
endmodule
