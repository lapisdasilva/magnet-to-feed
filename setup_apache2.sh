#!/bin/bash

# Define o diretório a ser configurado
diretorio="/var/www/html/rss"

# Altera o proprietário e grupo do diretório
chown -R www-data:www-data "$diretorio"

# Define permissões no diretório e subdiretórios
chmod -R 755 "$diretorio"

# Atualiza a lista de pacotes disponíveis
sudo apt update

# Instala o servidor web Apache
sudo apt install -y apache2

# Interrompe o serviço Apache
sudo service apache2 stop

# Altera a configuração de porta no arquivo ports.conf
sudo sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf

# Altera a configuração de porta no arquivo 000-default.conf
sudo sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf

# Inicia o serviço Apache
sudo service apache2 start

echo "Agora acesse o feed por http://127.0.0.1:8080/rss/feed.xml"