# OpenROAD-flow-scripts config: Croc SoC with the AES accelerator on SkyWater 130 nm (sky130hd).
# Core-level hardening of croc_soc: no IO pads. Memories are flip-flop based (sky130/tc_sram_impl.sv).
# Run with asic/sky130/run_orfs.sh croc   (see asic/sky130/README.md)
CROC_ROOT := $(abspath $(dir $(DESIGN_CONFIG))../../..)
include $(dir $(DESIGN_CONFIG))files.mk

export DESIGN_NICKNAME = croc
export DESIGN_NAME     = croc_soc
export PLATFORM        = sky130hd

export SYNTH_HDL_FRONTEND  = slang
export VERILOG_FILES       = $(CROC_VERILOG_FILES)
export VERILOG_INCLUDE_DIRS = $(CROC_INCLUDE_DIRS)
export VERILOG_DEFINES     = -D SYNTHESIS -D COMMON_CELLS_ASSERTS_OFF -D TARGET_ASIC -D TARGET_SKY130 -D TARGET_SYNTHESIS -D TARGET_RTL
export SDC_FILE            = $(dir $(DESIGN_CONFIG))constraint.sdc
export SYNTH_CANONICALIZE_TCL = $(dir $(DESIGN_CONFIG))canonicalize.tcl

# Hierarchy is flattened after synthesis; keep it during synth for readable reports
export SYNTH_HIERARCHICAL = 0

# Each SRAM bank is 512x32 = 16384 flip-flops; let Yosys build it
export SYNTH_MEMORY_MAX_BITS = 16384

export CORE_UTILIZATION = 35
export PLACE_DENSITY    = 0.55

# After detail routing, ORFS inserts antenna diodes and reroutes, which for the
# whole SoC is a second multi-hour detail route. Skip it; leftover antenna
# violations are reported in 6_finish / drt_antennas.log.
export SKIP_ANTENNA_REPAIR_POST_DRT ?= 1
