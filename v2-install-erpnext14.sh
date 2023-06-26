#!/bin/bash

# STEP 1 Install git
sudo apt-get install git

# STEP 2 install python-dev
sudo apt-get install python3-dev

# STEP 3 Install setuptools and pip (Python's Package Manager).
sudo apt-get install python3-setuptools python3-pip

# STEP 4 Install virtualenv
sudo apt-get install virtualenv
sudo apt install python3.10-venv

# STEP 5 Install MariaDB
sudo apt-get install software-properties-common
sudo apt install mariadb-server

# Prompt for MariaDB setup
echo "Please provide the following information to set up MariaDB:"
sudo mysql_secure_installation

# STEP 6 MySQL database development files
sudo apt-get install libmysqlclient-dev

# STEP 7 Edit the mariadb configuration ( unicode character encoding )
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf

# Prompt the user to add the required configuration
echo "Please add the following configuration to the 50-server.cnf file:"
echo "[server]
user = mysql
pid-file = /run/mysqld/mysqld.pid
socket = /run/mysqld/mysqld.sock
basedir = /usr
datadir = /var/lib/mysql
tmpdir = /tmp
lc-messages-dir = /usr/share/mysql
bind-address = 127.0.0.1
query_cache_size = 16M
log_error = /var/log/mysql/error.log

[mysqld]
innodb-file-format=barracuda
innodb-file-per-table=1
innodb-large-prefix=1
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4"

# Prompt to continue after editing the file
read -p "Press Enter to continue once you have edited the file: " continue_input

# Restart MariaDB
sudo service mysql restart

# STEP 8 install Redis
sudo apt-get install redis-server

# STEP 9 install Node.js 14.X package
sudo apt install curl
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash &&
apt-get install nodejs -y

# STEP 10 install Yarn
sudo apt-get install npm
sudo npm install -g yarn

# STEP 11 install wkhtmltopdf
sudo apt-get install xvfb libfontconfig wkhtmltopdf

# STEP 12 install frappe-bench
sudo -H pip3 install frappe-bench
bench --version

# STEP 13 initialize the frappe bench & install frappe latest version
bench init frappe-bench --frappe-branch version-14
cd frappe-bench/
bench start

# Prompt for site name
read -p "Enter the site name: " site_name

# STEP 14 create a site in frappe bench
bench new-site "$site_name"
bench use "$site_name"

# STEP 15 install ERPNext latest version in bench & site
bench get-app payments
bench get-app erpnext --branch version-14
bench --site "$site_name" install-app erpnext
bench start

# Step 16 setup production
sudo bench setup production {username}-frappe
bench restart

# Prompt to continue after restarting bench
read -p "Press Enter to continue once bench has been restarted: " continue_input

# If bench restart is not worked run the following command again with all Questions Yes
sudo bench setup production dcode-frappe

# Prompt to continue after setting up production
read -p "Press Enter to continue once production setup is complete: " continue_input

# Fix permissions for js and css file loading on login window
sudo chmod o+x /home/

# Prompt to ask if a new user should be created
read -p "Do you want to create a new user? (y/n): " create_user_input

if [[ $create_user_input == "y" ]]; then
    read -p "Enter the new username: " new_username

    # Create a new user
    sudo adduser "$new_username"
    sudo usermod -aG sudo "$new_username"

    # Prompt to ask if SSL setup is required
    read -p "Do you want to set up SSL? (y/n): " ssl_setup_input

    if [[ $ssl_setup_input == "y" ]]; then
        # Prompt for the domain name for SSL certificate
        read -p "Enter the domain name for SSL certificate: " domain_name

        # Install certbot and obtain the SSL certificate
        sudo apt install certbot python3-certbot-nginx
        sudo certbot -d "$domain_name" --register-unsafely-without-email

        # Switch to the new user
        su - "$new_username"

        # Prompt to continue after switching user
        read -p "Press Enter to continue: " continue_input

        # Auto renew the certificate
        sudo certbot renew --dry-run
    fi
fi

echo "Frappe/ERPNext installation completed successfully!"
