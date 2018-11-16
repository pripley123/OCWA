map $http_upgrade $connection_upgrade {
  default upgrade;
  "" close;
}

server {
  listen                    443 ssl;
  server_name               authdev.popdata.bc.ca;

  ssl_certificate           /ssl/popdata2016-chain-cert.pem;
  ssl_certificate_key       /ssl/popdata2016-key.pem;

  location = / {
    return 301 /auth;
  }

  # Proxy everything over to the service
  location /auth/ {
    proxy_set_header        Host            $host;
    proxy_set_header        X-Real-IP       $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_http_version      1.1;
    proxy_set_header         Upgrade $http_upgrade;
    proxy_set_header         Connection $connection_upgrade;

    proxy_pass http://ocwa_keycloak:8080;
  }
}

server {
  listen                    443 ssl;
  server_name               ocwadev.popdata.bc.ca;

  ssl_certificate           /ssl/popdata2016-chain-cert.pem;
  ssl_certificate_key       /ssl/popdata2016-key.pem;

  location /minio/ {
    proxy_set_header        Host            $host;
    proxy_set_header        X-Real-IP       $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_http_version      1.1;
    proxy_set_header         Upgrade $http_upgrade;
    proxy_set_header         Connection $connection_upgrade;

    proxy_pass http://ocwa_minio:9000;
  }

  location /api/v1/files {
    proxy_set_header        Host            $host;
    proxy_set_header        X-Real-IP       $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_http_version      1.1;
    proxy_set_header         Upgrade $http_upgrade;
    proxy_set_header         Connection $connection_upgrade;

    proxy_pass http://ocwa_tusd:1080;
  }

  # Proxy everything over to the service
  location / {
    proxy_set_header        Host            $host;
    proxy_set_header        X-Real-IP       $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_http_version      1.1;
    proxy_set_header         Upgrade $http_upgrade;
    proxy_set_header         Connection $connection_upgrade;

    proxy_pass http://ocwa_frontend:8000;
  }

}

server {
  listen                    443 ssl default;

  ssl_certificate           /ssl/popdata2016-chain-cert.pem;
  ssl_certificate_key       /ssl/popdata2016-key.pem;

  return 301 https://ocwadev.popdata.bc.ca;
}

server {
  listen                    80 default;

  return 301 https://ocwadev.popdata.bc.ca;
}
