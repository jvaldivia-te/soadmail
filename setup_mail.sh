#!/bin/bash

set -e

REPO="$HOME/jose/soadmail"
MAILDIR="$HOME/Mail/hoover"
EMAIL="jose@valdivia.com"
SERVICE="hoover"

echo "📦 Instalando herramientas..."
brew install isync imapfilter notmuch msmtp ripgrep

echo "📁 Creando carpetas necesarias..."
mkdir -p "$MAILDIR"
mkdir -p "$HOME/.imapfilter"

echo "🔗 Enlazando archivos de configuración..."
ln -sf "$REPO/mbsyncrc" "$HOME/.mbsyncrc"
ln -sf "$REPO/config.lua" "$HOME/.imapfilter/config.lua"
ln -sf "$REPO/notmuch-config" "$HOME/.notmuch-config"

echo "🔐 Ingresando y guardando la contraseña de $EMAIL en el llavero de macOS..."
read -s -p "Introduce la contraseña de $EMAIL: " PASSWORD
echo
security add-generic-password -a "$EMAIL" -s "$SERVICE" -w "$PASSWORD" -U

echo "🔐 Contraseña guardada en el llavero con service '$SERVICE' y account '$EMAIL'."

read -p "¿Agregar cronjob para sincronizar automáticamente cada 15 minutos? (s/n): " answer
if [[ "$answer" == "s" ]]; then
    (crontab -l 2>/dev/null; echo "*/15 * * * * /opt/homebrew/bin/mbsync hoover && /opt/homebrew/bin/notmuch new") | crontab -
    echo "✅ Cronjob agregado."
else
    echo "⏭️  Saltando cronjob."
fi

echo ""
echo "🚀 Todo listo. Puedes correr:"
echo "  mbsync hoover"
echo "  imapfilter"
echo "  notmuch new"

