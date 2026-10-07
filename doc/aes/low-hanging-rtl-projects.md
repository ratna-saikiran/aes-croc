# Low-hanging RTL projects to bring up on PULP

Goal: small RTL blocks you can write yourself, attach to an open PULP SoC, and grow toward a chip with an Indian commercial use.

## Which PULP platform to start on

| Platform | Use it for | Why |
|---|---|---|
| **X-HEEP** (EPFL, built on PULP IPs) | **Start here** | Made to be extended. Has documented "eXtending" flow for adding your own peripheral on its bus or an accelerator on the CV-X-IF coprocessor port, Verilator sim, and ready FPGA targets (Pynq-Z2, Nexys). |
| **PULPissimo** | Peripherals that stream data (ADC, sensors) | Its uDMA moves data from peripherals into memory without the CPU, which suits filters and correlators. |
| **Croc** (PULP's teaching SoC) | Your first tapeout | Minimal SoC that is taped out on the open IHP 130 nm PDK with open EDA tools; easy place to drop in a finished block. |
| **Cheshire** | Later, if you need Linux | Linux-capable CVA6 SoC. Too heavy for a first project. |

Bring-up ladder for every project below: **Python golden model → RTL unit test (Verilator + cocotb) → attach to X-HEEP in simulation, driven by a C program → FPGA board → tapeout** (Croc on IHP 130 nm, or an Indian MPW shuttle such as SCL 180 nm via the ChipIN/C2S programmes; check current shuttle dates).

## Ranked list

### 1. AES-128-GCM crypto accelerator for smart meters (best first project)
- **Indian pull:** the RDSS scheme is rolling out roughly 250 million prepaid smart meters. Indian smart meters follow IS 16444 and use DLMS/COSEM, whose security suite is AES-128-GCM. Every meter SoC needs this block; it also serves POS/UPI terminals and IoT gateways.
- **What to build:** AES-128 round engine (iterative, one round per cycle, ~1 day of RTL), then add GHASH (GF(2^128) multiplier) for GCM.
- **How it attaches:** memory-mapped peripheral on X-HEEP's bus (key, IV, data, status registers), later fed by X-HEEP's DMA.
- **First step:** write the AES core, verify it in cocotb against the NIST FIPS-197 test vectors, then call it from a C program running on X-HEEP in Verilator.

### 2. Energy-metering front end (decimation filter + Vrms/Irms/power)
- **Indian pull:** same smart-meter market. The metrology part (turning sigma-delta ADC bitstreams into voltage, current, active power and energy) is what meter chip vendors sell; today it is mostly imported.
- **What to build:** CIC decimator → small FIR compensator → multiply-accumulate block for V×I, squared sums for RMS, and an energy pulse counter.
- **How it attaches:** PULPissimo uDMA channel (or an X-HEEP peripheral) streaming samples into memory; registers for calibration gains.
- **First step:** model the CIC + FIR in Python with a synthetic 50 Hz waveform plus harmonics, then write the CIC in RTL and match the model bit-exactly.

### 3. NavIC (IRNSS) baseband correlator
- **Indian pull:** AIS-140 vehicle-tracking devices (trucks, buses, taxis) are required to support NavIC, and the government has been pushing NavIC into phones. An indigenous NavIC baseband block is a clear "Make in India" story.
- **What to build:** NavIC L5 SPS PRN code generator (Gold-code LFSRs from the public ICD), carrier NCO, and a bank of early/prompt/late correlators with integrate-and-dump.
- **How it attaches:** peripheral with a sample input port and accumulator registers read by the CPU; the CPU (X-HEEP or PULPissimo) runs acquisition and tracking loops in C.
- **First step:** implement the PRN generator in RTL and check the first chips of every satellite code against the NavIC SPS ICD tables. That alone is a small, satisfying milestone.
- **Note:** you will need an RF front end chip (off the shelf) feeding samples; keep that off-chip for now.

### 4. CAN-FD controller for EV battery management and two-wheelers
- **Indian pull:** India's EV two- and three-wheeler market is large and growing, and every BMS, motor controller and charger talks CAN.
- **What to build:** CAN 2.0 first (bit timing, bit stuffing, CRC-15, arbitration, error counters), then CAN-FD. The open CTU CAN FD core is a good reference to study, not copy.
- **How it attaches:** standard APB/OBI peripheral with TX/RX FIFOs and an interrupt to the core.
- **First step:** build the bit-timing and bit-stuffing logic, loop TX to RX in simulation, then talk to a USB-CAN dongle from the FPGA board.

### 5. Tiny ML accelerator on the CV-X-IF coprocessor port
- **Indian pull:** low-cost edge AI for agriculture sensors, keyword spotting in Indian languages, and predictive maintenance in factories.
- **What to build:** custom RISC-V instructions for 8-bit SIMD dot product and MAC with saturation, issued through X-HEEP's CV-X-IF port.
- **How it attaches:** CV-X-IF (the core-to-coprocessor interface on X-HEEP's CV32E40X/PX cores); the compiler gets the instructions via inline assembly.
- **First step:** follow X-HEEP's CV-X-IF configuration guide, add one instruction (4×int8 dot product), and benchmark a small matrix multiply against plain C.

## My recommendation

Start with **#1 (AES)** on **X-HEEP** this week: it is self-contained, has official test vectors so you always know if you are right, and the smart-meter market makes it commercially credible. Then do **#2** so the two together form the core of a smart-meter SoC, which is a realistic Indian commercial chip to aim for. Keep #3 as the stretch project with the strongest national-interest story.

## Sources
- X-HEEP: extending hardware — https://x-heep.readthedocs.io/en/latest/Extending/eXtendingHW.html
- X-HEEP: CV-X-IF configuration — https://x-heep.readthedocs.io/en/latest/Configuration/XIFConfiguration.html
- Croc SoC — https://github.com/pulp-platform/croc
- PULP open-source idea-to-silicon flow (DAC 2025) — https://pulp-platform.org/docs/dac2025/Marco_Bertuletti_OpenSourceFromIdeastoSiliconPULPTeaching&ResearchwithOpenIPsEDAsPDKs_DAC.pdf
- India DLI scheme overview — https://www.india-briefing.com/news/india-design-linked-incentive-scheme-semiconductor-sector-supply-chain-40767.html

Market facts on RDSS meter numbers, IS 16444/DLMS security and AIS-140 NavIC support are from my own knowledge, not re-checked in this pass; verify before using them in a pitch.
