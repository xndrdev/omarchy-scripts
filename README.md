# Hyprland System-Skripte

Eine Sammlung von nützlichen Bash-Skripten zur Verwaltung von Hyprland-Monitor-Konfigurationen und Laptop-Deckel-Handling.

## Übersicht

Dieses Repository enthält mehrere Utility-Skripte für die Verwaltung von Monitor-Konfigurationen und Laptop-Einstellungen unter Hyprland:

- **set-monitor**: Wechsel zwischen vordefinierten Monitor-Konfigurationen (z.B. Home/Work)
- **handle_lid**: Verwaltung des Laptop-Deckels (aktivieren/deaktivieren des integrierten Displays oder Automatik-Erkennung)
- **install.sh**: Installationsskript zum Verlinken aller Skripte in den System-PATH

## Installation

Das Projekt kann mit dem bereitgestellten Installationsskript installiert werden:

```bash
./install.sh
```

Dies verlinkt alle ausführbaren Dateien nach `/usr/local/bin` (oder `$PREFIX`, falls gesetzt).

## Skripte

### set-monitor

Wechselt zwischen verschiedenen Monitor-Konfigurationen für Hyprland.

**Verwendung:**
```bash
set-monitor home    # Aktiviert die Home-Monitor-Konfiguration
set-monitor work    # Aktiviert die Work-Monitor-Konfiguration
```

**Funktionsweise:**
- Schreibt die entsprechende Monitor-Konfiguration nach `~/.config/hypr/monitors.conf`
- Lädt Hyprland neu, um die Änderungen anzuwenden
- Sendet eine Benachrichtigung über den Wechsel
- Schließt den Laptop-Deckel nach dem Wechsel

### handle_lid

Verwaltet den Status des Laptop-Deckels und aktiviert/deaktiviert entsprechend das integrierte Display (eDP-1).

**Verwendung:**
```bash
handle_lid open     # Aktiviert das Laptop-Display (Deckel offen)
handle_lid close    # Deaktiviert das Laptop-Display (Deckel geschlossen)
handle_lid check    # Erkennt automatisch den aktuellen Deckelstatus und setzt die passende Konfiguration
```

**Funktionsweise:**
- Modifiziert die `~/.config/hypr/monitors.conf` Datei
- Entfernt bestehende eDP-1 Einträge und fügt neue je nach Status hinzu
- Bei `handle_lid check` wird der Deckelstatus automatisch ausgelesen und übernommen (offen = Display an, geschlossen = Display aus)
- Lädt Hyprland neu, um die Änderungen anzuwenden
- Sendet optional eine Benachrichtigung

## Voraussetzungen

- **Hyprland**: Window Manager
- **hyprctl**: Hyprland Control Tool
- **notify-send**: Für Desktop-Benachrichtigungen (optional)
- Bash mit `set -euo pipefail` Support

## Konfiguration

Die Skripte arbeiten mit der Hyprland-Konfigurationsdatei:
```
~/.config/hypr/monitors.conf
```

Stelle sicher, dass Hyprland so konfiguriert ist, dass diese Datei geladen wird.

## Anpassung

### Monitor-Konfigurationen anpassen

Die Monitor-Konfigurationen in `set-monitor` können nach Bedarf angepasst werden. Bearbeite die Monitor-Zeilen im Skript entsprechend deiner Hardware:

```bash
monitor = <DISPLAY>, <RESOLUTION>, <POSITION>, <SCALE>
```

### Anpassung der Installationspfade

Das Standard-Installationsverzeichnis ist `/usr/local/bin`. Dies kann durch Setzen der Umgebungsvariable `PREFIX` geändert werden:

```bash
PREFIX=/usr/bin ./install.sh
```

## Lizenz

Diese Skripte sind für den persönlichen Gebrauch gedacht.
