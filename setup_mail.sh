#!/bin/bash

set -e

HOME="/Users/jose"
REPO="$HOME/jose/soadmail"
MAILDIR="$HOME/Mail/hoover"
EMAIL="jose@valdivia.com"
SERVICE="hoover"

echo "📦 Instalando herramientas..."
brew install isync imapfilter notmuch msmtp ripgrep neomutt

echo "📁 Creando carpetas necesarias..."
mkdir -p "$MAILDIR"
mkdir -p "$HOME/.imapfilter"

echo "🔗 Enlazando archivos de configuración..."
ln -sf "$REPO/mbsyncrc" "$HOME/.mbsyncrc"
ln -sf "$REPO/config.lua" "$HOME/.imapfilter/config.lua"
ln -sf "$REPO/notmuch-config" "$HOME/.notmuch-config"
ln -sf "$REPO/muttrc $HOME/.muttrc"


echo "🔐 Ingresando y guardando la contraseña de $EMAIL en el llavero de macOS..."
read -s -p "Introduce la contraseña de $EMAIL: " PASSWORD
echo
security add-generic-password -a "$EMAIL" -s "$SERVICE" -w "$PASSWORD" -U

echo "🔐 Contraseña guardada en el llavero con service '$SERVICE' y account '$EMAIL'."

read -r -p "¿Agregar cronjob para sincronizar automáticamente cada 15 minutos? (s/n): " answer

if [ "$answer" = "s" ]; then
    croncmd="*/15 * * * * /opt/homebrew/bin/mbsync hoover && /opt/homebrew/bin/notmuch new"

    # Verifica si ya está
    if crontab -l 2>/dev/null | grep -Fq "$croncmd"; then
        echo "⏭️  El cronjob ya estaba agregado. No se duplicó."
    else
        # Agrega sin duplicar
        (crontab -l 2>/dev/null; echo "$croncmd") | crontab -
        echo "✅ Cronjob agregado."
    fi
else
    echo "⏭️  Saltando cronjob."
fi


notmuch tag +inbox -- folder: "$MAILDIR/INBOX/"


echo ""
echo "🚀 Todo listo. Puedes correr:"
echo "  mbsync hoover"
echo "  imapfilter"
echo "  notmuch new"

