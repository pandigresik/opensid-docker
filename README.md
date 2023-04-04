## OpenSID Docker

OpenSID adalah Sistem Informasi Desa (SID) yang sengaja dibuat supaya terbuka dan dapat dikembangkan bersama-sama oleh komunitas peduli SID. Lebih lengkap mengenai ini silakan menuju ke repo [OpenSID](https://github.com/OpenSID/OpenSID).

Repositori ini merupakan sekumpulan berkas pendukung jika Anda menginginkan melakukan instalasi OpenSID menggunakan Docker Container dan Docker Compose.

> **CATATAN**: Panduan yang lebih lengkap dapat dibaca di [Wiki OpenSID](https://github.com/OpenSID/OpenSID/wiki/Instalasi-OpenSID-dengan-Docker-Container)

Langkah Instalasinya adalah sebagai berikut: yang pertama, kita perlu clone repo OpenSID didalam folder repo ini.

```
git clone -b umum https://github.com/OpenSID/OpenSID.git opensid
cd opensid
```

sehingga kurang lebih susunan foldernya seperti dibawah ini

```
├── .docker
├── db_data
├── logs
├── opensid
├── .docker
├── docker-compose.yml
```

lakukan perubahan yang diperlukan pada berkas `docker-compose.yml`, misal Anda ingin mengubah password MySQL-nya, ganti `rahasia` dengan password yang lebih aman.

```bash
docker-compose up --build
```


Tunggu hingga sekitar 10-30 menit. Kecepatannya tentunya tergantung dari spesifikasi server Anda dan koneksi internet yang digunakan.

Buat database untuk aplikasi kita, kali ini saya gunakan command line untuk masuk ke instance mysql kita yang baru dimana kita set port expose ke 3307, karena 3306 sudah dipakai mysql bawaan OS

```bash
mysql -u opensid -h 127.0.01 -P 3307 -p
$ mysql -u opensid -h 127.0.0.1 -P 3307 -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 54
Server version: 5.5.5-10.3.38-MariaDB-1:10.3.38+maria~ubu2004 mariadb.org binary distribution

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create database opensid;
```
Jika sudah selesai anda bisa tekan Ctrl + D untuk keluar

Setelah selesai, silakan akses melalui browser di url http://localhost:8000, setelah itu aplikasi akan menampilkan error untuk meminta setting koneksi database;

pada file `desa/config/database.php`, sesuaikan konfigurasi database-nya dengan file yml tadi. Misalnya sebagai berikut

```php
$db['default']['hostname'] = 'db';
$db['default']['username'] = 'opensid';
$db['default']['password'] = 'rahasia';
$db['default']['database'] = 'opensid';
```

> **CATATAN**: db hostname harus ditulis sebagai `db`, jika tidak, aplikasi akan error karena tidak dapat terhubung dengan database. Kecuali Anda mengubah file `docker-compose.yml` pada bagian nama service db.

Selanjutnya eksekusi perintah berikut untuk mengubah permission folder aplikasi di dalam container.

```
docker-compose exec php chown -Rf www-data.www-data /public_html/storage
docker-compose exec php chown -Rf www-data.www-data /public_html/desa
docker-compose exec php chown -Rf www-data.www-data /public_html/backup_incremental
```

Setelah selesai, silakan akses kembali melalui browser di url http://localhost:8000
