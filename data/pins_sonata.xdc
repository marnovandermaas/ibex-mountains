## Copyright lowRISC contributors.
## Licensed under the Apache License, Version 2.0, see LICENSE for details.
## SPDX-License-Identifier: Apache-2.0

## Clocks
create_clock -period 40.000 -name main_clk -waveform {0.000 20.000} [get_ports main_clk]
create_clock -period 100.000 -name tck_i -waveform {0.000 50.000} [get_ports tck_i]

## Reset
set_property -dict { PACKAGE_PIN T5 IOSTANDARD LVCMOS33 } [get_ports {nrst_btn}]

## Raspberry Pi Hat
set_property -dict { PACKAGE_PIN L13 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[0]}];
set_property -dict { PACKAGE_PIN M16 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[1]}];
set_property -dict { PACKAGE_PIN N15 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[2]}];
set_property -dict { PACKAGE_PIN K17 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[3]}];
set_property -dict { PACKAGE_PIN L18 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[4]}];
set_property -dict { PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[5]}];
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[6]}];
set_property -dict { PACKAGE_PIN L14 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[7]}];
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[8]}];
set_property -dict { PACKAGE_PIN N14 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[9]}];
set_property -dict { PACKAGE_PIN N16 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[10]}];
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[11]}];
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[12]}];
set_property -dict { PACKAGE_PIN L15 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[13]}];
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[14]}];
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[15]}];
set_property -dict { PACKAGE_PIN R11 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[16]}];
set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[17]}];
set_property -dict { PACKAGE_PIN T15 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[18]}];
set_property -dict { PACKAGE_PIN T13 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[19]}];
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[20]}];
set_property -dict { PACKAGE_PIN V10 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[21]}];
set_property -dict { PACKAGE_PIN R13 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[22]}];
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[23]}];
set_property -dict { PACKAGE_PIN T9 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[24]}];
set_property -dict { PACKAGE_PIN R15 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[25]}];
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[26]}];
set_property -dict { PACKAGE_PIN V11 IOSTANDARD LVCMOS33 } [get_ports {rpi_gpio[27]}];

## General purpose LEDs
set_property -dict { PACKAGE_PIN B13 IOSTANDARD LVCMOS33 } [get_ports {led_user[0]}];
set_property -dict { PACKAGE_PIN B14 IOSTANDARD LVCMOS33 } [get_ports {led_user[1]}];
set_property -dict { PACKAGE_PIN C12 IOSTANDARD LVCMOS33 } [get_ports {led_user[2]}];
set_property -dict { PACKAGE_PIN B12 IOSTANDARD LVCMOS33 } [get_ports {led_user[3]}];
set_property -dict { PACKAGE_PIN B11 IOSTANDARD LVCMOS33 } [get_ports {led_user[4]}];
set_property -dict { PACKAGE_PIN A11 IOSTANDARD LVCMOS33 } [get_ports {led_user[5]}];
set_property -dict { PACKAGE_PIN F13 IOSTANDARD LVCMOS33 } [get_ports {led_user[6]}];
set_property -dict { PACKAGE_PIN F14 IOSTANDARD LVCMOS33 } [get_ports {led_user[7]}];

## JTAG test
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports tck_i];
set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports td_i];
set_property -dict { PACKAGE_PIN J14 IOSTANDARD LVCMOS33 } [get_ports td_o];
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports tms_i];

