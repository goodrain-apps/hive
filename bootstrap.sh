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

for f in hive-site.xml; do
    if [[ -e ${CONFIG_DIR}/$f ]]; then
        cp ${CONFIG_DIR}/$f $HIVE_HOME/conf/$f
    else
        echo "ERROR: Could not find $f in $CONFIG_DIR"
        exit 1
    fi
done


# ------------------------------------------------------
# Start HIVE
# ------------------------------------------------------
if [[ "${HIVE_ROLE}" == "hiveserver2" ]]; then
    $HIVE_HOME/bin/hive --service metastore -p ${PORT} &
    $HIVE_HOME/bin/hive --service hiveserver2
fi

# ------------------------------------------------------
# Start bash if requested (parameter -bash)
# ------------------------------------------------------
if [[ $1 == "-bash" ]]; then
    /bin/bash
fi
