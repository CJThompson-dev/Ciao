FROM nginx:alpine

COPY ciao_proxy.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/cache/nginx/hosp

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]