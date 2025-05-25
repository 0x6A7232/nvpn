# nvpn.sh - Simplify NordVPN Usage on Linux

A Bash script to streamline common NordVPN tasks on Linux, such as connecting to servers, disconnecting, checking status, and managing the default connection command.

## Installation

1. Download the script:

   ```bash
   wget https://raw.githubusercontent.com/0x6A7232/nvpn/main/nvpn.sh
   ```

2. Make it executable:

   ```bash
   chmod +x nvpn.sh
   ```

3. Run `./nvpn.sh --install`, or manually achieve this by creating a symlink for it in a directory in your $PATH (e.g., /usr/local/bin); alternatively, you can move the script itself there:

   ```bash
   ./nvpn.sh --install
   ```

   **OR**

   ```bash
   ln -s $(pwd)/nvpn.sh /usr/local/bin/nvpn
   ```

   **OR**

   ```bash
   mv nvpn.sh /usr/local/bin/nvpn
   ```

## Usage

Run the script with:

```bash
nvpn [options] [arguments]
```

For detailed usage, run:

```bash
nvpn --help
```

## Features

The script provides shortcuts for common NordVPN tasks, making it a timesaver for daily use.

Below is the output of the `nvpn --help` command:

```
nvpn.sh script usage syntax:
  nvpn.sh                    : Connects using default command: 'nordvpn c --group p2p us'
  nvpn.sh <group>            : Connects to a server group
    'nvpn.sh p2p' runs 'nordvpn c --group p2p'
  nvpn.sh normal|regular|standard : Connects to Standard_VPN_Servers
    'nvpn.sh normal' runs 'nordvpn c --group Standard_VPN_Servers'
  nvpn.sh <group> <country>  : Connects to a specific group and country
    'nvpn.sh p2p brazil' runs 'nordvpn c --group p2p brazil'
  nvpn.sh <group> <country> <city> : Connects to a specific group, country, and city
    'nvpn.sh p2p sweden stockholm' runs 'nordvpn c --group p2p sweden stockholm'
  nvpn.sh d                  : Disconnects from VPN (runs 'nordvpn d')
  nvpn.sh status             : Shows connection status (runs 'nordvpn status')
  nvpn.sh --install          : Installs the script by creating a symlink in a bin directory
  nvpn.sh --update-default <command> : Updates the default command to the specified command
    'nvpn.sh --update-default nordvpn c --group p2p uk' updates the default command
  nvpn.sh --reset-default    : Resets the default command to 'nordvpn c --group p2p us'
  nvpn.sh --help             : Shows this help message

For full NordVPN application help, run `nordvpn --help` or `man nordvpn`.
```

## Prerequisites

- NordVPN CLI installed (`nordvpn` command must be available).
- A terminal that supports ANSI colors for the best experience.

## License

This project is licensed under the MIT License - see the script header for details.
