# Run inside Yosys (SYNTH_CANONICALIZE_TCL).
# Croc and common_cells mark cells with (* dont_touch = "true" *). OpenROAD's
# Verilog reader expects an integer there and fails in link_design, so drop the
# attribute; the cells that matter also carry (* keep *), which Yosys honours.
setattr -unset dont_touch
setattr -mod -unset dont_touch
