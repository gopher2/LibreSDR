# LibreSDR B210mini Source

This directory contains the complete Vivado project source code for the LibreSDR B210mini firmware.

## Hardware Target
- **Device**: USRP B210mini
- **FPGA**: Smaller FPGA configuration
- **Firmware Size**: 2.9MB

## Project Files
- **libresdr_b210.xpr** - Main Vivado project file
- **libresdr_b210.srcs/** - Source files and constraints
- **libresdr_b210.gen/** - Generated IP cores
- **libresdr_b210.runs/** - Build outputs and reports

## Build Requirements
- **Xilinx Vivado** (Windows/Linux only)
- **License**: Vivado WebPACK or full license
- **Target Device**: Spartan-6 FPGA support

## Building
1. Open `libresdr_b210.xpr` in Vivado
2. Run synthesis and implementation
3. Generate bitstream
4. Output firmware will be in `runs/impl_1/`

## Notes
- This is the B210mini specific variant with smaller FPGA configuration
- Different from B220mini - do not use interchangeably
- Built firmware should be approximately 2.9MB in size