## Switch and button input
set_property -dict { PACKAGE_PIN D12 IOSTANDARD LVCMOS33 } [get_ports {user_sw[0]}];
set_property -dict { PACKAGE_PIN D13 IOSTANDARD LVCMOS33 } [get_ports {user_sw[1]}];
set_property -dict { PACKAGE_PIN B16 IOSTANDARD LVCMOS33 } [get_ports {user_sw[2]}];
set_property -dict { PACKAGE_PIN B17 IOSTANDARD LVCMOS33 } [get_ports {user_sw[3]}];
set_property -dict { PACKAGE_PIN A15 IOSTANDARD LVCMOS33 } [get_ports {user_sw[4]}];
set_property -dict { PACKAGE_PIN A16 IOSTANDARD LVCMOS33 } [get_ports {user_sw[5]}];
set_property -dict { PACKAGE_PIN A13 IOSTANDARD LVCMOS33 } [get_ports {user_sw[6]}];
set_property -dict { PACKAGE_PIN A14 IOSTANDARD LVCMOS33 } [get_ports {user_sw[7]}];
set_property -dict { PACKAGE_PIN F5  IOSTANDARD LVCMOS18 } [get_ports {nav_sw[0]}];
set_property -dict { PACKAGE_PIN D8  IOSTANDARD LVCMOS18 } [get_ports {nav_sw[1]}];
set_property -dict { PACKAGE_PIN C7  IOSTANDARD LVCMOS18 } [get_ports {nav_sw[2]}];
set_property -dict { PACKAGE_PIN E7  IOSTANDARD LVCMOS18 } [get_ports {nav_sw[3]}];
set_property -dict { PACKAGE_PIN D7  IOSTANDARD LVCMOS18 } [get_ports {nav_sw[4]}];

## CHERI error LEDs
set_property -dict { PACKAGE_PIN K6  IOSTANDARD LVCMOS33 } [get_ports {led_cherierr[0]}];
set_property -dict { PACKAGE_PIN L1  IOSTANDARD LVCMOS33 } [get_ports {led_cherierr[1]}];
set_property -dict { PACKAGE_PIN M1  IOSTANDARD LVCMOS33 } [get_ports {led_cherierr[2]}];
set_property -dict { PACKAGE_PIN K3  IOSTANDARD LVCMOS33 } [get_ports {led_cherierr[3]}];
set_property -dict { PACKAGE_PIN L3  IOSTANDARD LVCMOS33 } [get_ports {led_cherierr[4]}];
set_property -dict { PACKAGE_PIN N2  IOSTANDARD LVCMOS33 } [get_ports {led_cherierr[5]}];
set_property -dict { PACKAGE_PIN N1  IOSTANDARD LVCMOS33 } [get_ports {led_cherierr[6]}];
set_property -dict { PACKAGE_PIN M3  IOSTANDARD LVCMOS33 } [get_ports {led_cherierr[7]}];
set_property -dict { PACKAGE_PIN M2  IOSTANDARD LVCMOS33 } [get_ports {led_cherierr[8]}];

## Status LEDs
set_property -dict { PACKAGE_PIN K5  IOSTANDARD LVCMOS33 } [get_ports led_legacy];
set_property -dict { PACKAGE_PIN L4  IOSTANDARD LVCMOS33 } [get_ports led_cheri];
set_property -dict { PACKAGE_PIN L6  IOSTANDARD LVCMOS33 } [get_ports led_halted];
set_property -dict { PACKAGE_PIN L5  IOSTANDARD LVCMOS33 } [get_ports led_bootok];

## LCD display
set_property -dict { PACKAGE_PIN R6  IOSTANDARD LVCMOS33 } [get_ports lcd_rst];
set_property -dict { PACKAGE_PIN U4  IOSTANDARD LVCMOS33 } [get_ports lcd_dc];
set_property -dict { PACKAGE_PIN R3  IOSTANDARD LVCMOS33 } [get_ports lcd_copi];
set_property -dict { PACKAGE_PIN R5  IOSTANDARD LVCMOS33 } [get_ports lcd_clk];
set_property -dict { PACKAGE_PIN P5  IOSTANDARD LVCMOS33 } [get_ports lcd_cs];

## UART
set_property -dict { PACKAGE_PIN C17 IOSTANDARD LVCMOS33 } [get_ports ser0_tx];
set_property -dict { PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports ser0_rx];

## Switches
set_property PULLTYPE PULLUP [get_ports user_sw[*]]
set_property PULLTYPE PULLUP [get_ports nav_sw[*]]


set_output_delay -clock main_clk 0.000 [get_ports led_user]

set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports main_clk];

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets tck_i]
