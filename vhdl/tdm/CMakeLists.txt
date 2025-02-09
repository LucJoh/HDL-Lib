cmake_minimum_required(VERSION 3.31)

project(tdm_rx)

# Set default simulator (can be overridden by setting VUNIT_SIMULATOR when running CMake)
#set(VUNIT_SIMULATOR "modelsim")

# Define a helper function for creating simulation targets
function(create_simulation_target target_name command_args)
    message(STATUS "Using simulator: ${VUNIT_SIMULATOR}")
    add_custom_target(${target_name}
        COMMAND ${CMAKE_COMMAND} -E env VUNIT_SIMULATOR=${VUNIT_SIMULATOR} python3 run.py ${command_args}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
endfunction()

# Create simulation targets
create_simulation_target(sim "")
create_simulation_target(sim_multhread "-p 9")
create_simulation_target(sim_frame_1 "tdm. tb.frame_1")
create_simulation_target(sim_write_gui "--gtkwave-args \"-a waves/ wave.gtkw\" --gui")
create_simulation_target(sim_read "i2c. tb.read")

# Set default build target (optional)
set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY
             DEFAULT_BUILD_TARGET sim)

