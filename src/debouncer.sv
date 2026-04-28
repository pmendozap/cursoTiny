/*
* Instituto Tecnológico de Costa Rica
* Prof. Dr.-ing. Pablo Mendoza Ponce
* Rev. 1 28 July 2024
*/
module debouncer 
  #(
    parameter WAIT_CYCLES = 100 //2us @ 50Mhz
  )
  (
    input logic   clk_i,
    input logic   sa_rst_n_i,
    input logic   sn_i,
    output logic  sd_o
  );
  
  timeunit 1ns;
  timeprecision 1ps;

  typedef enum logic [1:0] {
    GET_POS_EDGE,
    WAIT_HIGH,
    GET_NEG_EDGE,
    WAIT_LOW
  }state_t;
  
  
  state_t state;
  
  localparam WIDTH_COUNTER = $clog2(WAIT_CYCLES);
  typedef logic [WIDTH_COUNTER:0] t_counter;
  t_counter counter;
  
  always_ff@(posedge clk_i, negedge sa_rst_n_i) begin
    if(!sa_rst_n_i) begin
      state   <= GET_POS_EDGE;
      counter <= t_counter'(WAIT_CYCLES);
      sd_o    <= '0;
    end else begin
      case(state)
        //wait for a change from 0 to 1 at the input
        GET_POS_EDGE:
          begin
            counter <= t_counter'(WAIT_CYCLES);
            sd_o <= '0;
            if(!sn_i) state <= GET_POS_EDGE;
            else      state <= WAIT_HIGH;
          end
          
        //the input should stay in 1 for at least WAIT_CYCLES
        //to assume that the signal is stable in 1
        //generate a pulse in 1 when detecting stability in the signal
        WAIT_HIGH:
          begin
            if(!sn_i) begin
              state <= GET_POS_EDGE;
              counter <= t_counter'(WAIT_CYCLES);
            end else begin
              if(counter=='d0) begin
                state <= GET_NEG_EDGE;
                sd_o <= '1;
                counter <= t_counter'(WAIT_CYCLES);
              end else begin
                counter <= counter - 1'b1;
                state <= WAIT_HIGH;
              end
            end
          end
          
        //wait for a change from 1 to 0 at the input
        GET_NEG_EDGE:
          begin
            counter <= t_counter'(WAIT_CYCLES);
            sd_o <= '0;
            if(!sn_i) state <= WAIT_LOW;
            else      state <= GET_NEG_EDGE;
          end
          
        //the input should stay in 0 for at least WAIT_CYCLES
        //to assume that the signal is stable in 0
        WAIT_LOW:
          begin
            if(!sn_i) begin
              if(counter==0) begin
                state <= GET_POS_EDGE;
                counter <= t_counter'(WAIT_CYCLES);
              end else begin
                counter <= counter - 1'b1;
                state <= WAIT_LOW;
              end
            end else begin
              state <= GET_NEG_EDGE;
              counter <= t_counter'(WAIT_CYCLES);
            end
          end
            
      endcase
    end
  end
  
  
  
endmodule