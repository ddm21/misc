```bash
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

# Check if running as root user
if [ "$EUID" -ne 0 ]; then
    show_error_message "This script must be run as root user."
    exit 1
fi

# Function to create a new user
function create_new_user {
    show_info_message "Creating a new user..."
    $CREATE_USER
    show_success_message "New user created successfully!"
}

# Function to install git
function install_git {
    show_info_message "Installing git..."
    $GIT_INSTALLATION
    show_success_message "Git installed successfully!"
}

# Function to install python-dev
function install_python_dev {
    show_info_message "Installing python-dev..."
    $PYTHON_DEV_INSTALLATION
    show_success_message "Python-dev installed successfully!"
}

# Function to install setuptools and pip
function install_setuptools_pip {
    show_info_message "Installing setuptools and pip..."
    $SETUPTOOLS_PIP_INSTALLATION
    show_success_message "Setuptools and pip installed successfully!"
}

# Function to install virtualenv
function install_virtualenv {
    show_info_message "Installing virtualenv..."
    $VIRTUALENV_INSTALLATION
    show_success_message "Virtualenv installed successfully!"
}

# Function to install MariaDB
function install_mariadb {
    show_info_message "Installing MariaDB..."
    $MARIADB_INSTALLATION
    show_success_message "MariaDB installed successfully!"
}

# Function to secure MariaDB installation
function secure_mariadb {
    show_prompt_message "Do you want to secure the MariaDB installation? (Y/n)"
    read -r secure_mariadb

    if [[ $secure_mariadb =~ ^[Yy]$ ]]; then
        $SECURE_MARIADB
    fi
}

# Function to install MySQL database development files
function install_mysql_dev_files {
    show_info_message "Installing MySQL database development files..."
    $MYSQL_DEV_FILES_INSTALLATION
    show_success_message "MySQL database development files installed successfully!"
}

# Function to edit the mariadb configuration
function edit_mariadb_configuration {
    show_info_message "Editing mariadb configuration..."
    sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
    # Add the required configuration to 50-server.cnf file

    show_prompt_message "Press Enter after making the necessary changes in the mariadb configuration file..."
    read -r enter_key

    sudo service mysql restart
    show_success_message "Mariadb configuration updated successfully!"
}

# Function to install Redis
function install_redis {
    show_info_message "Installing Redis..."
    $REDIS_INSTALLATION
    show_success_message "Redis installed successfully!"
}

# Function to install Node.js 14.X
function install_nodejs {
    show_info_message "Installing Node.js 14.X..."
    $NODEJS_INSTALLATION
    show_success_message "Node.js 14.X installed successfully!"
}

# Function to install Yarn
function install_yarn {
    show_info_message "Installing Yarn..."
    $YARN_INSTALLATION
    show_success_message "Yarn installed successfully!"
}

# Function to install wkhtmltopdf
function install_wkhtmltopdf {
    show_info_message "Installing wkhtmltopdf..."
    $WKHTMLTOPDF_INSTALLATION
    show_success_message "wkhtmltopdf installed successfully!"
}

# Function to install frappe-bench
function install_frappe_bench {
    show_info_message "Installing frappe-bench..."
    $FRAPPE_BENCH_INSTALLATION
    show_success_message "frappe-bench installed successfully!"
}

# Function to initialize frappe-bench and install frappe latest version
function initialize_frappe_bench {
    show_info_message "Initializing frappe-bench..."
    bench init frappe-bench --frappe-branch "$FRAPPE_BRANCH"
    cd frappe-bench/
    show_success_message "frappe-bench initialized successfully!"
}

# Function to create a site in frappe bench
function create_site {
    show_info_message "Creating a new site in frappe-bench..."
    bench new-site "$SITE_NAME"
    bench use "$SITE_NAME"
    show_success_message "New site created successfully!"
}

# Function to install ERPNext latest version in bench and site
function install_erpnxt {
    show_info_message "Installing ERPNext..."
    $ERPNEXT_APP_INSTALLATION
    show_success_message "ERPNext installed successfully!"
}

# Function to setup production environment
function setup_production {
    show_info_message "Setting up production environment..."
    $PRODUCTION_SETUP
    show_success_message "Production environment setup completed successfully!"
}

# Function to install SSL certificate
function install_ssl_certificate {
    show_info_message "Installing SSL certificate..."
    sudo apt-get install -y certbot python3-certbot-nginx
    certbot -d "$SSL_DOMAIN_NAME" --register-unsafely-without-email
    show_success_message "SSL certificate installed successfully!"
}

# Function to setup auto-renewal for the SSL certificate
function setup_ssl_auto_renewal {
    show_info_message "Setting up auto-renewal for the SSL certificate..."
    sudo certbot renew --dry-run
    show_success_message "SSL certificate auto-renewal setup completed successfully!"
}

# Main script
install_git
install_python_dev
install_setuptools_pip
install_virtualenv
install_mariadb
secure_mariadb
install_mysql_dev_files
edit_mariadb_configuration
install_redis
install_nodejs
install_yarn
install_wkhtmltopdf
install_frappe_bench
initialize_frappe_bench
create_site
install_erpnxt
create_new_user
setup_production
install_ssl_certificate
setup_ssl_auto_renewal
