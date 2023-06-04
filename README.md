# orderjutsu-docker
Docker Dateien für Orderjutsu Bestellsystem

## Wie funktioniert das?
Das Docker-Compose File generiert zwei Container:
  1. Applikations-Container (nginx+php+orderjutsu)
  2. Datenbank-Container (mariadb)

Für den Applikations-Container wird ein eigenes Image gebaut, das das Basis-Image mit nginx und php 7.1 um die Orderjutsu-Applikation erweitert. Orderjutsu wird dabei über den Download-Link, den man beim Kauf erhalten hat, heruntergeladen und automatisch eingerichtet. Der Download-Link ist daher zwingend notwendig!

Das Datenverzeichnis der Datenbank wird über ein Docker Volume eingebunden und die Daten bleiben daher auch bei Stop und Neustart der Container erhalten.

## Konfiguration
Die ".env" Datei öffnen und den eigenen Download-Link, sowie die aktuelle Orderjutsu-Version eingeben (findet man auf der Orderjutsu Homepage). Die Versionsangabe dient nur zum Taggen des Image, es wird ansonsten immer die letzte verfügbare Version installiert.
Weiters sind die Datenbankparameter für Benutzer, Passwort und Name der Datenbank einzugeben.

*Achtung: Diese .env hat nichts mit der .env von Orderjutsu gemein. Sie dient nur docker-compose zum Laden der Umgebungsvariablen!*

## Ausführen
```
git clone https://github.com/hannes-ma/orderjutsu-docker.git
cd orderjutsu-docker
docker-compose up
```
**Achtung bei Git unter Windows**: Beachten dass bei git clone keine automatische Konvertierung der Zeilenenden von LF nach CRLF erfolgt (ansonsten kommt es zu Fehlermeldungen wie z.B. "init.sh not found"). In diesem Fall besser die Dateien in github als Zip-Datei herunterladen (oben rechts Code->Download ZIP)

Orderjutsu ist nach erfolgreichem Ausführen auf der Adresse *http://localhost:80* erreichbar.




