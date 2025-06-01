#!/usr/bin/env bash
set -eu

wget -q https://github.com/epassaro/instant-ngp-colab/releases/latest/download/instant-ngp
chmod +x instant-ngp
cp instant-ngp /usr/local/bin
rm instant-ngp
