`Install Frappe/ERPNext version 14 in Ubuntu 22.04 LTS`

#### STEP 1 Install git
```
sudo apt-get install git
```
#### STEP 2 install python-dev
```
sudo apt-get install python3-dev
```
#### STEP 3 Install setuptools and pip (Python's Package Manager).
```
sudo apt-get install python3-setuptools python3-pip
```
#### STEP 4 Install virtualenv
```
sudo apt-get install virtualenv
sudo apt install python3.10-venv
```
#### STEP 5 Install MariaDB
```
sudo apt-get install software-properties-common
sudo apt install mariadb-server
sudo mysql_secure_installation
```
after running this command it will as few question to setup mariadb which i need to be asked in terminal and get the answer
- Enter current password for root (enter for none): # PRESS ENTER
- Switch to unix_socket authentication [Y/n] Y
- Change the root password? [Y/n] Y
- Remove anonymous users? [Y/n] Y
- Disallow root login remotely? [Y/n] Y
- Remove test database and access to it? [Y/n] Y
- Reload privilege tables now? [Y/n] Y
#### STEP 6 MySQL database development files
```
sudo apt-get install libmysqlclient-dev
```
#### STEP 7 Edit the mariadb configuration ( unicode character encoding )
```
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
```
add this to the 50-server.cnf file
```
[server]
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
default-character-set = utf8mb4
```
- comment anything if any duplicate configuration found by default and paste this config insted
#### Now press (Ctrl-X) to exit
```
sudo service mysql restart
```
#### STEP 8 Install Redis
```
sudo apt-get install redis-server
```
#### STEP 9 Install Node.js 16.X package
```
sudo apt install curl
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash &&
apt-get install nodejs -y
```
#### STEP 10 Install Yarn
```
sudo apt-get install npm
sudo npm install -g yarn
```
#### STEP 11 Install wkhtmltopdf
```
sudo apt-get install xvfb libfontconfig wkhtmltopdf
```
#### STEP 12 Install frappe-bench
```
sudo -H pip3 install frappe-bench
bench --version
```
#### STEP 13 Initialize the frappe bench & install frappe latest version
```
bench init frappe-bench --frappe-branch version-14
cd frappe-bench/
bench start
```
#### STEP 14 create a site in frappe bench
- ask user what site-name they want to give and update the command with the {site-name} and run the bench command
```
bench new-site {site-name}
bench use {site-name}
```
- Enable Developer mode ```bench set-config -g developer_mode 1``` ( run this command in /frappe-bench )
#### STEP 15 install ERPNext latest version in bench & site
```
bench get-app payments
bench get-app erpnext --branch version-14
bench --site {site-name} install-app erpnext
bench start
```
- In order to install production bench needed to be start which will be used in installing any apps so keep bench running until apps are installing

#### Step 16 setup production
```
sudo bench setup production {username}-frappe
bench restart
```
- If bench restart is not worked run the following command again with all Questions Yes
```
sudo bench setup production dcode-frappe
```
- If js and css file is not loading on login window run the following command
```
sudo chmod o+x /home/
```
#### STEP 17 Create a new user
```
sudo adduser {new-user-name}
sudo usermod -aG sudo {new-user-name}
```
#### STEP 18 SSL certificate fot https
- ask user for domainname for ssl certificate in {domain_name}
```
sudo apt install certbot python3-certbot-nginx
certbot -d {domain_name} --register-unsafely-without-email
su - {new-user-name}
```
#### STEP 19 For auto renew the certificate
```
sudo certbot renew --dry-run
```
