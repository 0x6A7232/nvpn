#!/bin/bash

# nvpn.sh - A simple Bash script to streamline common NordVPN tasks on Linux
#
# Description:
#   This script simplifies daily NordVPN usage on Linux by providing shortcuts for connecting
#   to servers, disconnecting, checking status, and managing its default connection command.
#
# Usage:
#   ./nvpn.sh [options] [arguments]
#   Run './nvpn.sh --help' for detailed usage instructions.
#
# Author:
#   0x6A7232 (https://github.com/0x6A7232/nvpn)
#
# License:
#   MIT License
#
#   Copyright (c) 2025 0x6A7232
#
#   Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"), to deal
#   in the Software without restriction, including without limitation the rights
#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in all
#   copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#   SOFTWARE.

# Default connection command
DEFAULT_CONNECT="nordvpn c --group p2p us"

# Original default command for resetting
ORIGINAL_DEFAULT="nordvpn c --group p2p us"

# ANSI color codes
YELLOW='\033[38;5;214m'  # Muted hazy sunset yellow (soft gold/ochre tone)
BRIGHT_YELLOW='\033[1;33m'  # Bright yellow for warnings and cancellation
ORANGE='\033[0;33m'      # Dark orange
PINK='\033[38;5;205m'    # Soft pink for the specified command
NC='\033[0m'             # No Color

# Function to display usage help with colors and improved formatting
show_help() {
    echo "nvpn.sh script usage syntax:"
    echo -e "  ${YELLOW}nvpn.sh${NC}                    : Connects using default command: '${ORANGE}$DEFAULT_CONNECT${NC}'"
    echo -e "  ${YELLOW}nvpn.sh <group>${NC}            : Connects to a server group"
    echo -e "    '${YELLOW}nvpn.sh p2p${NC}' runs '${ORANGE}nordvpn c --group p2p${NC}'"
    echo -e "  ${YELLOW}nvpn.sh normal|regular|standard${NC} : Connects to Standard_VPN_Servers"
    echo -e "    '${YELLOW}nvpn.sh normal${NC}' runs '${ORANGE}nordvpn c --group Standard_VPN_Servers${NC}'"
    echo -e "  ${YELLOW}nvpn.sh <group> <country>${NC}  : Connects to a specific group and country"
    echo -e "    '${YELLOW}nvpn.sh p2p brazil${NC}' runs '${ORANGE}nordvpn c --group p2p brazil${NC}'"
    echo -e "  ${YELLOW}nvpn.sh <group> <country> <city>${NC} : Connects to a specific group, country, and city"
    echo -e "    '${YELLOW}nvpn.sh p2p sweden stockholm${NC}' runs '${ORANGE}nordvpn c --group p2p sweden stockholm${NC}'"
    echo -e "  ${YELLOW}nvpn.sh d${NC}                  : Disconnects from VPN (runs '${ORANGE}nordvpn d${NC}')"
    echo -e "  ${YELLOW}nvpn.sh status${NC}             : Shows connection status (runs '${ORANGE}nordvpn status${NC}')"
    echo -e "  ${YELLOW}nvpn.sh --install${NC}          : Installs the script by creating a symlink in a bin directory"
    echo -e "  ${YELLOW}nvpn.sh --update-default <command>${NC} : Updates the default command to the specified command"
    echo -e "    '${YELLOW}nvpn.sh --update-default nordvpn c --group p2p uk${NC}' updates the default command"
    echo -e "  ${YELLOW}nvpn.sh --reset-default${NC}    : Resets the default command to '${ORANGE}nordvpn c --group p2p us${NC}'"
    echo -e "  ${YELLOW}nvpn.sh --help${NC}             : Shows this help message"
    echo ""
    echo -e "For full NordVPN application help, run '${ORANGE}nordvpn --help${NC}' or '${ORANGE}man nordvpn${NC}'."
}

# Function to find a suitable bin directory in $PATH
find_bin_dir() {
    # List of preferred bin directories to check
    local bin_dirs=("/usr/local/bin" "/usr/bin" "$HOME/bin")
    
    for dir in "${bin_dirs[@]}"; do
        # Check if the directory exists
        if [ -d "$dir" ]; then
            # Check if the directory is in $PATH
            if echo "$PATH" | grep -q "$dir"; then
                # Check if the directory is writable by the user
                if [ -w "$dir" ]; then
                    echo "$dir"
                    return 0
                fi
            fi
        fi
    done
    
    # If no writable directory is found, provide instructions
    echo "No writable bin directory found in \$PATH."
    echo "You can either:"
    echo "1. Run this script with sudo to create a symlink in /usr/local/bin:"
    echo "   sudo ln -s $(realpath "$0") /usr/local/bin/nvpn"
    echo "2. Manually place the script in a directory in your \$PATH:"
    echo "   chmod +x $(realpath "$0")"
    echo "   mv $(realpath "$0") /path/to/bin/nvpn"
    echo "   (e.g., /usr/local/bin or ~/bin if it's in your \$PATH)"
    return 1
}

