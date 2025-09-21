#!/bin/bash

# Set environment variable for current session
export UHD_IMAGES_DIR=/opt/homebrew/Cellar/uhd/4.9.0.0/share/uhd/images/

# Add to zsh profile for persistence across reboots
echo "export UHD_IMAGES_DIR=/opt/homebrew/Cellar/uhd/4.9.0.0/share/uhd/images/" >> ~/.zshrc

# Run UHD images downloader
python3 uhd_images_downloader.py

# Select LibreSDR firmware version
echo ""
echo "Select LibreSDR firmware version:"
echo "1) B210mini (2.9MB - smaller FPGA)"
echo "2) B220mini (4.3MB - larger FPGA)"
echo -n "Enter your choice [1-2]: "
read choice

case $choice in
    1)
        echo "Selected: B210mini firmware"
        SOURCE_FPGA="./libresdr_b210mini.bin"
        ;;
    2)
        echo "Selected: B220mini firmware"
        SOURCE_FPGA="./libresdr_b220mini.bin"
        ;;
    *)
        echo "Invalid choice. Defaulting to B220mini firmware"
        SOURCE_FPGA="./libresdr_b220mini.bin"
        ;;
esac

# Copy selected firmware to standard name
if [ -f "$SOURCE_FPGA" ]; then
    cp "$SOURCE_FPGA" "./libresdr_b210.bin"
    echo "Copied $SOURCE_FPGA to libresdr_b210.bin"
else
    echo "Error: Selected firmware file not found: $SOURCE_FPGA"
    exit 1
fi

# Backup original FPGA file and install LibreSDR version
FPGA_PATH="/opt/homebrew/Cellar/uhd/4.9.0.0/share/uhd/images/usrp_b210_fpga.bin"
BACKUP_PATH="${FPGA_PATH}.original"
LIBRESDR_FPGA="./libresdr_b210.bin"

echo "Backing up original FPGA file..."
if [ -f "$FPGA_PATH" ] && [ ! -f "$BACKUP_PATH" ]; then
    sudo cp "$FPGA_PATH" "$BACKUP_PATH"
    echo "Original FPGA file backed up to: $BACKUP_PATH"
elif [ -f "$BACKUP_PATH" ]; then
    echo "Backup already exists at: $BACKUP_PATH"
fi

echo "Installing LibreSDR FPGA file..."
if [ -f "$LIBRESDR_FPGA" ]; then
    sudo cp "$LIBRESDR_FPGA" "$FPGA_PATH"
    echo "LibreSDR FPGA file installed successfully"
else
    echo "Error: LibreSDR FPGA file not found at $LIBRESDR_FPGA"
fi

echo ""
echo "⚠️  WARNING: To use UHD devices in your current terminal session, run:"
echo "   source ~/.zshrc"
echo ""
echo "Or restart your terminal to load the environment variable."