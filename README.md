## <p align="center">Índice</p> 
### <p align="right">Joaquín Blanco Contreras, Curso: ASIR2</p>

1.0. [INTRODUCCIÓN PILA LEMP](#INTRODUCCIÓN-PILA-LEMP)
-    1.1. [ESCENARIO DE LA PRÁCTICA](#Escenario-de-la-práctica)
-    1.2. [CONFIGURACIÓN BALANCEADOR](#CONFIGURACIÓN-BALANCEADOR)
-    1.3. [CONFIGURACIÓN BACKEND NGINX](#CONFIGURACIÓN-BACKEND-NGINX)
-    1.4. [CONFIGURACIÓN SERVIDOR NFS](#CONFIGURACIÓN-SERVIDOR-NFS)
-    1.5. [CONFIGURACIÓN SERVIDOR MARIADB](#CONFIGURACIÓN-SERVIDOR-MARIADB)

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

Una pila "LEMP" es un conjunto de software de código abierto que se instala comúnmente juntos para habilitar un servidor para alojar sitios web y aplicaciones web. La palabra "LEMP" es un acrónimo que representa el primer letra de cada uno de los siguientes componentes:

Linux: El sistema operativo subyacente. Linux es un sistema operativo gratuito y de código abierto que es ampliamente utilizado para servidores y sistemas integrados.
EngineX (se pronuncia "engine-x" y se abrevia como "NGINX"): Es el servidor web utilizado en la pila. NGINX es conocido por su alto rendimiento, estabilidad, rica configuración de características, simple arquitectura y bajo uso de recursos.
MySQL/MariaDB: El sistema de gestión de base de datos. MySQL es el sistema de base de datos relacional más popular, pero muchos usuarios de LEMP optan por MariaDB, un fork de MySQL que es completamente compatible con MySQL pero es de código abierto.
PHP: El lenguaje de programación del lado del servidor. PHP es un lenguaje de programación popular para el desarrollo web que puede incrustarse directamente en el HTML.
Este conjunto de software proporciona una base sólida para servir aplicaciones web dinámicas. NGINX actúa como el servidor web que maneja las solicitudes HTTP y puede servir archivos estáticos y pasar solicitudes dinámicas a PHP, que a su vez puede utilizar MySQL o MariaDB para gestionar datos. Linux, siendo el sistema operativo, maneja todas las interacciones con el hardware y proporciona la plataforma sobre la cual corren todos los demás componentes.

La pila LEMP es una alternativa a la pila LAMP, donde Apache es el servidor web en lugar de NGINX.

## ESCENARIO DE LA PRÁCTICA


## CONFIGURACIÓN BALANCEADOR

## CONFIGURACIÓN BACKEND NGINX

## CONFIGURACIÓN SERVIDOR NFS

## CONFIGURACIÓN SERVIDOR MARIADB




En nuestro balanceador borraremos las zonas sites-enabled y configuraremos un nuevo fichero con un enlace simbolico ubicado en sites-available que ira a al directorio /etc/nginx/sites-enabled 
Borramos este enlace y habilitamos el nuestro. 

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/004888dc-33b3-4551-8199-c735c855dbde)

ahora copiamos el fichero default y le cambiamos el nombre por "Balanceador" asi nos será mucho mas identificativo.

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/59022ec8-6b1f-4a80-9dff-103b6b17819e)

ahora nos iremos a la ruta /etc/nginx/sites-enabled, veremos el fichero "Balanceador", pero esa configuración que viene por defecto en el fichero no nos servirá por lo que tendremos que escribir esta otra. 

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/b7f117fe-643e-4aa2-ba90-4496ecbb0845)

    upstream backend_servidores {
    server 192.168.3.10; # nginx1
    server 192.168.3.11; # nginx2
    }
    
    server {
    listen 80;
    server_name nginxm_balanceador_backend;

    location / {
        proxy_redirect off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_pass http://backend_servidores;
      }
    }

Servidor NFS

creamos la ruta mkdir -p /var/nfs/wordpress

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/71883044-c8cf-41da-a94c-53bb9cb39cc2)

Una vez creada la ruta nos vamos a nuestro fichero sudo nano /etc/export

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/6cb0d735-a7ea-439a-8f00-33e18ed6d34c)


    /var/nfs/wordpress 192.168.3.10(rw,sync,no_subtree_check) 192.168.3.11(rw,sync,no_subtree_check)

Recordemos descargar worpress en nuestra ruta, /var/nfs

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/8d2163d5-a4a2-4481-9407-395d023a4089)

Despues de tenerlo descargado hacemos lo siguiente, recordemos que tenemos una carpeta llamada "wordpress" pues la eliminamos y descomprimimos el .tar que tenemos descargado. 

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/bc37b292-1db5-44cd-b18e-9860cb6101b8)

El archivo descomprimido nos dara la carpeta perteneciente a wordpress. 
borramos el archivo descargado y nos quedamos con nuestra carpeta que es la que nos interesa. 

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/21ec6133-5540-43f5-9ebc-710e8b88dbb8)

Ahora nos vamos al fichero de la ruta /etc/

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/21ec6133-5540-43f5-9ebc-710e8b88dbb8)

VAGRANT STATUS
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/302d2c06-7138-4a0b-9807-8010a7b7f344)


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
una vez editemos descarguemos el worpress y borremos la carpeta y la volvamos a crear tendremos que ejecutar este comando. 
sudo exportfs -ra

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/9292aa60-7278-4c0d-935f-37bc289a26a6)

ahora lo recomendable despues de instalar wordpress seria cambiar de nombre de nuestro fichero de configuracion para que sea mas identificativo para nosotros

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/bf87d97a-8bb9-4e21-b62b-e18c595bcf66)

sudo mkdir -p /var/nfs/wordpress 

sudo service nfs-kernel-server restart

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/b8c9e541-c97b-4ebf-a4a1-666b079e4ef6)

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/d209f56a-98d7-482b-9580-df8637173cb5)

En mi caso he modificado el fichero dentro de wordpress llamado, sudo mv wp-config-sample.php wp-config.php

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

Tenemos que crear nuestro directorio para despues montarlo. 
sudo mount 192.168.3.12:/var/nfs/wordpress /var/nfs/wordpress

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/6a290956-5061-4d97-9c14-7d4f60303bff)

ahora habilitaremos las siguientes normas en nuestros servidores backend. 
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/4c01bd99-b418-49bc-a6b9-afb28e72ed40)



BBDD MARIADB

ahora creamos la base de datos . 

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/98b1d633-b931-430b-b80b-fea733564c0d)

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/404c2ddb-2d4f-4b30-81aa-78447e457187)

edito los privilegios porque me confundi 
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/c104548a-e9ba-4e2a-ba14-ce81dfa9237b)


