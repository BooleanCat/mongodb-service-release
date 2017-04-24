#!/usr/bin/env bash

ensure_dir() {
  local dir="$1"
  local user_and_group="$2"

  mkdir -p "$dir"
  chown "$user_and_group" "$dir"
}
