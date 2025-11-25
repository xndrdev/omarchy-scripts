#!/usr/bin/env bash
set -euo pipefail
prefix="${PREFIX:-/usr/local/bin}"
repo="$(pwd)"
script_name="$(basename "$0")"

# Alle ausführbaren Dateien im aktuellen Ordner (nicht rekursiv) verlinken, ausser install.sh selber
# Stelle sicher, dass reset-monitor ausführbar ist
if [[ -f "$repo/reset-monitor" && ! -x "$repo/reset-monitor" ]]; then
  chmod +x "$repo/reset-monitor"
  echo "✓ reset-monitor ausführbar gemacht"
fi

for f in "$repo"/*; do
  filename="$(basename "$f")"
  if [[ -f "$f" && -x "$f" && "$filename" != "$script_name" ]]; then
    sudo ln -sf "$f" "$prefix/$filename"
    echo "✓ $filename wurde nach $prefix/$filename verlinkt"
  fi
done

# Füge reset-monitor und handle_lid check zu ~/.config/hypr/autostart.conf hinzu
HYPR_CONFIG="$HOME/.config/hypr/autostart.conf"
RESET_LINE='exec-once = reset-monitor'
HANDLE_LID_LINE='exec-once = handle_lid check'

mkdir -p "$(dirname "$HYPR_CONFIG")"

if [[ -f "$HYPR_CONFIG" ]]; then
  # Erstelle temporäre Datei
  tmp_file=$(mktemp)
  
  # Entferne beide Zeilen falls vorhanden
  grep -vFx "$RESET_LINE" "$HYPR_CONFIG" | grep -vFx "$HANDLE_LID_LINE" > "$tmp_file" || true
  
  # Füge reset-monitor ganz oben hinzu
  echo "$RESET_LINE" > "$HYPR_CONFIG"
  
  # Füge handle_lid check danach hinzu
  echo "$HANDLE_LID_LINE" >> "$HYPR_CONFIG"
  
  # Füge den Rest der Datei hinzu (falls vorhanden)
  if [[ -s "$tmp_file" ]]; then
    cat "$tmp_file" >> "$HYPR_CONFIG"
  fi
  
  rm -f "$tmp_file"
  echo "✓ $RESET_LINE wurde als erste Zeile zu $HYPR_CONFIG hinzugefügt."
  echo "✓ $HANDLE_LID_LINE wurde als zweite Zeile zu $HYPR_CONFIG hinzugefügt."
else
  # Erstelle neue Datei mit beiden Zeilen
  echo "$RESET_LINE" > "$HYPR_CONFIG"
  echo "$HANDLE_LID_LINE" >> "$HYPR_CONFIG"
  echo "$HYPR_CONFIG wurde erstellt mit $RESET_LINE und $HANDLE_LID_LINE."
fi
