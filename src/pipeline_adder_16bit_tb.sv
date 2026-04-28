/*
* Instituto Tecnológico de Costa Rica
* Prof. Dr.-ing. Pablo Mendoza Ponce
* Rev. 1 29 Nov 2025
*/

module pipeline_adder_16bit_tb;
  timeunit 1ns;
  timeprecision 1ps;  

  logic         clk_i;
  logic         reset_n_i;
  logic [15:0]  a_i,b_i;
  logic         cin_i;
  logic [15:0]  sum_o;
  logic         cout_o;

  
  clk_gen #(.HALF_T(10)) u_clk (.clk_o(clk_i));

  pipeline_adder_16bit dut(
    .*
  );
  
  initial begin
    reset_n_i = '0;
    a_i = '0;
    b_i = '0;
    cin_i = '0;
    repeat(2)
      @(posedge clk_i);
    #1 reset_n_i <= 1'b1;
    repeat(2) 
      @(posedge clk_i);
    #1 a_i <= 16'h1234;
       b_i <= 16'h1234;  
    repeat(5)
      @(posedge clk_i);
    repeat(2) 
      @(posedge clk_i);
    #1 a_i <= 16'h3333;
       b_i <= 16'h1111;  
    repeat(5)
      @(posedge clk_i);
    repeat(2) 
      @(posedge clk_i);
    #1 a_i <= '1;
       b_i <= 16'd1;
    repeat(5)
      @(posedge clk_i);
    repeat(2)
      @(posedge clk_i);
      #1 a_i <= 16'd1;
    repeat(16) begin
      @(posedge clk_i);
      #1 a_i <= a_i + 16'd1;
    end
    repeat(7)
      @(posedge clk_i);
    #2 $stop;
  end
 
 
endmodule
  