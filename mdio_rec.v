/*
Parte 2 Proyecto final. Circuitos Digitales 2. I Semestre 2024
Receptor de transacciones MDIO
Aurora Matamoros Cuadra B84707
Kenneth Rojas Rivera B96890
Jimena Gonzalez Jiménez B83443
Profesora: Ana Eugenia Sanchez Villalobos
*/
module receptor(
    input rst, MDC, MDIO_OE, MDIO_OUT,
    input [15:0] RD_DATA,
    output reg MDIO_IN, WR_STB, MDIO_DONE,
    output reg [4:0] ADDR,
    output reg [15:0] WR_DATA);
reg [5:0] count;
reg [31:0] data;
reg [2:0] state;
always @(posedge MDC or rst) begin
    if (~rst)begin
        count <= 0;
        data <= 32'b0;
        state <= 0;
        MDIO_IN <= 0;
        WR_STB <= 0;
        MDIO_DONE <=0;
        ADDR <= 5'b0;
        WR_DATA <= 16'b0;
    end else begin
        case(state)
        0: begin // recibe t_data del generador por medio de MDIO_OUT
            if ((count < 32) && MDIO_OE) begin
                data [count] <= MDIO_OUT; // guarda los datos recibidos
                count <= count + 1;
            end else if ((count == 32) && (data[29:28] == 2'b01)) begin // modo write
                count <= 0; //reiniciamos contador
                state <= 1; // estado write
            end else if ((count == 16) && (data[13:12] == 2'b10)) begin // modo read
                count <= 0; // reiniciamos contador
                state <= 2; // estado read
            end
        end
        1: begin // write mode
            if (count == 0) begin // salidas hacia el PHY
                ADDR [4:0] <= data[23:18]; // asigna el valor de REGADR en t_data a la salida ADDR
                WR_DATA[15:0] <= data[15:0]; // transmite los datos a escribir, ultimos 16 bits de t_data
                WR_STB <= 1; // pulso de wr_stb
                count <= count + 1;
            end else if (count == 1) begin // genera un delay para terminar la transaccion
                WR_STB <= 0;
                MDIO_DONE <= 1;
                state <= 3;
            end
        end
        2: begin // read mode
            ADDR [4:0] <= data[6:2]; // asigna el valor de REGADR en t_data a la salida ADDR
            if (count < 16)begin
                MDIO_IN <= RD_DATA[count]; // transmite RD_DATA al generador con MDIO_IN
                count <= count + 1;
            end else if (count == 16)begin
                count <= count +1;
                MDIO_IN <= 0;
                MDIO_DONE <= 1; // genera el pulso de MDIO_DONE
                state <= 3;
            end
        end
        3: begin // iddle mode
            // todas las señales vuelven al estado inicial
            count <= 0;
            MDIO_DONE <=0;
            WR_STB <= 0;
            state <= 0;
        end
        default: state <= 0;
        endcase
    end
end

endmodule