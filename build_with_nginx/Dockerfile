# FROM nginx:1.24.0-alpine-slim
FROM alpine:latest

ENV NGINX_BUILD_VERSION=1.24.0

RUN apk update
# RUN apk add --upgrade apk-tools
# RUN apk upgrade --available

# для сборки nginx
# RUN apk --update --upgrade --no-cache add g++ make
# RUN apk --no-cache --virtual add .build-deps gcc g++ make linux-headers build-base \
# RUN apk --update add gcc linux-headers pkgconfig
# для сборки отдельных модулей nginx
# RUN apk --update --upgrade --no-cache add zlib-dev pcre-dev openssl-dev gd-dev
    # && apk --no-cache --virtual add zlib-dev pcre-dev openssl-dev gd-dev
# для работы с исходниками
# RUN apk --update add wget

# TODO указать версию, на момент конца апреля 2023 версия 1.24.0 - самая свежая
RUN apk --no-cache --virtual .download-deps add wget git tar \
    && wget https://nginx.org/download/nginx-${NGINX_BUILD_VERSION}.tar.gz \
    && tar -zxvf nginx-${NGINX_BUILD_VERSION}.tar.gz \
    && rm nginx-${NGINX_BUILD_VERSION}.tar.gz \
    && git clone https://github.com/vozlt/nginx-module-vts.git \
    && apk del .download-deps

RUN apk --no-cache --virtual .build-deps add gcc g++ make \
# linux-headers build-base alpine-sdk \
# RUN apk --update add gcc linux-headers pkgconfig
# для сборки отдельных модулей nginx
# RUN apk --update --upgrade --no-cache add zlib-dev pcre-dev openssl-dev gd-dev
    && apk --no-cache add zlib-dev pcre-dev openssl-dev gd-dev \
# конфигурирование, см. https://nginx.org/en/docs/configure.html
    && cd nginx-${NGINX_BUILD_VERSION} \
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
    --with-http_mp4_module \
    --add-module=/nginx-module-vts \
# сборка
    && make \
# установка
    && make install \
    && apk del .build-deps
# удаление библиотек, инструментов сборки и исходников
# RUN apk del g++ make
# RUN apk cache clean
# RUN apk del zlib-dev pcre-dev openssl-dev gd-dev
RUN rm -rf /nginx-${NGINX_BUILD_VERSION}
RUN rm -rf /nginx-module-vts
#  && \
#     rm -rf /tmp/src && \
#     rm -rf /var/cache/apk/*

# WORKDIR /etc/nginx
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]