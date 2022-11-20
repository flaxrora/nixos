
parted /dev/vda -- mklabel gpt

parted /dev/vda -- mkpart primary 512MiB -2GiB

parted /dev/vda -- mkpart primary linux-swap -2GiB 100%

parted /dev/vda -- mkpart ESP fat32 1MiB 512MiB

parted /dev/vda -- set 3 esp on

# formatting

mkfs.ext4 -L nixos /dev/vda1

mkswap -L swap /dev/vda2

mkfs.fat -F 32 -n boot /dev/vda3

# mounting

mount /dev/disk/by-label/nixos /mnt

mkdir -p /mnt/boot

mount /dev/disk/by-label/boot /mnt/boot

swapon /dev/vda2

nixos-generate-config --root /mnt

# echo "" > /mnt/etc/nixos/configuration.nix

# vim /mnt/etc/nixos/configuration.nix

# # INSTALL

# nixos-install

# reboot

# # ----- AFTER INSTALL -----

# sudo smbpasswd -a [username]

# nixos-rebuild switch # anytime you made change on the config

# nixos-rebuild test   # reflecting the changes on the config without switching
#                      # once reboot it will revert back to the old version
