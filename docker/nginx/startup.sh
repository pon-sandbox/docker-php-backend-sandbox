
   
#!/bin/sh

# 自己証明書を発行 (*.localhost localhost のみ)
if "${IS_SELF_SIGNED}"; then
    openssl genrsa 2048 > /root/server.key
    openssl req -new -key /root/server.key -subj "/C=JP" > /root/server.csr
    echo "subjectAltName = DNS:*.localhost,DNS:localhost" > san.txt
    openssl x509 -in /root/server.csr -days 825 -req -signkey /root/server.key -extfile san.txt > /root/server.crt
    rm san.txt
    ln -nfs /root/server.crt /etc/nginx/server.crt
    ln -nfs /root/server.key /etc/nginx/server.key
    chmod 400 /etc/nginx/server.key
else
    # さくらクラウド DNS で Let's Encrypt の証明書を発行 (*.${DOMAIN_FOR_LETSENCRYPT} ${DOMAIN_FOR_LETSENCRYPT} のみ)
    if [ -s /etc/letsencrypt/archive/${DOMAIN_FOR_LETSENCRYPT}/cert1.pem -a -s /etc/letsencrypt/archive/${DOMAIN_FOR_LETSENCRYPT}/chain1.pem -a -s /etc/letsencrypt/archive/${DOMAIN_FOR_LETSENCRYPT}/fullchain1.pem -a -s /etc/letsencrypt/archive/${DOMAIN_FOR_LETSENCRYPT}/privkey1.pem ]; then
        if [ ! -L /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/cert.pem -o ! -L /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/chain.pem -o ! -L /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/fullchain.pem -o ! -L /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/privkey.pem ]; then
            if [ -s /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/fullchain.pem ]; then
                rm /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/cert.pem
            fi
            if [ -s /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/chain.pem ]; then
                rm /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/chain.pem
            fi
            if [ -s /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/fullchain.pem ]; then
                rm /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/fullchain.pem
            fi
            if [ -s /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/privkey.pem ]; then
                rm /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/privkey.pem
            fi
            ln -nfs /etc/letsencrypt/archive/${DOMAIN_FOR_LETSENCRYPT}/cert1.pem /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/cert.pem
            ln -nfs /etc/letsencrypt/archive/${DOMAIN_FOR_LETSENCRYPT}/chain1.pem /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/chain.pem
            ln -nfs /etc/letsencrypt/archive/${DOMAIN_FOR_LETSENCRYPT}/fullchain1.pem /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/fullchain.pem
            ln -nfs /etc/letsencrypt/archive/${DOMAIN_FOR_LETSENCRYPT}/privkey1.pem /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/privkey.pem
        fi
        ln -nfs /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/fullchain.pem /etc/nginx/server.crt
        ln -nfs /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/privkey.pem /etc/nginx/server.key
        
        if [ ! -s /etc/letsencrypt/live/.${DOMAIN_FOR_LETSENCRYPT}.sakura ]; then
            echo "dns_sakuracloud_api_token = "${DNS_SAKURACLOUD_API_TOKEN} > /etc/letsencrypt/live/.${DOMAIN_FOR_LETSENCRYPT}.sakura
            echo "dns_sakuracloud_api_secret = "${DNS_SAKURACLOUD_API_SECRET} >> /etc/letsencrypt/live/.${DOMAIN_FOR_LETSENCRYPT}.sakura
            chmod 600 /etc/letsencrypt/live/.${DOMAIN_FOR_LETSENCRYPT}.sakura
        fi
        certbot renew --cert-name ${DOMAIN_FOR_LETSENCRYPT}
    else
        mkdir -p /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}
        echo "dns_sakuracloud_api_token = "${DNS_SAKURACLOUD_API_TOKEN} > /etc/letsencrypt/live/.${DOMAIN_FOR_LETSENCRYPT}.sakura
        echo "dns_sakuracloud_api_secret = "${DNS_SAKURACLOUD_API_SECRET} >> /etc/letsencrypt/live/.${DOMAIN_FOR_LETSENCRYPT}.sakura
        chmod 600 /etc/letsencrypt/live/.${DOMAIN_FOR_LETSENCRYPT}.sakura
        certbot certonly --dns-sakuracloud --dns-sakuracloud-credentials /etc/letsencrypt/live/.${DOMAIN_FOR_LETSENCRYPT}.sakura -d *.${DOMAIN_FOR_LETSENCRYPT} -d ${DOMAIN_FOR_LETSENCRYPT} -m ${MAIL_FOR_LETSENCRYPT} --agree-tos --non-interactive
        ln -nfs /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/fullchain.pem /etc/nginx/server.crt
        ln -nfs /etc/letsencrypt/live/${DOMAIN_FOR_LETSENCRYPT}/privkey.pem /etc/nginx/server.key
    fi
fi

nginx -g "daemon off;"