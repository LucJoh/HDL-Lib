# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.30

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/lucas/documents/github/HDL-Lib/vhdl/communication_protocols/tdm

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/lucas/documents/github/HDL-Lib/vhdl/communication_protocols/tdm/build

# Utility rule file for sim.

# Include any custom commands dependencies for this target.
include CMakeFiles/sim.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/sim.dir/progress.make

CMakeFiles/sim:
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/home/lucas/documents/github/HDL-Lib/vhdl/communication_protocols/tdm/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Simulating all testcases"
	cd /home/lucas/documents/github/HDL-Lib/vhdl/communication_protocols/tdm && /usr/bin/cmake -E env VUNIT_SIMULATOR=ghdl python3 run.py -v

sim: CMakeFiles/sim
sim: CMakeFiles/sim.dir/build.make
.PHONY : sim

# Rule to build all files generated by this target.
CMakeFiles/sim.dir/build: sim
.PHONY : CMakeFiles/sim.dir/build

CMakeFiles/sim.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/sim.dir/cmake_clean.cmake
.PHONY : CMakeFiles/sim.dir/clean

CMakeFiles/sim.dir/depend:
	cd /home/lucas/documents/github/HDL-Lib/vhdl/communication_protocols/tdm/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/lucas/documents/github/HDL-Lib/vhdl/communication_protocols/tdm /home/lucas/documents/github/HDL-Lib/vhdl/communication_protocols/tdm /home/lucas/documents/github/HDL-Lib/vhdl/communication_protocols/tdm/build /home/lucas/documents/github/HDL-Lib/vhdl/communication_protocols/tdm/build /home/lucas/documents/github/HDL-Lib/vhdl/communication_protocols/tdm/build/CMakeFiles/sim.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/sim.dir/depend

