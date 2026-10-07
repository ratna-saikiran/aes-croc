# OpenROAD-flow-scripts config: AES-128 core on SkyWater 130 nm (sky130hd).
# Run with asic/sky130/run_orfs.sh aes   (see asic/sky130/README.md)
export DESIGN_NICKNAME = aes_core
export DESIGN_NAME     = aes_core
export PLATFORM        = sky130hd

# aes_core.v is generated from rtl/user_domain/aes/*.sv with sv2v
export VERILOG_FILES = $(dir $(DESIGN_CONFIG))aes_core.v
export SDC_FILE      = $(dir $(DESIGN_CONFIG))constraint.sdc

export CORE_UTILIZATION = 40
export PLACE_DENSITY    = 0.60
