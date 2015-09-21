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


Setup config file
-----------------

Some GeoNetwork internal configuration can be overridden by external definitions.

By setting the sytem property ``geonetwork.jeeves.configuration.overrides.file`` you can define an 
override file which will replace some default configuration with local ones. 

Create the override file:: 

   vim /var/lib/tomcat/geonetwork/gn/config-overrides.xml

and insert :download:`this content <resources/config-overrides.xml>`.

This file will also include two other files:

- :download:`geonetwork.properties <resources/geonetwork.properties>`
  A property file for redefining among the other things the DB connection.
  You will have to customize at least the DB credentials.
- :download:`config-db.xml <resources/config-db.xml>`
  A Spring configuration file to redefine the DB connections for both the GeoNetowrk DB and the spatial index.

Copy the linked files into ``/var/lib/tomcat/geonetwork/gn/`` and replace the requested info.
   

setenv.sh
---------

We have to set some system vars used by tomcat, by the JVM, and by the webapp itself.

Create the file ::

   vim /var/lib/tomcat/geonetwork/bin/setenv.sh

and insert :download:`this content <resources/setenv.sh>`.

   
Then make it executable::

   chmod +x /var/lib/tomcat/geonetwork/bin/setenv.sh


Setup JNDI
----------

TODO


Tomcat dir ownership
--------------------

Set the ownership of the ``geonetwork/`` related directories to user tomcat ::

   chown tomcat: -R /var/lib/tomcat/geonetwork
 




