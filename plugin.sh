#!/bin/bash

if [ -z ${PLUGIN_TOKEN} ]; then
    echo "please provide a mastodon access token";
    exit 1
fi

if [ -z ${PLUGIN_INSTANCE} ]; then
    echo "please provide a mastodon instance (without https)";
    exit 1
fi

if [ -z ${PLUGIN_VISIBILITY} ]; then
    export PLUGIN_VISIBILITY="public"
fi

if [ -z ${PLUGIN_MESSAGE} ]; then
    if [ "${DRONE_BUILD_STATUS}"  == "success" ]; then
        export M_STATUS="succeeded";
    elif [ "${DRONE_BUILD_STATUS}"  == "failure" ]; then
        export M_STATUS="failed";
    else
        export M_STATUS="is unknown"
    fi
    export PLUGIN_MESSAGE="Build of ${DRONE_REPO_NAME} ${M_STATUS}"
fi



madonctl -i ${PLUGIN_INSTANCE} -t ${PLUGIN_TOKEN} status post --visibility ${PLUGIN_VISIBILITY} "${PLUGIN_MESSAGE}"
