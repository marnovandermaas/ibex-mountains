TOP := top_artya7
TARGET := arty_35

BUILDDIR := build
BOARD_BUILDDIR := ${BUILDDIR}/${TARGET}

ROOTDIR := /home/mvdmaas/repos/demo-system-ibex
SOURCES := ${ROOTDIR}/rtl/fpga/top_artya7.sv
SOURCES += ${ROOTDIR}/rtl/system/*.sv
SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/rtl/*.sv
SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/shared/rtl/*.sv
SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/shared/rtl/fpga/xilinx/*.sv
SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/dv/uvm/core_ibex/common/prim/*.sv
#SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim/rtl/*.sv
#SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_pkg.sv
#SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_pkg.sv
SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_*_pkg.sv
SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_sync.sv
SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_sync_cnt.sv
SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_async.sv
SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_flop_2sync.sv
SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_buf.sv
SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_clock_gating.sv
SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_ram_1p.sv
SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim_xilinx/rtl/*.sv
#SOURCES += ${ROOTDIR}/vendor/lowrisc_ibex/vendor/lowrisc_ip/dv/sv/dv_utils/*.svh
SOURCES += ${ROOTDIR}/vendor/pulp_riscv_dbg/src/*.sv
SOURCES += ${ROOTDIR}/vendor/pulp_riscv_dbg/debug_rom/*.sv
SOURCES += /nas/lowrisc/tools/xilinx/Vivado/2021.1/data/verilog/src/xeclib/BSCANE2.v
#SOURCES += /home/mvdmaas/repos/yosys-systemverilog/image/share/yosys/xilinx/cells_sim.v

# Set board properties based on TARGET variable
ifeq ($(TARGET),arty_35)
  DEVICE := xc7a50t_test
  BITSTREAM_DEVICE := artix7
  PARTNAME := xc7a35tcsg324-1
  OFL_BOARD := arty_a7_35t
else ifeq ($(TARGET),arty_100)
  DEVICE := xc7a100t_test
  BITSTREAM_DEVICE := artix7
  PARTNAME := xc7a100tcsg324-1
  OFL_BOARD := arty_a7_100t
else ifeq ($(TARGET),nexys4ddr)
  DEVICE := xc7a100t_test
  BITSTREAM_DEVICE := artix7
  PARTNAME := xc7a100tcsg324-1
  OFL_BOARD := unsupported
else ifeq ($(TARGET),zybo)
  DEVICE := xc7z010_test
  BITSTREAM_DEVICE := zynq7
  PARTNAME := xc7z010clg400-1
  OFL_BOARD := zybo_z7_10
else ifeq ($(TARGET),nexys_video)
  DEVICE := xc7a200t_test
  BITSTREAM_DEVICE := artix7
  PARTNAME := xc7a200tsbg484-1
  OFL_BOARD := nexysVideo
else ifeq ($(TARGET),basys3)
  DEVICE := xc7a50t_test
  BITSTREAM_DEVICE := artix7
  PARTNAME := xc7a35tcpg236-1
  OFL_BOARD := $(TARGET)
else
  $(error Unsupported board type)
endif

# Determine the type of constraint being used
ifneq (${XDC},)
  XDC_CMD := -x ${XDC}
endif
ifneq (${SDC},)
  SDC_CMD := -s ${SDC}
endif
ifneq (${PCF},)
  PCF_CMD := -p ${PCF}
endif

# Determine if we should use Surelog/UHDM to read sources
ifneq (${SURELOG_CMD},)
  SURELOG_OPT := -s ${SURELOG_CMD}
endif

.DELETE_ON_ERROR:

# Build design
all: ${BOARD_BUILDDIR}/${TOP}.bit

${BOARD_BUILDDIR}:
	mkdir -p ${BOARD_BUILDDIR}

${BOARD_BUILDDIR}/${TOP}.eblif: ${SOURCES} ${XDC} ${SDC} ${PCF} | ${BOARD_BUILDDIR}
	cd ${BOARD_BUILDDIR} && symbiflow_synth -t ${TOP} ${SURELOG_OPT} -v ${SOURCES} -d ${BITSTREAM_DEVICE} -p ${PARTNAME} ${XDC_CMD} -s "-sv -noassert -DSYNTHESIS -I/home/mvdmaas/repos/demo-system-ibex/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim/rtl -I/home/mvdmaas/repos/demo-system-ibex/vendor/lowrisc_ibex/vendor/lowrisc_ip/ip/prim_generic/rtl -I/home/mvdmaas/repos/demo-system-ibex/vendor/lowrisc_ibex/vendor/lowrisc_ip/dv/sv/dv_utils"

${BOARD_BUILDDIR}/${TOP}.net: ${BOARD_BUILDDIR}/${TOP}.eblif
	cd ${BOARD_BUILDDIR} && symbiflow_pack -e ${TOP}.eblif -d ${DEVICE} ${SDC_CMD} 2>&1 > /dev/null

${BOARD_BUILDDIR}/${TOP}.place: ${BOARD_BUILDDIR}/${TOP}.net
	cd ${BOARD_BUILDDIR} && symbiflow_place -e ${TOP}.eblif -d ${DEVICE} ${PCF_CMD} -n ${TOP}.net -P ${PARTNAME} ${SDC_CMD} 2>&1 > /dev/null

${BOARD_BUILDDIR}/${TOP}.route: ${BOARD_BUILDDIR}/${TOP}.place
	cd ${BOARD_BUILDDIR} && symbiflow_route -e ${TOP}.eblif -d ${DEVICE} ${SDC_CMD} 2>&1 > /dev/null

${BOARD_BUILDDIR}/${TOP}.fasm: ${BOARD_BUILDDIR}/${TOP}.route
	cd ${BOARD_BUILDDIR} && symbiflow_write_fasm -e ${TOP}.eblif -d ${DEVICE}

${BOARD_BUILDDIR}/${TOP}.bit: ${BOARD_BUILDDIR}/${TOP}.fasm
	cd ${BOARD_BUILDDIR} && symbiflow_write_bitstream -d ${BITSTREAM_DEVICE} -f ${TOP}.fasm -p ${PARTNAME} -b ${TOP}.bit

download: ${BOARD_BUILDDIR}/${TOP}.bit
	if [ $(TARGET)='unsupported' ]; then \
	  echo "The commands needed to download the bitstreams to the board type specified are not currently supported by the F4PGA makefiles. \
    Please see documentation for more information."; \
	fi
	openFPGALoader -b ${OFL_BOARD} ${BOARD_BUILDDIR}/${TOP}.bit

clean:
	rm -rf ${BUILDDIR}
