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

  // Instantiating the Ibex Demo System.
  ibex_demo_system #(
    .GpoWidth(4),
    .PwmWidth(12),
    .SRAMInitFile(SRAMInitFile)
  ) u_ibex_demo_system (
    //input
    .clk_sys_i(clk_sys),
    .rst_sys_ni(rst_sys_n),
    .sw_i(SW),

    //output
    .gp_o(ibex_led),
    .pwm_o(RGB_LED),
    .uart_tx_o(UART_TX)
  );

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
