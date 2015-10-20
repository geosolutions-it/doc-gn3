.. _geonet_setup_http:

##########################
Setting up Apache HTTPd
##########################

httpd configuration
===================
   
As ``root``, create the file ``/etc/httpd/conf.d/80-geonetwork.conf`` and insert these lines::

   ProxyPass        /geonetwork   ajp://localhost:8009/geonetwork                                                                                                                                                                                                                           
   ProxyPassReverse /geonetwork   ajp://localhost:8009/geonetwork

Then make httpd reload the configuration::

   service httpd reload
