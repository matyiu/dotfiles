#!/bin/sh

DOMAIN=SET_DOMAIN
PORT=5000
CERT_PATH=$HOME/certs
DOCKER_CERT_PATH=/etc/docker/certs.d/$DOMAIN:$PORT

echo "Generating cert keys..."
openssl req -new -nodes -x509 -days 365 \
	-keyout $CERT_PATH/domain.key \
	-out $CERT_PATH/domain.crt \
	-config $CERT_PATH/san.cnf

mkdir -p $DOCKER_CERT_PATH
cp $CERT_PATH/domain.crt $DOCKER_CERT_PATH/ca.crt

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
