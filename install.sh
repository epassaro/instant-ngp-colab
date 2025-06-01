#!/usr/bin/env bash
set -eu

CYAN="\033[1;36m"
GREEN="\033[1;32m"
RESET="\033[0m"

echo -e "${CYAN}"
cat << "EOF"
 ___   __    _  _______  _______  _______  __    _  _______         __    _  _______  _______         _______  _______  ___      _______  _______ 
|   | |  |  | ||       ||       ||   _   ||  |  | ||       |       |  |  | ||       ||       |       |       ||       ||   |    |   _   ||  _    |
|   | |   |_| ||  _____||_     _||  |_|  ||   |_| ||_     _| ____  |   |_| ||    ___||    _  | ____  |       ||   _   ||   |    |  |_|  || |_|   |
|   | |       || |_____   |   |  |       ||       |  |   |  |____| |       ||   | __ |   |_| ||____| |       ||  | |  ||   |    |       ||       |
|   | |  _    ||_____  |  |   |  |       ||  _    |  |   |         |  _    ||   ||  ||    ___|       |      _||  |_|  ||   |___ |       ||  _   | 
|   | | | |   | _____| |  |   |  |   _   || | |   |  |   |         | | |   ||   |_| ||   |           |     |_ |       ||       ||   _   || |_|   |
|___| |_|  |__||_______|  |___|  |__| |__||_|  |__|  |___|         |_|  |__||_______||___|           |_______||_______||_______||__| |__||_______|

EOF
echo -e "${RESET}"
echo -e "${GREEN}Installing instant-ngp-colab dependencies...${RESET}"
echo -e "${RED}Note:${RESET} This script assumes a compatible environment (Colab or local with prerequisites)."
echo

wget -q https://github.com/epassaro/instant-ngp-colab/releases/latest/download/instant-ngp
chmod +x instant-ngp
cp instant-ngp /usr/local/bin
rm instant-ngp
