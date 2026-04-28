/*
* Instituto Tecnológico de Costa Rica
* Prof. Dr.-ing. Pablo Mendoza Ponce
* Rev. 1 28 July 2024
*/
module async_res_ctrl	
	( 
		input logic  clk_i, 
		input logic  a_rst_n_i, 
		output logic sa_rst_n_o
	);
	
	timeunit 1ns;
	timeprecision 1ps;
	
	logic r0, r1;
	
	always_ff @(posedge clk_i, negedge a_rst_n_i)
		if(!a_rst_n_i) begin
			r0 <= 1'b0;
			r1 <= 1'b0;
		end else begin
			r0 <= 1'b1;
			r1 <= r0;
		end
	
	assign sa_rst_n_o = r1;
	
endmodule