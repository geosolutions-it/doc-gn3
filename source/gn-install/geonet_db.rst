.. _geonetwork_create_db:

###########################
Create GeoNetwork databases
###########################

.. _geonetwork_internal_db:

Internal database
=================

GeoNetwork needs a DB for storing its internal data.

We will create a DB in PostgreSQL on the local machine.

If you plan to have GeoNetwork use an external DB, you can skip this section (:ref:`geonetwork_internal_db`); 
please **do** read next section anyway (:ref:`geonetwork_spatial_index_db`). 

As user ``root``, switch to user ``postgres``::

   su - postgres

Create a PostgreSQL DB for GeoNetwork::

   createuser -S -D -R -P -l geonetwork

Annotate the user password.   
   
Create the DB::
   
   createdb -O geonetwork geonetwork -E utf-8

Add the spatial extension to the ``geonetwork`` DB::

   psql geonetwork
   


.. _geonetwork_spatial_index_db:    

Spatial index
=============

GeoNetwork uses different index tecniques for indexing the metadata.
In particular, it uses `GeoTools datastores <http://docs.geotools.org/latest/userguide/library/data/datastore.html>`_
for creating spatial indices.

If you have a spatially enabled DBMS (such as PostGIS or Oracle Spatial) you may create a DB for
creating a datastore that will be used as a spatial index. If no DB is available, a shapefile will be created on the 
filesystem for storing the spatial info; this may be a proper solution for demo or small installations, but its performance
will decrease as the number of metadata in the catalog grows.

You have different options:

- if the internal database runs on a spatially enabled DBMS, you may use the very same DB for the spatial index, 
  since it will use different tables;
- you may create a brand new separate DB on a spatially enabled DBMS for the spatial index;
- you may skip the DB configuration and use a shapefile (even if this solution is not recommended).


When planning your DB architecture, please note that *the internal DB will need a periodic backup, while
the DB used for indices can be recreated on the fly*. 

Create a new DB
---------------

.. note:: This is an optional step, read the section above!

Create the DB that will contain the spatial index only.
As user ``root``, switch to user ``postgres``::

   su - postgres
   
and create the new DB ::   
   
   createdb -O geonetwork gn_spatial -E utf-8
   

Add the spatial extension
-------------------------

In order to add the spatial extension in your postgres DB you need to have superuser privileges on the DB. 
As user ``root``, switch to user ``postgres``::

   su - postgres

Then connect to the DB you will be using for the spatial indices, either 

- ``psql geonetwork`` 
  if you want to use a single DB for both data and indices 
- ``psql gn_spatial`` 
  if you want to use a DB for indices only

Then add the ``postgis`` extensions ::

   CREATE EXTENSION postgis;
   CREATE EXTENSION "postgis_topology";  
   GRANT ALL PRIVILEGES ON DATABASE geonetwork TO geonetwork;
   GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO geonetwork;


In a later section we'll tell GeoNetwork how to use these DBs.
