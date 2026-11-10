#!/usr/bin/env bash
# Uilenschool installeren op een Ubuntu/Debian-VM (bv. in Synology Virtual Machine Manager).
# Gebruik:  sudo bash install-vm.sh [poort]     (standaard poort 80)
set -euo pipefail
PORT="${1:-80}"
DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET=/var/www/uilenschool

if [ "$(id -u)" -ne 0 ]; then echo "Start dit script met sudo."; exit 1; fi
[ -f "$DIR/www/index.html" ] || { echo "Map 'www' niet gevonden naast dit script."; exit 1; }

echo ">> nginx installeren"
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq nginx

echo ">> bestanden kopiëren naar $TARGET"
mkdir -p "$TARGET"
cp -r "$DIR/www/." "$TARGET/"
chown -R www-data:www-data "$TARGET"

echo ">> nginx configureren op poort $PORT"
cat > /etc/nginx/sites-available/uilenschool <<CONF
server {
    listen $PORT default_server;
    listen [::]:$PORT default_server;
    root $TARGET;
    index index.html;
    location / { try_files \$uri \$uri/ /index.html; }

}
CONF
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/uilenschool /etc/nginx/sites-enabled/uilenschool
nginx -t
systemctl enable --now nginx
systemctl reload nginx

if command -v ufw >/dev/null && ufw status | grep -q "Status: active"; then
  echo ">> firewall: poort $PORT openzetten"; ufw allow "$PORT"/tcp
fi

IP="$(hostname -I | awk '{print $1}')"
echo
echo "Klaar! Open op een tablet of pc in je netwerk:  http://$IP$( [ "$PORT" = 80 ] || echo ":$PORT" )"
