#!/usr/bin/env bash

## Función para ejecutar si no está en ejecución
run() {
  # $1 es el nombre del proceso a buscar con pgrep
  # $2 es el comando completo a ejecutar
  if ! pgrep "$1" > /dev/null; then
    # El & al final es vital para que el script no se bloquee
    $2 & 
  fi
}

# --- Lista de aplicaciones ---

# Picom
run "picom" "picom --config $HOME/.config/picom/config"

# MPD
run "mpd" "mpd $HOME/.config/mpd/mpd.conf"

# Unclutter
run "unclutter" "unclutter -root"

# Dunst
run "dunst" "dunst -conf $HOME/.config/dunst/dunstrc"

# Numlockx (Este suele cerrarse tras activarse, pero 'run' lo manejará)
run "numlockx" "numlockx"

# Xsettingsd
run "xsettingsd" "xsettingsd"

# Parcellite
run "parcellite" "parcellite"

# Emacs Daemon (Descomenta si lo usas)
run "emacs" "emacs --daemon"

# --- Scripts que se ejecutan siempre (sin pgrep) ---

# Teclado (setxkbmap no deja un proceso persistente fácil de trackear)
setxkbmap -layout us -variant intl

# Polybar (Usualmente el launch.sh ya mata instancias previas)
bash "$HOME/.config/polybar/launch.sh"

# Wallpapers
bash "$HOME/.local/bin/randWallpaper.sh"
