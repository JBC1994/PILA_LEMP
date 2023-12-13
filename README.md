## <p align="center">Índice</p> 
### <p align="right">Joaquín Blanco Contreras, Curso: ASIR2</p>

1.0. [INTRODUCCIÓN PILA LEMP](#INTRODUCCIÓN-PILA-LEMP)
-    1.1. [ESCENARIO DE LA PRÁCTICA](#Escenario-de-la-práctica)
-    1.2. [CONFIGURACIÓN BALANCEADOR](#CONFIGURACIÓN-BALANCEADOR)
-    1.3. [CONFIGURACIÓN BACKEND NGINX](#CONFIGURACIÓN-BACKEND-NGINX)
-    1.4. [CONFIGURACIÓN SERVIDOR NFS](#CONFIGURACIÓN-SERVIDOR-NFS)
-    1.5. [MONTAJE DE CARPETA NFS A BACKEND](MONTAJE-DE-CARPETAS-NFS-A-BACKEND)
-    1.5. [CONFIGURACIÓN SERVIDOR MARIADB](#CONFIGURACIÓN-SERVIDOR-MARIADB)

2.0. [CONEXIÓN REMOTA A NUESTRA BBDD DESDE BACKEND NGINX](#CONEXIÓN-REMOTA-A-NUESTRA-BBDD-DESDE-BACKEND-NGINX)
-    2.1. [COMPROBACIÓN DE VOLUMENES INSTALADOS EN BACKEND](#COMPROBACIÓN-DE-VOLUMENES-INSTALADOS-EN-BACKEND)
-    2.2. [PUESTA EN MARCHA PILA LEMP](#PUESTA-EN-MARCHA-PRUEBA-LEMP)
-    2.3. [PRUEBA DE LOG CON NUESTROS SERVIDORES BACKEND](#PRUEBA-DE-LOG-CON-NUESTROS-SERVIDORES-BACKEND)
-    2.4. [VAGRANT STATUS](#VAGRANT-STATUS)


## INTRODUCCIÓN PILA LEMP

Una pila "LEMP" es un conjunto de software de código abierto que se instala comúnmente juntos para habilitar un servidor para alojar sitios web y aplicaciones web. La palabra "LEMP" es un acrónimo que representa la primera letra de cada uno de los siguientes componentes:

Linux: El sistema operativo subyacente. Linux es un sistema operativo gratuito y de código abierto que es ampliamente utilizado para servidores y sistemas integrados.
EngineX (se pronuncia "engine-x" y se abrevia como "NGINX"): Es el servidor web utilizado en la pila. NGINX es conocido por su alto rendimiento, estabilidad, rica configuración de características, simple arquitectura y bajo uso de recursos.
MySQL/MariaDB: El sistema de gestión de base de datos. MySQL es el sistema de base de datos relacional más popular, pero muchos usuarios de LEMP optan por MariaDB, un fork de MySQL que es completamente compatible con MySQL pero es de código abierto.
PHP: El lenguaje de programación del lado del servidor. PHP es un lenguaje de programación popular para el desarrollo web que puede incrustarse directamente en el HTML.
Este conjunto de software proporciona una base sólida para servir aplicaciones web dinámicas. NGINX actúa como el servidor web que maneja las solicitudes HTTP y puede servir archivos estáticos y pasar solicitudes dinámicas a PHP, que a su vez puede utilizar MySQL o MariaDB para gestionar datos. Linux, siendo el sistema operativo, maneja todas las interacciones con el hardware y proporciona la plataforma sobre la cual corren todos los demás componentes.

La pila LEMP es una alternativa a la pila LAMP, donde Apache es el servidor web en lugar de NGINX.

## ESCENARIO DE LA PRÁCTICA

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/9937737f-05b6-4e6e-a4ce-d1873baaa0ef)


Nos encontraremos con lo siguiente:

        Maquina balanceador con IP: 192.168.3.5
        Maquina NGINX1 con IP: 192.168.3.10 - 172.16.1.10
        Maquina NGINX2 con IP: 192.168.3.11 - 172.16.1.11
        Maquina NFS con IP: 192.168.3.12 - 172.16.1.12
        Maquina MARIADB con IP: 172.16.1.5

Nuestro servidor Balanceador si podrá tener acceso a internet y si podrá conectarse a nuestras maquinas backend, pero NO a nuestro servidor MariaDB.
Nuestros host backend, si podrán tener conexión con el servidor MariaDB, servidor nfs y balanceador, pero NO pueden tener internet.
Nuestro servidor NFS estará configurado de igual forma que nuestros backend.
Nuestro servidor MariaDB si podrán conectarse a los servidores backend, pero NO tendrá acceso a internet ni tampoco al servidor balanceador.

## CONFIGURACIÓN BALANCEADOR

En este apartado empezaremos configurando nuestro balanceador. Parto de la base que después de ejecutar nuestro maravilloso script de aprovisionamiento tenemos instalado el servidor NGINX el cual nos permitirá que está máquina se convierta en un balanceador. 

Para ello haremos lo siguiente, nos iremos a nuestro directorio **/etc/nginx/sites-available/default** , una vez ahí haremos un cp del fichero original llamado "default" y le cambiaremos el nombre por uno mas identificativo, en este caso "Balanceador".

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/feeab358-0fae-4977-a85e-c53dda0f324b)

Bien, una vez hecho esto tendremos que entender que nuestro servidor **nginx** solo recogerá los ficheros en sitios habilitados a través de un enlace, a diferencia de nuestro conocido **"apache2"** que se hacía con **a2enable**.

Lo primero que crearemos será un enlace del fichero **"Balanceador"** y que este apunte a la ruta **/etc/nginx/sitex-available /etc/nginx/sites-enabled**
Para ello ejecutaremos el siguiente comando. 

    COMANDO: sudo ln -s /etc/nginx/sites-available/Balanceador /etc/nginx/sites-enabled/ 
    Lo que estamos haciendo es crear un enlace simbólico que apunte desde nuestro directorio "Sites-available" a "sites-enabled".

Bien, una vez hecho este paso, haremos lo siguiente, nos iremos a la ruta de **/etc/nginx/sites-enabled**, ahí veremos fichero habilitado, pero... no servirá con esto, deberemos borrar el enlace anterior, en este caso el fichero **"default"** por defecto. 

    sudo rm -r default

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/798a9df6-53ec-4508-8780-5538b0b75f9c)

Como vemos, después de haber borrado el anterior, nos quedaríamos con este ya activo, de hecho cambia de color, y si hacemos un **ls -l** apreciamos la ruta de donde hace referencia.

¿Hasta aqui bien no?

Ahora deberemos de configurar nuestro servidor, para ello, editaremos nuestro fichero "Balanceador" y borraremos todo su interior. 
Una vez borrado su interior, copiaremos lo siguiente:

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

De tal manera, que su resultado será el siguiente: 

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/77e96065-7c21-42fb-a10b-be82cd9a9848)

Bueno, pues hasta aquí podemos decir que hemos terminado la configuración de nuestro Balanceador. 
Antes que nada, ejecutaremos el comando:

    sudo systemctl restart nginx

## CONFIGURACIÓN BACKEND NGINX

Como hemos comentado en el apartado anterior, teniendo en cuenta que nuestro script de aprovisionamiento se instalaron correctamente. 
Esta máquina contendrá los siguientes servicios instalados.

    servidor nginx
    servidor mariadb-client
    install nfs-common
    --------------------------
    --------------------------
    COMANDOS QUE UTILIZAREMOS.
    sudo systemctl restart nginx
    sudo systemctl restart mariadb.service
    sudo systemctl restart php7.4-fpm
    sudo mount

Para configurar nuestro servidor de backend Nginx, haremos lo siguiente, nos iremos a la siguiente ruta: **/etc/nginx/sites-available**.
Una vez aquí haremos lo siguiente, editaremos el fichero **"default"** y tan solo modificaremos estas líneas.

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/d86d9d7c-79ab-4953-bcca-8fad7a43458c)

Vemos como he puesto la ruta **"root /var/nfs/wordpress"** Esto esto es así porque ahí será donde nuestro servidor nginx backend hará la petición al sitio web, que a su vez se hará una carpeta montada en nuestro servidor **"NFS"** .
También crearemos nuestra carpeta para que el montaje sea exitoso.

    sudo mkdir -p /var/nfs/wordpress

Hago bastante hincapié en que tengáis cuidado con esta linea, tendreis que añadir manualmente la palabra **index.php**.

    # Add index.php to the list if you are using PHP
        index index.html index.php index.htm index.nginx-debian.html;

También tendremos que tener en cuenta que esa ip que ponemos ahi hace referencia al servidor NFS desde el cual se hará la petición.

Bien, una vez hecho todo esto, el siguiente paso será hacer exactamente lo mismo, pero en nuestro otro servidor backend.
Una vez hecho este paso, reiniciamos el servicio.

    sudo systemctl restart nginx
    sudo systemctl restart php7.3-fpm

## CONFIGURACIÓN SERVIDOR NFS

En este apartado teniendo en cuenta que nuestros scripts de aprovisionamiento han hecho bien su trabajo, haremos lo siguiente.

Nos iremos a nuestra ruta **/var/nfs/**, Descargaremos ahi nuestro CMS, en este caso con sudo wget.

    wget https://wordpress.org/latest.tar.gz
    
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/2bcb0729-fbf5-4f7d-9098-a1c24d74af5d)

Una vez realizada la descarga tendremos que descomprimir el archivo de la siguiente manera.

    sudo tar -xzvf latest.tar.gz

Nos debería de quedar algo así.

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/6826fad8-3597-48c5-bef8-3584c24ad38a)

Ahora nos meteremos dentro de la carpeta de wordpress y buscaremos el fichero **wp-config-example.php.**
Lo recomendable seria darle un nombre mas orientativo, en este caso me decanté por:

    mv wp-config-sample.php wp-config.php

Editamos el fichero y añadimos lo siguiente, en mi caso:

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/d8af1996-b812-45f3-af66-2244cdaa884b)


Pongo estos datos porque son con los que trabajaré el resto de práctica, veremos mas adelante como configuramos nuestro usuario y creamos la BBDD en la maquina MariaDB server.

Bien, una vez tengamos este paso, nos tendremos que ir a la siguiente ruta.

    sudo nano /etc/exports

Este sitio será donde nuestro servidor NFS montará nuestra carpeta en los servidores de backend, deberemos de indicarles las IP según corresponda. 

    /var/nfs/wordpress 192.168.3.10(rw,sync,no_subtree_check) 192.168.3.11(rw,sync,no_subtree_check)
    
![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/064d2d93-54b5-4bbb-83d9-fe1e311fc318)

Hecho este paso, tendremos que irnos al siguiente directorio y editar su fichero de configuración.

    sudo nano /etc/php/7.3/fpm/pool.d/www.conf

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/9965b65c-1595-494d-8b87-bb5b2046c52e)

Deberemos de poner la IP de nuestro servidor NFS.
Una vez terminado ejecutaremos el siguiente comando para actualizar los volúmenes montados en caso de que surgiese algún problema.
    
    sudo exportfs -ra
    sudo systemctl restart php7.3-fpm
    sudo systemctl restart nfs-server


## MONTAJE DE CARPETA NFS A BACKEND

Bien, teniendo en cuenta que nuestro servidor NFS ahora mismo ya tiene montado el volumen haremos lo siguiente. Nos iremos a nuestros servidores de backend y haremos lo siguiente.

    sudo mount 192.168.3.12:/var/nfs/wordpress /var/nfs/wordpress

    Lo que estamos haciendo aquí es que estamos montado el directorio de nuestro servidor backend que habíamos hecho 
    en el paso anterior, en la carpeta que nuestro script de aprovisionamiento 
    creo cuando se incio la maquina, que esta en /var/nfs/wordpress .

Ahora si hacemos un ls -l de nuestro directorio /var/nfs/wordpress, nos encontraremos con la carpeta del servidor NFS montada. 

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/4c1b9189-5d64-4d81-825f-a7f02a730c28)

## CONFIGURACIÓN SERVIDOR MARIADB

Nos iremos a nuestro servidor MariaDB, y ahí nos iremos a la siguiente ruta. 

    sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf

Una vez ahí modificaremos la IP y pondremos que solo escuche solicitudes desde su red. 

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/76d5e6e2-1b8f-4b66-a7bc-c1fd5c5dc924)

Ahora empezaremos a crear la BBDD para nuestro wordpress, para ello nos logueamos como root.

    sudo mysql -u root;

    CREATE DATABASE wordpress_db;
    CREATE USER 'joaquin'@'172.16.1.%' IDENTIFIED BY 'joaquinpass';
    GRANT ALL PRIVILEGES ON wordpress_db.* TO 'joaquin'@'172.16.1.%';
    FLUSH PRIVILEGES;

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/a10b6ffb-e7e7-4018-b548-9a9bac86bbe5)

    Después de todo esto, reiniciaremos el servicio de mariadb.
    sudo systemctl restart mariadb

Bien, hasta aquí, ¿todo correcto no? lo recomendable seria ir a nuestro cliente backend nginx y hacer una prueba de conexión remota para certificar que si conecta correctamente con la BBDD.


## CONEXIÓN REMOTA A NUESTRA BBDD DESDE BACKEND NGINX

Bien, como hemos comentado en el apartado anterior, antes de probar nada lo correcto sería ver si verdaderamente nuestro servidor nginx puede conectarse remotamente a nuestro servidor de BBDD. Para ello haremos lo siguiente.

    sudo mysql -u joaquin -p -h 172.16.1.5;

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/cd14aca2-a788-41bd-a38a-2aa8ddb4b2ad)

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/8d9e16c5-2cd0-4f0c-802d-b83c02d505c3)


## COMPROBACIÓN DE VOLÚMENES INSTALADOS EN BACKEND

        comando df -h

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/517a6fd1-c475-4f3e-b92a-08709f682002)

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/7a47f3a0-9799-4d68-828f-40123bb2815b)


## PUESTA EN MARCHA PILA LEMP 

En este apartado tendremos que tener en cuenta que si todo lo anterior lo hemos hecho correctamente, está práctica no tendrá inconveniente ninguno en su funcionamiento. 

Para ello lo primero que tendremos que hacer será irnos a nuestro navegador web (recomiendo ejecutar con "pestaña privada" para ahorrarnos problemas).

Introduciremos la siguiente dirección: **http://localhost:9000/wp-admin/install.php**

Si todo ha salido correctamente, debería de salirnos esta ventana, en caso de que no os saliera nada os recomendaría que observarais muy bien el error y os vayais a vuestros ficheros error.log , ya que muchas veces suelen ser problemas de sintaxis o que no hemos reiniciado los servicios correctamente...

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/2fc37959-2a8f-4bb7-85c3-5b3df675cae6)

El resultado ha sido un éxito!! 

Ahora no es más que instalar nuestro wordpress. Para ello lo personalizaremos a nuestra manera y le daremos al botón de la esquina inferior que pone **"install wordpress"**

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/b9d58d06-a285-4f13-8bd0-d0c8f7f783a4)


![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/19e98852-67f9-4208-a4c4-cfefa9a5294e)


## PRUEBA DE LOG CON NUESTROS SERVIDORES BACKEND

En este apartado veremos las conexiones que hemos tenido con el siguiente comando. 

        tail /var/log/nginx/access.log

NGINX BAKEND1

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/e392d88a-272d-468e-8f10-54a56543f07a)

NGINX BAKEND2

![image](https://github.com/JBC1994/PILA_LEMP/assets/120668110/84adcd7b-b54c-4691-8188-ef665a3d0021)

## VAGRANT STATUS

![image](https://github.com/JBC1994/PRACTICA_PILA_LEMP_JOAQUIN_BLANCO_CONTRERAS/assets/120668110/a16b65a1-84f1-4bda-b1a7-da62f4ada180)

VIDEO: https://www.youtube.com/watch?v=dEOnv9bB7z0
