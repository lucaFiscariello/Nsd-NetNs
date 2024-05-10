#!/bin/bash

echo Starting OVSDB for $1
mkdir -p /tmp/ovs-$1

if [ -e /tmp/ovs-$1/conf.db ]; then
   echo DB already exists
else
   echo Createing OVSDB
   ovsdb-tool create /tmp/ovs-$1/conf.db /usr/share/openvswitch/vswitch.ovsschema
fi

ovsdb-server /tmp/ovs-$1/conf.db \
-vconsole:emer \
-vsyslog:err \
-vfile:info \
--remote=punix:/tmp/ovs-$1/db.sock \
--private-key=db:Open_vSwitch,SSL,private_key \
--certificate=db:Open_vSwitch,SSL,certificate \
--bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
--no-chdir \
--log-file=/tmp/ovs-$1/ovsdb-server.log \
--pidfile=/tmp/ovs-$1/ovsdb-server.pid \
--detach \
--monitor

ovs-vsctl --db=unix:/tmp/ovs-$1/db.sock --no-wait init
