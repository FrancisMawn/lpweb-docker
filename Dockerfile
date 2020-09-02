# Start from a nginx/php7.4 pre-defined image.
FROM wyveo/nginx-php-fpm:php74

# Remove existing webroot, configure PHP, install postgresql-client (pg_dump) and nodejs/npm.
RUN rm -rf /usr/share/nginx/* && \
    sed -i -e "s/memory_limit\s*=\s*.*/memory_limit = 256M/g" ${php_conf} && \
    sed -i -e "s/max_execution_time\s*=\s*.*/max_execution_time = 120/g" ${php_conf} && \
    wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' && \
    apt-get update && \
    apt-get install -y postgresql-client-11 && \
    apt install -y nodejs npm

# Install prestissimo (composer plugin which speeds up composer install process).
RUN composer global require hirak/prestissimo

# Add default craft cms nginx config.
ADD ./default.conf /etc/nginx/conf.d/default.conf

# Get lp-web code from git.
RUN git clone https://csps-efpc-ux@dev.azure.com/csps-efpc-ux/learning-platform/_git/lp-web /usr/share/nginx/

# Setup nginx permissions.
RUN chown -Rf nginx:nginx /usr/share/nginx/

# Copy environment file.
ADD .env.sample /usr/share/nginx/.env

# Install composer and npm dependencies.
WORKDIR /usr/share/nginx
RUN composer install
RUN npm install && npm run dev

EXPOSE 80
