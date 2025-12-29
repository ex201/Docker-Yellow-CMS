# Yellow-CMS Container
Docker Datenstrom Yellow mit Apache 2 und PHP 8

# docker-compose.yml
```yaml
services:
  cms:
    build: .
    container_name: yellow_cms
    restart: unless-stopped
    ports:
      - "8084:80"
    volumes:
      - ./www:/var/www/html
      - ./log/apache2:/var/log/apache2
    entrypoint: 
      - /bin/bash
      - -c
      - |
        if [ ! -f /var/www/html/yellow.php ]; then
          echo "Initialisiere Yellow CMS..."
          curl -L https://github.com/datenstrom/yellow/archive/refs/heads/master.zip -o /tmp/yellow.zip
          unzip /tmp/yellow.zip -d /tmp/
          cp -a /tmp/yellow-*/. /var/www/html/
          rm -rf /tmp/yellow.zip /tmp/yellow-*
        fi
        chown -R www-data:www-data /var/www/html
        exec apache2-foregroun
```
Eine aktuelle Version von Yellow wird automatisch heruntergeladen.
Infos zum CMS: https://datenstrom.se/de/
Git: datenstrom/yellow
