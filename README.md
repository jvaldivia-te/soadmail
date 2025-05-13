# soadmail

# ✉️ Combo CLI para correo IMAP: `isync` + `imapfilter` + `notmuch` + `msmtp`

Este setup te permite sincronizar tu correo IMAP, procesarlo con scripts o vim localmente, filtrar desde el servidor, y enviar correo desde la terminal.

---

## ✅ Paquetes a instalar con Homebrew

```sh
brew install isync imapfilter notmuch msmtp mu
```

---

## 📁 Estructura de carpetas (Maildir estándar)

```
~/Mail/
├── hoover/               # Carpeta para cuenta principal
│   ├── cur/
│   ├── new/
│   └── tmp/
```

---

## ⚙️ Configuración de `mbsync` (`~/.mbsyncrc`)

```ini
IMAPAccount hoover
Host imap.hoover.realnames.com
User tu_usuario@tudominio.com
Pass eval:`gpg --decrypt ~/.mailpass.gpg`
SSLType IMAPS

IMAPStore hoover-remote
Account hoover

MaildirStore hoover-local
Path ~/Mail/hoover/
Inbox ~/Mail/hoover/

Channel hoover
Master :hoover-remote:
Slave :hoover-local:
Patterns *
Create Slave
SyncState *
```

---

## 🔐 Contraseña encriptada (opcional con GPG)

```sh
echo "tu-contraseña" | gpg --symmetric --output ~/.mailpass.gpg
```

---

## ⚙️ Configuración básica de `imapfilter` (`~/.imapfilter/config.lua`)

```lua
options.timeout = 120
options.subscribe = true

account_hoover = IMAP {
  server = 'imap.hoover.realnames.com',
  username = 'tu_usuario@tudominio.com',
  password = 'tu-contraseña',
  ssl = 'ssl3'
}

inbox = account_hoover.INBOX

-- Ejemplo: mover correos de Amazon a carpeta "Amazon"
amazon = inbox:contain_from("amazon.com")
amazon:move_messages(account_hoover["Amazon"])
```

---

## ⚙️ Configuración de `notmuch`

```sh
notmuch setup
# Te pedirá tu nombre, email, y la carpeta Maildir (~/Mail/hoover)
```

Después puedes buscar correos con:
```sh
notmuch search from:amazon
```

Y editar con:
```sh
vim $(notmuch search --output=files subject:unsubscribe | head -n1)
```

---

## ⚙️ Configuración de `msmtp` para enviar (en `~/.msmtprc`)

```ini
account hoover
host smtp.hoover.realnames.com
port 587
from tu_usuario@tudominio.com
auth on
user tu_usuario@tudominio.com
passwordeval gpg --decrypt ~/.mailpass.gpg
tls on
tls_starttls on

account default : hoover
```

---

## 🚀 Uso rápido

```sh
mbsync hoover           # Sincroniza correo desde el servidor
imapfilter              # Filtra correo en el servidor
notmuch new             # Indexa nuevos correos descargados
msmtp -a hoover ...     # Enviar correo desde CLI
```

---

## 🧠 Tip extra: seguimiento de links de desuscripción
Puedes hacer un script que use `ripgrep` para buscar `List-Unsubscribe:` en los correos locales:

```sh
rg -i 'List-Unsubscribe:' ~/Mail/hoover/
```

Y luego extraer los links y abrirlos con `xdg-open` o `open` en Mac.
```


