

docker run -d --net=ocwa_vnet --name ocwa_nginx \
  -p 443:443 -p 80:80 \
  -v $WORKSPACE/ssl:/ssl \
  -v $WORKSPACE/nginx:/etc/nginx/conf.d/ \
  nginx
