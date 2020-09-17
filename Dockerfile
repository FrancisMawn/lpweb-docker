# Start from a nginx/php7.4 pre-defined image.
FROM wyveo/nginx-php-fpm:php74

ARG branch
ARG repo

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
COPY ./config/nginx/default.conf /etc/nginx/conf.d/default.conf

# Get lp-web code from git.
RUN git clone -b $branch $repo /usr/share/nginx/

# Copy environment file.
COPY ./config/craftcms/.env.sample /usr/share/nginx/.env

# Copy Craft installation script.
COPY ./scripts/install-craft.sh /usr/share/nginx/install-craft.sh

# Install composer and npm dependencies.
WORKDIR /usr/share/nginx
RUN composer install
RUN npm install && npm run dev

# Remove unnecessary files
RUN rm -rf ./node_modules
RUN rm -rf ./src

# Setup nginx permissions.
RUN chown -Rf nginx:nginx /usr/share/nginx/

EXPOSE 80
