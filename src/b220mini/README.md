# LibreSDR B220mini Source

This directory contains the complete Vivado project source code for the LibreSDR B220mini firmware.

## Hardware Target
- **Device**: USRP B220mini
- **FPGA**: Larger FPGA configuration
- **Firmware Size**: 4.3MB

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
- This is the B220mini specific variant with larger FPGA configuration
- Different from B210mini - do not use interchangeably
- Built firmware should be approximately 4.3MB in size