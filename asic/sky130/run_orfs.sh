#!/bin/bash
# Run a design through OpenROAD-flow-scripts (sky130hd) in Docker, from RTL to GDS.
# Usage: asic/sky130/run_orfs.sh <aes|croc> [make target]
#   asic/sky130/run_orfs.sh croc              # full flow, ends with the GDS
#   asic/sky130/run_orfs.sh croc gui_final    # needs X11 forwarding
# Results: asic/sky130/build/{logs,reports,results}/sky130hd/<design>/base/
# On Apple Silicon the image runs under emulation; set DOCKER_PLATFORM=linux/amd64 if Docker asks.
set -euo pipefail
design="${1:?usage: run_orfs.sh <aes|croc> [make target]}"
repo="$(cd "$(dirname "$0")/../.." && pwd)"
mkdir -p "$repo/asic/sky130/build"
docker run --rm ${DOCKER_PLATFORM:+--platform $DOCKER_PLATFORM} \
  -v "$repo":/work \
  openroad/orfs:latest \
  bash -c "source ./env.sh >/dev/null && cd flow && \
           make DESIGN_CONFIG=/work/asic/sky130/$design/config.mk WORK_HOME=/work/asic/sky130/build ${2:-}"
