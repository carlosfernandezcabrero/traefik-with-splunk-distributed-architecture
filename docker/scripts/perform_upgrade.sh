cd $SPLUNK_HOME/..

if [ -f /tmp/splunk_7.3.6_backup.tgz ]; then
    echo "Eliminando backup anterior"
    rm -r /tmp/splunk_7.3.6_backup.tgz
fi

echo "Creando backup nuevo"
tar -cf /tmp/splunk_7.3.6_backup.tgz splunk

echo "Descomprimiendo nueva versión"
tar -xf $1