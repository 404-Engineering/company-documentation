#!/usr/bin/env bash
# Copy the site to the droplet. Run from the website folder on your Mac:
#   ./deploy/deploy.sh user@droplet-ip
set -euo pipefail

TARGET="${1:?usage: deploy.sh <user@host>}"
cd "$(dirname "$0")/.."

rsync -avz --delete --exclude '.DS_Store' site/ "$TARGET:/var/www/404engineering/"
echo "Deployed to $TARGET"
