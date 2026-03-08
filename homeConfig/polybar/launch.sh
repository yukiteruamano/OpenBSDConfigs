#!/usr/bin/env bash

# 1. Definir el nombre de la barra (ajusta si tu barra se llama distinto en config.ini)
BAR_NAME="top"

# 2. Apagar las instancias actuales de forma limpia
# polybar-msg es preferible si tienes IPC habilitado, pkill es el respaldo
if pgrep -x polybar >/dev/null; then
    polybar-msg cmd quit >/dev/null 2>&1 || pkill -9 polybar
fi

# 3. Esperar a que los procesos se hayan cerrado completamente
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# 4. Lanzamiento multimonitor
# Detectamos los monitores conectados y lanzamos una instancia en cada uno
if type "xrandr" > /dev/null; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload "$BAR_NAME" 2>&1 | tee -a /tmp/polybar.log & disown
  done
else
  # Fallback si xrandr no está disponible
  polybar --reload "$BAR_NAME" 2>&1 | tee -a /tmp/polybar.log & disown
fi

echo "Polybar iniciada en todos los monitores..."
