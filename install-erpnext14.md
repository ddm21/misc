#### STEP 1 Install git
```
sudo apt-get install git
```
#### STEP 2 install python-dev setuptools, pip and virtualenv
```
sudo apt-get install python3-dev python3-setuptools python3-pip virtualenv python3.10-venv
```
#### STEP 3 Install MariaDB
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
#### STEP 4 MySQL database development files
```
sudo apt-get install libmysqlclient-dev
```
#### STEP 5 Edit the mariadb configuration ( unicode character encoding )
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
- comment if any duplicate configuration found by default and paste this config insted
#### Now press (Ctrl-X) to exit
```
sudo service mysql restart
```
#### STEP 6 Install Redis
```
sudo apt-get install redis-server
```
#### STEP 7 Install Node.js 16.X package
```
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash &&
sudo apt-get install nodejs -y
```
#### STEP 8 Install Yarn
```
sudo npm install -g yarn
```
#### STEP 9 Install wkhtmltopdf
```
sudo apt-get install xvfb libfontconfig wkhtmltopdf
```
#### STEP 10 Install frappe-bench
```
sudo -H pip3 install frappe-bench
bench --version
```
#### STEP 11 Initialize the frappe bench & install frappe latest version
```
bench init frappe-bench --frappe-branch version-14
cd frappe-bench/
bench start
```
#### STEP 12 create a site in frappe bench
- ask user what site-name they want to give and update the command with the {site-name} and run the bench command
```
bench new-site {site-name}
bench use {site-name}
```
- Enable Developer mode ```bench set-config -g developer_mode 1``` ( run this command in /frappe-bench )
#### STEP 13 install ERPNext latest version in bench & site
```
bench get-app payments --branch version-14
bench get-app erpnext --branch version-14
bench --site {site-name} install-app erpnext
bench start
```
- In order to install production bench needed to be start which will be used in installing any apps so keep bench running until apps are installing

#### Step 14 setup production
```
sudo bench setup production {username}-frappe
bench restart
```
- If bench restart is not worked run the following command again with all Questions Yes
```
sudo bench setup production {username}-frappe
```
- If js and css file is not loading on login window run the following command
```
sudo chmod o+x /home/
```
#### STEP 15 Create a new user
```
sudo adduser {new-user-name}
sudo usermod -aG sudo {new-user-name}
su {new-user-name}
```
#### STEP 16 SSL certificate fot https
- ask user for domainname for ssl certificate in {domain_name}
```
sudo apt install certbot python3-certbot-nginx
certbot -d {domain_name} --register-unsafely-without-email
su - {new-user-name}
```
#### STEP 17 For auto renew the certificate
```
sudo certbot renew --dry-run
```

#### 20 Enable Firewall
```
sudo iptables -A INPUT -p tcp -m multiport --dports 22,25,143,80,443,3306,3022,8000 -j ACCEPT
sudo ufw allow 22,25,143,80,443,3306,3022,8000/tcp
```
