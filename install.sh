#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="${AGMD_APP_DIR:-$HOME/.local/share/agmd-cli}"
BIN_DIR="${AGMD_BIN_DIR:-$HOME/.local/bin}"
VENV_DIR="$APP_DIR/venv"
TARGET_BIN="$BIN_DIR/agmd"

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required but was not found." >&2
  exit 1
fi

mkdir -p "$APP_DIR" "$BIN_DIR"

echo "Creating virtual environment at: $VENV_DIR"
python3 -m venv "$VENV_DIR"

echo "Installing agmd-cli from source..."
"$VENV_DIR/bin/python" -m pip install --upgrade pip
"$VENV_DIR/bin/pip" install "$SCRIPT_DIR"

ln -sf "$VENV_DIR/bin/agmd" "$TARGET_BIN"

echo ""
echo "Installed 'agmd' to: $TARGET_BIN"

case ":$PATH:" in
  *":$BIN_DIR:"*)
    echo "'$BIN_DIR' is already in PATH."
    ;;
  *)
    echo "Add '$BIN_DIR' to your PATH, then restart your shell."
    echo "Example (bash/zsh):"
    echo "  echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.zshrc"
    ;;
esac

echo ""
echo "Try: agmd --help"
