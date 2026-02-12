#!/usr/bin/env sh
set -eu

APP_DIR="${AGMD_APP_DIR:-$HOME/.local/share/agmd-cli}"
BIN_DIR="${AGMD_BIN_DIR:-$HOME/.local/bin}"
VENV_DIR="${APP_DIR}/venv"
TARGET_BIN="${BIN_DIR}/agmd"

REPO="${AGMD_REPO:-zhzhang/agmd}"
REF="${AGMD_REF:-main}"
SOURCE_URL_DEFAULT="https://github.com/${REPO}/archive/refs/heads/${REF}.tar.gz"
SOURCE_URL="${AGMD_SOURCE_URL:-$SOURCE_URL_DEFAULT}"

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required but was not found." >&2
  exit 1
fi

mkdir -p "$APP_DIR" "$BIN_DIR"

if [ ! -x "${VENV_DIR}/bin/python" ]; then
  echo "Creating virtual environment at: ${VENV_DIR}"
  if ! python3 -m venv "$VENV_DIR"; then
    echo "Failed to create virtual environment. Ensure python3 venv support is installed." >&2
    exit 1
  fi
else
  echo "Using existing virtual environment at: ${VENV_DIR}"
fi

echo "Installing agmd-cli from source:"
echo "  ${SOURCE_URL}"
"${VENV_DIR}/bin/python" -m pip install --upgrade pip
"${VENV_DIR}/bin/pip" install --upgrade "$SOURCE_URL"

ln -sf "${VENV_DIR}/bin/agmd" "$TARGET_BIN"

echo ""
echo "Installed 'agmd' to: ${TARGET_BIN}"

case ":$PATH:" in
  *":$BIN_DIR:"*)
    echo "'${BIN_DIR}' is already in PATH."
    ;;
  *)
    echo "Add '${BIN_DIR}' to your PATH, then restart your shell."
    echo "Example (bash/zsh):"
    echo "  echo 'export PATH=\"${BIN_DIR}:\$PATH\"' >> ~/.zshrc"
    ;;
esac

echo ""
echo "Try: agmd --help"
