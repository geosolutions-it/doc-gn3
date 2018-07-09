.. _vm_setup:

################
VM configuration
################


=======================
VM Configuration params
=======================


------------------------------
Suggested system configuration
------------------------------

+-----------+----------------+----------------------+
|           | Recommended    | Prod                 |
|           | minimal config | (recommended config) |
+===========+================+======================+
| CPU       | 2 CPU / core   | 4-8 CPU / core       |
+-----------+----------------+----------------------+
| RAM       | 3 GB           | 8 GB                 |
+-----------+----------------+----------------------+
| Hard disk | 30GB           | 100GB - 1TB          |
+-----------+----------------+----------------------+

Provided VM is configured this way:

- 1 CPU with 2 cores
- RAM: 3GB
- Disk space: 30GB

This configuration is not enough for a minimal production environment,
adding more CPUs or cores is required.  


VM setup
--------

When creating a VM, you may not want to give VMWare all the information about the system. 
The reason behind this is because VMWare is smart enough to automatically handle some SO installation stages; this stages
will be skipped on the UI, and this will make the deployment procedure different than one performed on a real machine.
   

Setting up VMWare
'''''''''''''''''

Sample settings for creating a new VM:

- VM configuration: Custom
- HW compatibility: workstation 8 
- Install OS from: I will install the the operationg system later
- Guest OS: Linux Centos 64-bit
- VM name: *setup the name*
- Processors: 1 processor, 2 cores
- Memory: 6144MB
- Network connection: bridged

Then configure the disk as you need.
1
This is a sample configuration:

- I/O Controller type: LSI Logic
- Disk: create a new virtual disk
- Virtual disk type: SCSI
- Mode: Independent, persistent
- Max disk size: 30G, store virtual disk as a single file.

Then configure the DVD reader setting the ISO image of the OSinstaller, and start the VM. 


System Info recap
=================

Here a list of the information you are going to set up in your systems. 
You will need them when configuring the various applications.  


Host info
---------

- IP address: ___________________________
- Hostname:   ___________________________


System users
------------

+----------+----------+---------------------------------------------+
| Username | Password | Notes                                       |
+==========+==========+=============================================+
| root     |          | Set during OS installation                  |
+----------+----------+---------------------------------------------+
| tomcat   |          | Set up in section :ref:`create_user_tomcat` |
+----------+----------+---------------------------------------------+
|          |          |                                             |
+----------+----------+---------------------------------------------+
|          |          |                                             |
+----------+----------+---------------------------------------------+
|          |          |                                             |
+----------+----------+---------------------------------------------+

   
PostgreSQL users
----------------

+----------+--------------------------+-----------------------------+
| Username | Password . . . . . . . . | Notes                       |
+==========+==========================+=============================+
| geonet   |                          | Used for GeoNetwork main DB |
+----------+--------------------------+-----------------------------+
|          |                          |                             |
+----------+--------------------------+-----------------------------+
|          |                          |                             |
+----------+--------------------------+-----------------------------+
   
.. _vm_application_ports:   
   
Installed applications
----------------------

+------------+---------+------+------+------------+------+
| Name       | Command | HTTP | AJP  | context    | Note |
|            | port    | port | port |            |      |
+============+=========+======+======+============+======+
| GeoNetwork |         | 8080 |      | /geonetwork|      |
+------------+---------+------+------+------------+------+
|            |         |      |      |            |      |
+------------+---------+------+------+------------+------+
|            |         |      |      |            |      |
+------------+---------+------+------+------------+------+

