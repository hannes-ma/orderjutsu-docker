# orderjutsu-docker
Docker Dateien für Orderjutsu Bestellsystem

2023-06-28: Achtung Docker Dateien wurden aktualisiert. Um mehr der Docker Philosophie zu entsprechen und durch Nutzung der offiziellen Images mehr Architekturen unterstützen zu können (speziell x86/amd64 und arm) wurden nginx und php in zwei getrennte Container aufgeteilt. Für die alte Methode mit nginx+php in einem Container siehe Branch '***all-in-one***'.

## Wie funktionierts?
Damit Orderjutsu funktioniert braucht es:
  * einen Webserver (nginx)
  * den PHP-Interpreter
  * eine Datenbank (mariadb)

Das sind dann auch schon die drei Container, die über das docker-compose Script gestartet werden.
Für PHP wird zudem ein eigenes Image generiert, basierend auf das offizielle PHP-Image, da für das Orderjutsu zusätzliche PHP Module und Packete benötigt werden.
Für den Nginx und mariadb Container wird hingegen direkt das offizielle Image von hub.docker.com hergenommen. 

### Daten Volumes

Die Daten werden in zwei Docker-Volumes abgelegt:
  * ***orderjutsu-dbdata***: Datenbank-Daten
  * ***orderjutsu-\<version\>***: Dieses Volume wird beim ersten Start des PHP-Containers initialisiert. *\<version\>* entspricht der Orderjutsu-Version und wird über die Umgebungsvariable ORDERJUTSU_VERSION konfiguriert (siehe Konfiguration unten). Bei der Initialisierung wird Orderjutsu über den Download-Link automatisch heruntergeladen, entpackt, sowie das Framework aufgesetzt. 

## Konfiguration
Die ".env" Datei öffnen und den eigenen Download-Link, sowie die aktuelle Orderjutsu-Version eingeben (findet man auf der Orderjutsu Homepage). Die Versionsangabe dient nur zur Namensgebung des Docker-Volumes, es wird ansonsten immer die letzte verfügbare Version installiert.
Weiters sind die Datenbankparameter für Benutzer, Passwort und Name der Datenbank einzugeben.

*Achtung: Diese .env hat nichts mit der .env von Orderjutsu gemein. Sie dient nur docker-compose zum Laden der Umgebungsvariablen!*

## Ausführen
```
git clone https://github.com/hannes-ma/orderjutsu-docker.git
cd orderjutsu-docker
docker compose up
```
**Achtung bei Git unter Windows**: Beachten dass bei git clone keine automatische Konvertierung der Zeilenenden von LF nach CRLF erfolgt (ansonsten kommt es zu Fehlermeldungen wie z.B. "init.sh not found"). In diesem Fall besser die Dateien in github als Zip-Datei herunterladen (oben rechts Code->Download ZIP)

Orderjutsu ist nach erfolgreichem Ausführen auf der Adresse *http://localhost:8080* erreichbar.

## Weiteres

### Log-Dateien
 
Fehlermeldungen werden direkt ins Docker Log geschrieben:
```
docker logs orderjutsu-php
docker logs orderjutsu-nginx
docker logs orderjutsu-db
```

Fehlermeldungen der Applikation (Druckerfehler, usw) sind im Laravel Log zu finden:
```
docker exec -it orderjutsu-php /bin/sh -c 'grep -v "^#" /srv/www/storage/logs/laravel.log'
``` 

### Volumes löschen

Möchte man Orderjutsu neu aufsetzen (z.B. um eine neue Version zu installieren), einfach das Volume löschen:
```
docker compose down
docker volume rm orderjutsu-<version>
```

Falls gewünscht kann auch die Datenbank gelöscht werden (Daten sind dann weg!):
```
docker volume rm docker-orderjutsu_orderjutsu-dbdata
```
Nach Löschen der Datenbank muss diese neu aufgesetzt werden. Dies kann manuell über folgenden Befehl erfolgen:
```
docker compose up
docker exec -it orderjutsu-php /bin/sh -c 'cd /srv/www && php artisan migrate --force --seed'
```
Alternativ wenn auch das orderjutsu Volume gelöscht wurde dann wird die Datenbank beim nächsten Start automatisch neu aufgesetzt.

### Bugs / TODO
 - Datenbank Backup (mysqldump) funktioniert nicht

 
