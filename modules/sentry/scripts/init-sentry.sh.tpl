#!/bin/sh
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg

cd /root
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu
sudo systemctl enable docker
sudo systemctl start docker
sudo apt-get install -y docker-compose


wget https://github.com/getsentry/onpremise/archive/21.2.0.tar.gz
tar -xvf 21.2.0.tar.gz 
cd onpremise-21.2.0
CI=true ./install.sh
sudo docker-compose up -d
sudo docker-compose run --rm web createuser --email=${sentry_email} --password=${sentry_pass} --superuser