#!/bin/bash

set -e

echo "=== Aztec Node Installer (Interactive Mode) ==="

# گرفتن اطلاعات از کاربر
read -p "Enter your Ethereum RPC URL: " ETHEREUM_RPC_URL
read -p "Enter your Consensus Beacon URL: " CONSENSUS_BEACON_URL
read -p "Enter your Validator Private Key (starting with 0x): " VALIDATOR_PRIVATE_KEY
read -p "Enter your Coinbase (your own wallet address): " COINBASE
read -p "Enter your public IP (P2P IP): " P2P_IP

echo "=== 1. Updating and Installing Dependencies ==="
sudo apt-get update && sudo apt-get upgrade -y

sudo apt install -y curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip

echo "=== 2. Installing Docker ==="
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do 
  sudo apt-get remove -y $pkg 
done

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Test Docker
sudo docker run hello-world
sudo systemctl enable docker
sudo systemctl restart docker

echo "=== 3. Installing Aztec Tools ==="
yes | bash -i <(curl -s https://install.aztec.network)
echo 'export PATH="$HOME/.aztec/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

echo "=== 4. Updating Aztec ==="
aztec-up alpha-testnet

echo "=== 5. Enabling Firewall and Opening Ports ==="
sudo ufw allow 22
sudo ufw allow ssh
sudo ufw allow 40400
sudo ufw allow 8080
sudo ufw --force enable

echo "=== 6. Setting Up Aztec Node via Docker ==="
docker stop $(docker ps -q --filter "ancestor=aztecprotocol/aztec") || true
docker rm $(docker ps -a -q --filter "ancestor=aztecprotocol/aztec") || true
screen -ls | grep -i aztec | awk '{print $1}' | xargs -I {} screen -X -S {} quit || true

mkdir -p ~/aztec && cd ~/aztec

cat <<EOF > .env
ETHEREUM_RPC_URL=$ETHEREUM_RPC_URL
CONSENSUS_BEACON_URL=$CONSENSUS_BEACON_URL
VALIDATOR_PRIVATE_KEY=$VALIDATOR_PRIVATE_KEY
COINBASE=$COINBASE
P2P_IP=$P2P_IP
EOF

cat <<EOF > docker-compose.yml
services:
  aztec-node:
    container_name: aztec-sequencer
    network_mode: host 
    image: aztecprotocol/aztec:alpha-testnet
    restart: unless-stopped
    environment:
      ETHEREUM_HOSTS: \${ETHEREUM_RPC_URL}
      L1_CONSENSUS_HOST_URLS: \${CONSENSUS_BEACON_URL}
      DATA_DIRECTORY: /data
      VALIDATOR_PRIVATE_KEY: \${VALIDATOR_PRIVATE_KEY}
      COINBASE: \${COINBASE}
      P2P_IP: \${P2P_IP}
      LOG_LEVEL: debug
    entrypoint: >
      sh -c 'node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js start --network alpha-testnet --node --archiver --sequencer'
    ports:
      - 40400:40400/tcp
      - 40400:40400/udp
      - 8080:8080
    volumes:
      - /root/.aztec/alpha-testnet/data/:/data
EOF

echo "=== 7. Running Aztec Node via Docker ==="
docker compose up -d

echo "✅ All steps completed successfully. Your Aztec node is running."
