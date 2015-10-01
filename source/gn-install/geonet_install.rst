.. _install_gn:

###########################
Installing GeoNetwork 3.0.x
###########################

============
Introduction
============

In this document you'll only find specific information for installing GeoNetwork.

It is expected that the base system has already been properly installed and configured as described in :ref:`centos_setup`.

In such document there are information about how to install some required base components, such as 
PostgreSQL (:ref:`os_postgres_install`), Apache HTTPD (:ref:`os_httpd_install`), 
Java (:ref:`os_java_install`), Apache Tomcat (:ref:`os_tomcat_install`).

=====================
Installing GeoNetwork
=====================

.. hint::
   The GeoNetwork project page is at http://geonetwork-opensource.org/
      

Download packages
-----------------

Download the ``.war`` files needed for a full GeoNetwork installation::

   cd /root/download
   wget http://kent.dl.sourceforge.net/project/geonetwork/GeoNetwork_opensource/v3.0.2/geonetwork.war   

Setup tomcat base
-----------------

Create catalina base directory for MapStore::

   cp -a /var/lib/tomcat/base/       /var/lib/tomcat/geonetwork
   cp /root/download/geonetwork.war  /var/lib/tomcat/geonetwork/webapps/


Data dir
--------

GeoNetwork data dirs can be externalized. This means that GeoNetwork can be instructed to create 
such directories outside the webapp directory, so they will be maintained through the application 
upgrades.

We'll put the data in ``/var/lib/tomcat/geonetwork/gn/data``.
Create the directory hierarchy::

   cd /var/lib/tomcat/geonetwork/
   mkdir -p gn/data
   
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

Replacing and overriding may be quite complex, so here a recap of the configuration `flow`:

- In ``setenv.sh``: set the position of the ``config-overrides.xml`` file

  - In ``config-overrides.xml``:
  
    - Import the file containing Spring definitions of the database.
     
      You'll have to edit it to choose either postgres (``config-db-postgres.xml``) or oracle (``config-db-oracle.xml``).
      
      - In file ``config-db-*.xml``:
            
        - Load the property file ``geonetwork.properties``, which contains the property definitions used to connect to the DB, used in other internal XML files.
        - Define 3 Spring beans needed to setup the proper DBMS. 

    - Import the Spring definition of the datastore (``config-datastore.xml``). 
      If this file is not imported, a shapefile will be created for handling the spatial index.  
                        
    - Set the DMBS dialect according to the choosen DB. 


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

   vim /var/lib/tomcat/geonetwork/gn/config-overrides.xml

and insert :download:`this content <resources/config-overrides.xml>`.

You may want to **edit** the file and replace the ``import file`` and ``set bean`` elements to 
point to the Oracle settings.


Config file: ``config-db-*.xml``
________________________________

Either copy the content of 

- :download:`this file <resources/config-db-postgres.xml>` into ``/var/lib/tomcat/geonetwork/gn/config-db-postgres.xml``, or
- :download:`this file <resources/config-db-oracle.xml>` into ``/var/lib/tomcat/geonetwork/gn/config-db-oracle.xml``.

You may have both file in your directory, since only one will be imported by the ``config-overrides.xml`` file.      


Config file: ``geonetwork.properties``
______________________________________

Copy the content of :download:`this file <resources/geonetwork.properties>`
into ``/var/lib/tomcat/geonetwork/gn/geonetwork.properties``.

Here you can find the credentials for accessing the main DB, so you will have to 
**edit** this file to customize at least the DB credentials.

You may also need to change the value for the property ``jdbc.basic.validationQuery`` in case you will be using Oracle.


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
 




