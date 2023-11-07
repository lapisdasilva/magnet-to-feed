#!/bin/bash

# Atualize o sistema
apt update;
apt upgrade -y;

# Instalar o Apache
apt install apache2 -y;

# Instalar o PHP e os módulos necessários
apt install php libapache2-mod-php -y;

# Reiniciar o Apache para aplicar as alterações
systemctl restart apache2;

# Instale as dependências do sistema para o feed
apt install -y python3;
apt install -y python3-pip;
apt install -y wget;
pip3 install beautifulsoup4;
pip install qbittorrent-api;

echo "Script executado com sucesso!"