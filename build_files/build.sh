#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

# dnf -y remove gnome-shell
# dnf -y install pipewire xdg-desktop-portal-wlr
dnf -y install xdg-desktop-portal-wlr

## DNF5 Speedup
sed -i '/^\[main\]/a max_parallel_downloads=10' /etc/dnf/dnf.conf

## System apps
dnf -y install libvirt virt-manager qemu-kvm flatpak-builder wlr-randr iotop sysstat lxqt-openssh-askpass lxpolkit parallel just seahorse android-tools iperf3 ktls-utils podman-compose

# User apps
dnf -y install nautilus kitty mpv gnome-terminal gnome-system-monitor gnome-calculator loupe

# OBS and fully-featured ffmpeg with nonfree components from rpm fusion
dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf -y install ffmpeg x264-libs obs-studio obs-studio-plugin-x264 libva-utils --allowerasing

# Nautilus open any terminal extension
curl -Lo /etc/yum.repos.d/nautilus-open-any-terminal.repo \
  https://copr.fedorainfracloud.org/coprs/monkeygold/nautilus-open-any-terminal/repo/fedora-$(rpm -E %fedora)/monkeygold-nautilus-open-any-terminal-fedora-$(rpm -E %fedora).repo
# dnf install -y nautilus-open-any-terminal
# glib-compile-schemas /usr/share/glib-2.0/schemas
# gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty


# Install Niri
dnf -y install niri

curl -Lo /etc/yum.repos.d/peterwu.repo https://copr.fedorainfracloud.org/coprs/peterwu/rendezvous/repo/fedora-$(rpm -E %fedora)/peterwu-rendezvous-fedora-$(rpm -E %fedora).repo
dnf -y install bibata-cursor-themes

# # Install Noctalia shell
# curl -fsSL https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo -o /etc/yum.repos.d/terra.repo
# dnf -y install terra-release
# dnf -y install noctalia-shell
# # ABILITARE LE NOTIFICHE: systemctl --user enable --now swaync.service

# Install Dank Linux shell
curl --output-dir "/etc/yum.repos.d/" --remote-name "https://copr.fedorainfracloud.org/coprs/avengemedia/dms/repo/fedora-$(rpm -E %fedora)/avengemedia-dms-fedora-$(rpm -E %fedora).repo"

# Quickshell uses Qt private APIs. Keep the Qt stack aligned with the Fedora
# repositories before installing Quickshell, otherwise a bootc base image with
# an older Qt patch level can produce an ABI mismatch (e.g. Qt 6.11.1 vs 6.11.2).
dnf -y upgrade 'qt6-*'
dnf -y install quickshell dms greetd dms-greeter --allowerasing

# Niri configuration for newly created users. Copy our main config first, then
# let DMS populate any missing ~/.config/niri/dms/*.kdl fragments in /etc/skel.
mkdir -p /etc/skel/.config/niri
cp -f /ctx/dot_config/niri/config.kdl /etc/skel/.config/niri/config.kdl

# Start DMS automatically in graphical user sessions.
mkdir -p /etc/skel/.config/systemd/user/graphical-session.target.wants
ln -sf /usr/lib/systemd/user/dms.service /etc/skel/.config/systemd/user/graphical-session.target.wants/dms.service

# Configure greetd + DMS Greeter. Keep the greeter compositor configuration
# separate from the user's Niri configuration: it must be minimal and must not
# depend on files in a user's home directory.
mkdir -p /etc/greetd/niri
cat > /etc/greetd/niri/config.kdl <<'EOF'
hotkey-overlay {
    skip-at-startup
}

environment {
    DMS_RUN_GREETER "1"
}

gestures {
    hot-corners {
        off
    }
}

layout {
    background-color "#000000"
}
EOF

cat > /etc/greetd/config.toml <<'EOF'
[terminal]
vt = 1

[default_session]
user = "greeter"
command = "/usr/bin/dms-greeter --command niri -C /etc/greetd/niri/config.kdl --cache-dir /var/cache/dms-greeter"
EOF

# dms-greeter sync is intentionally not run here: during image construction
# there is no real desktop user yet, so it would sync root's state. Users can
# run `dms-greeter sync` after first login to mirror their theme/settings into
# the greeter; the baseline greeter above works independently of that sync.
rm -f /etc/systemd/system/display-manager.service
ln -s /usr/lib/systemd/system/greetd.service /etc/systemd/system/display-manager.service
systemctl enable --force greetd.service

# DEV packages
# cargo evtest git input-remapper libevdev-devel libinput-utils python3-devel

# dnf -y install bitwarden-cli

#### Enable podman

systemctl enable podman.socket

# Remove waybar
dnf -y remove waybar

# this is needed for some glib applications
glib-compile-schemas /usr/share/glib-2.0/schemas/

dnf5 install -y openssh-server
systemctl enable sshd

## CLEAN UP
# Clean up dnf cache to reduce image size
dnf5 -y clean all
rm -rf /run/dnf /run/selinux-policy
rm -rf /var/lib/dnf
