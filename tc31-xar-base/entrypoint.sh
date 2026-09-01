#!/bin/sh
# SPDX-License-Identifier: Zero-Clause BSD

# Exit immediately if a command exits with a non-zero status
set -e

# TwinCAT Linux authenticates ADS route setup against a local Linux account.
# Defaults match Beckhoff's documented Runtime for Linux credentials.
: "${ADS_USERNAME:=Administrator}"
: "${ADS_PASSWORD:=1}"

if ! id "${ADS_USERNAME}" >/dev/null 2>&1; then
    useradd --create-home --shell /bin/bash "${ADS_USERNAME}"
fi
printf '%s:%s\n' "${ADS_USERNAME}" "${ADS_PASSWORD}" | chpasswd

# Indicate the script's start for logging purposes
echo "Starting TcSystemServiceUm..."

# Replaces the shell process with the TcSystemServiceUm process, ensuring proper signal handling
exec /usr/bin/TcSystemServiceUm -f 0x7 -i "${AMS_NETID}" -p /var/run/TcSystemServiceUm.pid
