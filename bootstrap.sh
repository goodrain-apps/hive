#!/bin/bash -x

echo Starting

: ${HIVE_PREFIX:=/usr/local/hive}

echo Using ${HIVE_HOME} as HIVE_HOME

. $HIVE_HOME/etc/hive-env.sh

# ------------------------------------------------------
# Directory to find config artifacts
# ------------------------------------------------------

CONFIG_DIR="/tmp/hive-config"

# ------------------------------------------------------
# Copy config files from volume mount
# ------------------------------------------------------

for f in hive_site.xml; do
    if [[ -e ${CONFIG_DIR}/$f ]]; then
        cp ${CONFIG_DIR}/$f $HIVE_HOME/etc/$f
    else
        echo "ERROR: Could not find $f in $CONFIG_DIR"
        exit 1
    fi
done


# ------------------------------------------------------
# Start HIVE
# ------------------------------------------------------
if [[ "${HIVE_ROLE}" == "hiveserver2" ]]; then

    $HIVE_HOME/bin/hive --service hiveserver2 --hiveconf $HIVE_HOME/etc/hive_site.xml
    $HIVE_HOME/bin/hive --service metastore -p ${PORT} --hiveconf $HIVE_HOME/etc/hive_site.xml

fi
# ------------------------------------------------------
# Start DATA NODE
# ------------------------------------------------------
if [[ "${HIVE_ROLE}" == "metastore" ]]; then

    #  Wait (with timeout) for namenode
    #   TMP_URL="http://hive-hive-hdfs-nn:9870"
    #   if timeout 5m bash -c "until curl -sf $TMP_URL; do echo Waiting for $TMP_URL; sleep 5; done"; then
    #     $HIVE_HOME/bin/hdfs --loglevel INFO --daemon start datanode
    #   else
    #     echo "$0: Timeout waiting for $TMP_URL, exiting."
    #     exit 1
    #   fi

    $HIVE_HOME/bin/hive --service metastore -p ${PORT}

fi


# ------------------------------------------------------
# Tail logfiles for daemonized workloads (parameter -d)
# ------------------------------------------------------
if [[ $1 == "-d" ]]; then
    until
        find ${HIVE_HOME}/logs -mmin -1 | egrep -q '.*'
        echo "$(date): Waiting for logs..."
    do sleep 2; done
    tail -F ${HIVE_HOME}/logs/* &
    while true; do sleep 1000; done
fi

# ------------------------------------------------------
# Start bash if requested (parameter -bash)
# ------------------------------------------------------
if [[ $1 == "-bash" ]]; then
    /bin/bash
fi
