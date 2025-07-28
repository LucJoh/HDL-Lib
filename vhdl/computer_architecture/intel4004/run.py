from vunit import VUnit
from os.path import join, dirname

VU = VUnit.from_argv()
VU.add_vhdl_builtins()  # Add the VHDL builtins explicitly!

ROOT = dirname(__file__)

#      __            _
#     / /___  ____ _(_)____
#    / / __ \/ __ `/ / ___/
#   / / /_/ / /_/ / / /__
#  /_/\____/\__, /_/\___/
#          /____/

logic = VU.add_library("logic")
logic.add_source_files(join(ROOT, "src", "logic", "*.vhdl"))
logic.add_source_files(join(ROOT, "test", "and_gate_tb.vhdl"))
logic.add_source_files(join(ROOT, "test", "not_gate_tb.vhdl"))
logic.set_sim_option("modelsim.init_file.gui", "waves/wave.do")
logic.set_sim_option("ghdl.viewer_script.gui", "waves/wave.tcl")
#logic.set_sim_option("nvc.viewer_script.gui","waves/wave.tcl")

#     ____ ___  __  ___  __
#    / __ `__ \/ / / / |/_/
#   / / / / / / /_/ />  <
#  /_/ /_/ /_/\__,_/_/|_|

mux = VU.add_library("mux")
mux.add_source_files(join(ROOT, "src", "mux", "*.vhdl"))
mux.add_source_files(join(ROOT, "test", "mux2to1_tb.vhdl"))
mux.add_source_files(join(ROOT, "test", "mux4to1_tb.vhdl"))
mux.set_sim_option("modelsim.init_file.gui", "waves/wave.do")
mux.set_sim_option("ghdl.viewer_script.gui", "waves/wave.tcl")
#alu.set_sim_option("nvc.viewer_script.gui","waves/wave.tcl")

#           __
#    ____ _/ /_  __
#   / __ `/ / / / /
#  / /_/ / / /_/ /
#  \__,_/_/\__,_/

alu = VU.add_library("alu")
alu.add_source_files(join(ROOT, "src", "alu", "*.vhdl"))
alu.add_source_files(join(ROOT, "test", "alu_tb.vhdl"))
alu.set_sim_option("modelsim.init_file.gui", "waves/wave.do")
alu.set_sim_option("ghdl.viewer_script.gui", "waves/wave.tcl")
#alu.set_sim_option("nvc.viewer_script.gui","waves/wave.tcl")

""" #         __      __                    __  __
#    ____/ /___ _/ /_____ _____  ____ _/ /_/ /_
#   / __  / __ `/ __/ __ `/ __ \/ __ `/ __/ __ \
#  / /_/ / /_/ / /_/ /_/ / /_/ / /_/ / /_/ / / /
#  \__,_/\__,_/\__/\__,_/ .___/\__,_/\__/_/ /_/
#                      /_/

data_path = VU.add_library("data_path")
data_path.add_source_files(join(ROOT, "src", "data_path", "*.vhdl"))
data_path.add_source_files(join(ROOT, "test", "data_path_tb.vhdl"))
data_path.set_sim_option("modelsim.init_file.gui", "waves/wave.do")
data_path.set_sim_option("ghdl.viewer_script.gui", "waves/wave.tcl")
datapath.set_sim_option("nvc.viewer_script.gui","waves/wave.tcl")

#          __       __               _ __
#    _____/ /______/ /  __  ______  (_) /_
#   / ___/ __/ ___/ /  / / / / __ \/ / __/
#  / /__/ /_/ /  / /  / /_/ / / / / / /_
#  \___/\__/_/  /_/   \__,_/_/ /_/_/\__/

ctrl_unit = VU.add_library("ctrl_unit")
ctrl_unit.add_source_files(join(ROOT, "src", "ctrl_unit", "*.vhdl"))
ctrl_unit.add_source_files(join(ROOT, "test", "ctrl_unit_tb.vhdl"))
ctrl_unit.set_sim_option("modelsim.init_file.gui", "waves/wave.do")
ctrl_unit.set_sim_option("ghdl.viewer_script.gui", "waves/wave.tcl")
ctrl_unit.set_sim_option("nvc.viewer_script.gui","waves/wave.tcl") """

VU.main()
