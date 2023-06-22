#!/bin/bash

# Variables
GIT_INSTALLATION="sudo apt-get install -y git"
PYTHON_DEV_INSTALLATION="sudo apt-get install -y python3-dev"
SETUPTOOLS_PIP_INSTALLATION="sudo apt-get install -y python3-setuptools python3-pip"
VIRTUALENV_INSTALLATION="sudo apt-get install -y virtualenv && sudo apt-get install -y python3.10-venv"
MARIADB_INSTALLATION="sudo apt-get install -y software-properties-common && sudo apt-get install -y mariadb-server"
SECURE_MARIADB="sudo mysql_secure_installation"
MYSQL_DEV_FILES_INSTALLATION="sudo apt-get install -y libmysqlclient-dev"
REDIS_INSTALLATION="sudo apt-get install -y redis-server"
NODEJS_INSTALLATION="sudo apt-get install -y curl && curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash && source ~/.profile && nvm install 16"
YARN_INSTALLATION="sudo apt-get install -y npm && sudo npm install -g yarn"
WKHTMLTOPDF_INSTALLATION="sudo apt-get install -y xvfb libfontconfig wkhtmltopdf"
FRAPPE_BENCH_INSTALLATION="sudo -H pip3 install frappe-bench==5.10.1"
FRAPPE_BRANCH="version-14"
SITE_NAME="dcode.com"
ERPNEXT_APP_INSTALLATION="bench get-app payments && bench get-app erpnext --branch version-14 && bench --site dcode.com install-app erpnext"
PRODUCTION_SETUP="sudo bench setup production dcode-frappe"
CREATE_USER="sudo adduser dcode-frappe && sudo usermod -aG sudo dcode-frappe"
SSL_CERTBOT_INSTALLATION="sudo apt-get install -y certbot python3-certbot-nginx"
SSL_DOMAIN_NAME="{domain_name}"
SSL_CERTBOT_RENEWAL="sudo certbot renew --dry-run"

# Function to display success message with emoji
function show_success_message {
    echo -e "\e[32m✅ $1\e[0m"
}

# Function to display error message with emoji
function show_error_message {
    echo -e "\e[31m❌ $1\e[0m"
}

# Function to display information message with emoji
function show_info_message {
    echo -e "\e[33m🔔 $1\e[0m"
}

# Function to display prompt message
function show_prompt_message {
    echo -e "\e[34m❓ $1\e[0m"
}

# STEP 1: Install git
show_info_message "Installing git..."
$GIT_INSTALLATION
show_success_message "Git installed successfully!"

# STEP 2: Install python-dev
show_info_message "Installing python-dev..."
$PYTHON_DEV_INSTALLATION
show_success_message "Python-dev installed successfully!"

# STEP 3: Install setuptools and pip
show_info_message "Installing setuptools and pip..."
$SETUPTOOLS_PIP_INSTALLATION
show_success_message "Setuptools and pip installed successfully!"

# STEP 4: Install virtualenv
show_info_message "Installing virtualenv..."
$VIRTUALENV_INSTALLATION
show_success_message "Virtualenv installed successfully!"

# STEP 5: Install MariaDB
show_info_message "Installing MariaDB..."
$MARIADB_INSTALLATION
show_success_message "MariaDB installed successfully!"

# Secure MariaDB installation
show_prompt_message "Do you want to secure the MariaDB installation? (Y/n)"
read -r secure_mariadb

if [[ $secure_mariadb =~ ^[Yy]$ ]]; then
    $SECURE_MARIADB
fi

# STEP 6: Install MySQL database development files
show_info_message "Installing MySQL database development files..."
$MYSQL_DEV_FILES_INSTALLATION
show_success_message "MySQL database development files installed successfully!"

# STEP 7: Edit the mariadb configuration
show_info_message "Editing mariadb configuration..."
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
# Add the required configuration to 50-server.cnf file

show_prompt_message "Press Enter after making the necessary changes in the mariadb configuration file..."
read -r enter_key

sudo service mysql restart
show_success_message "Mariadb configuration updated successfully!"

# STEP 8: Install Redis
show_info_message "Installing Redis..."
$REDIS_INSTALLATION
show_success_message "Redis installed successfully!"

# STEP 9: Install Node.js 14.X package
show_info_message "Installing Node.js 14.X..."
$NODEJS_INSTALLATION
show_success_message "Node.js 14.X installed successfully!"

# STEP 10: Install Yarn
show_info_message "Installing Yarn..."
$YARN_INSTALLATION
show_success_message "Yarn installed successfully!"

# STEP 11: Install wkhtmltopdf
show_info_message "Installing wkhtmltopdf..."
$WKHTMLTOPDF_INSTALLATION
show_success_message "wkhtmltopdf installed successfully!"

# STEP 12: Install frappe-bench
show_info_message "Installing frappe-bench..."
$FRAPPE_BENCH_INSTALLATION
show_success_message "frappe-bench installed successfully!"

# Verify frappe-bench installation
bench_version=$(bench --version)

if [[ $? -eq 0 ]]; then
    show_success_message "frappe-bench version: $bench_version"
else
    show_error_message "frappe-bench installation failed!"
    exit 1
fi

# STEP 13: Initialize the frappe bench & install frappe latest version
show_info_message "Initializing frappe-bench..."
bench init frappe-bench --frappe-branch "$FRAPPE_BRANCH"
cd frappe-bench/
show_success_message "frappe-bench initialized successfully!"

# Start frappe-bench
show_prompt_message "Do you want to start the frappe-bench? (Y/n)"
read -r start_bench

if [[ $start_bench =~ ^[Yy]$ ]]; then
    bench start
fi

# STEP 14: Create a site in frappe bench
show_info_message "Creating a new site in frappe-bench..."
bench new-site "$SITE_NAME"
bench use "$SITE_NAME"
show_success_message "New site created successfully!"

# STEP 15: Install ERPNext latest version in bench & site
show_info_message "Installing ERPNext..."
$ERPNEXT_APP_INSTALLATION
show_success_message "ERPNext installed successfully!"

# Start frappe-bench
show_prompt_message "Do you want to start the frappe-bench? (Y/n)"
read -r start_bench

if [[ $start_bench =~ ^[Yy]$ ]]; then
    bench start
fi

# STEP 16: Setup production
show_info_message "Setting up production environment..."
$PRODUCTION_SETUP
show_success_message "Production environment setup completed successfully!"

# STEP 17: Create a new user
show_info_message "Creating a new user..."
$CREATE_USER
su - dcode-frappe
show_success_message "New user created successfully!"

# STEP 16: SSL certificate for HTTPS
show_info_message "Installing SSL certificate..."
sudo apt-get install -y certbot python3-certbot-nginx
certbot -d "$SSL_DOMAIN_NAME" --register-unsafely-without-email
show_success_message "SSL certificate installed successfully!"

# Auto renew the SSL certificate
show_info_message "Setting up auto-renewal for the SSL certificate..."
sudo certbot renew --dry-run
show_success_message "SSL certificate auto-renewal setup completed successfully!"
