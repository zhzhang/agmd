#!/usr/bin/env sh
set -eu

APP_DIR="${AM_APP_DIR:-$HOME/.local/share/am-cli}"
BIN_DIR="${AM_BIN_DIR:-$HOME/.local/bin}"
VENV_DIR="${APP_DIR}/venv"
TARGET_BIN="${BIN_DIR}/am"
EXPECTED_TARGET="${VENV_DIR}/bin/am"

FORCE="${AM_CLEAN_FORCE:-0}"

confirm() {
  if [ "$FORCE" = "1" ]; then
    return 0
  fi

  echo "This will remove:"
  echo "  - ${APP_DIR}"
  echo "  - ${TARGET_BIN} (only if it points to ${EXPECTED_TARGET})"
  printf "Proceed? [y/N] "
  read -r answer
  case "$answer" in
    y|Y|yes|YES)
      return 0
      ;;
    *)
      echo "Cancelled."
      exit 0
      ;;
  esac
}

remove_bin_link() {
  if [ ! -e "$TARGET_BIN" ] && [ ! -L "$TARGET_BIN" ]; then
    echo "No binary link found at: ${TARGET_BIN}"
    return 0
  fi

  if [ -L "$TARGET_BIN" ]; then
    link_target="$(readlink "$TARGET_BIN" || true)"
    if [ "$link_target" = "$EXPECTED_TARGET" ]; then
      rm -f "$TARGET_BIN"
      echo "Removed binary link: ${TARGET_BIN}"
    else
      echo "Skipped ${TARGET_BIN}: symlink target does not match install path."
      echo "  Found target: ${link_target}"
    fi
    return 0
  fi

  echo "Skipped ${TARGET_BIN}: not a symlink."
}

remove_app_dir() {
  if [ -d "$APP_DIR" ]; then
    rm -rf "$APP_DIR"
    echo "Removed app directory: ${APP_DIR}"
  else
    echo "No app directory found at: ${APP_DIR}"
  fi
}

confirm
remove_bin_link
remove_app_dir

echo ""
echo "am install cleanup complete."
