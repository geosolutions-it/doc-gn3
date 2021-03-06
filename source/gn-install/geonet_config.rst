======================
Final setup
======================

Once GeoNetwork is up and running, you have to perform some other steps using the web interface.

Login as ``admin`` / ``admin``.

Change the admin pw
-------------------

Click on the "admin admin (Administrator)" link, then click on "Reset password".
Change and annotate the new password.

Check the system configuration
------------------------------

Click on `Admin console` >  `Settings`.

Check if the right values are set in these fields:

* In "Catalog description"
 
  * Catalog name
  * Organization
* In "Catalog Server"
   
  * Host
  * Port (you may want to put ``80`` here) 

You then may want to:

* Change the folder of the removed metadata
* Enable search statistics
* INSPIRE Directive configuration

  * Enable "**INSPIRE**"
  * Enable "**INSPIRE** search panel" **(to be fixed)**
* Metadata views  
* Setup the CSW server info

CSW
---

Create a contact for the CSW GetCapabilities.
This can be done creating a new user:
`Admin console` >  `Users and Groups` > `Manage users` > `New User`

Then you have to select such user as the contact for CSW: 
`Admin console` > `Settings` > Tab `CSW` > `Contact`.
Select the user you just created as CSW PoC.

Site logo
---------

`Admin console` > `Settings` > Tab `Logo`.

You have to upload your logo, and then select it as the main picture for your site.


Load ISO19139 templates
-----------------------

`Admin console` > `Metadata and templates`. 

Select the standards you want to import in your catalog (at least ISO19139), 
and then press the button "Load templates".

If you need also sample data, load sample as well. You won't want these sample data in a production catalog.


Enable INSPIRE validation
-------------------------

`Admin console` > `Metadata and templates` > Tab `Schematron`

Click on "INSPIRE Validation Rules" and change the dropdown value from
"Ignore this group [...]" to "Require to be valid" (or "Only report errors", according to your needs).

Repeat for "Inspire strict rules extension".


Load INSPIRE thesauri
---------------------

.. hint:: Official documentation for the INSPIRE setup is at

          http://geonetwork-opensource.org/manuals/trunk/eng/users/administrator-guide/configuring-the-catalog/inspire-configuration.html


`Admin console` > `Classification systems` > `Add thesaurus`

Select the "From URL" entry from the choice.

Set this address in the URL field::

   https://raw.githubusercontent.com/geonetwork/util-gemet/master/thesauri/inspire-theme.rdf

And select "Theme" in the dropdown menu.

Once uploaded, you should have the new entry "GEMET - INSPIRE themes, version 1.0 (theme)".


Configuration **not** externalizable
------------------------------------
  

Set INSPIRE as default view
___________________________
  
In order to set the INSPIRE view as the default one, 

`Admin console` > `Settings`.

Edit the field "Configuration par standard" in the "metadata" section.

The string :: 

   "iso19139":{"defaultTab":"default"
   
should be changed into ::

   "iso19139":{"defaultTab":"inspire"
   

.. _gn_setup_inspire_css:

CSS files
---------

In file ``webapps/geonetwork/catalog/style/gn_search.less`` look for the lines ::


   @import (less) "inspire/iti.css";
   // Import this CSS to have INSPIRE themes translations
   //@import (less) "inspire/iti-i18n.css";

and remove the comment from the ``import``.
  
.. _gn_setup_log_file_location:    

Log file location
-----------------

GeoNetwork is configured to output the logs both on console and on file.

You'll find the console output redirected into the file ``logs/catalina.out``.
The configured output log file, which contains some different information, is set to
``logs/geonetwork.logs``. The base dir is set wherever the starting process place it, but starting 
tomcat with systemd will probably set a read-only location.      
This means that you may need to set manually the location of the log file.

You have to enter the directory ::

   cd /var/lib/tomcat/geonetwork/webapps/geonetwork/WEB-INF/classes/

and edit the files:

* ``log4j-dev.xml``
* ``log4j-index.xml``
* ``log4j-search.xml``
* ``log4j.xml``

replacing the line ::

    <param name="File" value="logs/geonetwork.log" />

with ::

    <param name="File" value="/var/lib/tomcat/geonetwork/logs/geonetwork.log" />

You may want to modify the files with this line::

    for file in  /var/lib/tomcat/geonetwork/webapps/geonetwork/WEB-INF/classes/log4j*xml ; do sed -i -e s_logs/geonetwork.log_/var/lib/tomcat/geonetwork/logs/geonetwork.log_g $file ; done

 
Please note that GeoNetwork loads the log4j configuration file according to the 
setting in `Admin console` > `Settings` > section `Catalog server` > `Log level`.
 
