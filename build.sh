#!/bin/bash

set -euo pipefail

COLOR_RESET='\033[0m'
COLOR_RED='\033[31m'
COLOR_GREEN='\033[32m'
COLOR_BLUE='\033[34m'
COLOR_YELLOW='\033[33m'

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

function detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "${ID,,}"
    return
  fi
  unameOut="$(uname -s)"
  case "${unameOut}" in
    Linux*) echo linux ;;
    Darwin*) echo macos ;;
    *) echo unknown ;;
  esac
}

function color_text() {
  local color="$1"
  shift
  printf "%b%s%b\n" "${color}" "$*" "${COLOR_RESET}"
}

function echo_error() {
  color_text "${COLOR_RED}" "Erreur : $*"
}

function echo_info() {
  color_text "${COLOR_BLUE}" "$*"
}

function echo_success() {
  color_text "${COLOR_GREEN}" "$*"
}

function ant_install_hint() {
  distro="$(detect_distro)"
  case "$distro" in
    arch|archlinux|cachyos)
      echo "sudo pacman -S --needed apache-ant" ;;
    fedora)
      echo "sudo dnf install ant" ;;
    ubuntu|debian)
      echo "sudo apt update && sudo apt install ant" ;;
    linux)
      echo "Installe Ant avec le gestionnaire de paquets de ta distribution." ;;
    macos)
      echo "brew install ant" ;;
    *)
      echo "Installe Ant avec le gestionnaire de paquets de ton système." ;;
  esac
}

if ! command -v ant >/dev/null 2>&1; then
  echo_error "'ant' n'est pas installé ou n'est pas dans le PATH."
  echo_info "Commande recommandée pour installer Ant :"
  echo_info "  $(ant_install_hint)"
  echo_info "Ensuite, relance ./build.sh."
  exit 1
fi

if [ ! -f build.xml ]; then
  echo_error "build.xml introuvable dans le répertoire du projet."
  exit 1
fi

echo_info "Lancement du build Ant dans $PROJECT_DIR..."
CORES=$(nproc)
echo_info "Système détecté : $CORES coeurs disponibles"
ant

echo_success "Build terminé."
