#!/usr/bin/env bash

set -oue pipefail

mkdir -p /var/usrlocal/bin

curl -sfL https://get.k3s.io |
	INSTALL_K3S_SKIP_ENABLE=true \
		INSTALL_K3S_SELINUX_WARN=true \
		INSTALL_K3S_SKIP_START=true \
		INSTALL_K3S_BIN_DIR=/var/usrlocal/bin \
		INSTALL_K3S_SYSTEMD_DIR="/usr/lib/systemd/system" \
		sh -
