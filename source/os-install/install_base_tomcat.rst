.. _os_tomcat_install:

###################
Tomcat Installation
###################

.. _os_java_install:

Installing Java
===============

We'll need a JDK to run GeoServer.

You may already have the OpenJDK package (``java-1.8.0-openjdk-devel.x86_64``) installed.
Check and see if Java is already installed:: 

   # java -version
   openjdk version "1.8.0_242"
   OpenJDK Runtime Environment (build 1.8.0_242-b08)
   OpenJDK 64-Bit Server VM (build 25.242-b08, mixed mode)
   
   # javac -version
   javac 1.8.0_242

If it is not, check for available versions::

   dnf list *openjdk*
   
You'll get a list like this one, probably with versions 1.6.0, 1.7.0, 1.8.0::
   
   [...]
   java-1.6.0-openjdk.x86_64                                                                1:1.6.0.41-1.13.13.1.el7_3                                             base    
   java-1.6.0-openjdk-demo.x86_64                                                           1:1.6.0.41-1.13.13.1.el7_3                                             base    
   java-1.6.0-openjdk-devel.x86_64                                                          1:1.6.0.41-1.13.13.1.el7_3                                             base    
   java-1.6.0-openjdk-javadoc.x86_64                                                        1:1.6.0.41-1.13.13.1.el7_3                                             base    
   java-1.6.0-openjdk-src.x86_64                                                            1:1.6.0.41-1.13.13.1.el7_3                                             base    
   java-1.7.0-openjdk.x86_64                                                                1:1.7.0.181-2.6.14.8.el7_5                                             updates 
   java-1.7.0-openjdk-accessibility.x86_64                                                  1:1.7.0.181-2.6.14.8.el7_5                                             updates 
   java-1.7.0-openjdk-demo.x86_64                                                           1:1.7.0.181-2.6.14.8.el7_5                                             updates 
   java-1.7.0-openjdk-devel.x86_64                                                          1:1.7.0.181-2.6.14.8.el7_5                                             updates 
   java-1.7.0-openjdk-headless.x86_64                                                       1:1.7.0.181-2.6.14.8.el7_5                                             updates 
   java-1.7.0-openjdk-javadoc.noarch                                                        1:1.7.0.181-2.6.14.8.el7_5                                             updates 
   java-1.7.0-openjdk-src.x86_64                                                            1:1.7.0.181-2.6.14.8.el7_5                                             updates 
   java-1.8.0-openjdk.x86_64                                                                1:1.8.0.171-8.b10.el7_5                                                @updates
   java-1.8.0-openjdk-devel.x86_64                                                          1:1.8.0.171-8.b10.el7_5                                                @updates
   java-1.8.0-openjdk-headless.x86_64                                                       1:1.8.0.171-8.b10.el7_5                                                @updates
   [...]
   
Go for the version 1.8.0::

   yum install java-1.8.0-openjdk-devel
   
Once done, the command ``java -version`` should return info about the installed version. 


Installing Tomcat
=================

.. _create_user_tomcat:

Create tomcat user
------------------
:: 

  adduser -m -s /bin/bash tomcat
  passwd tomcat


Tomcat
------

Let's download and install `Tomcat` first::

    wget http://it.apache.contactlab.it/tomcat/tomcat-8/v8.5.51/bin/apache-tomcat-8.5.51.tar.gz
    tar xzvf apache-tomcat-8.5.51.tar.gz
    mv apache-tomcat-8.5.51 /opt
    ln -s /opt/apache-tomcat-8.5.51 /opt/tomcat

Then prepare a clean instance called ``base`` to be used as a template 
for all tomcat instances::

    mkdir -p /var/lib/tomcat/base/{bin,conf,logs,temp,webapps,work}
    cp -r /opt/tomcat/conf/* /var/lib/tomcat/base/conf

And fix the permissions on the files::

    chown -R tomcat:tomcat /opt/apache*
    chown -R tomcat:tomcat /var/lib/tomcat


Instance manager script
-----------------------

To manage our Tomcat instances create the file ``/etc/systemd/system/tomcat\@.service``
with the following content::

    [Unit]
    Description=Tomcat %I
    After=network.target

    [Service]
    Type=forking
    User=tomcat
    Group=tomcat

    Environment=CATALINA_PID=/var/run/tomcat/%i.pid
    #Environment=TOMCAT_JAVA_HOME=/usr/java/default
    Environment=CATALINA_HOME=/opt/tomcat
    Environment=CATALINA_BASE=/var/lib/tomcat/%i
    Environment=CATALINA_OPTS=

    ExecStart=/opt/tomcat/bin/startup.sh
    ExecStop=/opt/tomcat/bin/shutdown.sh -force
    #ExecStop=/bin/kill -15 $MAINPID

    WorkingDirectory=/var/lib/tomcat/%i

    [Install]
    WantedBy=multi-user.target

Then make it executable::

   chmod +x /etc/systemd/system/tomcat\@.service

SELinux will prevent systemd to run the shell script; we'll disable SELinux altogether::

   setenforce 0

In order to have a secure system, please consider keeping SELinux active and setting the proper rules for running tomcat.
Secure setup is not covered here.
