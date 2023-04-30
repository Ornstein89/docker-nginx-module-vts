FROM alpine:latest

RUN apk update
RUN apk add --upgrade apk-tools
RUN apk upgrade --available

# для сборки nginx
RUN apk --update add g++ make
# RUN apk --update add gcc linux-headers pkgconfig

# для сборки отдельных модулей nginx
RUN apk --update add zlib-dev pcre-dev openssl-dev gd-dev
# для работы с исходниками
# RUN apk --update add wget

# TODO указать версию, на момент конца апреля 2023 версия 1.24.0 - самая свежая
# см. 
RUN wget https://nginx.org/download/nginx-1.24.0.tar.gz
RUN tar -zxvf nginx-1.24.0.tar.gz

RUN cd nginx-1.24.0 \
    && ./configure --prefix=/var/www/html \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --with-pcre \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/var/run/nginx.pid \
    --with-http_ssl_module \
    --with-http_image_filter_module=dynamic \
    --modules-path=/etc/nginx/modules \
    --with-http_v2_module \
    --with-stream=dynamic \
    --with-http_addition_module \
    --with-http_mp4_module
RUN cd nginx-1.24.0 && make
RUN cd nginx-1.24.0 && make install

WORKDIR /etc/nginx
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]