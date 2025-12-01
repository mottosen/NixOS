# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS flake-based configuration repository supporting multiple system profiles. The configuration uses a modular architecture that separates hardware and software concerns, with profile-specific settings defined centrally.

## Common Commands

### Update flake lock file

```bash
nix flake update
```

### Rebuild system

Replace `<profile>` with one of the specified profiles in the flake:

```bash
sudo nixos-rebuild switch --flake .#<profile>
```

### Install NixOS from scratch

```bash
nixos-install --flake "github:mottosen/NixOS#<profile>"
```

## Architecture

### Profile System

The repository uses a profile-based architecture where each profile specifies both system and user settings. Profiles are selected via the `profile` parameter in `flake.nix`, which is passed as a `specialArg` to all modules.

**Key files:**

- `flake.nix` - Defines nixosConfigurations for each profile
- `profiles/*/default.nix` - Profile-specific settings using lib.mkIf guards
- `.definitions/` - Declares options for systemSettings and userSettings

### Module Structure

The configuration is split into two main module trees:

**Hardware modules** (`modules/hardware/`):

- `bootloader/` - EFI, BIOS, and BIOS-Libreboot configurations
- `kernel/` - Kernel-specific settings
- `system/` - Hardware-specific modules
- `default.nix` - Common hardware settings (graphics, bluetooth, filesystems)

**Software modules** (`modules/software/`):

- `browser/`, `editor/`, `multiplexor/`, `shell/`, `terminal/`, `windowManager/` - User application modules
- `default.nix` - System-wide packages, services, and user configuration

### Settings System

Settings are defined as NixOS module options in `.definitions/`:

- `systemSettings` - Hardware and system-level config (hostname, timezone, bootloader, kernel, etc.)
- `userSettings` - User preferences (username, email, shell, editor, windowManager, etc.)

Profiles set these options, and modules throughout the tree reference them via `config.systemSettings.*` and `config.userSettings.*`.

### Module Activation Pattern

Many modules use conditional activation based on profile settings:

```nix
config = lib.mkIf (config.userSettings.windowManager == "hypr") {
  # module configuration
};
```

## Important Notes

- The system requires experimental features "nix-command" and "flakes"
- `nix-ld` is enabled to support dynamically linked executables (needed for Mason LSP servers)
- Default filesystem layout uses `/dev/disk/by-label/nixos` for root
- Dotfiles are managed in the `dotfiles/` subdirectory
