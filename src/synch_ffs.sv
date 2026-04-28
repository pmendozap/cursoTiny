/*
* Instituto Tecnológico de Costa Rica
* Prof. Dr.-ing. Pablo Mendoza Ponce
* Rev. 1 28 July 2024
*/
module synch_ffs 
  ( 
    input logic  clk_i, 
    input logic  s_i, 
    output logic s_o
  );
  
  timeunit 1ns;
  timeprecision 1ps;
  
  //three flip-flops in cascade
  logic [2:0] reg_local;
  
  always_ff @(posedge clk_i) begin
    reg_local <= {reg_local[1:0],s_i};
  end
  
  assign s_o = reg_local[2];
  
endmodule