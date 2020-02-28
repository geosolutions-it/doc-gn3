.. _os_postgres_install:

=================================
Installing PostgreSQL and PostGIS
=================================

Install PostgreSQL
------------------

Update the packages list::

   dnf check-update
   
Install the package for configuring the PGDG repository::

   dnf install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
 
EPEL repository will provide GDAL packages::

   dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm


Force the system to use the postgresql repo for PG:

   dnf config-manager --set-enabled PowerTools
   dnf module disable postgresql

Install PostgreSQL, PostGIS and related libs::

   dnf install postgresql11-server postgresql11-devel postgresql11-contrib  postgis25_11

Verify::

   rpm -qa | grep postg | sort

   postgis25_11-2.5.3-8.rhel8.x86_64
   postgresql11-11.7-1PGDG.rhel8.x86_64
   postgresql11-contrib-11.7-1PGDG.rhel8.x86_64
   postgresql11-devel-11.7-1PGDG.rhel8.x86_64
   postgresql11-libs-11.7-1PGDG.rhel8.x86_64
   postgresql11-server-11.7-1PGDG.rhel8.x86_64

Init the DB::

   /usr/pgsql-11/bin/postgresql-11-setup initdb
   
Enable start on boot::

   systemctl enable postgresql-11
   
Start postgres service by hand::

   systemctl start postgresql-11
      
To restart or reload the instance, you can use the following commands::

   systemctl restart postgresql-11
   systemctl reload postgresql-11
  

Setting PostgreSQL access
-------------------------

Edit the file ``/var/lib/pgsql/11/data/pg_hba.conf`` so that the local connection entries
will change to::

  # "local" is for Unix domain socket connections only

  local   all             postgres                                peer
  local   all             all                                     md5

  # IPv4 local connections:

  host    all             postgres        127.0.0.1/32            ident
  host    all             all             127.0.0.1/32            md5

  # IPv6 local connections:
  host    all             postgres        ::1/128                 ident
  host    all             all             ::1/128                 md5


Once the configuration file has been edited, restart postgres::

   systemctl restart postgresql-11

   
