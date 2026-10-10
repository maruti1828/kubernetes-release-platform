FROM nginx:1.28-alpine

COPY app/index.html /usr/share/nginx/html/index.html
COPY app/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
