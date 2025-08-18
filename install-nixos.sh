#!/usr/bin/env bash
set -euo pipefail

# ---------- defaults (edit or override via flags) ----------
DISK="/dev/sda"                              # target disk (e.g. /dev/sda or /dev/vda)
EFI_SIZE="1GiB"                              # size of EFI System Partition
EFI_LABEL="EFI"
ROOT_LABEL="nixos"
FLAKE_URL="github:mottosen/NixOS"
FLAKE_HOST="system"                          # nixosConfigurations.<host>
NO_ROOT_PASSWD=0                              # set 1 to skip setting a root password
# -----------------------------------------------------------

usage() {
  cat <<EOF
Usage: sudo $0 [--disk /dev/sdX] [--flake github:user/repo] [--host <key>] [--no-root-passwd]

This will DESTROY all data on the target disk by repartitioning it.
EOF
  exit 2
}

# ---- parse flags ----
while [[ $# -gt 0 ]]; do
  case "$1" in
    --disk)              DISK="$2"; shift 2 ;;
    --flake)             FLAKE_URL="$2"; shift 2 ;;
    --host)              FLAKE_HOST="$2"; shift 2 ;;
    --no-root-passwd)    NO_ROOT_PASSWD=1; shift ;;
    -h|--help)           usage ;;
    *) echo "Unknown arg: $1"; usage ;;
  esac
done

# ---- root check ----
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (e.g.: sudo $0 ...)" >&2
  exit 1
fi

# ---- confirm destructive action ----
echo "About to wipe and install NixOS to: ${DISK}"
read -rp "This will ERASE ${DISK}. Type 'yes (y)' to continue: " ans
[[ "$ans" == "y" ]] || { echo "Aborted."; exit 1; }

# ---- unmount any previous mounts ----
swapoff -a || true
for m in /mnt/boot /mnt; do
  mountpoint -q "$m" && umount -R "$m"
done

# ---- partition disk (GPT: EFI + root) ----
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart EFI fat32 1MiB "$EFI_SIZE"
parted -s "$DISK" set 1 esp on
parted -s "$DISK" mkpart nixos ext4 "$EFI_SIZE" 100%

# ---- make filesystems + labels ----
mkfs.vfat -F32 -n "$EFI_LABEL" "${DISK}1"
mkfs.ext4 -L "$ROOT_LABEL" "${DISK}2"

# ---- mount partitions ----
mount "/dev/disk/by-label/${ROOT_LABEL}" /mnt
mkdir -p /mnt/boot
mount "/dev/disk/by-label/${EFI_LABEL}" /mnt/boot

# ---- install from flake ----
echo "Installing from flake: ${FLAKE_URL}#${FLAKE_HOST}"
if [[ "$NO_ROOT_PASSWD" -eq 1 ]]; then
  nixos-install --no-root-passwd --flake "${FLAKE_URL}#${FLAKE_HOST}"
else
  nixos-install --flake "${FLAKE_URL}#${FLAKE_HOST}"
fi

echo "Install complete. Powering off..."
echo "\tRemember to remove install media.
poweroff

