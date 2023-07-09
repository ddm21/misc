# Stage 1: Build frappe-bench
FROM ubuntu:22.04 AS builder

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libmysqlclient-dev \
    nano \
    mariadb-server \
    curl \
    npm \
    xvfb \
    libfontconfig \
    python3-pip

# Configure MariaDB
RUN echo "[server]\n\
user = mysql\n\
pid-file = /run/mysqld/mysqld.pid\n\
socket = /run/mysqld/mysqld.sock\n\
basedir = /usr\n\
datadir = /var/lib/mysql\n\
tmpdir = /tmp\n\
lc-messages-dir = /usr/share/mysql\n\
bind-address = 127.0.0.1\n\
query_cache_size = 16M\n\
log_error = /var/log/mysql/error.log\n\
\n\
[mysqld]\n\
innodb-file-format=barracuda\n\
innodb-file-per-table=1\n\
innodb-large-prefix=1\n\
character-set-client-handshake = FALSE\n\
character-set-server = utf8mb4\n\
collation-server = utf8mb4_unicode_ci\n\
\n\
[mysql]\n\
default-character-set = utf8mb4" > /etc/mysql/mariadb.conf.d/50-server.cnf

# Restart MySQL service
RUN systemctl restart mariadb

# Install Node.js 16.x
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# Install Yarn
RUN npm install -g yarn

# Install wkhtmltopdf
RUN apt-get install -y wkhtmltopdf

# Install frappe-bench
RUN pip3 install frappe-bench

# Stage 2: Final image
FROM ubuntu:22.04

# Copy frappe-bench from the builder stage
COPY --from=builder /usr/local/lib/python3.8/dist-packages /usr/local/lib/python3.8/dist-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Install Redis
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server

CMD ["bash"]
