module master (
    input clk,
    input reset,
    input [15:0] datain,
    input MISO1, // Entradas MISO
    input MISO2,
    output cs_1, // Salidas CS1 y CS2
    output cs_2,
    output sclk, // serial clock
    output spi_data, // MOSI
    output [15:0] counter
);

reg spi_cs1;// Registros para los selectores del slave
reg spi_cs2; 
reg spi_sclk;
reg [15:0]  MOSI;
reg [2:0] state;
reg [4:0] count;
reg [15:0] miso_data; // datos del MISO
reg slave; // selecciona el slave
always @(posedge clk) begin
    if(reset) begin
        spi_cs1 <= 1'b1; // CS1 = 1 | CS2 = 1
        spi_cs2 <= 1'b1;
        MOSI <= 16'b0;
        count <= 5'd17;
        spi_sclk <= 1'b0; //porque nada puede empezar hasta el CS no baje
        slave <=0;
    end else begin
        case (state)
            0 : begin
                spi_cs1 <= 1;
                spi_cs2 <= 1;
                spi_sclk <= 0;
                state <= 1;
                count <= 17;
            end 
            1 : begin // transmite MOSI
                if (~slave) 
                    spi_cs1 <= 0; // selecciona slave 1
                else
                    spi_cs2 <=0; // selecciona slave 2
                spi_sclk <= 1;
                if (count > 1)begin
                    MOSI <= datain[count-2];
                    state <= 2;
                    count <= count - 1;
                end else begin
                    state <= 2;
                    count <= count - 1;
                end
            end
            2 : begin // Stand by MOSI
                spi_sclk <= 0;
                if(count > 0) begin
                    state <= 1;
                end else begin
                    miso_data <=16'b0;
                    state <= 3;
                    count <=18;
                end
            end
            3 : begin // recibe MISO
                spi_sclk <= 1;
                if (~slave)begin
                    if (((count%2)==0) && count > 0)begin
                        miso_data <= {miso_data[15:0], MISO1};
                        count <= count - 1;
                        state <=4;
                    end
                    else begin
                        count <= count-1;
                        state <=4;
                    end
                end else if (slave) begin
                    if (((count%2)==0) && count > 0)begin
                        miso_data <= {miso_data[15:0], MISO2};
                        count <= count - 1;
                        state <=4;
                    end
                    else begin
                        count <= count-1;
                        state <=4;
                    end
                end
            end
            4: begin // Stand by MISO
                spi_sclk <= 0;
                if (count > 0)begin
                    state <= 3;
                end else begin
                    state <= 0;
                    slave <=1;
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