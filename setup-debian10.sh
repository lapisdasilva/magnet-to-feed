#!/bin/bash

# Atualize o sistema
apt update
apt upgrade -y

# Instalar o Nginx
apt-get install nginx -y

# Instalar o PHP e os módulos necessários para o Nginx
apt-get install php-fpm -y

# Reinicie o Nginx e o PHP-FPM para aplicar as alterações
systemctl restart nginx
systemctl restart php7.3-fpm

# Instale as dependências do sistema para o feed
apt-get install -y python3
apt-get install -y python3-pip
apt-get install -y wget

# Certifique-se de usar o pip3 para instalar beautifulsoup4
pip3 install beautifulsoup4

# Instale qbittorrent-api usando pip3 para Python 3
pip3 install qbittorrent-api

mkdir /var/www/html/rss
cp criar_lista.py rotina_rss.sh index.html /var/www/html/rss/

echo "Script executado com sucesso!"
