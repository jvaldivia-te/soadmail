-- Configuración segura de imapfilter para hoover
options.timeout = 120
options.subscribe = true

function get_password(account, service)
    local handle = io.popen("security find-generic-password -a " .. account .. " -s " .. service .. " -w")
    local password = handle:read("*a")
    handle:close()
    return string.gsub(password, "\n", "")
end

account = IMAP {
    server = 'mail.realnames.com',
    username = 'jose@valdivia.com',
    password = get_password('jose@valdivia.com', 'hoover'),
    ssl = 'tls1'
}

-- Ejemplo: mover correos de Amazon
amazon = account.INBOX:contain_from('amazon.com')
amazon:move_messages(account['amazon'])

-- Mover correos con encabezado List-Unsubscribe
unsub = account.INBOX:match_header('List-Unsubscribe', '.+')
unsub:move_messages(account['unsubscribe'])

