# глобальный параметр, общий для сборочного и целевого контейнера
#TODO дистрибутив linux должен быть тем же, что и в целевом образе
ARG ARG_NGINX_VERSION=1.24.0 

# сборочный временный контейнер
FROM alpine:latest AS build-stage

ARG ARG_NGINX_VERSION
ENV NGINX_VERSION=$ARG_NGINX_VERSION

# RUN apk update
# RUN apk add --upgrade apk-tools
# RUN apk upgrade --available
RUN apk add wget git tar

# исходный код nginx
RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN tar -zxvf nginx-${NGINX_VERSION}.tar.gz

# исходный код модуля
RUN git clone https://github.com/vozlt/nginx-module-vts.git

# инструменты сборки
RUN apk add gcc g++ make

# зависимости nginx
RUN apk add zlib-dev pcre-dev openssl-dev gd-dev

# сборка модуля, новые модули добавлять через --add-dynamic-module
# модули собираются в каталог /nginx-${NGINX_VERSION}/objs
RUN cd nginx-${NGINX_VERSION} \
    && ./configure --with-compat --add-dynamic-module=/nginx-module-vts \
    && make modules


# вспомогательная ступень сборки, пустой образ, для опционального
# вывода собранного модуля на хост через docker build --output
# FROM scratch AS output-stage
# ARG ARG_NGINX_VERSION
# ENV NGINX_VERSION=$ARG_NGINX_VERSION
# COPY --from=build-stage /nginx-${NGINX_VERSION}/objs/ngx_http_vhost_traffic_status_module.so /

# целевой образ, официальный, с готовым nginx, в который нужно поместить модуль из сборочного образа
#TODO дистрибутив linux должен быть тем же, что и в сборочном образе
FROM nginx:1.24.0-alpine-slim

ARG ARG_NGINX_VERSION
ENV NGINX_VERSION=$ARG_NGINX_VERSION

# копирование собранного модуля из сборочного образа
COPY --from=build-stage /ngx_http_vhost_traffic_status_module.so /etc/nginx/modules

# копирование файлов конфигурации, модифицированных для работы нового модуля
# RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf
# RUN mkdir /etc/nginx/conf.d
COPY default.conf /etc/nginx/conf.d/default.conf
