.. _geonetwork_create_db:

####################
Create GeoNetwork DB
####################

As user ``root``, switch to user ``postgres``::

   su - postgres

Create a PostgreSQL DB for GeoNetwork::

   createuser -S -D -R -P -l geonetwork

Annotate the user password.   
   
Create the DB::
   
   createdb -O geonetwork geonetwork -E utf-8

Add the spatial extension to the ``geonetwork`` DB::

   psql geonetwork
   
   geonetwork=# CREATE EXTENSION postgis;
   geonetwork=# CREATE EXTENSION "postgis_topology";  
   geonetwork=# GRANT ALL PRIVILEGES ON DATABASE geonetwork TO geonetwork;
   geonetwork=# GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO geonetwork;
    
