/*
* Instituto Tecnológico de Costa Rica
* Prof. Dr.-ing. Pablo Mendoza Ponce
* Rev. 1 28 July 2024
*/
module synch_deb
  #(
    parameter WAIT_CYCLES = 100
  )
  (
    input logic 	clk_i,
    input logic 	sa_rst_n_i,
    input logic 	s_i,
    output logic 	sd_o
  );

  timeunit 1ns;
  timeprecision 1ps;

  logic s_s;

  //1. synchronize the input
  synch_ffs #(.WAIT_CYCLES(WAIT_CYCLES)) synchronize
  ( 
    .s_o(s_s),
    .*
  );

  //2. Debounce and generate one pulse when s_i=1
  debouncer debounce
  (
    .sn_i(s_s),
    .*
  );

endmodule