.. _install_gn:

###########################
Installing GeoNetwork 3.4.2
###########################

============
Introduction
============

In this document you'll only find specific information for installing GeoNetwork.

It is expected that the base system has already been properly installed and configured as described in :ref:`centos_setup`.

In such document there are information about how to install some required base components, such as 

- PostgreSQL (:ref:`os_postgres_install`), 
- Apache HTTPD (:ref:`os_httpd_install`), 
- Java (:ref:`os_java_install`), 
- Apache Tomcat (:ref:`os_tomcat_install`).

=====================
Installing GeoNetwork
=====================

.. hint::
   The GeoNetwork project page is at http://geonetwork-opensource.org/
      

Download packages
-----------------

Download the ``.war`` files needed for a full GeoNetwork installation, for instance::

   cd /root/download
   wget https://kent.dl.sourceforge.net/project/geonetwork/GeoNetwork_opensource/v3.4.2/geonetwork.war

.. hint::
   This is only one of the available mirrors; choose on SourceForge the mirror nearest to you.


.. hint::
   You may find other userful custom builds at http://demo.geo-solutions.it/share/geonetwork
     

Setup tomcat base
-----------------

Create catalina base directory for GeoNetwork::

   cp -a /var/lib/tomcat/base/       /var/lib/tomcat/geonetwork
   cp /root/download/geonetwork.war  /var/lib/tomcat/geonetwork/webapps/


Data dir
--------

GeoNetwork data dirs can be externalized. This means that GeoNetwork can be instructed to create 
such directories outside the webapp directory, so they will be maintained through the application 
upgrades.

We'll put the data in ``/var/lib/tomcat/geonetwork/gn/data`` and the 
custom configurations in ``/var/lib/tomcat/geonetwork/gn/conf``.

Create the directory hierarchy::

   cd /var/lib/tomcat/geonetwork/
   mkdir -p gn/data
   mkdir -p gn/conf
   
By setting the sytem property ``geonetwork.dir`` we'll tell 
GeoNetwork to use such directory to store its data.


Setup config files
------------------

Some GeoNetwork internal configuration can be overridden by external definitions.

By setting the system property ``geonetwork.jeeves.configuration.overrides.file`` you can define an 
override file which will replace some default configuration with local ones.
We'll set  this property in the ``setenv.sh`` file (see next subsection).

In the override file you can:

- set internal properties,
- import Spring config files into the configuration,
- replace Spring property values in declared beans,
- replace pieces of Geonetwork XML configuration files.

Here a recap of the configuration `flow`:

- In ``setenv.sh``: set the position of the ``config-overrides.xml`` file

  - In ``config-overrides.xml``:
  
    - Set the properties related to the DB connection parameters.
    - Import the Spring definition of the datastore (``config-datastore.xml``). 
      If this file is not imported, a shapefile will be created for handling the spatial index.  


Config file: ``setenv.sh``
__________________________

We have to set some system vars used by tomcat, by the JVM, and by the webapp itself.

Create the file ::

   vim /var/lib/tomcat/geonetwork/bin/setenv.sh

and insert :download:`this content <resources/setenv.sh>`.

Then make it executable::

   chmod +x /var/lib/tomcat/geonetwork/bin/setenv.sh


Config file: ``config-overrides.xml``
_____________________________________

Create the override file:: 

   vim /var/lib/tomcat/geonetwork/gn/conf/config-overrides.xml

You need different content in the override file for the different DBMS.

H2
..

This is the content of the override file to setup the H2 db.

Note that using H2 you can configure the path where H2 will store the files containing the DB data.
By default the DB files will be create in the current directory at the time of the startup of GeoNetwork.
You can define the path in the JDBC URL.
 
::

   <overrides>
      <spring>
          <set bean="jdbcDataSource" property="Url" value="jdbc:h2:/PATH/TO/THE/DB/FILE"/>
          <set bean="jdbcDataSource" property="username" value="admin"/>
          <set bean="jdbcDataSource" property="password" value="gnos"/>
      </spring>
   </overrides>

PostgreSQL
..........

This is the content of the override file to setup a PG db::

   <overrides>
      <spring>
         <set bean="jpaVendorAdapter" property="database" value="POSTGRESQL"/>
         <set bean="jdbcDataSource" property="driverClassName" value="org.postgresql.Driver"/>
         <set bean="jdbcDataSource" property="Url" value="jdbc:postgresql://localhost:5432/gn3"/>
         <set bean="jdbcDataSource" property="username" value="gn3"/>
         <set bean="jdbcDataSource" property="password" value="gn3"/>
      </spring>
   </overrides>
 

Oracle
......

This is the content of the override file to setup an Oracle db.

Please note that when GeoNetwork is installed the first time, it will insert some initial data in the DB.
This procedure will use lots of resources, so you'll need to set the properties ``poolPreparedStatements``
and ``maxOpenPreparedStatements`` as indicated below, or you'll get a "Too many cursor" error. 
Once the installation has completed, you can safely remove those settings.

Also remember to install the Oracle JDBC ``.jar`` file in the tomcat ``lib/`` directory. Since this file is not redistributable
according to Oracle policies, you'll have to download it on your own, accepting Oracle's license.

::

   <overrides>
      <spring>
         <set bean="jpaVendorAdapter" property="database" value="ORACLE"/>
       
          <set bean="jdbcDataSource" property="driverClassName" value="oracle.jdbc.driver.OracleDriver"/>
          <set bean="jdbcDataSource" property="Url" value="jdbc:oracle:thin:@//10.10.100.77:1521/ORCL"/>
          <set bean="jdbcDataSource" property="username" value="gnora"/>
          <set bean="jdbcDataSource" property="password" value="gnora"/>       
          <set bean="jdbcDataSource" property="validationQuery" value="SELECT 1 FROM DUAL"/>  

          <!-- only when installing the first time -->             
          <set bean="jdbcDataSource" property="poolPreparedStatements" value="false"/>  
          <set bean="jdbcDataSource" property="maxOpenPreparedStatements" value="-1"/>  
      </spring>
   </overrides>


Config file: ``config-datastore.xml``
_____________________________________

Copy the content of :download:`this file <resources/config-datastore.xml>`
into ``/var/lib/tomcat/geonetwork/gn/config-datastore.xml``.

This file will configure the database for the spatial index.
By default it will use the same information and credentials used for the default PostgreSQL database, 
(which means it should be spatially enabled).  

If you need to use another database (maybe on Oracle), you need to **edit** this file.


Setup JNDI
----------

JNDI should allow you to configure the databases at the container level, so that you won't need to
set any credentials in GeoNetwork configuration files. It should work both for the internal database and the 
db for the spatial index. 

*(More will be added here once we test the JNDI configuration and prepare the sample files.)*


Tomcat dir ownership
--------------------

Set the ownership of the ``geonetwork/`` related directories to user tomcat ::

   chown tomcat: -R /var/lib/tomcat/geonetwork
 




