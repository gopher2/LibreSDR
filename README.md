# LibreSDR

LibreSDR firmware for USRP B210 series devices with interactive setup script.

## Overview

This project provides LibreSDR firmware variants for USRP B210 hardware and an automated setup script that handles installation, backup, and environment configuration.

## Firmware Variants

- **libresdr_b210mini.bin** (2.9MB) - For B210mini hardware with smaller FPGA
- **libresdr_b220mini.bin** (4.3MB) - For B220mini hardware with larger FPGA

Both variants are compatible with USRP B210 devices but require different firmware files based on the specific hardware configuration.

## Installation

### Prerequisites

- Python 3
- UHD (optional - script can install to standalone location)
- macOS with Homebrew (or other package manager)

### Quick Start

1. Clone or download this repository
2. Navigate to the project directory
3. Run the setup script:

```bash
./libresdr_setup.sh
```

### What the Script Does

The `libresdr_setup.sh` script performs the following operations:

1. **Environment Setup**
   - Sets UHD_IMAGES_DIR environment variable
   - Adds environment variable to ~/.zshrc for persistence

2. **UHD Images Download**
   - Downloads standard UHD firmware images using uhd_images_downloader.py

3. **Firmware Selection**
   - Prompts user to choose between B210mini or B220mini firmware
   - Copies selected firmware to standardized name

4. **Installation Detection**
   - Automatically detects existing UHD installations
   - Supports multiple installation methods (Homebrew, system install, MacPorts)
   - Version-agnostic detection

5. **Installation Location**
   - If UHD found: Uses existing installation directory
   - If no UHD: Offers choice between local or system-wide installation
     - Local: `~/.local/share/uhd/images/` (user-only, no sudo required)
     - System: `/opt/uhd/images/` (all users, requires sudo)

6. **Safe Backup**
   - Creates backup of original firmware (.original suffix)
   - Never overwrites existing backups
   - Uses appropriate permissions based on install location

7. **Firmware Installation**
   - Replaces original USRP B210 firmware with LibreSDR version
   - Smart permission handling (sudo only when needed)

## File Structure

```
LibreSDR/
├── README.md                    # This file
├── libresdr_setup.sh           # Main installation script
├── uhd_images_downloader.py    # UHD firmware downloader
├── libresdr_b210mini.bin       # B210mini firmware (2.9MB)
├── libresdr_b220mini.bin       # B220mini firmware (4.3MB)
└── libresdr_b210.bin           # Working copy (created by script)
```

## Usage

After installation, restart your terminal or run:

```bash
source ~/.zshrc
```

Your USRP B210 device will now use the LibreSDR firmware instead of the original UHD firmware.

## Supported Platforms

- **macOS** (Apple Silicon and Intel)
- **Package Managers**: Homebrew, MacPorts, system installations
- **UHD Versions**: All versions (version-agnostic detection)

## Installation Paths

The script automatically detects and supports:

- `/opt/homebrew/Cellar/uhd/*/share/uhd/images/` (Apple Silicon Homebrew)
- `/usr/local/Cellar/uhd/*/share/uhd/images/` (Intel Homebrew)
- `/usr/local/share/uhd/images/` (System installation)
- `/opt/local/share/uhd/images/` (MacPorts)
- `~/.local/share/uhd/images/` (Local user installation)
- `/opt/uhd/images/` (System-wide installation)

## Backup and Recovery

The script creates automatic backups with `.original` suffix:
- Original firmware is preserved as `usrp_b210_fpga.bin.original`
- Existing backups are never overwritten
- To restore original firmware, copy the backup back:

```bash
sudo cp /path/to/usrp_b210_fpga.bin.original /path/to/usrp_b210_fpga.bin
```

## Hardware Compatibility

- **B210mini**: Use libresdr_b210mini.bin (smaller FPGA configuration)
- **B220mini**: Use libresdr_b220mini.bin (larger FPGA configuration)
- **USRP B210**: Both firmware variants are compatible but choose based on your specific hardware

## Troubleshooting

### Permission Issues
- The script automatically handles permissions
- System installations require sudo access
- Local installations don't require elevated privileges

### UHD Not Found
- Script offers standalone installation options
- Choose local install if you don't need system-wide access
- Choose system install if multiple users need access

### Wrong Firmware Variant
- Re-run the script and select the correct firmware variant
- B210mini users should use the smaller 2.9MB firmware
- B220mini users should use the larger 4.3MB firmware

## Contributing

This project provides LibreSDR firmware for USRP B210 series devices. For issues or contributions, please refer to the project documentation.

## License

Refer to the LibreSDR project license for firmware licensing information.