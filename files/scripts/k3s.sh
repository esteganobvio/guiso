#!/usr/bin/env bash

set -oue pipefail

mkdir -p /var/usrlocal/bin

# shortcut: installer installs k3s SELinux policy with rpm-ostree, impossible in the build container.
# No k3s.pp policy module lands in the image; install k3s-selinux from rpm.rancher.io on the host if needed.
curl -sfL https://get.k3s.io |
	INSTALL_K3S_SKIP_ENABLE=true \
	INSTALL_K3S_SELINUX_WARN=true \
	INSTALL_K3S_SKIP_SELINUX_RPM=true \
	INSTALL_K3S_SKIP_START=true \
	INSTALL_K3S_BIN_DIR=/var/usrlocal/bin \
	INSTALL_K3S_SYSTEMD_DIR="/usr/lib/systemd/system" \
	sh -
