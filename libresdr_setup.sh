#!/bin/bash

# Check if UHD_IMAGES_DIR is already set
if [ -n "$UHD_IMAGES_DIR" ]; then
    echo "UHD_IMAGES_DIR already set to: $UHD_IMAGES_DIR"
    echo -n "Use existing setting? [Y/n]: "
    read use_existing

    if [ "$use_existing" = "n" ] || [ "$use_existing" = "N" ]; then
        echo "Will detect/configure UHD_IMAGES_DIR during installation"
        unset UHD_IMAGES_DIR
    else
        echo "Using existing UHD_IMAGES_DIR setting"
        EXISTING_UHD_DIR="$UHD_IMAGES_DIR"
    fi
else
    echo "No existing UHD_IMAGES_DIR found"
fi

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

# Detect UHD installation or use existing setting
echo ""

if [ -n "$EXISTING_UHD_DIR" ]; then
    # User chose to keep existing UHD_IMAGES_DIR
    UHD_IMAGES_DIR="$EXISTING_UHD_DIR"
    FPGA_PATH="$UHD_IMAGES_DIR/usrp_b210_fpga.bin"
    echo "Using existing UHD_IMAGES_DIR: $UHD_IMAGES_DIR"

    # Check if the path actually exists
    if [ -f "$FPGA_PATH" ]; then
        UHD_IMAGES_PATH="$FPGA_PATH"
        echo "Found USRP B210 firmware at existing location"
    else
        echo "Warning: usrp_b210_fpga.bin not found at $FPGA_PATH"
        echo "Will create new firmware file at this location"
    fi
else
    # No existing setting or user chose to reconfigure
    echo "Detecting UHD installation..."

    # Search for existing UHD installations
    UHD_IMAGES_PATH=$(find /opt/homebrew/Cellar/uhd /usr/local/Cellar/uhd /usr/local/share/uhd /opt/local/share/uhd -name "usrp_b210_fpga.bin" 2>/dev/null | head -1)

    if [ -n "$UHD_IMAGES_PATH" ]; then
        # Found existing UHD installation
        FPGA_PATH="$UHD_IMAGES_PATH"
        UHD_IMAGES_DIR=$(dirname "$FPGA_PATH")
        echo "Found existing UHD installation at: $UHD_IMAGES_DIR"
    else
        # No UHD found, ask user for install preference
        echo "No existing UHD installation found."
        echo ""
        echo "Choose installation location:"
        echo "1) Local install (user-only): ~/.local/share/uhd/images/"
        echo "2) System install (all users): /opt/uhd/images/ (requires sudo)"
        echo -n "Enter your choice [1-2]: "
        read install_choice

        case $install_choice in
            1)
                UHD_IMAGES_DIR="$HOME/.local/share/uhd/images"
                echo "Selected: Local installation"
                mkdir -p "$UHD_IMAGES_DIR"
                NEED_SUDO=false
                ;;
            2)
                UHD_IMAGES_DIR="/opt/uhd/images"
                echo "Selected: System-wide installation"
                sudo mkdir -p "$UHD_IMAGES_DIR"
                NEED_SUDO=true
                ;;
            *)
                echo "Invalid choice. Defaulting to local installation"
                UHD_IMAGES_DIR="$HOME/.local/share/uhd/images"
                mkdir -p "$UHD_IMAGES_DIR"
                NEED_SUDO=false
                ;;
        esac

        FPGA_PATH="$UHD_IMAGES_DIR/usrp_b210_fpga.bin"
    fi
fi

# Update environment variable and .zshrc if needed
export UHD_IMAGES_DIR

# Check if UHD_IMAGES_DIR is already in .zshrc to avoid duplicates
if [ -f ~/.zshrc ] && grep -q "export UHD_IMAGES_DIR=" ~/.zshrc; then
    echo "UHD_IMAGES_DIR already configured in ~/.zshrc"
else
    echo "Adding UHD_IMAGES_DIR to ~/.zshrc for persistence"
    echo "export UHD_IMAGES_DIR=\"$UHD_IMAGES_DIR\"" >> ~/.zshrc
fi

BACKUP_PATH="${FPGA_PATH}.original"
LIBRESDR_FPGA="./libresdr_b210.bin"

# Determine if sudo is needed (existing installations or system-wide new installs)
if [ -n "$UHD_IMAGES_PATH" ] || [ "$NEED_SUDO" = "true" ]; then
    USE_SUDO="sudo"
else
    USE_SUDO=""
fi

echo "Backing up original FPGA file..."
if [ -f "$FPGA_PATH" ] && [ ! -f "$BACKUP_PATH" ]; then
    $USE_SUDO cp "$FPGA_PATH" "$BACKUP_PATH"
    echo "Original FPGA file backed up to: $BACKUP_PATH"
elif [ -f "$BACKUP_PATH" ]; then
    echo "Backup already exists at: $BACKUP_PATH"
fi

echo "Installing LibreSDR FPGA file..."
if [ -f "$LIBRESDR_FPGA" ]; then
    $USE_SUDO cp "$LIBRESDR_FPGA" "$FPGA_PATH"
    echo "LibreSDR FPGA file installed successfully at: $FPGA_PATH"
    echo "UHD_IMAGES_DIR set to: $UHD_IMAGES_DIR"
else
    echo "Error: LibreSDR FPGA file not found at $LIBRESDR_FPGA"
fi

echo ""
echo "⚠️  WARNING: To use UHD devices in your current terminal session, run:"
echo "   source ~/.zshrc"
echo ""
echo "Or restart your terminal to load the environment variable."