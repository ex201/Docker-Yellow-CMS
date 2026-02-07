# Docker Datenstrom Yellow CMS
Dieses Repository enthält ein fertiges Docker-Image für das Datenstrom Yellow CMS. Es basiert auf PHP 8.2 mit Apache und ist so vorkonfiguriert, dass es sofort einsatzbereit ist.

## Features
Ready-to-run: Das CMS ist bereits im Image vorinstalliert (kein Download beim Start nötig).

Optimiert: Apache mod_rewrite und PHP-Erweiterungen (GD, Zip) sind vorkonfiguriert.

Leichtgewichtig: Basiert auf dem offiziellen PHP-Apache-Image mit automatischem Cleanup.

## Schnelleinstieg (Docker Compose)
Erstelle eine docker-compose.yml mit folgendem Inhalt:

```yaml
services:
  yellow-cms:
    image: ex201/yellow:latest
    container_name: yellow_cms
    restart: unless-stopped
    ports:
      - "8084:80"
    volumes:
      - ./www:/var/www/html
```

Starte den Container mit:

```bash
docker compose up -d
```
Deine Website ist nun unter http://localhost:8084 erreichbar.

## Verzeichnisse und Persistence
Das Image speichert alle CMS-Daten in /var/www/html. Um deine Inhalte (Seiten, Bilder, Konfiguration) dauerhaft zu speichern, solltest du dieses Verzeichnis auf deinen Host-Rechner mounten:

/var/www/html: Enthält die gesamte Yellow-Installation.

/var/log/apache2: (Optional) Kann gemountet werden, wenn du direkten Zugriff auf die Apache-Logfiles benötigst. Standardmäßig werden die Logs über docker logs ausgegeben.

Hinweis: Wenn du einen leeren Ordner vom Host mountest, stelle sicher, dass du die Yellow-Dateien dort hineinkopierst, oder nutze ein Named Volume für eine automatische Initialisierung.

## Eigene Anpassungen (Build)
Wenn du das Image selbst bauen möchtest, klone dieses Repository und führe folgenden Befehl aus:

```bash
docker build -t yellow-cms:custom .
```
## Informationen zum CMS
Webseite: https://datenstrom.se/de/

Source: GitHub datenstrom/yellow

Was hat sich geändert? (Für Bestandskunden)

Im Vergleich zur alten Version wird Yellow CMS nicht mehr beim Starten des Containers heruntergeladen, sondern ist bereits fester Bestandteil des Images. Dies sorgt für:

Höhere Stabilität: Keine Abhängigkeit von GitHub-Verfügbarkeit beim Start.

Schnelligkeit: Der Container ist in Sekundenbruchteilen bereit.
