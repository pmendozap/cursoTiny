/*
* Instituto Tecnológico de Costa Rica
* Prof. Dr.-ing. Pablo Mendoza Ponce
* Rev. 1 28 July 2024
*/
module clk_gen
#(parameter HALF_T = 10)
(output bit clk_o);
    timeunit 1ns;
    timeprecision 1ps;
    bit local_clk = 0;
    assign clk_o = local_clk;
    always #(HALF_T) local_clk = ~local_clk;
endmodule