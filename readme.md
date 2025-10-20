# Docker Setup Anleitung (Windows)

Diese Anleitung erklärt Schritt für Schritt, wie ein Windows-Nutzer dieses Projekt mit Docker starten kann.

---

## ✅ Voraussetzungen (einmalig)

Bevor du loslegst, installiere bitte folgende Software:

1. **Docker Desktop** für Windows:
   https://www.docker.com/products/docker-desktop
   - Bei der Installation **WSL2 aktivieren**

2. **Git für Windows**:
   https://git-scm.com/download/win

3. **Optional:** Visual Studio Code:
   https://code.visualstudio.com/

---

## 🚀 Repository klonen
Öffne PowerShell oder die Eingabeaufforderung und führe Folgendes aus:

```powershell
# Ordner wählen (optional)
cd $HOME\Documents

# Repository klonen (URL anpassen)
git clone https://github.com/<USER>/<REPO>.git
cd <REPO>
```

---

## 🔧 Docker Image bauen
Prüfe zuerst, ob eine `Dockerfile` im Projektordner liegt:

```powershell
dir
```

Dann das Docker-Image bauen:

```powershell
docker build -t myapp:latest .
```

---

## 🔍 Port im Dockerfile herausfinden
Finde heraus auf welchem Port die Anwendung läuft:

```powershell
Select-String -Path Dockerfile -Pattern "EXPOSE"
```

Beispielausgabe:
```
EXPOSE 8080
```
Dieser Port wird im nächsten Schritt verwendet.

---

## ▶️ Container starten
Starte den Container und öffne ihn nach außen über den Port:

```powershell
docker run --name myapp -p 8080:8080 -d myapp:latest
```

Wenn im Dockerfile `EXPOSE 8080` steht, verwende hier auch `8080:8080`. Falls ein anderer Port verwendet wird, entsprechend ersetzen.

---

## 🌍 Anwendung im Browser öffnen
Rufe im Browser auf:
```
http://localhost:8080
```
Wenn ein anderer Port verwendet wird, passe ihn an.

---

## 🛠️ Nützliche Befehle
| Zweck | Befehl |
|-------|--------|
| Laufende Container anzeigen | `docker ps` |
| Logs ansehen | `docker logs -f myapp` |
| Container stoppen | `docker stop myapp` |
| Container löschen | `docker rm myapp` |
| Image löschen | `docker rmi myapp:latest` |

---

## ❗ Häufige Probleme
| Problem | Lösung |
|----------|--------|
| Port ist bereits in Verwendung | Wechsel Host-Port: `-p 9090:8080` |
| Build schlägt fehl | `docker build --no-cache -t myapp .` |
| Keine Verbindung möglich | Prüfe Firewall / Logs | `docker logs -f myapp` |

---

## 🔚 Komplettbefehle für Schnellstart
```powershell
git clone https://github.com/<USER>/<REPO>.git
cd <REPO>
docker build -t myapp .
docker run --name myapp -p 8080:8080 -d myapp
```

---

Wenn du Fragen hast oder Hilfe brauchst, kannst du jederzeit ein Issue im Repository eröffnen.




