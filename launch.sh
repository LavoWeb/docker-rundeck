ls /etc/rundeck/profile || \
    dpkg -i /tmp/rundeck.deb && \
    cp -r /app/etc/* /etc && \
    sed -i 's,grails.serverURL\=.*,grails.serverURL\='${SERVER_URL}',g' \
    /etc/rundeck/rundeck-config.properties

if [ ! -f /var/lib/rundeck/.ssh/id_rsa ]; then
    mkdir -p /var/lib/rundeck/.ssh
    echo "=>Generating rundeck key"
    ssh-keygen -t rsa -b 4096 -f /var/lib/rundeck/.ssh/id_rsa -N ''
fi

echo "launching rundeck"

chown -R rundeck:rundeck /tmp/rundeck
chown -R rundeck:rundeck /etc/rundeck
chown -R rundeck:rundeck /var/rundeck
chown -R rundeck:rundeck /var/log/rundeck
chown -R rundeck:rundeck /var/lib/rundeck

cat /var/lib/rundeck/.ssh/id_rsa.pub

. /lib/lsb/init-functions
. /etc/rundeck/profile

DAEMON="${JAVA_HOME:-/usr}/bin/java"
DAEMON_ARGS="${RDECK_JVM} -cp ${BOOTSTRAP_CP} com.dtolabs.rundeck.RunServer /var/lib/rundeck ${RDECK_HTTP_PORT}"
rundeckd="$DAEMON $DAEMON_ARGS"

cd /var/log/rundeck
su -s /bin/bash rundeck -c "$rundeckd"
