vim:noet

export VUNIT_SIMULATOR=ghdl

sim:
	$(eval VUNIT_SIMULATOR = $(word 2, $(MAKECMDGOALS)))
	python3 run.py -v

sim_multhread:
	$(eval VUNIT_SIMULATOR = $(word 2, $(MAKECMDGOALS)))
	python3 run.py -v -p 6

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
	@echo "For example: make sim_multread ghdl"
	@echo ""
	@echo "  bitstream:       Perform synthesis, implementation and write bitstream"
	@echo "  sim:             Compile and simulate all test cases"
	@echo "  sim_multhread:   Compile and simulate all test cases (using 2 cpu cores)"
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

