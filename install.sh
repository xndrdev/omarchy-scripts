#!/usr/bin/env bash
set -euo pipefail
prefix="${PREFIX:-/usr/local/bin}"
repo="$(pwd)"
script_name="$(basename "$0")"

# Alle ausführbaren Dateien im aktuellen Ordner (nicht rekursiv) verlinken, ausser install.sh selber
for f in "$repo"/*; do
  filename="$(basename "$f")"
  if [[ -f "$f" && -x "$f" && "$filename" != "$script_name" ]]; then
    sudo ln -sf "$f" "$prefix/$filename"
  fi
done

# Füge exec-once = handle_lid check zu ~/.config/hypr/hyprland.conf hinzu, falls nicht schon vorhanden
HYPR_CONFIG="$HOME/.config/hypr/autostart.conf"
LINE='exec-once = handle_lid check'

if [[ -f "$HYPR_CONFIG" ]]; then
  if ! grep -Fxq "$LINE" "$HYPR_CONFIG"; then
    echo "$LINE" >> "$HYPR_CONFIG"
    echo "Zeile '$LINE' zu $HYPR_CONFIG hinzugefügt."
  else
    echo "Zeile '$LINE' ist bereits in $HYPR_CONFIG vorhanden."
  fi
else
  mkdir -p "$(dirname "$HYPR_CONFIG")"
  echo "$LINE" > "$HYPR_CONFIG"
  echo "$HYPR_CONFIG wurde erstellt und Zeile '$LINE' hinzugefügt."
fi
