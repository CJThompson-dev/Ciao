#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log) 2>&1

echo "Starting user data script..."

# install docker on Amazon Linux 2023
echo "Installing docker..."
yum install -y docker

echo "Starting docker..."
systemctl start docker
systemctl enable docker

echo "Authenticating with ECR..."
aws ecr get-login-password --region eu-west-2 | \
  docker login --username AWS --password-stdin \
  664047078509.dkr.ecr.eu-west-2.amazonaws.com

echo "Pulling and starting proxy container..."
docker run -d \
  --name ciao-proxy \
  --restart always \
  -p 80:80 \
  -v /var/cache/nginx/hosp:/var/cache/nginx/hosp \
  664047078509.dkr.ecr.eu-west-2.amazonaws.com/ciao-ecr:latest

echo "Done!"