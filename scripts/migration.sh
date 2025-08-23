#!/usr/bin/env sh

if ! command -v uwsm >/dev/null 2>&1; then
  echo "'uwsm' package is required for this update. Please install it."
  echo "You can also run './install.sh' to install all missing dependencies."
fi

if command -v aconfig-shell >/dev/null 2>&1; then
  echo "Reloading aConfig shell shaders..."
  aconfig-shell shaders --reload
fi
