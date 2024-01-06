#!/bin/sh

if [ ! -f "/buildbot/master.cfg" ] && [ ! -f "$BUILDBOT_CONFIG_DIR/master.cfg" ]
then
    echo Please provide a master.cfg file in $BUILDBOT_CONFIG_DIR
    exit 1
fi

cp $BUILDBOT_CONFIG_DIR/master.cfg /buildbot

if [ -f /$BUILDBOT_CONFIG_DIR/buildbot.tac ]
then
    cp $BUILDBOT_CONFIG_DIR/buildbot.tac /buildbot
fi

if [ ! -f /buildbot/buildbot.tac ]
then
    cp /usr/src/buildbot/buildbot.tac /buildbot
fi

. /buildbot_venv/bin/activate

if [ ! -f $BUILDBOT_SQLITE_DB ]
then
    python $BUILDBOT_CONFIG_DIR/init_sqlite.py $BUILDBOT_SQLITE_DB
fi

until buildbot upgrade-master /buildbot
do
    echo "Can't upgrade master yet. Waiting for database ready?"
    sleep 1
done

exec twistd -ny /buildbot/buildbot.tac
