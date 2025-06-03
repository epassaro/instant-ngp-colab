#!/usr/bin/env bash
set -eu

RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
RESET="\033[0m"

error_exit() {
    echo
    echo -e "${RED}Error:${RESET} $1"
    exit 1
}

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

echo -e "${CYAN}────────────────────────────────────────────────────────────────────${RESET}"
echo -e "${CYAN}🔗 Project repository: https://github.com/epassaro/instant-ngp-colab${RESET}"
echo -e "${CYAN}────────────────────────────────────────────────────────────────────${RESET}"

echo
echo -e "🚧 Checking Colab runtime environment..."
os_version=$(lsb_release -rs)
if [[ "$os_version" != "22.04" ]]; then
    error_exit "This script requires Ubuntu 22.04. Detected version: $os_version"
fi
echo -e "${GREEN}   ✔ Ubuntu 22.04 detected${RESET}"

python_version=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
if [[ "$python_version" != "3.11" ]]; then
    error_exit "Python 3.11 is required. Detected: $python_version"
fi
echo -e "${GREEN}   ✔ Python 3.11 detected${RESET}"

if ! command -v nvidia-smi &> /dev/null; then
    error_exit "The 'nvidia-smi' command was not found. Make sure the runtime is set to use a GPU."
fi

gpu_model=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n1)
if [[ "$gpu_model" != *"T4"* && "$gpu_model" != *"A100"* && "$gpu_model" != *"L4"* ]]; then
    error_exit "An NVIDIA T4, A100, or L4 GPU is required. Detected: $gpu_model"
fi
echo -e "${GREEN}   ✔ Supported GPU detected: $gpu_model${RESET}"

cuda_version=$(nvcc --version | grep "release" | sed -E 's/.*release ([0-9]+\.[0-9]+).*/\1/')
if [[ "$cuda_version" != "12.5" ]]; then
    error_exit "CUDA Toolkit 12.5 is required. Detected: $cuda_version"
fi
echo -e "${GREEN}   ✔ CUDA Toolkit 12.5 detected${RESET}"

#echo
#echo -e "${GREEN}Installing system dependencies...${RESET}"

echo
echo -e "⬇️ Downloading and installing binaries..."

wget -q https://github.com/epassaro/instant-ngp-colab/releases/latest/download/runtime-deps.tar.gz
tar xf runtime-deps.tar.gz -C /usr/local
rm runtime-deps.tar.gz
echo -e "${GREEN}   ✔ runtime dependencies installed${RESET}"

wget -q https://github.com/epassaro/instant-ngp-colab/releases/latest/download/instant-ngp
chmod +x instant-ngp
cp instant-ngp /usr/local/bin
rm instant-ngp
echo -e "${GREEN}   ✔ instant-ngp binary installed${RESET}"

wget -q https://github.com/epassaro/instant-ngp-colab/releases/latest/download/pyngp.cpython-311-x86_64-linux-gnu.so
cp pyngp.cpython-311-x86_64-linux-gnu.so /usr/local/lib/python3.11/dist-packages
rm pyngp.cpython-311-x86_64-linux-gnu.so
echo -e "${GREEN}   ✔ pyngp binary installed${RESET}"

echo
echo "🚀 Everything is set up! You can now run instant-ngp commands in this Colab environment."
