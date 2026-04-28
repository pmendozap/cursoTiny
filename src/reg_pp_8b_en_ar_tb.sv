/*
* Instituto Tecnológico de Costa Rica
* Prof. Dr.-ing. Pablo Mendoza Ponce
* Rev. 1 28 July 2024
*/
module reg_pp_8b_en_ar_tb;
  timeunit 1ns;
  timeprecision 1ps;  


  logic         clk_i;
  logic         rst_n_i = 0;
  logic [7:0]   d_i = '0;
  logic         en_i = '0;
  logic [7:0]   q_o;

  reg_pp_8b_en_ar dut (.*);

  clk_gen cg (.clk_o(clk_i));

  initial begin
    repeat(4) @(posedge clk_i);
    rst_n_i <= 1'b1;

    repeat(16) begin
      @(posedge clk_i);
      {en_i, d_i} <= $urandom%512;
    end

    repeat(4) @(posedge clk_i);
    $stop;

  end
  
endmodule