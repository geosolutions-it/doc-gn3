.. _os_postgres_install:

=================================
Installing PostgreSQL and PostGIS
=================================

Install PostgreSQL
------------------

Update the packages list::

   yum check-update
   
Install the package for configuring the PGDG repository::

   yum install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
 
EPEL repository will provide GDAL packages::

   yum install https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm

Install PostgreSQL, PostGIS and related libs::

   yum install postgresql96 postgresql96-server postgis2_96 postgresql96-libs postgresql96-contrib postgresql96-devel gdal geos

Verify::

   rpm -qa | grep postg | sort

   postgis24_96-2.4.4-2.rhel7.x86_64
   postgresql96-9.6.9-1PGDG.rhel7.x86_64
   postgresql96-contrib-9.6.9-1PGDG.rhel7.x86_64
   postgresql96-devel-9.6.9-1PGDG.rhel7.x86_64
   postgresql96-libs-9.6.9-1PGDG.rhel7.x86_64
   postgresql96-server-9.6.9-1PGDG.rhel7.x86_64

Init the DB::

   /usr/pgsql-9.6/bin/postgresql96-setup initdb
   
Enable start on boot::

   systemctl enable postgresql-9.6.service
   
Start postgres service by hand::

   systemctl start postgresql-9.6.service
      
To restart or reload the instance, you can use the following commands::

   systemctl restart postgresql-9.6.service
   systemctl reload postgresql-9.6.service
  

Setting PostgreSQL access
-------------------------

Edit the file ``/var/lib/pgsql/9.6/data/pg_hba.conf`` so that the local connection entries 
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

   systemctl restart postgresql-9.6.service

   
