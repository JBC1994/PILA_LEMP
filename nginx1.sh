#!/bin/bash
# Actualizar paquetes
sudo apt-get update

# Instalar Nginx
sudo apt-get install -y nginx

# Instalar cliente NFS, PHP-FPM y PHP MySQL
sudo apt-get install -y nfs-common php-fpm php-mysql

# Instalar cliente MariaDB
sudo apt-get install -y mariadb-client-10.3

# Crear ruta de montaje
sudo mkdir -p /var/nfs/wordpress

# Desactivando tarjeta de red
sudo ip route del default
