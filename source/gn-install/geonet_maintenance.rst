.. _geonetwork_maintenance:

###########
Maintenance
###########

.. _geonetwork_upgrade:

Upgrading GeoNetwork
====================

GeoNetwork updates will come in the form of new ``geonetwork.war`` files.

Usually upgrading to a new minor release is simply a matter of cleaning the Tomcat ``webapps/`` directory.

#. Stop Apache Tomcat
#. Backup your DB
#. Backup ``webapps/geonetwork/``, especially if you didn't externalize the data directory
#. Cleanup:
 
   - remove the file ``webapps/geonetwork.war``
   - remove the exploded ``webapps/geonetwork/`` directory.
   - In case you externalized the data dir, remove the Wro4j cache files (``<DATA_DIR>/wro4j-cache.h2.db``)
   
#. Copy the new ``geonetwork.war`` file in ``webapps``   
#. Run tomcat to expand the war file, or expand it by hand::
   
      cd webapps
      mkdir geonetwork
      cd geonetwork
      jar xf ../geonetwork.war

#. Repeat the changes for non-externalizable files, such as:

   - Enable INSPIRE view ( :ref:`gn_setup_inspire_view`)
   - Enable INSPIRE CSS ( :ref:`gn_setup_inspire_css`)
   - Update log file location ( :ref:`gn_setup_log_file_location`)

#. For non-externalized data dir, restore the data directory (``webapps/geonetwork/WEB-INF/data/``) 
   from the backup done in one of the first steps.
   
#. Restart Apache Tomcat
 

