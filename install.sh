#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="/etc/ligolo-ng"
BINARY_SRC="ligolo-proxy-linux-amd64"
BINARY_NAME="ligolo-proxy"
SERVICE="ligolo-ng"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

banner() { echo -e "\n${CYAN}==========================================${NC}\n${CYAN} $1${NC}\n${CYAN}==========================================${NC}\n"; }

if [[ $EUID -ne 0 ]]; then
    echo "Run as root: sudo $0"
    exit 1
fi

if [[ ! -f "${BUILD_DIR}/${BINARY_SRC}" ]]; then
    echo -e "${YELLOW}Binary not found at ${BUILD_DIR}/${BINARY_SRC}${NC}"
    echo "Run 'make build' first."
    exit 1
fi

echo -e "${GREEN}[1/3] Installing binary...${NC}"
install -Dm755 "${BUILD_DIR}/${BINARY_SRC}" "${INSTALL_DIR}/${BINARY_NAME}"
echo "  Copied to ${INSTALL_DIR}/${BINARY_NAME}"

echo -e "${GREEN}[2/3] Creating ${SERVICE}.service...${NC}"
cat > "/etc/systemd/system/${SERVICE}.service" <<EOF
[Unit]
Description=Ligolo-ng Proxy
After=network.target

[Service]
Type=simple
WorkingDirectory=${INSTALL_DIR}
ExecStart=${INSTALL_DIR}/${BINARY_NAME} -daemon -selfcert -laddr 0.0.0.0:11601
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
echo "  Service created (NOT started)"

banner "CONFIGURE LIGOLO-NG BEFORE STARTING"
echo "  Run the binary once to generate config:"
echo ""
echo -e "    ${YELLOW}cd ${INSTALL_DIR}${NC}"
echo -e "    ${YELLOW}sudo ./${BINARY_NAME} -selfcert${NC}"
echo ""
echo "  This will create ligolo-ng.yaml in ${INSTALL_DIR}/"
echo "  Go through the setup: enable Web UI, set CORS"

banner "After configuration, start the service:"
echo -e "    ${YELLOW}sudo systemctl enable ${SERVICE}${NC}"
echo -e "    ${YELLOW}sudo systemctl start ${SERVICE}${NC}"
echo ""

