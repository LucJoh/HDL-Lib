cmake_minimum_required(VERSION 3.10)

project(tdm_rx)

set(VUNIT_SIMULATOR ${SIM})

add_custom_target(sim
    COMMAND ${CMAKE_COMMAND} -E env VUNIT_SIMULATOR=${VUNIT_SIMULATOR} python3 run.py -v
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Simulating all testcases"
    VERBATIM
)
add_custom_target(sim_multhread
    COMMAND ${CMAKE_COMMAND} -E env VUNIT_SIMULATOR=${VUNIT_SIMULATOR} python3 run.py -p 10
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Simulating all testcases on 10 cpu threads"
    VERBATIM
)
add_custom_target(sim_gui
    COMMAND ${CMAKE_COMMAND} -E env VUNIT_SIMULATOR=${VUNIT_SIMULATOR} python3 run.py tdm_rx.tb.tc1 --gui
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Simulating testcase 1"
    VERBATIM
)
add_custom_target(write_bitstream
    COMMAND ${CMAKE_COMMAND} -E env vivado -mode batch -source /vivado_scripts/write_bitstream.tcl
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Simulating testcase 1"
    VERBATIM
)
