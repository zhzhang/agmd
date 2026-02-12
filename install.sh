#!/usr/bin/env sh
set -eu

APP_DIR="${AM_APP_DIR:-$HOME/.local/share/am-cli}"
BIN_DIR="${AM_BIN_DIR:-$HOME/.local/bin}"
VENV_DIR="${APP_DIR}/venv"
TARGET_BIN="${BIN_DIR}/am"

REPO="${AM_REPO:-zhzhang/am}"
REF="${AM_REF:-main}"
SOURCE_URL_DEFAULT="https://github.com/${REPO}/archive/refs/heads/${REF}.tar.gz"
SOURCE_URL="${AM_SOURCE_URL:-$SOURCE_URL_DEFAULT}"

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

echo "Installing am-cli from source:"
echo "  ${SOURCE_URL}"
"${VENV_DIR}/bin/python" -m pip install --upgrade pip
"${VENV_DIR}/bin/pip" install --upgrade "$SOURCE_URL"

ln -sf "${VENV_DIR}/bin/am" "$TARGET_BIN"

echo ""
echo "Installed 'am' to: ${TARGET_BIN}"

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
echo "Try: am --help"
