.. _setup_gn_startup:

################################
Starting and stopping GeoNetwork
################################

Commands
========

Once GeoNetwork has been installed, you can start it with::

   systemctl start  tomcat@geonetwork

These are the commands for managing GeoNetwork as a service:

- ``systemctl start  tomcat@geonetwork``
- ``systemctl stop   tomcat@geonetwork``
- ``systemctl status tomcat@geonetwork``

Autostart
=========

Set GeoNetwork to autostart at boot time with this command::

   systemctl enable tomcat@geonetwork
