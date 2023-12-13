#!/bin/bash

# Actualizar paquetes
sudo apt-get update

# Instalando servidor NFS

sudo apt install nfs-kernel-server

# Instalar PHP-FPM y PHP MySQL

sudo apt-get install -y php-fpm php-mysql

# Desactivando tarjeta de red
sudo ip route del default