# TDM VHDL Compilation and Simulation with CMake and VUnit

This directory contains the necessary files and CMakeLists, to manage VHDL simulation and compilation tasks for the TDM project.

## Prerequisites

Ensure you have the following tools installed on your system:

* Vivado (for generating bitstream)
* CMake (3.10 or newer)
* Make (for Unix) or MinGW (for Windows)
* One of the following simulators:
  - ModelSim
  - GHDL
  - NVC
  - Riviera-PRO
  - Active-HDL
  - Incisive
* GTKWave (required for waveform viewing when using GHDL or NVC)
* Python 3.0 (or newer)
* VUnit 5.0.0 (installed using pip)
```sh
  pip install vunit_hdl==5.0.0.dev5
```

## Generate bitstream

```sh
  vivado -mode batch -source vivado_scripts/write_bitstream.tcl
```

## Build the project

Unix
```sh
  mkdir build &&
  cd build &&
  cmake -DSIM=modelsim .. 
```

Windows
```sh
  mkdir build &&
  cd build &&
  cmake -G "MinGW Makefiles" -DSIM=modelsim .. 
```

## Simulation

Run all testcases
```sh
  make sim
```

Run all testcases in parallel
```sh
  make sim_multhread
```

Run testcase 1 with waveform window
```sh
  make sim_gui
```
