vim:noet

export VUNIT_SIMULATOR=ghdl

sim_all:
	$(eval VUNIT_SIMULATOR = $(word 2, $(MAKECMDGOALS)))
	python3 run.py

sim_alu:
	$(eval VUNIT_SIMULATOR = $(word 2, $(MAKECMDGOALS)))
	python3 run.py alu.alu_tb.* -v

sim_mux:
	$(eval VUNIT_SIMULATOR = $(word 2, $(MAKECMDGOALS)))
	python3 run.py mux.mux2to1_tb.* mux.mux4to1_tb* -v

sim_logic:
	$(eval VUNIT_SIMULATOR = $(word 2, $(MAKECMDGOALS)))
	python3 run.py logic.and_gate_tb.* logic.not_gate_tb* -v

sim_control:
	$(eval VUNIT_SIMULATOR = $(word 2, $(MAKECMDGOALS)))
	python3 run.py control.pc_tb.* -v

bitstream:
	vivado -mode batch -source vivado_scripts/write_bitstream.tcl

clean:
	rm -rf vunit_out vivado_output *.log *.jou *clockInfo* .Xil

help:
	@echo "$$HEADER"
	@echo "Usage: make [help|sim|sim_write|sim_write_gui|sim_read|sim_read_gui|clean]"
	@echo ""
	@echo "You need to set the simulator to modelsim|ghdl|nvc|rivierapro|activehdl|incisive"
	@echo ""
	@echo "For example: make sim_all ghdl"
	@echo ""
	@echo "  bitstream:       Perform synthesis, implementation and write bitstream"
	@echo "  sim_all          Compile and simulate all testbenches"
	@echo "  sim_alu:         Compile and simulate alu testbenches"
	@echo "  sim_mux          Compile and simulate mux testbenches"
	@echo "  sim_logic        Compile and simulate logic testbenches"
	@echo "  clean:           Remove all generated files"
	@echo ""

define HEADER                               
    _       __       ____ __  ____  ____  __ __
   (_)___  / /____  / / // / / __ \/ __ \/ // /
  / / __ \/ __/ _ \/ / // /_/ / / / / / / // /_
 / / / / / /_/  __/ /__  __/ /_/ / /_/ /__  __/
/_/_/ /_/\__/\___/_/  /_/  \____/\____/  /_/   
                                                    
endef

export HEADER

