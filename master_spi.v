module master (
    input cs1_selec, // Entradas para seleccionar el slave
    input cs2_selec,
    input clk,
    input reset,
    input [15:0] datain,
    input MISO, // Entrada MISO
    output cs_1, // Salidas CS1 y CS2
    output cs_2,
    output sclk,
    output spi_data, // MOSI
    output [15:0] counter
);

reg spi_cs1;// Registros para los selectores del slave
reg spi_cs2; 
reg spi_sclk;
reg [15:0]  MOSI;
reg [3:0] state;
reg [4:0] count;
reg [15:0] miso_data; // datos del MISO

always @(posedge clk) begin
    if(reset) begin
        spi_cs1 <= 1'b1; // CS1 = 1 | CS2 = 1
        spi_cs2 <= 1'b1;
        MOSI <= 16'b0;
        count <= 5'd16;
        spi_sclk <= 1'b0; //porque nada puede empezar hasta el CS no baje
        miso_data <= 16'b0;
    end else begin
        case (state)
            0 : begin
                spi_cs1 <= 1;
                spi_cs2 <= 1;
                spi_sclk <= 0;
                state <= 1;
            end 
            1 :  begin
                if (cs1_selec)begin // seleccionar slave
                    spi_cs1 <= 0;
                end else if (cs2_selec)begin
                    spi_cs2 <= 0;
                end
                spi_sclk <= 0;
                MOSI <= datain[count-1];
                count <= count -1;
                state <= 2;
            end
            2 : begin
                spi_sclk <= 1;
                if(count > 1) begin
                    state <= 1;
                end else begin
                    state <= 3;
                    count <= 16;
                end
            end
            3 : begin
                spi_sclk <= 0;
                miso_data <= {MISO, miso_data[15:1]}; // Guarda los datos del MISO bit por bit
                count <= count -1; // ajustar con el slave
                if (count > 1) begin // Cuando se reciben todos los datos MISO, excepto el último bit
                    count <= count - 1;
                end else begin // Cuando se recibe el último bit MISO
                    count <= 16;
                    state <= 0; // Volver al estado inicial después de recibir datos MISO
                end
            end
            default: state <= 0;
        endcase
    end
end
assign cs_1 = spi_cs1; // Salidas CS1 y CS2
assign cs_2 = spi_cs2;
assign spi_data = MOSI;
assign counter = count;
assign sclk = spi_sclk;
    
endmodule
