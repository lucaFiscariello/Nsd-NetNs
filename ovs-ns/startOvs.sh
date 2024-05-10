#!/bin/bash

echo Starting OVS for $1
ovs-vswitchd unix:/tmp/ovs-$1/db.sock \
-vconsole:emer \
-vsyslog:err \
-vfile:info \
--mlockall \
--no-chdir \
--log-file=/tmp/ovs-$1/ovs-vswitchd.log \
--pidfile=/tmp/ovs-$1/ovs-vswitchd.pid \
--detach \
--monitor
