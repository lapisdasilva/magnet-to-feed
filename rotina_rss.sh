#!/bin/bash

# Defina a URL do feed RSS
rss_url="http://fitgirl-repacks.site/feed/"

# Nome do arquivo de saÃ­da
output_file="fit.html"

# Use o wget para baixar o feed RSS e salve-o no arquivo de saÃ­da
wget -O "$output_file" "$rss_url"

# Verifica se o download foi bem-sucedido
if [ $? -eq 0 ]; then
  echo "Feed RSS baixado com sucesso e salvo em $output_file"
else
  echo "Ocorreu um erro ao baixar o feed RSS."
fi

python3 <<EOF
import re

# Abre o arquivo fit.html e lÃª seu conteÃºdo
with open('fit.html', 'r', encoding='utf-8') as file:
    html_content = file.read()

# Usa uma expressÃ£o regular para encontrar os trechos que comeÃ§am com "[<a href=" e terminam com ">magnet</a>]"
magnet_links = re.findall(r'\[<a href="(.*?)">magnet</a>]', html_content)

# Cria um arquivo de saÃ­da para gravar os magnet links no formato desejado
with open('magnet_links.txt', 'w', encoding='utf-8') as output_file:
    if magnet_links:
        for link in magnet_links:
            # Extrai o nome do magnet da tag "dn" no link do magnet
            name_match = re.search(r'dn=([^&#]+)', link)
            if name_match:
                name = name_match.group(1)
                # Remove caracteres especiais, mantendo apenas os "+"
                name = re.sub(r'[^\w+]', '', name)
                # Limita o nome a no mÃ¡ximo 50 caracteres
                name = name[:50]
                output_file.write(f"{name}@{link}\n")  # Use o separador "@" aqui
        print("Magnet links com nomes limitados a 50 caracteres extraÃ­dos com sucesso e salvos em magnet_links.txt")
    else:
        print("Nenhum link de magnet encontrado no arquivo.")
EOF

# Caminho para o arquivo magnet_links.txt
ARQUIVO_TXT="magnet_links.txt"

# Caminho para o arquivo XML de saÃ­da
ARQUIVO_XML="feed.xml"

# CabeÃ§alho do arquivo XML
cat <<EOF > "$ARQUIVO_XML"
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
	xmlns:content="http://purl.org/rss/1.0/modules/content/"
	xmlns:wfw="http://wellformedweb.org/CommentAPI/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
	xmlns:slash="http://purl.org/rss/1.0/modules/slash/"
	xmlns:georss="http://www.georss.org/georss"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
>
  <channel>
    <title>Feed FitGirl by lapisdasilva</title>
    <description>RSS feed generated from magnet_links.txt file</description>
EOF

# Processa o arquivo magnet_links.txt com "@" como separador
while IFS='@' read -r nome magnet; do
  echo "    <item>" >> "$ARQUIVO_XML"
  echo "      <title>$nome</title>" >> "$ARQUIVO_XML"
  echo "      <link>$magnet</link>" >> "$ARQUIVO_XML"
  echo "    </item>" >> "$ARQUIVO_XML"
done < "$ARQUIVO_TXT"

# RodapÃ© do arquivo XML
cat <<EOF >> "$ARQUIVO_XML"
  </channel>
</rss>
EOF

echo "Arquivo XML atualizado com sucesso em $ARQUIVO_XML"
