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
