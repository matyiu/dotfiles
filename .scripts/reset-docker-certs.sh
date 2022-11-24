#!/bin/sh

DOMAIN=localhost
PORT=5000
CERT_PATH=$HOME/certs

echo "Generating CA Key..."
openssl genrsa -out $CERT_PATH/key.pem 4096

echo "Generating CA Cert..."
openssl req -new \
  -subj '/CN=docker-server' \
  -key $CERT_PATH/key.pem \
  -config san.cnf \
  -out $CERT_PATH/cert.csr

echo "Signing Server Cert..."
openssl x509 -req \
	-in $CERT_PATH/cert.csr \
	-CA $CERT_PATH/ca.pem \
	-CAkey $CERT_PATH/ca-key.pem \
	-extfile san.cnf \
	-out $CERT_PATH/cert.pem \
	-days 365 -extensions v3_req -CAcreateserial

echo "Restarting Docker Engine..."
/etc/init.d/docker restart
sleep 10

echo "Restarting Registry..."
docker container rm -f registry && \
	docker container run -d -p 5000:5000 --name registry \
 		--restart unless-stopped \
  		-v $(pwd)/registry-data:/var/lib/registry \
  		-v $(pwd)/certs:/certs \
  		-v $(pwd)/auth:/auth \
  		-e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  		-e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  		-e REGISTRY_AUTH=htpasswd \
  		-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  		-e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \
  		registry

echo "Registry has been started"
