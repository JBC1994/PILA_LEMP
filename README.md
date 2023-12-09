## <p align="center">Índice</p> 
### <p align="right">Joaquín Blanco Contreras, Curso: ASIR2</p>

1.0. [INTRODUCCIÓN PILA LEMP](#INTRODUCCIÓN-PILA-LEMP)
-    1.1. [Escenario De La práctica](#Escenario-de-la-práctica)
-    1.2. [¿Qué es una VPC en AWS?](#Qué-es-una-VPC-en-AWS)
-    1.3. [Creación de VPC en AWS](#Creación-de-VPC-en-AWS)
-    1.4. [¿Qué es una EC2 en AWS?](#Qué-es-una-EC2-en-AWS)
-    1.5. [Creación de EC2 en AWS](#Creación-de-EC2-en-AWS)

2.0. [¿ Qué es una IP elástica en AWS ?](#Qué-es-una-IP-elástica-en-AWS) 
-    2.1. [Asociar una IP elástica a una instancia AWS](#Asociar-una-IP-elástica-a-una-instancia-AWS)
-    2.2. [Conexión a instancias EC2 AWS](#Conexión-a-instancias-EC2-AWS)

3.0. [Instalación de servicios en instancias AWS](#Instalación-de-servicios-en-instancias-AWS)
-    3.1. [Configuración de conectividad en instancias AWS](#Configuración-de-conectividad-en-instancias-AWS)
-    3.2. [Creación de dominio en NO-ip](#Creación-de-dominio-en-NO-ip)
-    3.3. [HTTPS con Let’s Encrypt y Certbot en instancia Balanceador AWS](#HTTPS-con-Lets-Encrypt-y-Certbot-en-instancia-Balanceador-AWS)
-    3.4. [Configuración Balanceador AWS](#Configuración-Balanceador-AWS)
-    3.5. [Repositorio GitHub, con SCP en AWS para instancias backend y MariaDB](#Repositorio-GitHub-con-SCP-en-AWS-para-instancias-backend-y-MariaDB)

4.0. [Puesta en marcha de nuestro Balanceador AWS](#Puesta-en-marcha-de-nuestro-Balanceador-AWS) 
-    4.1. [Configuración instancia server MariaDB AWS](#Configuración-instancia-server-MariaDB-AWS)
-    4.2. [Prueba definitiva Balanceador en AWS](#Prueba-definitiva-Balanceador-en-AWS)

## INTRODUCCIÓN PILA LEMP
Balanceador, prueba ping. 
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/4f846076-3689-46a9-91fb-d3c5b8fc3fbb)

Configuracion Balanceador.
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/a04ee319-25eb-45af-b54d-71d7e4959684)

reiniciamos el servidor. 

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/732ae7ef-c730-4409-b37d-1e684a7b31fa)

Estatus del mismo. 
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/d0eaf7c7-feaa-44e9-b633-23f3d7fb8de8)

---------------------------
--------------------------
tarjeta de red. 
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/764840b9-fe1e-4622-b6dc-532d344b993d)

Prueba de ping. 
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/64c27c1f-f367-459a-ae4d-762dbd2f5388)



ahora en nuestro servidor nginx1 copiamos el fichero default y le cambiamos el nombre por otro mas identificativo.

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/6c3b0d29-5a91-4c30-95a1-85cdf4f21168)

Una vez cambiado el nombre hacemos un enlace del mismo para habilitar la configuracion. 

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/21018ed8-ea50-4997-87eb-87de1fd64160)

Modificamos nuestro fichero y descomentamos las siguientes opciones. 
ademas deberemos de poner la ip de nuestro servidor NFS.
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/3dbcc94e-ec0f-4415-a4f2-65e454df4fd5)
Haremos el mismo proceso en nuestro nginx2.

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/5a02a9b4-dd0e-40d5-a400-7b71fb7450f9)

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/bbc9658e-f83d-4cb1-a178-6f2c536150fc)

Como vemos tenemos nuestra carpeta montada. 
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/f9dc2c17-694e-40db-b649-d8ac57bb60c5)

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/2da0275b-5ed5-4aff-87b5-b6136c89ec3f)


-------------------------
---------------------
ahora en nuestro NFS.
editamos nuestro servidor NFS.
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/9292aa60-7278-4c0d-935f-37bc289a26a6)


sudo mkdir -p /var/nfs/wordpress 

sudo service nfs-kernel-server restart

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/b8c9e541-c97b-4ebf-a4a1-666b079e4ef6)

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/d209f56a-98d7-482b-9580-df8637173cb5)

En mi caso he modificado el fichero dentro de wordpress llamado, sudo cp wp-config-sample.php wp-config.php

sudo chmod -R 755 wordpress/
sudo chown nobody:nogroup /var/nfs/wordpress/
sudo ufw allow from 192.168.3.10 to any port nfs
sudo ufw allow from 192.168.3.11 to any port nfs
sudo ufw allow from 192.168.3.12 to any port nfs
sudo nano wp-config.php
sudo apt install -y php-fpm
sudo apt install -y php-mysql
sudo nano /etc/php/7.3/fpm/pool.d/www.conf
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/fabfade6-3332-407b-8176-864d1ac2f996)

sudo apt install ufw
sudo ufw allow from 192.168.3.10 to any port nfs
sudo ufw allow from 192.168.3.11 to any port nfs
sudo ufw allow from 192.168.3.12 to any port nf

insertamos los datos de la bd que hemos creado. 
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/a7bd2318-a45d-4924-978c-d5d744bc12b1)

----------------------------
----------------------------
acceso a WordPress
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/c21e4a3b-621a-4a8e-a1d5-a06f041c5263)

TENEMOS QUE TENER EN CUENTA QUE VAGRANT TRATA LA HORA COMO UNA MENOS DESPUES DE LA PRUEBA. 
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/7baac47a-8fd7-44d1-b50a-b5f2c8037591)

AHORA NUESTRO BALANCEADOR. 
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/2778c8ea-d770-4325-a08d-d6a946f2019d)

AHORA NUESTRO NGINX1
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/75d6a442-ce5b-494a-9ef9-cdabe0ffd6fb)

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/02e50eda-1f5b-4e3b-82ff-22146464ac74)

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/c394da09-b8c1-4ad8-a751-42962c089ace)

BBDD MARIADB

