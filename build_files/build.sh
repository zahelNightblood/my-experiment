#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

dnf5 install -y \
  niri \
  xwayland-satellite \
  kitty \
  fuzzel \
  waybar \
  mako \
  swaybg \
  polkit-kde-agent-1 \
  network-manager-applet \
  gnome-keyring \
  libsecret \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal

### AUDIO ###
dnf5 install -y \
  pipewire \
  pipewire-pulseaudio \
  wireplumber \
  pavucontrol \
  helvum

### SYSTEM TOOLS ###
dnf5 install -y \
  tmux \
  git \
  neovim \
  btop \
  fastfetch \
  podman \
  distrobox \
  curl \
  wget \
  brightnessctl \
  pamixer \
  NetworkManager-tui

### FONTS (needed for waybar, foot, etc.) ###
dnf5 install -y \
  google-noto-sans-fonts \
  google-noto-emoji-fonts \
  fontawesome-fonts

### DISPLAY MANAGER (minimal — greetd with text greeter) ###
dnf5 install -y \
  greetd \
  tuigreet

### FLATPAK SUPPORT ###
dnf5 install -y \
  flatpak

### ENABLE SERVICES ###
systemctl enable podman.socket
systemctl enable greetd
systemctl --global enable pipewire.socket
systemctl --global enable wireplumber

### SET greetd TO AUTO-START NIRI ###
cat > /etc/greetd/config.toml << 'EOF'
[terminal]
vt = 1

[default_session]
command = "tuigreet --greeting 'Welcome to your Niri system!' --asterisks --time --cmd niri-session"
user = "greeter"
EOF

### CREATE A DEFAULT DESKTOP BACKGROUND ###
mkdir -p /usr/share/backgrounds

### CLEAN UP ###
dnf5 clean all
# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

