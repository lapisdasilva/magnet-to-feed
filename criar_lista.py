import re

# Abre o arquivo fit.html e lê seu conteúdo
with open('fit.html', 'r', encoding='utf-8') as file:
    html_content = file.read()

# Usa uma expressão regular para encontrar os trechos que começam com "[<a href=" e terminam com ">magnet</a>]"
magnet_links = re.findall(r'\[<a href="(.*?)">magnet</a>]', html_content)

# Cria um arquivo de saída para gravar os magnet links no formato desejado
with open('magnet_links.txt', 'w', encoding='utf-8') as output_file:
    if magnet_links:
        for link in magnet_links:
            # Extrai o nome do magnet da tag "dn" no link do magnet
            name_match = re.search(r'dn=([^&#]+)', link)
            if name_match:
                name = name_match.group(1)
                # Remove caracteres especiais, mantendo apenas os "+"
                name = re.sub(r'[^\w+]', '', name)
                # Limita o nome a no máximo 50 caracteres
                name = name[:50]
                output_file.write(f"{name}@{link}\n")  # Use o separador "@" aqui
        print("Magnet links com nomes limitados a 50 caracteres extraídos com sucesso e salvos em magnet_links.txt")
    else:
        print("Nenhum link de magnet encontrado no arquivo.")
