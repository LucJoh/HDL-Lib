cmake_minimum_required(VERSION 3.10)

project(VUnitProject)

# Set a default simulator if not specified
set(SIM "ghdl" CACHE STRING "Default simulator")

# Function to add custom targets for each test case
function(add_sim_target target_name frame)
    add_custom_target(${target_name}
        COMMAND ${CMAKE_COMMAND} -D SIM=${SIM} -D FRAME=${frame} -P ${CMAKE_BINARY_DIR}/run_sim_frame.cmake
        COMMAND ${CMAKE_COMMAND} -E echo "Running simulation for frame_${frame} with simulator ${SIM}"
    )
endfunction()

# Add custom targets for each test case
foreach(frame RANGE 1 9)
    add_sim_target(sim_frame_${frame} ${frame})
    add_sim_target(sim_frame_${frame}_gui ${frame})
endforeach()

# Add custom target for running all test cases
add_custom_target(sim
    COMMAND ${CMAKE_COMMAND} -D SIM=${SIM} -P ${CMAKE_BINARY_DIR}/run_sim_all.cmake
    COMMAND ${CMAKE_COMMAND} -E echo "Running all simulations with simulator ${SIM}"
)

# Add custom target for running all test cases multithreaded
add_custom_target(sim_multhread
    COMMAND ${CMAKE_COMMAND} -D SIM=${SIM} -P ${CMAKE_BINARY_DIR}/run_sim_all_multithread.cmake
    COMMAND ${CMAKE_COMMAND} -E echo "Running all simulations with simulator ${SIM} using multiple threads"
)

add_custom_target(clean_all
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_BINARY_DIR}/clean.cmake
)

# Generate scripts for running simulations
file(WRITE ${CMAKE_BINARY_DIR}/run_sim_frame.cmake
    "if(NOT DEFINED SIM)\n"
    "    message(FATAL_ERROR \"SIM is not set.\")\n"
    "endif()\n"
    "if(NOT DEFINED FRAME)\n"
    "    message(FATAL_ERROR \"FRAME is not set.\")\n"
    "endif()\n"
    
    # Windows-specific logic for setting environment variables
    "if(WIN32)\n"
    "    if(POLICY VERSION VERSION_GREATER_EQUAL \"10\")\n"
    "        # PowerShell or CMD\n"
    "        execute_process(COMMAND powershell.exe -Command \"\$env:VUNIT_SIMULATOR=${SIM}; python ${CMAKE_SOURCE_DIR}/run.py tdm_rx.tb.frame_${FRAME} -v\")\n"
    "    else()\n"
    "        # Older Windows systems\n"
    "        execute_process(COMMAND cmd.exe /C \"set VUNIT_SIMULATOR=${SIM}&&python ${CMAKE_SOURCE_DIR}/run.py tdm_rx.tb.frame_${FRAME} -v\")\n"
    "    endif()\n"
    "else()\n"
    "    # Linux / macOS / Git Bash\n"
    "    execute_process(COMMAND env VUNIT_SIMULATOR=${SIM} python3 ${CMAKE_SOURCE_DIR}/run.py tdm_rx.tb.frame_${FRAME} -v)\n"
    "endif()\n"
)

file(WRITE ${CMAKE_BINARY_DIR}/run_sim_all.cmake
    "if(NOT DEFINED SIM)\n"
    "    message(FATAL_ERROR \"SIM is not set.\")\n"
    "endif()\n"
    # Windows-specific logic for setting environment variables
    "if(WIN32)\n"
    "    if(POLICY VERSION VERSION_GREATER_EQUAL \"10\")\n"
    "        # PowerShell or CMD\n"
    "        execute_process(COMMAND powershell.exe -Command \"\$env:VUNIT_SIMULATOR=${SIM}; python ${CMAKE_SOURCE_DIR}/run.py -v\")\n"
    "    else()\n"
    "        # Older Windows systems\n"
    "        execute_process(COMMAND cmd.exe /C \"set VUNIT_SIMULATOR=${SIM}&&python ${CMAKE_SOURCE_DIR}/run.py -v\")\n"
    "    endif()\n"
    "else()\n"
    "    # Linux / macOS / Git Bash\n"
    "    execute_process(COMMAND env VUNIT_SIMULATOR=${SIM} python3 ${CMAKE_SOURCE_DIR}/run.py -v)\n"
    "endif()\n"
)

file(WRITE ${CMAKE_BINARY_DIR}/run_sim_all_multithread.cmake
    "if(NOT DEFINED SIM)\n"
    "    message(FATAL_ERROR \"SIM is not set.\")\n"
    "endif()\n"
    # Windows-specific logic for setting environment variables
    "if(WIN32)\n"
    "    if(POLICY VERSION VERSION_GREATER_EQUAL \"10\")\n"
    "        execute_process(COMMAND powershell.exe -Command \"\$env:VUNIT_SIMULATOR=${SIM}; python ${CMAKE_SOURCE_DIR}/run.py -v -p 2\")\n"
    "    else()\n"
    "        execute_process(COMMAND cmd.exe /C \"set VUNIT_SIMULATOR=${SIM}&&python ${CMAKE_SOURCE_DIR}/run.py -v -p 2\")\n"
    "    endif()\n"
    "else()\n"
    "    execute_process(COMMAND env VUNIT_SIMULATOR=${SIM} python3 ${CMAKE_SOURCE_DIR}/run.py -v -p 2)\n"
    "endif()\n"
)

file(WRITE ${CMAKE_BINARY_DIR}/clean.cmake
    "execute_process(COMMAND rm -rf *)\n"
)

# Add help command to display usage information
add_custom_target(show_help
    COMMAND ${CMAKE_COMMAND} -E echo "$$HEADER"
    COMMAND ${CMAKE_COMMAND} -E echo "Usage: cmake --build . --target [help|sim|sim_frame_1|sim_frame_1_gui|...|sim_frame_9|sim_frame_9_gui|sim_multhread|clean_all]"
    COMMAND ${CMAKE_COMMAND} -E echo ""
    COMMAND ${CMAKE_COMMAND} -E echo "You can set the simulator to modelsim|ghdl|nvc|rivierapro|activehdl|incisive by configuring the SIM variable."
    COMMAND ${CMAKE_COMMAND} -E echo "Default simulator: ghdl"
    COMMAND ${CMAKE_COMMAND} -E echo ""
    COMMAND ${CMAKE_COMMAND} -E echo "For example: cmake -G Ninja -DSIM=modelsim .."
    COMMAND ${CMAKE_COMMAND} -E echo ""
    COMMAND ${CMAKE_COMMAND} -E echo "  sim:             Compile and simulate all test cases"
    COMMAND ${CMAKE_COMMAND} -E echo "  sim_multhread:   Compile and simulate all test cases using multiple threads"
    COMMAND ${CMAKE_COMMAND} -E echo "  sim_frame_<n>:   Compile and simulate frame_<n> test case"
    COMMAND ${CMAKE_COMMAND} -E echo "  sim_frame_<n>_gui: Compile and simulate frame_<n> test case with GUI waveforms"
    COMMAND ${CMAKE_COMMAND} -E echo "  clean_all:       Remove all generated files"
    COMMAND ${CMAKE_COMMAND} -E echo ""
)

# Define header for help message
set(HEADER "
     _     ___   _       _ _   
    \\ \\   / / | | |_ __ (_) |_ 
     \\ \\ / /| | | | '_ \\| | __|
      \\ V / | |_| | | | | | |_ 
       \\_/   \\___/|_| |_|_|\\__|
")

