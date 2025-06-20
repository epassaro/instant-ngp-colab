#!/usr/bin/env bash
set -eu

RED="\033[1;31m"
ORANGE='\033[0;33m'
GREEN="\033[1;32m"
CYAN="\033[1;36m"
RESET="\033[0m"

error_exit() {
    echo
    echo -e "${RED}❌ Error:${RESET} $1"
    exit 1
}

warning() {
    echo
    echo -e "${ORANGE}⚠️ Warning:${RESET} $1"
}

echo -e "${CYAN}"
cat << "EOF"
 _______  _______  _______  __    _  _______  _______  ___      _______  _______         _______  _______  ___      _______  _______ 
|       ||       ||       ||  |  | ||       ||       ||   |    |   _   ||       |       |       ||       ||   |    |   _   ||  _    |
|   _   ||    _  ||    ___||   |_| ||  _____||    _  ||   |    |  |_|  ||_     _| ____  |       ||   _   ||   |    |  |_|  || |_|   |
|  | |  ||   |_| ||   |___ |       || |_____ |   |_| ||   |    |       |  |   |  |____| |       ||  | |  ||   |    |       ||       |
|  |_|  ||    ___||    ___||  _    ||_____  ||    ___||   |___ |       |  |   |         |      _||  |_|  ||   |___ |       ||  _   | 
|       ||   |    |   |___ | | |   | _____| ||   |    |       ||   _   |  |   |         |     |_ |       ||       ||   _   || |_|   |
|_______||___|    |_______||_|  |__||_______||___|    |_______||__| |__|  |___|         |_______||_______||_______||__| |__||_______|

EOF
echo -e "${RESET}"

echo -e "${CYAN}───────────────────────────────────────────────────────────────────${RESET}"
echo -e "${CYAN}🔗 Project repository: https://github.com/epassaro/opensplat-colab${RESET}"
echo -e "${CYAN}───────────────────────────────────────────────────────────────────${RESET}"

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
    warning "The 'nvidia-smi' command was not found. This runtime does not have a GPU."
fi

#gpu_model=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n1)
#if [[ "$gpu_model" != *"T4"* && "$gpu_model" != *"A100"* && "$gpu_model" != *"L4"* ]]; then
#    warning "An NVIDIA T4, A100, or L4 GPU is required. Detected: $gpu_model"
#fi
#echo -e "${GREEN}   ✔ Supported GPU detected: $gpu_model${RESET}"
#
#cuda_version=$(nvcc --version | grep "release" | sed -E 's/.*release ([0-9]+\.[0-9]+).*/\1/')
#if [[ "$cuda_version" != "12.5" ]]; then
#    error_exit "CUDA Toolkit 12.5 is required. Detected: $cuda_version"
#fi
#echo -e "${GREEN}   ✔ CUDA Toolkit 12.5 detected${RESET}"

echo
echo -e "⬇️ Downloading precompiled binaries..."
wget -q https://github.com/epassaro/instant-ngp-colab/releases/latest/download/colmap-3.9.1-ubuntu-22.04.tar.gz
tar xf colmap-3.9.1-ubuntu-22.04.tar.gz -C /usr/local
rm -f colmap-3.9.1-ubuntu-22.04.tar.gz
echo -e "${GREEN}   ✔ colmap installed${RESET}"

wget -q https://github.com/epassaro/instant-ngp-colab/releases/latest/download/opensplat
chmod +x opensplat
mv opensplat /usr/local/bin
echo -e "${GREEN}   ✔ opensplat installed${RESET}"

#wget -q https://github.com/epassaro/instant-ngp-colab/releases/latest/download/instant-ngp
#chmod +x instant-ngp
#mv instant-ngp /usr/local/bin
#echo -e "${GREEN}   ✔ instant-ngp installed${RESET}"

#wget -q https://github.com/epassaro/instant-ngp-colab/releases/latest/download/pyngp.cpython-311-x86_64-linux-gnu.so
#cp pyngp.cpython-311-x86_64-linux-gnu.so /usr/local/lib/python3.11/dist-packages
#rm -f pyngp.cpython-311-x86_64-linux-gnu.so
#echo -e "${GREEN}   ✔ pyngp installed${RESET}"

echo
echo -e "📦 Installing runtime dependencies..."
apt-get install -qq libmetis5 libspqr2 libcxsparse3 libfreeimage3 libqt5widgets5 > /dev/null 2>&1
echo -e "${GREEN}   ✔ libmetis5 installed${RESET}"
echo -e "${GREEN}   ✔ libspqr2 installed${RESET}"
echo -e "${GREEN}   ✔ libcxsparse3 installed${RESET}"
echo -e "${GREEN}   ✔ libfreeimage3 installed${RESET}"
echo -e "${GREEN}   ✔ libqt5widgets5 installed${RESET}"

wget -q https://download.pytorch.org/libtorch/cu124/libtorch-cxx11-abi-shared-with-deps-2.6.0%2Bcu124.zip -O libtorch.zip
unzip -q libtorch.zip
rm -f libtorch.zip
cp -r libtorch/. /usr/local
rm -rf libtorch/
ldconfig > /dev/null 2>&1
echo -e "${GREEN}   ✔ torchlib installed${RESET}"

echo
echo "🚀 Everything is set up! You can now run OpenSplat in this Colab environment 😀"
