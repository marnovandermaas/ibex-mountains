// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module pwm #(
  parameter int CtrSize = 8
) (
  input  logic               clk_sys_i,
  input  logic               rst_sys_ni,

  // If you want an always on signal, you will need to make pulse_width_i > max_counter_i.
  input  logic [CtrSize-1:0] pulse_width_i,
  input  logic [CtrSize-1:0] max_counter_i,

  output logic               modulated_o
);
  logic [CtrSize-1:0] counter;

  always_ff @(posedge clk_sys_i) begin
    if (!rst_sys_ni || max_counter_i == 0) begin
      counter <= 'b0;
      modulated_o <= 'b0;
    end else begin
      if (counter < max_counter_i) begin
        counter <= counter + 1;
      end else begin
        counter <= 0;
      end
      if (pulse_width_i > counter) begin
        modulated_o <= 1'b1;
      end else begin
        modulated_o <= 1'b0;
      end
    end
  end
endmodule
