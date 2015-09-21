export CATALINA_HOME=/opt/tomcat
export CATALINA_BASE=/var/lib/tomcat/geonetwork

# Configure memory and system stuff
JAVA_OPTS="-Xms1500m -Xmx1500m -XX:PermSize=256m -XX:MaxPermSize=1024m"

# Configure GeoNetwork
export GN_EXT_DIR=$CATALINA_BASE/gn

export GN_DATA_DIR=$CATALINA_BASE/gn/data
export JAVA_OPTS="$JAVA_OPTS -Dgeonetwork.dir=$GN_DATA_DIR"

# Configure override file
export GN_OVR_PROPNAME=geonetwork.jeeves.configuration.overrides.file
export GN_OVR_FILE=$GN_EXT_DIR/config-overrides.xml
export JAVA_OPTS="$JAVA_OPTS -D$GN_OVR_PROPNAME=$GN_OVR_FILE"


#export JPDA_OPTS="-agentlib:jdwp=transport=dt_socket,address=4000,server=y,suspend=y"