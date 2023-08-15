FROM openresty/openresty:1.21.4.2-0-alpine-fat

RUN mkdir -p /var/nginx/client_body_temp \
    /var/nginx/cache \
    /var/nginx/proxy_temp \
    /var/nginx/fastcgi_temp \
    /var/nginx/uwsgi_temp \
    /var/nginx/scgi_temp

RUN chown -R nobody:nobody /var/nginx/client_body_temp \
    /var/nginx/cache \
    /var/nginx/proxy_temp \
    /var/nginx/fastcgi_temp \
    /var/nginx/uwsgi_temp \
    /var/nginx/scgi_temp

RUN apk add openssl-dev

RUN luarocks install lapis
RUN luarocks install lapis-console
RUN luarocks install tableshape

STOPSIGNAL SIGQUIT
