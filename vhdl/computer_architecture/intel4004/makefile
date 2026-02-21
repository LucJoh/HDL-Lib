# ---------------------------------------
# Default simulator (override with SIM=...)
# ---------------------------------------
SIM ?= modelsim
export VUNIT_SIMULATOR=$(SIM)

PYTHON := python3
VUNIT  := $(PYTHON) run.py

# ---------------------------------------
# Simulation targets
# ---------------------------------------
sim_all:
	$(VUNIT)

sim_alu:
	$(VUNIT) alu.alu_tb.* -v

sim_mux:
	$(VUNIT) mux.mux2to1_tb.* mux.mux4to1_tb.* -v

sim_logic:
	$(VUNIT) logic.and_gate_tb.* logic.not_gate_tb.* -v

sim_control:
	$(VUNIT) control.pc_tb.* -v

sim_data_path_core:
	$(VUNIT) data_path.data_path_core_tb.* -v

# ---------------------------------------
# Bitstream (Vivado)
# ---------------------------------------
bitstream:
	vivado -mode batch -source vivado_scripts/write_bitstream.tcl

# ---------------------------------------
# Cleanup
# ---------------------------------------
clean:
	rm -rf vunit_out vivado_output *.log *.jou *clockInfo* .Xil

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
