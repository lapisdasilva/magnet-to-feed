import qbittorrentapi

# Configurações do servidor qBittorrent
conn_info = dict(
    host="http://192.168.1.23",
    port=8080,
    username="admin",
    password="123456",
)
qbt_client = qbittorrentapi.Client(**conn_info)

# O Cliente adquirirá/ manterá automaticamente um estado conectado
# em linha com qualquer solicitação. Portanto, isso não é estritamente necessário;
# no entanto, você pode querer testar as credenciais de login fornecidas.
try:
    qbt_client.auth_log_in()
except qbittorrentapi.LoginFailed as e:
    print(e)

# Caminho para o arquivo de links magnéticos
magnet_links_file = 'magnet_links.txt'

# Lista para armazenar os hashes dos torrents recém-adicionados
newly_added_torrents = []

# Abra o arquivo de links magnéticos e adicione cada um ao qBittorrent
with open(magnet_links_file, 'r') as file:
    for line in file:
        name, magnet_link = line.strip().split('/;/')
        response = qbt_client.torrents_add(urls=magnet_link)
        if response == "Ok.":
            print(f"Torrent adicionado com sucesso: {name}")
            newly_added_torrents.append(response)
        else:
            print(f"Falha ao adicionar torrent: {name}")

# Iniciar automaticamente os torrents recém-adicionados
if newly_added_torrents:
    qbt_client.torrents_start(torrents=newly_added_torrents)

# Exibir informações do qBittorrent
print(f"qBittorrent: {qbt_client.app.version}")
print(f"qBittorrent Web API: {qbt_client.app.web_api_version}")
for k, v in qbt_client.app.build_info.items():
    print(f"{k}: {v}")

# Recuperar e mostrar todos os torrents
for torrent in qbt_client.torrents_info():
    print(f"{torrent.hash[-6:]}: {torrent.name} ({torrent.state})")

# Certifique-se de fazer logout após a conclusão, a menos que você esteja usando um contexto gerenciado.
qbt_client.auth_log_out()
