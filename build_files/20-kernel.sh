#!/usr/bin/env bash

set -ouex pipefail

rpmostree_hook=/usr/lib/kernel/install.d/05-rpmostree.install
rpmostree_hook_disabled="${rpmostree_hook}.baffos-build-disabled"

# bootc: the CachyOS Fedora kernel RPM calls kernel-install in %posttrans.
# In a container build, the rpm-ostree hook currently fails while dracut crosses
# the build mount boundary. Disable only that hook for the RPM transaction and
# create the bootc module-tree initramfs explicitly below.
mv "${rpmostree_hook}" "${rpmostree_hook_disabled}"
dnf5 -y install kernel-cachyos policycoreutils-python-utils --allowerasing
mv "${rpmostree_hook_disabled}" "${rpmostree_hook}"

mapfile -t fedora_kernel_pkgs < <(
    rpm -qa --qf '%{NAME}\n' |
        grep -E '^kernel(-core|-modules(-core|-extra)?|-modules-extra-common)?$' |
        sort -u
)

if (( ${#fedora_kernel_pkgs[@]} )); then
    dnf5 -y remove "${fedora_kernel_pkgs[@]}"
fi

setsebool -P domain_kernel_load_modules on

mapfile -t cachy_modules < <(find /usr/lib/modules -maxdepth 1 -mindepth 1 -type d -name '*cachy*' -printf '%f\n' | sort -V)
(( ${#cachy_modules[@]} == 1 ))

kernel_version="${cachy_modules[0]}"
kernel_dir="/usr/lib/modules/${kernel_version}"

depmod "${kernel_version}"

# bootc: CachyOS' Fedora RPMs are built for normal hosts too, so fail the image
# build if kernel-install does not leave bootc-image-builder usable assets.
test -f "${kernel_dir}/modules.dep"
test -f "${kernel_dir}/vmlinuz"
dracut --no-hostonly --no-hostonly-cmdline -f --kver "${kernel_version}" "${kernel_dir}/initramfs.img"
test -f "${kernel_dir}/initramfs.img"

test "$(find /usr/lib/modules -maxdepth 1 -mindepth 1 -type d | wc -l)" -eq 1
