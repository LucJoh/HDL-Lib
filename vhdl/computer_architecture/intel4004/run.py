from vunit import VUnit
from os.path import join, dirname
from pathlib import Path

VU = VUnit.from_argv()
VU.add_vhdl_builtins()
ROOT = Path(__file__).parent

libraries = {
    "logic":   ("src/logic", "test/logic"),
    "mux":     ("src/mux", "test/mux"),
    "alu":     ("src/alu", "test/alu"),
    "control": ("src/control", "test/control"),
    "memory":  ("src/memory", None),
    "data_path": ("src/data_path", "test/data_path"),
}

for lib_name, (src_dir, test_dir) in libraries.items():
    lib = VU.add_library(lib_name)
    lib.add_source_files(str(ROOT / src_dir / "*.vhdl"))
    if test_dir:
        lib.add_source_files(str(ROOT / test_dir / "*.vhdl"))

VU.set_sim_option("modelsim.vsim_flags", ["-voptargs=+acc"])

VU.main()

