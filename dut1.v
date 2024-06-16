module dut1 (
  input mdio_start,
  input [31:0] t_data,
  input mdio_in,
  output reg [15:0] rd_data,
  output reg data_rdy,
  output reg mdc,
  output reg mdio_de,
  output reg mdio_out
);
endmodule
