from vunit import VUnit
from os.path import join, dirname

VU = VUnit.from_argv()
VU.add_vhdl_builtins()  # Add the VHDL builtins explicitly!

ROOT = dirname(__file__)

#           __     
#    ____ _/ /_  __
#   / __ `/ / / / /
#  / /_/ / / /_/ / 
#  \__,_/_/\__,_/

alu = VU.add_library("alu")
alu.add_source_files(join(ROOT, "src", "alu", "*.vhdl"))
alu.add_source_files(join(ROOT, "test", "alu_tb.vhdl"))

alu.set_sim_option("modelsim.init_file.gui","waves/wave.do")
alu.set_sim_option("ghdl.viewer_script.gui","waves/wave.tcl")
#i2c.set_sim_option("nvc.viewer_script.gui","waves/wave.tcl")

VU.main()
