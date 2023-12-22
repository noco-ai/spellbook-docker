# Spellbook Docker Compose

The repository contains the Docker Compose files for running the Spellbook AI Assistant stack. The function calling features
require ExLlama and a Nvidia Ampere or better GPU for real-time results.

![UI demo](https://github.com/noco-ai/spellbook-docker/blob/master/ui-demo.gif)

## Stack Architecture

![Software stack diagram](https://github.com/noco-ai/spellbook-docker/blob/master/stack.png)

## Ubuntu 22 Install Instructions

These instructions should work to get the SpellBook framework up and running on Ubuntu 22. A Nvidia video card supported by ExLlama is required for routing.

- Default username: admin
- Default password: admin

### Docker Installation

```bash
# add Dockers official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# add the repository to apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# install docker, create user and let current user access docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER
sudo newgrp docker
sudo shutdown -r now
```

### Build and Start Containers (NO GPU)

The docker-compose-nogpu.yml is useful for running the UI and middleware in a situation where you want another backend handling you GPUs and LLMs. For example
if you are also using Text Generation UI and do not want to mess with it settings this compose file can be used to just run the UI, allowing you then to then connect it to the endpoint provided by Oobabooga or any other OpenAI compatible backend.

```bash
docker compose -f docker-compose-nogpu.yml build
docker compose -f docker-compose-nogpu.yml up
```

### Build and Start Additional Workers (NO GPU)

If you have more than one server you can run additional Elemental Golem workers to give the UI access to more resources. A few steps need to be taken on the
primary Spellbook server that is running the UI, middleware and other resources like Vault.

- Run these command on the primary server that is running the UI and middleware software in Docker.
- Copy the read token to a temp file to copy it to the worker server.
- Make note of the LAN IP address of the primary server. It is needed for the GOLEM_VAULT_HOST and GOLEM_VAULT_HOST variables.
- Make sure ports for RabbitMQ and Vault are open.

```bash
sudo more /var/lib/docker/volumes/spellbook-docker_vault_share/_data/read-token 
ip address
sudo ufw allow 5671
sudo ufw allow 5672
sudo ufw allow 8200
```

- Run these command on the server running the worker. The GOLEM_ID needs to be unique for every server and golem1 is used by the primary.
```bash
docker compose -f docker-compose-worker-nogpu.yml build
sudo su
echo "TOKEN FROM PRIMARY SERVER" > /var/lib/docker/volumes/spellbook-docker_vault_share/_data/read-token
exit
GOLEM_VAULT_HOST=10.10.10.X GOLEM_AMQP_HOST=10.10.10.X GOLEM_ID=golem2 docker compose -f docker-compose-worker-nogpu.yml up
```

### Nvidia Driver Installation

```bash
# make sure system see's the Nvidia graphic(s) card
lspci | grep -e VGA

# check available drivers
ubuntu-drivers devices

# install the latest driver
sudo apt install nvidia-driver-535

# restart the server
sudo shutdown -h now

# confirm driver was installed
nvidia-smi

# install the Nvidia docker toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
  && \
    sudo apt-get update

sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# verify see the output of nvidia-smi for inside a container
sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
```

### Build and Start Containers (Nvidia GPU)

```bash
docker compose build
docker compose up
```
