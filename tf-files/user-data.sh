#!/bin/bash
set -e

apt-get update -y
apt-get install -y nginx

cat > /etc/nginx/conf.d/ciao_proxy.conf << 'EOF'
# PASTE CONTENTS OF proxy/ciao_proxy.conf HERE
EOF


nginx -t

systemctl start nginx
systemctl enable nginx