.. _setup_gn_startup:

################################
Starting and stopping GeoNetwork
################################

Commands
========

Once GeoNetwork has been isntalled, you can start it with::

   systemctl start  tomcat@geonetwork

These are the commands for starting and stopping GeoNetwork:

- ``systemctl start  tomcat@geonetwork``
- ``systemctl stop   tomcat@geonetwork``
- ``systemctl status tomcat@geonetwork``

Autostart
=========

The standard way for setting an autostarting service is::

   systemctl enable tomcat@geonetwork
   

On some distro it will not work (see https://bugzilla.redhat.com/show_bug.cgi?id=752774), so check if it really did its work.
If not, this commmand seems to do the work::

   ln -s /etc/systemd/system/tomcat\@.service  /lib/systemd/system/multi-user.target.wants/tomcat\@geonetwork.service

      