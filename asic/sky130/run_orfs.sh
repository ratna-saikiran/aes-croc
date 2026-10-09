#!/bin/bash
# Run a design through OpenROAD-flow-scripts (sky130hd) in Docker, from RTL to GDS.
# Usage: asic/sky130/run_orfs.sh <aes|croc> [make target]
#   asic/sky130/run_orfs.sh croc              # full flow, ends with the GDS
#   asic/sky130/run_orfs.sh croc gui_final    # needs X11 forwarding
# Results: asic/sky130/build/{logs,reports,results}/sky130hd/<design>/base/
# On Apple Silicon the image runs under emulation; set DOCKER_PLATFORM=linux/amd64 if Docker asks.
#
# For croc the full flow runs in three parts: up to detail routing, then
# scripts/repair_antennas_post_route.tcl (diodes + incremental reroute, with a
# checkpoint per pass, so it can be rerun after an interruption), then fill
# and the final report.
set -euo pipefail
design="${1:?usage: run_orfs.sh <aes|croc> [make target]}"
repo="$(cd "$(dirname "$0")/../.." && pwd)"
mkdir -p "$repo/asic/sky130/build"
mk="make DESIGN_CONFIG=/work/asic/sky130/$design/config.mk WORK_HOME=/work/asic/sky130/build"
if [ "$design" = croc ] && [ -z "${2:-}" ]; then
  steps="$mk /work/asic/sky130/build/results/sky130hd/croc/base/5_2_route.odb && \
         $mk run RUN_SCRIPT=/work/asic/sky130/scripts/repair_antennas_post_route.tcl RUN_LOG_NAME_STEM=5_2_antenna && \
         $mk"
else
  steps="$mk ${2:-}"
fi
docker run --rm ${DOCKER_PLATFORM:+--platform $DOCKER_PLATFORM} \
  -v "$repo":/work \
  openroad/orfs:latest \
  bash -c "source ./env.sh >/dev/null && cd flow && $steps"
