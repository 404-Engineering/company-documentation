#!/usr/bin/env bash
# One-time setup of a fresh Ubuntu droplet: nginx, firewall, site folder and HTTPS.
# Run on the droplet as root:  sudo bash setup.sh example.com you@example.com
set -euo pipefail

DOMAIN="${1:?usage: setup.sh <domain> <email-for-letsencrypt>}"
EMAIL="${2:?usage: setup.sh <domain> <email-for-letsencrypt>}"
SITE_DIR=/var/www/404engineering
CONF=/etc/nginx/sites-available/404engineering

apt-get update
apt-get install -y nginx certbot python3-certbot-nginx ufw rsync

# Firewall: SSH + HTTP/HTTPS only. OpenSSH is allowed first so the session isn't cut off.
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw --force enable

# Site folder, writable by the deploy user (the one who ran sudo).
DEPLOY_USER="${SUDO_USER:-root}"
mkdir -p "$SITE_DIR"
chown -R "$DEPLOY_USER":www-data "$SITE_DIR"
chmod -R 755 "$SITE_DIR"

# nginx config
sed "s/__DOMAIN__/$DOMAIN/g" "$(dirname "$0")/nginx.conf" > "$CONF"
ln -sf "$CONF" /etc/nginx/sites-enabled/404engineering
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl reload nginx

# HTTPS. The domain's A records (@ and www) must already point at this droplet.
certbot --nginx --non-interactive --agree-tos --redirect -m "$EMAIL" -d "$DOMAIN" -d "www.$DOMAIN"

echo "Done. Deploy the site from your Mac with deploy/deploy.sh."
