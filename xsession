xset b off

# Cargando el perfil
. /home/yukiteru/.profile

# Iniciando dbus sessions
if [ -x /usr/local/bin/dbus-launch -a -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
        eval `dbus-launch --sh-syntax --exit-with-x11`
fi

# Iniciando i3
exec i3
