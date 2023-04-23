#!/bin/bash

# Check if Docker is already installed
if ! [ -x "$(command -v docker)" ]; then
  # Install Docker
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
else
  # Docker is already installed, ask if user wants to update
  read -p "Docker is already installed. Do you want to update it? (y/n) " choice
  case "$choice" in 
    y|Y )
      # Update Docker
      sudo apt-get update
      sudo apt-get upgrade -y docker-ce docker-ce-cli containerd.io
      echo "Docker has been updated."
      ;;
    * )
      echo "Skipping Docker update."
      ;;
  esac
fi

# Check if Docker Compose is already installed
if ! [ -x "$(command -v docker-compose)" ]; then
  # Install Docker Compose
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
else
  echo "Docker Compose is already installed."
fi
