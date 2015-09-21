======================
GeoNetwork final setup
======================

Once GeoNetwork is up and running, you have to perform some other steps using the web interface.

Login as ``admin`` / ``admin``.

Change the admin pw
-------------------

Go to "Administration" >  "Users and groups" >  "Change password".
Change and annotate the new password.

Check the system configuration
------------------------------

Go to "Administration" >  "Catalogue settings" >  "System configuration".

Check if the right values are set in these fields:

* Site name
* Site organization
* Host
* Port (you may want to put ``80`` here) 

You then may want to:

* Disable Z39.50 server
* Enable search statistics
* Enable **INSPIRE**
* Enable **INSPIRE** view
* Setup the CSW server info

Default language
----------------

**TODO**

The only way to change de default UI language is to edit the index.html file::

   vim webapps/geonetwork/index.html
   
The default language is set as a 3 letters ISO code in this line::
   
   window.location="srv/eng/home" + search;
   
so you may for instance change the string to ``srv/ita/home`` to have Italian as default language. 

=========================
Installing schema plugins
=========================

**TODO**


You may want to add additional schemas to GeoNetwork.

For instance let's add the RNDT profile.

You need the zip file containing the definition of the schema, or a URL pointing to such file.

Go to "Administration" >  "Metadata & Template" >  "Add a metadata schema/profile".

Set as schema name ``iso19139.rndt``

Then check the "URL of Schema Zip Archive" option, and set ``http://84.33.2.27/download/iso19139.rndt.zip``.

Then press the "Add" button.

Now in "Administration" you can "Add templates" and "Add sample metadata" for the new schema.

============
Known issues
============

**TODO**


==============
Other settings
==============

Log file location
-----------------

**TODO**


GeoNetwork log setting are set to create the log files into ``CURRENT_DIRECTORY/logs/geonetwork.log``.
It means that, running GeoNetowrk with the configuration explained in this document, you'll get the log files into
``/home/tomcat/logs/geonetwork.log``.  

If you wish to customize the log location, you'll have to edit the file ``WEB-INF/log4j.cfg``. 

You may want to path the log4j configuration file before running the GeoNetowrk service hte first time, in order 
not to have temp log files places in unwanted places. 

- Expand the war file ::

   cd /var/lib/tomcat/geonetwork/webapps/
   mkdir geonetwork
   cd geonetwork
   jar xvf /root/geonetwork-main-2.10.xxxxx.war

Edit the file ``WEB-INF/log4j.cfg``, setting the property ``log4j.appender.jeeves.file`` as follows::

   log4j.appender.jeeves.file = ${catalina.base}/logs/geonetwork.log

Make sure you have the ``${catalina.base}`` part. In this way, the logfile should be created in the direcotry   
 ``/var/lib/tomcat/geonetwork/logs/``.


.. _gn_web_config:


Logo
----

**TODO**

You may customize the site logo in the administration page. 

In the option group "Catalog configuration" select "Logo configuration".
Upload the image you wish to use as the site logo. Once loaded, select it and click on "Use for this catalog".

Note: 
In previous GeoNetowrk releases you had to use the non-interactive procedure:
You had to identify the site UUID (in the info page -- "Info" link on hte toolbar). 
Then you had to copy the ``gif`` file into the directory ``images/logos``, 
with name ``SITE_UUID.gif``.
