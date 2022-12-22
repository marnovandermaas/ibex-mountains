# Using F4PGA to build the Ibex demo system

This is currently a work in progress.

## Prerequisites

To use the files in this directoy you need [Yosys SystemVerilog from Antmicro](https://github.com/antmicro/yosys-systemverilog).

### Building Yosys SystemVerilog
```bash
git clone https://github.com/antmicro/yosys-systemverilog.git
cd yosys-systemverilog
git submodule update --init --recursive
./build_binaries
```

You need to add Yosys to your path variable
```bash
export PATH=<path>/<to>/yosys-systemverilog/image.bin:$PATH
```

## Running

Running the current state, run the following commands in this F4PGA directory:
```bash
source source_to_start.sh
make
```

## Current state

I have not yet found a replacement for the proprietary BSCANE2 JTAG IP from Xilinx. Currently the Makefile refers to the Vivado install, which would render this work useless.

Currently the `symbiflow-pack` command is failing because it cannot find a flip-flop primitive LDCE.
