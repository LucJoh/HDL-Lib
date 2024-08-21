# UART Rx VHDL Simulation and Compilation with Makefile

This directory contains the necessary files and a Makefile to manage VHDL simulation and compilation tasks for the UART Rx project using ModelSim, GHDL, or NVC.

# src/uart\_pkg.vhdl

The package file contains parameters that dictates the UART operation.

- sys\_clk\_period: System clock period (ns)
- baud\_rate: Baud rate (bps)
- datawidth: Data width

## Prerequisites

Ensure you have at least one of the following tools installed on your system:

- ModelSim
- GHDL 
- NVC 
- GTKWave (required for waveform viewing when using GHDL or NVC)

## Usage

The Makefile supports various targets to help you manage your simulation and compilation workflow. Below are the available targets and their descriptions:

# help
- Purpose: Display a list of available targets and their descriptions.
- Usage:

  *make help*

# init
- Purpose: Initialize the design library and generate a copy of modelsim.ini.
- Usage:

  *make init*

# vcom
- Purpose: Compile the design using ModelSim.
- Usage:  

  *make vcom*

# vsim
- Purpose: Simulate the design using ModelSim (GUI mode).
- Usage:  

  *make vsim*

# vsimb
- Purpose: Simulate the design using ModelSim in batch mode.
- Usage:  

  *make vsimb*

# all
- Purpose: Compile and simulate the design using ModelSim (GUI mode).
- Usage:  

  *make all*

# ghdl
- Purpose: Compile and simulate the design using GHDL.
- Usage: 

  *make ghdl*

- To view waveforms with GTKWave, run:
  *gtkwave wave.ghw*
- To save waveform configuration:
  Inside GTKWave, go to File -> Write Save File.
- To load waveform configuration:
  gtkwave wave.ghw config.gtkw

# nvc
- Purpose: Compile and simulate the design using NVC.
- Usage:  

  *make nvc*

- To view waveforms with GTKWave, run:
  *gtkwave wave.ghw*
- To save waveform configuration:
  Inside GTKWave, go to File -> Write Save File.
- To load waveform configuration:
  gtkwave wave.ghw config.gtkw

# clean
- Purpose: Remove all generated files.
- Usage:  

  *make clean*

## Example Workflow with ModelSim

1. Initialize the project:  

  *make init*

2. Compile and open the simulation in the GUI:  

  *make all*