# Function to install the script by creating a symlink in a bin directory
install_script() {
    # Get the absolute path of the script
    local script_path
    script_path=$(realpath "$0")
    
    # Find a suitable bin directory
    local bin_dir
    bin_dir=$(find_bin_dir)
    if [ $? -ne 0 ]; then
        exit 1
    fi
    
    # Check if the script is executable
    if [ ! -x "$script_path" ]; then
        echo "Warning: This script ($script_path) is not executable."
        echo "The symbolic link will be created, but you won't be able to run 'nvpn' until you make the script executable."
        echo "Please run the following command to fix this:"
        echo "    chmod +x \"$script_path\""
    fi
    
    # Create the symbolic link
    local link_path="$bin_dir/nvpn"
    if [ -e "$link_path" ]; then
        echo "A file named 'nvpn' already exists in $bin_dir."
        echo "Would you like to overwrite it? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            ln -sf "$script_path" "$link_path"
            echo "Symbolic link created: $link_path -> $script_path"
        else
            echo "Installation aborted."
            exit 1
        fi
    else
        ln -s "$script_path" "$link_path"
        echo "Symbolic link created: $link_path -> $script_path"
    fi
}

# Function to validate the new default command
validate_default_command() {
    local command="$1"
    if ! echo "$command" | grep -q "^nordvpn c"; then
        echo -e "${BRIGHT_YELLOW}Warning:${NC} The specified default command '${PINK}$command${NC}' may not connect to a VPN server when running '${YELLOW}./nvpn.sh${NC}'. Proceed? (y/n)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo -e "${BRIGHT_YELLOW}Update canceled.${NC}"
            exit 1
        fi
    fi
}

# Function to update the DEFAULT_CONNECT variable in the script
update_default_command() {
    local new_command="$1"
    # Validate the new command
    validate_default_command "$new_command"
    # Escape special characters in the new command for sed
    new_command_escaped=$(echo "$new_command" | sed 's/[\/&]/\\&/g')
    # Use sed to replace the DEFAULT_CONNECT line in the script
    sed -i "s/^DEFAULT_CONNECT=\".*\"/DEFAULT_CONNECT=\"$new_command_escaped\"/" "$0"
    if [[ $? -eq 0 ]]; then
        echo -e "${YELLOW}Default command updated to:${NC} ${PINK}$new_command${NC}"
    else
        echo "Error: Failed to update the default command."
        exit 1
    fi
}

# Function to reset the DEFAULT_CONNECT variable to its original value
reset_default_command() {
    update_default_command "$ORIGINAL_DEFAULT"
}

# Check if nordvpn is installed
if ! command -v nordvpn &> /dev/null; then
    echo "Error: nordvpn command not found. Please install NordVPN."
    exit 1
fi

# Check for --help, --install, --update-default, or --reset-default flags
if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
elif [[ "$1" == "--install" ]]; then
    install_script
    exit 0
elif [[ "$1" == "--update-default" ]]; then
    shift
    if [[ -z "$1" ]]; then
        echo "Error: No command provided for --update-default."
        show_help
        exit 1
    fi
    # Join all remaining arguments as the new command
    new_command="$*"
    update_default_command "$new_command"
    exit 0
elif [[ "$1" == "--reset-default" ]]; then
    reset_default_command
    exit 0
fi

# Handle aliases for Standard_VPN_Servers
case "$1" in
    normal|regular|standard)
        GROUP="Standard_VPN_Servers"
        shift
        ;;
    *)
        GROUP="$1"
        ;;
esac

# Check number of arguments
case $# in
    0)
        echo "Connecting with default command: $DEFAULT_CONNECT"
        eval "$DEFAULT_CONNECT"
        ;;
    1)
        if [[ "$1" == "d" ]]; then
            nordvpn d
        elif [[ "$1" == "status" ]]; then
            nordvpn status
        else
            echo "Connecting to group: $GROUP"
            nordvpn c --group "$GROUP"
        fi
        ;;
    2)
        echo "Connecting to group: $GROUP, country: $2"
        nordvpn c --group "$GROUP" "$2"
        ;;
    3)
        echo "Connecting to group: $GROUP, country: $2, city: $3"
        nordvpn c --group "$GROUP" "$2" "$3"
        ;;
    *)
        echo "Invalid number of arguments."
        show_help
        exit 1
        ;;
esac
