# ---------------------------------------
# Default simulator (override with SIM=...)
# ---------------------------------------
SIM ?= modelsim
export VUNIT_SIMULATOR := $(SIM)

VENV := .venv
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip
VUNIT := $(PYTHON) run.py

REQS := py-requirements.txt
VENV_MARKER := $(VENV)/.installed

.PHONY: setup sim_all sim_alu sim_mux sim_logic sim_control sim_data_path_core bitstream clean help

# ---------------------------------------
# Environment setup
# ---------------------------------------
$(VENV_MARKER): $(REQS)
	@if [ ! -d $(VENV) ]; then python3 -m venv $(VENV); fi
	$(PIP) install --upgrade pip
	$(PIP) install -r $(REQS)
	touch $(VENV_MARKER)

setup: $(VENV_MARKER)

# ---------------------------------------
# Simulation targets
# ---------------------------------------
sim_all: setup
	$(VUNIT)

sim_alu: setup
	$(VUNIT) alu.alu_tb.* -v

sim_mux: setup
	$(VUNIT) mux.mux2to1_tb.* mux.mux4to1_tb.* -v

sim_logic: setup
	$(VUNIT) logic.and_gate_tb.* logic.not_gate_tb.* -v

sim_control: setup
	$(VUNIT) control.pc_tb.* -v

sim_data_path_core: setup
	$(VUNIT) data_path.data_path_core_tb.* -v

# ---------------------------------------
# Bitstream (Vivado)
# ---------------------------------------
bitstream: setup
	vivado -mode batch -source vivado_scripts/write_bitstream.tcl

# ---------------------------------------
# Cleanup
# ---------------------------------------
clean:
	rm -rf vunit_out vivado_output *.log *.jou *clockInfo* .Xil
	rm -f $(VENV_MARKER)

# ---------------------------------------
# Help
# ---------------------------------------
help:
	@echo "$$HEADER"
	@echo "Usage:"
	@echo "  make <target> [SIM=modelsim|ghdl|nvc|...]"
	@echo ""
	@echo "Examples:"
	@echo "  make sim_all SIM=modelsim"
	@echo "  make sim_data_path_core SIM=ghdl"
	@echo ""
	@echo "Targets:"
	@echo "  setup"
	@echo "  sim_all"
	@echo "  sim_alu"
	@echo "  sim_mux"
	@echo "  sim_logic"
	@echo "  sim_control"
	@echo "  sim_data_path_core"
	@echo "  bitstream"
	@echo "  clean"
	@echo ""

define HEADER
    _       __       ____ __  ____  ____  __ __
   (_)___  / /____  / / // / / __ \/ __ \/ // /
  / / __ \/ __/ _ \/ / // /_/ / / / / / / // /_
 / / / / / /_/  __/ /__  __/ /_/ / /_/ /__  __/
/_/_/ /_/\__/\___/_/  /_/  \____/\____/  /_/
endef

export HEADER
