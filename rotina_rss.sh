#!/bin/bash

# Defina a URL do feed RSS
rss_url="http://fitgirl-repacks.site/feed/"

# Nome do arquivo de saída
output_file="fit.html"

# Use o wget para baixar o feed RSS e salve-o no arquivo de saída
wget -O "$output_file" "$rss_url"

# Verifica se o download foi bem-sucedido
if [ $? -eq 0 ]; then
  echo "Feed RSS baixado com sucesso e salvo em $output_file"
else
  echo "Ocorreu um erro ao baixar o feed RSS."
fi

python3 criarlista.py

# Caminho para o arquivo magnet_links.txt
ARQUIVO_TXT="magnet_links.txt"

# Caminho para o arquivo XML de saída
ARQUIVO_XML="feed.xml"

# Cabeçalho do arquivo XML
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

# Rodapé do arquivo XML
cat <<EOF >> "$ARQUIVO_XML"
  </channel>
</rss>
EOF

echo "Arquivo XML atualizado com sucesso em $ARQUIVO_XML"
