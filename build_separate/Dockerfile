FROM nginx:1.24.0-alpine-slim
# FROM nginx:1.24.0-alpine

COPY build/ngx_http_vhost_traffic_status_module.so /etc/nginx/modules
RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf
# RUN mkdir /etc/nginx/conf.d
COPY default.conf /etc/nginx/conf.d/default.conf

# EXPOSE 80 443
# STOPSIGNAL SIGTERM
# CMD ["nginx", "-g", "daemon off;"]