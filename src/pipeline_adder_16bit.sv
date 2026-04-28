/*
* Instituto Tecnológico de Costa Rica
* Prof. Dr.-ing. Pablo Mendoza Ponce
* Rev. 1 29 Nov 2025
*/

module pipeline_adder_16bit(
  input logic         clk_i,
  input logic         reset_n_i,
  input logic [15:0]  a_i,b_i,
  input logic         cin_i  ,
  output logic [15:0] sum_o,
  output logic        cout_o 
  );

  timeunit 1ns;
  timeprecision 1ps; 
  
  logic [3:0][3:0] internal_a,internal_b;
  logic [3:0][3:0] internal_out;


  logic [3:0] carry_w;
  logic [3:0][3:0] sum_w;

  logic [2:0][3:0] stage_1_a, stage_1_b;

  logic [3:0] stage_2_sum_0;
  logic stage_2_carry_0;
  logic [1:0][3:0] stage_2_a, stage_2_b;

  logic [1:0][3:0] stage_3_sum_1_0;
  logic stage_3_carry_1;
  logic [3:0] stage_3_a, stage_3_b;

  logic stage_4_carry_2;
  logic [2:0][3:0] stage_4_sum_2_1_0;


  always_ff @(posedge clk_i or negedge reset_n_i) begin
    if (!reset_n_i) begin
      internal_a <= '0;
      internal_b <= '0;
    end else begin
      internal_a <= a_i;
      internal_b <= b_i;
    end
  end

  carry_adder_4bit rca_stage_1(
    .a_i    (internal_a[0]), 
    .b_i    (internal_b[0]), 
    .cin_i    (cin_i  ),
    .sum_o  (sum_w[0]),
    .cout_o  (carry_w[0]));

  always_ff @(posedge clk_i or negedge reset_n_i) begin
    if (!reset_n_i) begin
      stage_1_a <= '0;
      stage_1_b <= '0;
    end else begin
      stage_1_a <= internal_a[3:1];
      stage_1_b <= internal_b[3:1];
    end
  end

  carry_adder_4bit rca_stage_2(
    .a_i    (stage_1_a[0]),
    .b_i    (stage_1_b[0]), 
    .cin_i  (stage_2_carry_0), 
    .sum_o  (sum_w[1]),
    .cout_o (carry_w[1]));
  
  
  always_ff @(posedge clk_i or negedge reset_n_i) begin
    if (!reset_n_i) begin
      stage_2_a <= '0;
      stage_2_b <= '0;
      stage_2_carry_0 <= '0;
      stage_2_sum_0  <= '0;
    end else begin
      stage_2_a <= stage_1_a[2:1];
      stage_2_b <= stage_1_b[2:1];
      stage_2_carry_0 <= carry_w[0];
      stage_2_sum_0 <= sum_w[0];
    end
  end

  carry_adder_4bit rca_stage_3(
    .a_i    (stage_2_a[0]),
    .b_i    (stage_2_b[0]), 
    .cin_i  (stage_3_carry_1), 
    .sum_o  (sum_w[2]),
    .cout_o (carry_w[2]));
    
  always_ff @(posedge clk_i or negedge reset_n_i) begin
    if (!reset_n_i) begin
      stage_3_a <= '0;
      stage_3_b <= '0;
      stage_3_carry_1 <= '0;
      stage_3_sum_1_0 <= '0;
    end else begin
      stage_3_a <= stage_2_a[1];
      stage_3_b <= stage_2_b[1];
      stage_3_carry_1 <= carry_w[1];
      stage_3_sum_1_0 <= {sum_w[1], stage_2_sum_0};
    end
  end
  
  
  carry_adder_4bit rca_stage_4(
    .a_i    (stage_3_a),
    .b_i    (stage_3_b), 
    .cin_i  (stage_4_carry_2), 
    .sum_o  (sum_w[3]),
    .cout_o (carry_w[3]));
    
  
  always_ff @(posedge clk_i or negedge reset_n_i) begin
    if (!reset_n_i) begin
      stage_4_carry_2 <= '0;
      stage_4_sum_2_1_0 <= '0;
    end else begin
      stage_4_carry_2 <= carry_w[2];
      stage_4_sum_2_1_0 <= {sum_w[2], stage_3_sum_1_0};
    end
  end


  always_ff @(posedge clk_i or negedge reset_n_i) begin
    if (!reset_n_i) begin
      sum_o <= '0;
      cout_o  <= '0;
    end else begin
      sum_o <= {sum_w[3], stage_4_sum_2_1_0};
      cout_o  <= carry_w[3];
    end
  end

endmodule


module carry_adder_4bit(
  input logic [3:0]   a_i, b_i,
  input logic         cin_i  ,
  output logic [3:0]  sum_o,
  output logic        cout_o 
);
assign {cout_o , sum_o} = a_i + b_i + cin_i  ;
endmodule
