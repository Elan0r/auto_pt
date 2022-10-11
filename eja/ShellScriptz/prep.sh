#!/bin/bash

# Reading Website Path into variable
read -p "Enter Website: " site

# Stopping old containers
docker stop phish > /dev/null 2>&1
docker rm phish > /dev/null 2>&1
docker stop mail > /dev/null 2>&1
docker rm mail > /dev/null 2>&1

# Start Webserver
echo "[#] Starting Webserver.."
docker run -dit --name phish -p 80:80 -p 443:443 -v /root/phish/website:/var/www/customer registry.gitlab.com/prosec/phish

# Changing customer conf ServerName to website
docker exec -it phish sed -ri 's/ServerName ALIAS/ServerName '$site'/g' /etc/apache2/sites-available/001-customer.conf

# Making Alias out of Website and changing Customer Conf
alias=`echo $site | cut -d "." -f 2-5`
docker exec -it phish sed -ri 's/ServerAlias \*\.ALIAS/ServerAlias \*.'$alias'/g' /etc/apache2/sites-available/001-customer.conf

# Copy .htaccess in customer root dir
docker exec -it phish bash -c 'cp /var/www/html/.htaccess /var/www/customer/.htaccess'

# Cleaning Up iptables rules
iptables -F DOCKER-USER
iptables -I DOCKER-USER -j DROP
iptables -I DOCKER-USER -s 10.222.222.0/24 -j ACCEPT
iptables -I DOCKER-USER -i docker0 -j ACCEPT
iptables -I DOCKER-USER -m state --state related,established -j ACCEPT

# Adding 80 & 443 to iptables
iptables -I DOCKER-USER -p tcp --dport 80 -j ACCEPT
iptables -I DOCKER-USER -p tcp --dport 443 -j ACCEPT

# Certbot for HTTPS Certificate
docker exec -it phish certbot -n --redirect --agree-tos --apache -m info@prosec-networks.com -d $site

# Start Mailserver
echo "[#] Starting Mailserver.."
docker run -dit -e DISABLE_CLAMAV=TRUE -e DISABLE_RSPAMD=TRUE -e TZ=Europe/Berlin -v /root/data:/data --name mail -p 127.0.0.1:8080:443 -p 25:25 -h "mx.$site" -t analogic/poste.io

# Accept Incoming Mails
iptables -I DOCKER-USER -p tcp --dport 25 -j ACCEPT
