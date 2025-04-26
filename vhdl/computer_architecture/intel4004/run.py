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
alu.add_source_files(join(ROOT, "src", "mux", "*.vhdl"))
alu.add_source_files(join(ROOT, "test", "alu_tb.vhdl"))

alu.set_sim_option("modelsim.init_file.gui","waves/wave.do")
alu.set_sim_option("ghdl.viewer_script.gui","waves/wave.tcl")
#alu.set_sim_option("nvc.viewer_script.gui","waves/wave.tcl")

#         __      __                    __  __  
#    ____/ /___ _/ /_____ _____  ____ _/ /_/ /_ 
#   / __  / __ `/ __/ __ `/ __ \/ __ `/ __/ __ \
#  / /_/ / /_/ / /_/ /_/ / /_/ / /_/ / /_/ / / /
#  \__,_/\__,_/\__/\__,_/ .___/\__,_/\__/_/ /_/ 
#                      /_/                      

data_path = VU.add_library("data_path")
data_path.add_source_files(join(ROOT, "src", "alu", "*.vhdl"))
data_path.add_source_files(join(ROOT, "src", "mux", "*.vhdl"))
data_path.add_source_files(join(ROOT, "src", "data_path", "*.vhdl"))
data_path.add_source_files(join(ROOT, "test", "data_path_tb.vhdl"))

data_path.set_sim_option("modelsim.init_file.gui","waves/wave.do")
data_path.set_sim_option("ghdl.viewer_script.gui","waves/wave.tcl")
#datapath.set_sim_option("nvc.viewer_script.gui","waves/wave.tcl")

VU.main()
