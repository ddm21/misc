#!/bin/bash

# Installing Docker
echo "Updating software repositories..."
sudo apt update

# Install prerequisites
sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg-agent -y

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/$(awk -F'=' '/^ID=/{ print $NF }' /etc/os-release)/gpg | sudo apt-key add -

# Add Docker software repository
sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(awk -F'=' '/^ID=/{ print $NF }' /etc/os-release) $(lsb_release -cs) stable"

# Install Docker
sudo apt install docker-ce docker-compose containerd.io -y

# Enable and start Docker service
sudo systemctl enable docker && sudo systemctl start docker

# Add the current user to the Docker group
sudo usermod -aG docker $USER

# Reauthenticate for the new group membership to take effect
su - $USER

# Running Docker Mailserver Container

# Prompt for mailserver configuration
read -p "Enter the desired hostname for the mailserver: " HOSTNAME

# Create main working directories
mkdir ~/docker/mailserver/{data,state,logs,config} -p

# Set owner of working directories
sudo chown "$USER":"$USER" ~/docker -R

# Run the mailserver container
docker run -d --name=mailserver --hostname="$HOSTNAME" --domainname="docker.local" -p 25:25 -p 143:143 -p 587:587 -p 993:993 -e ENABLE_SPAMASSASSIN=1 -e SPAMASSASSIN_SPAM_TO_INBOX=1 -e ENABLE_CLAMAV=1 -e ENABLE_POSTGREY=1 -e ENABLE_FAIL2BAN=0 -e ENABLE_SASLAUTHD=0 -e ONE_DIR=1 -e TZ=America/New_York -v ~/docker/mailserver/data/:/var/mail/ -v ~/docker/mailserver/state/:/var/mail-state/ -v ~/docker/mailserver/logs/:/var/log/mail/ -v ~/docker/mailserver/config/:/tmp/docker-mailserver/ --restart=unless-stopped mailserver/docker-mailserver

# Prompt for user and inbox configuration
read -p "Enter the desired email address for the user/inbox: " MAIL_USER
read -p "Enter the desired password for the user/inbox: " MAIL_PASS

# Create a user/inbox
docker run --rm -e MAIL_USER="$MAIL_USER" -e MAIL_PASS="$MAIL_PASS" -it mailserver/docker-mailserver /bin/sh -c 'echo "$MAIL_USER|$(doveadm pw -s SHA512-CRYPT -u $MAIL_USER -p $MAIL_PASS)"' >> ~/docker/mailserver/config/postfix-accounts.cf

echo "Script execution completed."

# https://docker-mailserver.github.io/docker-mailserver/latest/examples/tutorials/basic-installation/
