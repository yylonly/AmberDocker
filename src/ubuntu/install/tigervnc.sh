#!/usr/bin/env bash
set -e

echo "Install TigerVNC server"
wget -qO- https://sourceforge.net/projects/tigervnc/files/stable/1.13.0/tigervnc-1.13.0.x86_64.tar.gz/download | tar xz --strip 1 -C /
