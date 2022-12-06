// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This is the top level SystemVerilog file that connects the IO on the board to the Ibex Demo System.
module top_artya7 (
  // These inputs are defined in data/pins_artya7.xdc
  input               IO_CLK,
  input               IO_RST_N,
  input         [3:0] SW,
  input         [3:0] BTN,
  output logic  [3:0] LED,
  output logic [11:0] RGB_LED,
  output              UART_TX
);
  parameter SRAMInitFile = "";

  logic clk_sys, rst_sys_n;

  logic  [3:0] ibex_led;
  logic [11:0] ibex_rgb_led;

  // Instantiating the Ibex Demo System.
  ibex_demo_system #(
    .GpoWidth(16),
    .SRAMInitFile(SRAMInitFile)
  ) u_ibex_demo_system (
    //input
    .clk_sys_i(clk_sys),
    .rst_sys_ni(rst_sys_n),

    //output
    .gp_o({ibex_led, ibex_rgb_led}),
    .uart_tx_o(UART_TX)
  );

  for (genvar i = 0; i < 12; i++) begin : gen_pwm
    pwm #(
      .CtrSize(8)
    ) u_pwm (
      .clk_sys_i(clk_sys),
      .rst_sys_ni(rst_sys_n),
      .pulse_width_i({4'b0000, SW}),
      .max_counter_i(8'b11111111),
      .modulated_o(RGB_LED[i])
    );
  end : gen_pwm

  always_ff @(posedge clk_sys) begin
    LED <= BTN ^ ibex_led;
  end

  // Generating the system clock and reset for the FPGA.
  clkgen_xil7series clkgen(
    .IO_CLK,
    .IO_RST_N,
    .clk_sys,
    .rst_sys_n
  );

endmodule
