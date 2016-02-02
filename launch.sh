if [ ! -f /etc/rundeck/profile ]; then
    echo "=>installing rundeck"

    dpkg -i /tmp/rundeck.deb
    cp -r /app/etc/* /etc
    sed 's,https://localhost:4443,'$SERVER_URL',g' -i /etc/rundeck/rundeck-config.groovy
    PASSWORD=$(echo "yolo" $(head -n1 /dev/urandom) | sha1sum | cut -d' ' -f1)
    sed 's,tochange,'$PASSWORD',g' -i /etc/rundeck/realm.properties
    echo $PASSWORD
    PASSWORD=""
fi

if [ ! -f /var/lib/rundeck/.ssh/id_rsa ]; then
    echo "=>Generating rundeck ssh key"

    mkdir -p /var/lib/rundeck/.ssh
    ssh-keygen -t rsa -b 4096 -f /var/lib/rundeck/.ssh/id_rsa -N ''
fi

if [ ! -f /etc/rundeck/ssl/truststore ]; then
    echo "=>Generating ssl cert"

    keytool -keystore /etc/rundeck/ssl/keystore \
        -alias rundeck -genkey -keyalg RSA -keypass adminadmin \
        -storepass adminadmin -dname "cn=$HOST_RUNDECK, o=OME, c=FR"
    cp /etc/rundeck/ssl/keystore /etc/rundeck/ssl/truststore
fi

echo "=>launching rundeck"

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

