#!/bin/bash
# Actualizar paquetes
sudo apt-get update

# Instalar servidor MariaDB
sudo apt-get install -y mariadb-server-10.3

# Desactivando tarjeta de red
sudo ip route del default