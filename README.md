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
3. Move it to a directory in your \$PATH (e.g., /usr/local/bin):
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

## Prerequisites

- NordVPN CLI installed (`nordvpn` command must be available).
- A terminal that supports ANSI colors for the best experience.

## License

This project is licensed under the MIT License - see the script header for details.
