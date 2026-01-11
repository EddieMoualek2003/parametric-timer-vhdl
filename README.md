# Parametric Timer (VHDL)
This repository contains a parametric, synthesizable VHDL timer module together with self-checking simulation tests and formal verification. The design is verified using both VUnit (GHDL) and PSL + SymbiYosys, with continuous integration enforcing correctness with every push.

## Overview
The timer asserts a `done_o` signal after a specified delay, which is defined by:
 - `clk_freq_hz_g` : An input clock frequency
 - `delay_g` : A requested delay

The delay is computed at elaboration time into an integer number of clock cycles using the ceiling operation. This ensures the timer **never expires earlier than requested**.

### Reset Strategy
The timer uses an active-high synchronous reset (`arst_i`), which is sampled on the rising edge of the clock. This choice was made deliberately for the following reasons:
 - The timer's behaviour is entirely clock-driven, and all state transitions are synchronous.
 - Synchronous resets avoid introducing an additional asynchronous path into the design. This simplifies both the timing analysis and the formal verification.
 - Reset behaviour is fully deterministic and aligned with the clock domain in which the timer operates.

The formal properties and simulation testbench explicitly model and verify the reset behaviour, including eventual reset deassertion before normal operation.

## Design Files
 - `src/timer.vhd`
    - Parametric timer RTL implementation
 - `src/timer_wrapper.vhd`
    - Wrapper used for formal verification, instantiating the timer with fixed parameters, due to SymbiYosys's inability to directly handle `time` generics for VHDL.
 - `src/timer.psl`
    - PSL properties proving correct timer behaviour.

## Verification Strategy
### 1. Simulation-Based Verification - VUnit
A self-checking testbench verifies that:
 - `done_o` deasserts when the timer starts.
 - `done_o` asserts after the correct number of cycles.
 - Behaviour is synchronous to the rising clock edge.

**Testbench**:
 - `tb/tb_timer.vhd`

**Test name**:
 - `done_o_self_checking`

The testbench computes the expected delay in cycles independently and checks the DUT output using VUnit assertions.

**To run locally**
 - Ensure you are in the root folder.
 - Run

```bash
python3 run.py
```
### 2. Formal Verification (PSL + SymbiYosys)
Formal verification is used to prove that:
 - The timer always asserts `done_o` exactly after the specified number of cycles.
 - No invalid transitions occur in the idle state.
 - Reset behaviour is correctly handled.

**Key files**:
 - `src/timer.psl`
 - `src/timer_vhdl.sby`
 - `src/timer_wrapper.vhd`

**To run locally**:
 - Ensure OSS CAD has been installed. The version used for this test is the one linked in the task
 - Enable the OSS CAD Suite environment
 - Ensure you are in the root folder
 - run
```bash
sby -f src/timer_vhdl.sby
```
Bounded model checking is sufficient as the timing behaviour is fixed-cycle.

## Continuous Integration
Two GitHub Action workflows are configured:
 1. Parametric Timer - VHDL CI (VUnit + GHDL)
    - This runs the self-checking simulation tests using VUnit and GHDL
 2. Formal Verification (OSS CAD Suite)
    - Runs PSL-based formal verification using SymbiYosys.

Both workflows run automatically on every push and pull request. The CI history also demonstrates intentional failures and recovery, which validate the checks are effective.

## Notes
 - Generated simulation and formal artifacts are excluded via `.gitignore`.
 - The design assumes a valid, non-zero delay configuration.
 - The wrapper exists solely to bind concrete generics for formal verification.

## Tooling and Environment
Development and verification were performed on Ubuntu 22.04 using standard open-source tools, including GHDL, GTKWave, VUnit, and the OSS CAD Suite. The continuous integration workflows mirror this environment to ensure consistency between local development and automated verification.
