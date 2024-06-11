FROM nginx:alpine
COPY public_build /usr/share/nginx/html
EXPOSE 80/tcp


