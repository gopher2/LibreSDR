# LibreSDR Source Code

This directory contains the complete source code for building LibreSDR firmware from scratch.

## Directory Structure

### b210mini/
Complete Vivado project for B210mini hardware variant
- **Target**: USRP B210mini with smaller FPGA
- **Output**: ~2.9MB firmware file
- **Project**: `b210mini/libresdr_b210.xpr`

### b220mini/
Complete Vivado project for B220mini hardware variant
- **Target**: USRP B220mini with larger FPGA
- **Output**: ~4.3MB firmware file
- **Project**: `b220mini/libresdr_b210.xpr`

## Build Requirements

### Software
- **Xilinx Vivado** (2018.3 or later recommended)
- **Operating System**: Windows or Linux (macOS not supported)
- **License**: Vivado WebPACK (free) or full license

### Hardware
- **RAM**: 8GB minimum, 16GB+ recommended
- **Storage**: 10GB+ free space for Vivado installation
- **CPU**: Multi-core recommended for faster builds

## Building Firmware

1. **Open Project**
   ```bash
   vivado src/b210mini/libresdr_b210.xpr
   # or
   vivado src/b220mini/libresdr_b210.xpr
   ```

2. **Run Build**
   - Synthesis: Generate → Run Synthesis
   - Implementation: Generate → Run Implementation
   - Bitstream: Generate → Generate Bitstream

3. **Locate Output**
   - Built firmware: `runs/impl_1/*.bin`
   - Copy to main directory as `libresdr_b210mini.bin` or `libresdr_b220mini.bin`

## Hardware Compatibility

| Variant | Hardware | FPGA Size | Firmware Size |
|---------|----------|-----------|---------------|
| B210mini | USRP B210mini | Smaller | ~2.9MB |
| B220mini | USRP B220mini | Larger | ~4.3MB |

## Important Notes

- **Platform Limitation**: Vivado only runs on Windows/Linux, not macOS
- **Hardware Specific**: Each variant is designed for specific FPGA configuration
- **Not Interchangeable**: B210mini and B220mini firmware are incompatible
- **Build Time**: Full builds can take 30+ minutes depending on hardware

## Troubleshooting

### License Issues
- Ensure Vivado WebPACK license is properly installed
- Check that target device (Spartan-6) is covered by license

### Build Failures
- Check Vivado version compatibility
- Verify all IP cores are properly generated
- Review synthesis/implementation logs for specific errors

### Missing Files
- Ensure all source files were properly extracted
- Check that IP core dependencies are available
- Verify project paths are correct

For pre-built firmware, see the main directory's `libresdr_b210mini.bin` and `libresdr_b220mini.bin` files.