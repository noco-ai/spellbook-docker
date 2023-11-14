# Spellbook Docker Compose

The repository contains the Docker Compose files for running the Spellbook AI Assistant stack. The function calling features
require ExLlama and a Nvidia Ampere or better GPU for real-time results.

![UI demo](https://github.com/noco-ai/spellbook-docker/blob/master/ui-demo.gif)

## Stack Architecture

![Software stack diagram](https://github.com/noco-ai/spellbook-docker/blob/master/stack.png)

## Ubuntu 22 Install Instructions

These instructions should work to get the SpellBook framework up and running on Ubuntu 22. A Nvidia video card supported by ExLlama is required for routing.

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

### Build and Start Containers

```bash
docker compose build
docker compose up
```
