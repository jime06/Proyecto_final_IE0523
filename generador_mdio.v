module generador_mdio (
    input clk,reset, mdio_start, mdio_in,
    input [31:0] t_data,
    output mdc, mdio_out, mdio_oe,
    output reg [15:0] rd_data,
    output reg data_rdy
);

//definimos los estados de la máquina con la que manejaremos el módulo
localparam INICIO = 3'b001;
localparam LECTURA = 3'b010;
localparam ESCRITURA = 3'b100;

//definimos variables internas
reg [1:0] clk_count;
reg [4:0] bit_count, next_bit_count;
reg [2:0] state, next_state;
reg mdio_out, mdio_oe;
wire write; //cuando estamos en modo escritura: write = 1
reg mdc_anterior;
wire posedge_mdc; //los datos los transmitimos en el posedge del mdc
wire trans_finalizada;
reg [15:0] next_dato_rec;

always @ (posedge clk) begin //funcionamiento del reset
    if (reset) begin
        clk_count <= 2'b00;
        state <= INICIO;
        mdc_anterior <= 0;
        bit_count <= 5'h00;
        rd_data <= 16'h0000;
    end
    else begin
        clk_count <= clk_count + 1;
        state <= next_state;
        mdc_anterior <= mdc;
        bit_count <= next_bit_count;
        rd_data <= next_dato_rec;
    end
end

always @ (*) begin
    next_state = state;
    next_bit_count = bit_count;
    mdio_out = t_data[bit_count];
    next_dato_rec = rd_data;
    mdio_oe = 0;

    case (state)
    INICIO: begin
        if (mdio_start & posedge_mdc) begin
            next_bit_count = bit_count + 1;
            mdio_oe = 1;
        end
        if (mdio_start & write & posedge_mdc)
            next_state = ESCRITURA;
        else if (mdio_start & !write & posedge_mdc)
            next_state = LECTURA;
    end

    ESCRITURA: begin
        mdio_oe = 1;
        if(trans_finalizada)
            next_state = INICIO;
        if (posedge_mdc)
            next_bit_count = bit_count + 1;
    end

    LECTURA: begin
        mdio_oe = (bit_count < 16);
        if(trans_finalizada)
            next_state = INICIO;
            data_rdy = 1;
        if (posedge_mdc)
            next_bit_count = bit_count + 1;

        if(mdio_oe)
            /*next_dato_rec[31 - bit_count]*/ rd_data = 32'b0110010101010101;
    end
    endcase
end

assign mdc = clk_count[1]; //mdc a 25% del clk
assign write = ~t_data[29] & t_data[28]; //write = 01
assign posedge_mdc = mdc & ~mdc_anterior;
assign trans_finalizada = (bit_count == 5'h1F);
endmodule