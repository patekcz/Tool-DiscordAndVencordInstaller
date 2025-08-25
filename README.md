# Discord Canary + Vencord - Linux Installer

A simple and powerful installer for Discord Canary with optional Vencord extension installation for Linux.

## Quick Start - Single Command

For quick installation directly from GitHub, you can use this command:

```bash
curl -fsSL https://raw.githubusercontent.com/patekcz/Tool-DiscordAndVencordInstaller/main/install.sh | bash
```

This will run the installer in interactive mode, guiding you through the entire process.

## Advanced Commands

### Complete installation with Vencord and .desktop file

```bash
curl -fsSL https://raw.githubusercontent.com/patekcz/Tool-DiscordAndVencordInstaller/main/install.sh | bash -s -- --installVencord --createDesktop
```

### Installation without Vencord

```bash
curl -fsSL https://raw.githubusercontent.com/patekcz/Tool-DiscordAndVencordInstaller/main/install.sh | bash -s -- --skipVencord
```

### Installation to custom directory

```bash
curl -fsSL https://raw.githubusercontent.com/patekcz/Tool-DiscordAndVencordInstaller/main/install.sh | bash -s -- --installDirName=$HOME/Applications/DiscordCanary
```

### Forced reinstallation

```bash
curl -fsSL https://raw.githubusercontent.com/patekcz/Tool-DiscordAndVencordInstaller/main/install.sh | bash -s -- --force
```

### Forced Vencord reinstallation without .desktop

```bash
curl -fsSL https://raw.githubusercontent.com/patekcz/Tool-DiscordAndVencordInstaller/main/install.sh | bash -s -- --forceVencord --skipDesktop
```

## Features

* Automatic installation of the latest Discord Canary version
* Optional Vencord extension installation
* Creation of .desktop file for easy launching
* Interactive and non-interactive modes
* Version checking and update support
* Automatic dependency checking and installation
* Forced reinstallation options for both Discord and Vencord

## Requirements

The script automatically checks and installs all necessary dependencies:

* curl
* wget
* tar
* rsync
* nodejs (only if installing Vencord)

## Usage via Script Download

If you prefer to download the script first and then run it:

```bash
# Download the script
curl -fsSL -o install.sh https://raw.githubusercontent.com/patekcz/Tool-DiscordAndVencordInstaller/main/install.sh

# Set permissions
chmod +x install.sh

# Run the script
./install.sh
```

## Command Line Parameters

* `--installDirName=PATH` - Specifies installation directory (default: $HOME/Programs/DiscordCanary)
* `--createDesktop` - Creates .desktop file for easy launching
* `--skipDesktop` - Skips .desktop file creation
* `--skipVencord` - Skips Vencord installation
* `--installVencord` - Installs Vencord (default)
* `--force` - Forced installation (overwrites existing files)
* `--forceVencord` - Forced Vencord reinstallation
* `--interactive` - Forces interactive mode
* `--help` - Shows help

## Uninstallation

To uninstall Discord Canary and Vencord, simply remove the installation directory and .desktop file:

```bash
rm -rf ~/Programs/DiscordCanary
rm ~/.local/share/applications/discord-canary-vencord.desktop
```

## License

This script is provided free for use, modification, and redistribution.