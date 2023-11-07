#!/bin/bash

# Atualize o sistema
apt update;
apt upgrade -y;

# Instalar o Apache
apt-get install apache2 -y;

# Instalar o PHP e os módulos necessários
apt-get install php libapache2-mod-php -y;

# Reiniciar o Apache para aplicar as alterações
systemctl restart apache2;

# Instale as dependências do sistema para o feed
apt-get install -y python3;
apt-get install -y python3-pip;
apt-get install -y wget;

# Certifique-se de usar o pip3 para instalar beautifulsoup4
pip3 install beautifulsoup4;

# Instale qbittorrent-api usando pip3 para Python 3
pip3 install qbittorrent-api;

echo "Script executado com sucesso!"
