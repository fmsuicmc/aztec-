# Aztec Node Installer (Interactive & Dockerized)

This repository provides an interactive and automated Bash script to install and run an Aztec Sequencer node on Ubuntu-based systems. The script installs required dependencies, configures Docker, installs Aztec tools, and launches the node via Docker Compose.

## ⚙️ Features

- Automated installation of system dependencies
- Secure Docker installation and setup
- Interactive prompts for required input values
- Auto-generation of `.env` and `docker-compose.yml`
- Node deployment using Docker
- Firewall configuration and required port setup

## 🖥️ Requirements

- Ubuntu 20.04 or later
- Sudo or root access
- Open ports: `22`, `40400`, `8080`
- The following information:
  - `ETHEREUM_RPC_URL`: Your Ethereum Sepolia RPC URL
  - `CONSENSUS_BEACON_URL`: Your sepolia Beacon URL
  - `VALIDATOR_PRIVATE_KEY`: Your wallet private key
  - `COINBASE`: Your wallet address to receive rewards
  - `P2P_IP`: Your public IP address for peer-to-peer communication

## 🚀 Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/fmsuicmc/aztec-.git
cd aztec-
```

### 2. Make the script executable

```bash
chmod +x install_aztec_node.sh
```

### 3. Run the script

```bash
./install_aztec_node.sh
```

You will be prompted to input your node credentials and configuration values. The script will then create the `.env` and `docker-compose.yml` files automatically.

### 4. Check if the node is running

```bash
docker ps
```

### 5. View logs

```bash
docker logs -f aztec-sequencer
```
### 6. go to Discord

```curl -s -X POST -H 'Content-Type: application/json' \
-d '{"jsonrpc":"2.0","method":"node_getL2Tips","params":[],"id":67}' \
http://localhost:8080 | jq -r ".result.proven.number"```

```curl -s -X POST -H 'Content-Type: application/json' \
-d '{"jsonrpc":"2.0","method":"node_getArchiveSiblingPath","params":["BLOCK_NUMBER","BLOCK_NUMBER"],"id":67}' \
http://localhost:8080 | jq -r ".result"```


## 🔐 Security Notes

- Your `.env` file contains sensitive information such as your private key. **Do not share it publicly.**
- The default data path in Docker is `/root/.aztec/alpha-testnet/data/`. You may change this path as needed in `docker-compose.yml`.

## 🛠️ Updating the Node

To update your node:

1. Stop the node:

```bash
docker compose down
```

2. Update Aztec tools:

```bash
aztec-up alpha-testnet
```

3. (Optional) Clear old data:

```bash
rm -rf ~/.aztec/alpha-testnet/data/
```

4. Restart the node:

```bash
docker compose up -d
```

## 📚 Useful Resources

- [Aztec Documentation](https://docs.aztec.network/)
- [How to Run a Sequencer](https://docs.aztec.network/the_aztec_network/guides/run_nodes/how_to_run_sequencer)
- [Aztec Discord Community](https://discord.gg/aztec)

## 📄 License

MIT © 2025 [fmsuicmc](https://github.com/fmsuicmc)

---

> Need help? Open an issue or ask in the Aztec Discord!
