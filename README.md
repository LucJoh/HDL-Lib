# VHDLCommLib

Welcome to VHDLCommLib, a comprehensive library of communication protocols implemented in VHDL. This repository aims to provide high-quality, reusable VHDL modules for a wide range of communication standards, making it easier for developers and engineers to integrate robust communication capabilities into their FPGA and hardware designs.

## Design Methodology

The VHDL modules in this repository are designed using the **two-process method**. This method involves separating the combinational logic and the sequential logic into two distinct processes. The first process handles the combinational logic and is sensitive to input signals, while the second process handles the sequential logic and is driven by the clock signal. This separation simplifies the design, improves readability, and ensures that the design adheres to good coding practices, reducing the risk of errors and making the design more maintainable.

For more details on the two-process method, you can refer to the original paper [here](https://www.gaisler.com/doc/vhdl2proc.pdf).

## Features
- **SPI (Serial Peripheral Interface)**
- **I2C (Inter-Integrated Circuit)**
- **UART (Universal Asynchronous Receiver/Transmitter)**
- **CAN (Controller Area Network)**
- **TDM (Time-Division Multiplexing)**
- **Ethernet**
- **RS-232/RS-485**

