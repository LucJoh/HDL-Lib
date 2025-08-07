from vunit import VUnit
from os.path import join, dirname

VU = VUnit.from_argv()
VU.add_vhdl_builtins()  # Add the VHDL builtins explicitly!

ROOT = dirname(__file__)

#   _             _
#  | | ___   __ _(_) ___
#  | |/ _ \ / _` | |/ __|
#  | | (_) | (_| | | (__
#  |_|\___/ \__, |_|\___|
#           |___/

logic = VU.add_library("logic")
logic.add_source_files(join(ROOT, "src", "logic", "*.vhdl"))
logic.add_source_files(join(ROOT, "test", "and_gate_tb.vhdl"))
logic.add_source_files(join(ROOT, "test", "not_gate_tb.vhdl"))

#   _ __ ___  _   ___  __
#  | '_ ` _ \| | | \ \/ /
#  | | | | | | |_| |>  <
#  |_| |_| |_|\__,_/_/\_\

mux = VU.add_library("mux")
mux.add_source_files(join(ROOT, "src", "mux", "*.vhdl"))
mux.add_source_files(join(ROOT, "test", "mux2to1_tb.vhdl"))
mux.add_source_files(join(ROOT, "test", "mux4to1_tb.vhdl"))

#         _
#    __ _| |_   _
#   / _` | | | | |
#  | (_| | | |_| |
#   \__,_|_|\__,_|

alu = VU.add_library("alu")
alu.add_source_files(join(ROOT, "src", "alu", "*.vhdl"))
alu.add_source_files(join(ROOT, "test", "alu_tb.vhdl"))

#                   _             _
#    ___ ___  _ __ | |_ _ __ ___ | |
#   / __/ _ \| '_ \| __| '__/ _ \| |
#  | (_| (_) | | | | |_| | | (_) | |
#   \___\___/|_| |_|\__|_|  \___/|_|

control = VU.add_library("control")
control.add_source_files(join(ROOT, "src", "control", "*.vhdl"))
control.add_source_files(join(ROOT, "test", "pc_tb.vhdl"))

#   _ __ ___   ___ _ __ ___   ___  _ __ _   _
#  | '_ ` _ \ / _ \ '_ ` _ \ / _ \| '__| | | |
#  | | | | | |  __/ | | | | | (_) | |  | |_| |
#  |_| |_| |_|\___|_| |_| |_|\___/|_|   \__, |
#                                       |___/

memory = VU.add_library("memory")
memory.add_source_files(join(ROOT, "src", "memory", "*.vhdl"))
#memory.add_source_files(join(ROOT, "test", "memory_tb.vhdl"))

##       _       _                    _   _
##    __| | __ _| |_ __ _ _ __   __ _| |_| |__
##   / _` |/ _` | __/ _` | '_ \ / _` | __| '_ \
##  | (_| | (_| | || (_| | |_) | (_| | |_| | | |
##   \__,_|\__,_|\__\__,_| .__/ \__,_|\__|_| |_|
##                       |_|
#
#data_path = VU.add_library("data_path")
#data_path.add_source_files(join(ROOT, "src", "data_path", "*.vhdl"))
#data_path.add_source_files(join(ROOT, "test", "data_path_tb.vhdl"))

VU.main()
