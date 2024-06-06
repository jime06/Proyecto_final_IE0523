module TransMDIO (

input clk,
input reset,
output reg mdc,

output reg MDIO_start,
input [N:0] T_data ,
output reg MDIO_out,
output reg MDIO_oe, 

input MDIO_in,
output reg [(N-1)/2 : 0] RD_data,
output reg data_RDY

);
    //Variables internas para la máquina de estado
    reg [2:0] state;
    reg [2:0] nxt_state;        

    //Variables internas para el proceso de transacción
    reg [N:0] almc ; //Esta variable se encarga de almacenar los valores que se obtienen a la entrada s_in
    reg [5:0] count ;  //Esta variable se encarga de contar los números ingresados a la variable de almacenamiento que posteriormente será cargados en paralelo
    reg freqcounter= 0 ;  //Esta variable se encarga de determinar si la frecuencia de salida se coloca en alto o en bajo
    reg [(N-1)/2 : 0] almLEC ; //Esta variable se encarga de almacenar los valores que serán cargados en RD_data luego del proceso de lectura
    reg [5:0] wrtcount ; //Esta variable se encarga de contar los bits leídos una vez que se comienza con la transferencia MDIO_in

    parameter N = 31 ; //Tamaño de bits de la carga paralela
    parameter freqdiv = 10'd2 ; //Dato por el cual se dividira la frecuencia, en nuestro caso será de 2

    
    //-------------------------------------------------------------------------------------------------------------------------------------------------------------
    //Generacion del mdc, reloj de salida a mitad de frecuencia que la del clk

    always @(posedge clk)
    begin
    freqcounter <= freqcounter + 1; //Se comienza sumando una unidad al contador
    if(freqcounter >= (freqdiv-1)) //Si el contador de frecuencia es igual al divisor -1, el contador de frecuencia pasa a ser 0.
    freqcounter <= 0;
    mdc <= (freqcounter < freqdiv/2)?1'b1:1'b0; //El condicional genera que el mdc se ponga en alto o en bajo cíclicamente gracias a las condiciones anteriores
    end

    //-------------------------------------------------------------------------------------------------------------------------------------------------------------
    //Efecto del RESET

    always @(posedge clk) begin
        
        if (reset == 0) begin //Cuando reset esté en bajo, los valores a continuación se ponen en un estado bajo.
            MDIO_out = 0;
            almc  = T_data; //La variable interna de almacenamiento se vuelve igual a la entrada paralela colocada
            count = 0;
            mdc = 0;
            MDIO_oe = 0;
            RD_data = 0;
            data_RDY = 0;
            almLEC = 0;
            wrtcount = 0;
            
        end    
        else begin //Se quedan como están
            MDIO_out = MDIO_out;
            almc = almc;
            count = count;
            mdc = mdc;
            MDIO_oe = MDIO_oe;
            RD_data = RD_data;
            data_RDY = data_RDY;
            almLEC = almLEC;
            wrtcount = wrtcount;
        end
    end
        

    //-------------------------------------------------------------------------------------------------------------------------------------------------------------
    // Entrada paralela a salida serial

    always @(posedge clk) begin
        
        if (~reset) state <= 3'b001; //Acá se está indicando que cuando el reset sea 0, la señal vuelva al estado de IDLE (que es el estado numero 1). 
        else state <= nxt_state; //Si el reset se encuentra en 1, el FF se mantiene funcionando con normalidad, esperando un flanco para cambiar de estado.
    
    end  

    always @(*) begin 
    
        nxt_state = state;  

        case(state)
            3'b001: begin
                if (T_data[N] == 0) nxt_state = 3'b010;
                else  nxt_state = nxt_state ;   
            end

            3'b010: begin 
                if (T_data[N-1] == 1) nxt_state = 3'b100;   
                else nxt_state = 3'b010; 
            end                                            //Una vez verificado el start, es posible comenzar con la transferencia serial.
            3'b100: begin                      
                        MDIO_start = 1 ;
            end 
            
            default:   nxt_state = 3'b001; // Si la máquina de estados obtuviese un valor de estado distinto o no definido por factores inesperados, este volverá inmediatamente al IDLE. 
        endcase
    end               


    always @(posedge clk) begin
        if((T_data[N:0] == almc[N:0]) && (reset == 1) && (MDIO_start == 1 ))begin  //Dado que queremos que en primera instancia la variable de almacenamiento sea igual a la carga paralela, en el primer flanco se debe cumplir que son iguales 
            MDIO_out = almc[N];                    //Dado que son iguales, se toma la cifra más significativa de la carga en paralelo (que sería la misma de la variable de almacenamiento)
            almc = {almc[N-1:0], 1'b0};               //Acá lo que se hace es mover los bits hacia la izquierda, para que en el siguiente flanco el bit más significativo de la variable de almacenamiento sea realmente
                                                //el segundo bit más significativo de la carga paralela a la entrada
            count = count + 1;                     //Se aumenta en 1 el contador                                   
            end 
            else if ((T_data[N:0] != almc[N:0]) && (reset == 1) && (MDIO_start == 1)) begin   //Por la rotación anterior, en el segundo flanco ya la variable de almacenamiento no será igual a la carga en paralelo, por ende:
                MDIO_out = almc[N];                          //Ahora la salida tomará el valor más significativo en el almacenamiento, que gracias a la rotación es en realidad T_data[N-1] (el segundo más significativo de T_data)
                almc = {almc[N-1:0], 1'b0};                     //Acá se vuelve a rotar. Para el siguiente clock será este else if el que seguirá actuando.
                count = count + 1;                           //El contador aumenta en 1
            end
            else MDIO_out = MDIO_out ;                            //Si nada se cumple, todo permanece igual a como estaba.

        //Modo de Escritura    
        if (({T_data[N-2], T_data[N-3]} == 2'b01) && (count >= 1) && (count <= 32) && (reset == 1)) //Si el tercer y cuarto bit más significativos de T_data son 01, el modo es de escritura
            MDIO_oe <= 1;                                               //Si el contador indica un número entre 0 y 33, esta salida se pone en alto
        else MDIO_oe = 0;                                              //Si el contador indica un número igual o mayor a 33 esto quiere decir que la transmisión serial concluyó, por tanto MDIO_oe cae a 0

        //Modo de Lectura
        if (({T_data[N-2], T_data[N-3]} == 2'b10) && (count >= 1) && (count <= 16) && (reset == 1)) //Si el tercer y cuarto bit más significativos de T_data son 10, el modo es de lectura
            MDIO_oe <= 1;                                               //Si el contador indica un número entre 0 y 17, esta salida se pone en alto
        else MDIO_oe = 0;                                              //Si el contador indica un número igual o mayor a 17 implica que se está recibiendo el dato de MDIO_IN, por tanto cae a 0.



    //-------------------------------------------------------------------------------------------------------------------------------------------------------------
    //Modo lectura: Entrada serial a salida paralela

    //Modo de Lectura

        if ((MDIO_oe == 0) && (count >= 17) )                       //El MDIO_oe nos dice directamente si ya la transmisión de lectura por el MDIO_in comenzó
           wrtcount = wrtcount + 1;             //Se añade un contador de cara a poder indicar que la transferencia fue exitosa con el tamaño esperado
        else wrtcount = wrtcount; 

        if ((MDIO_oe == 0) && (wrtcount >= 17))                  //Cuando el contador de lectura esté entre 1 y 16, se estará en el proceso de transmisión
            data_RDY = 1;                        //Por lo tanto, RDY debe estar en bajo
        else data_RDY = 0;                       //Una vez que el contador supere los 16, quiere decir que los 16 bits fueron recibidos y la señal se pone en alto

        if ((MDIO_oe == 0) && (data_RDY == 0) && (1 <= wrtcount) && (wrtcount <= 16))        //Sabiendo que la transferencia de lectura inició, se realiza una rotación en la variable de almacenamiento de lectura
           almLEC = {MDIO_in, almLEC[(N-1)/2 : 1]}; //Esto se consigue ingresando hacia la izquierda con el valor de MDIO_in como la variable más significativa
        else almLEC = almLEC;                    //En caso de que MDIO_oe esté en uno, quiere decir que no se está en lectura, y si RDY está en bajo la transferencia no ha acabado 
        
        if (data_RDY == 1)        //Una vez que RDY se pone en alto, inmediatamente el valor de la variable de almacenamiento de lectura se carga en paralelo en RD_data
           RD_data <= almLEC ; 
        else RD_data = RD_data;              
    end






endmodule