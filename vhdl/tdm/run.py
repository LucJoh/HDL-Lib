from vunit import VUnit
from os.path import join, dirname

VU = VUnit.from_argv()
VU.add_vhdl_builtins()  # Add the VHDL builtins explicitly!

ROOT = dirname(__file__)

tdm_rx = VU.add_library("tdm_rx")
tdm_rx.add_source_files(join(ROOT, "src", "*.vhdl"))
tdm_rx.add_source_files(join(ROOT, "test", "*.vhdl"))

# Add waveform automatically when running in GUI mode.
tdm_rx.set_sim_option("modelsim.init_file.gui","waves/wave.do")
tdm_rx.set_sim_option("ghdl.viewer_script.gui","waves/wave.tcl")
#i2c.set_sim_option("nvc.viewer_script.gui","waves/wave.tcl")

VU.main()
