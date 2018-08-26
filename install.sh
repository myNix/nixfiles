#!/usr/bin/env bash

# USAGE: ./install.sh [DEVICE_NAME] [USER_NAME] [HOSTNAME]

set -e -x -u -o pipefail

DEVICE=$1
USERNAME=$2
GROUP=$3

format_disk () {
  sgdisk -Z ${DEVICE}
  sgdisk -og ${DEVICE}
  partprobe ${DEVICE}
  sgdisk -n 1:2048:1050623 -c 1:\"EFI System Partition\" -t 1:ef00 ${DEVICE}
  local END_SECTOR=`sgdisk -E ${DEVICE}`
  sgdisk -n 2:1050624: -c 1:\"Linux LUKS\" -t 2:8309 ${DEVICE}
  sgdisk -p ${DEVICE}
  local BOOT_PART="${DEVICE}1"
  local CRYPTED_PART="${DEVICE}2"
  cryptsetup luksFormat -c aes-xts-plain64 -s 512 "${CRYPTED_PART}"
  crypsetup open "${CRYPTED_PART}" system
  mkfs.ext4 -L system /dev/mapper/system
  mkfs.fat -F32 "${DEVICE}1"
  mount /dev/mapper/system /mnt
  mount ${BOOT_PART} /mnt/boot
}

main () {
  format_disk
  nixos-generate-config --root /mnt
}

main
