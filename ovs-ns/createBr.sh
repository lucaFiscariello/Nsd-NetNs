#!/bin/bash

echo Configure OVS for $1
ovs-vsctl --db=unix:/tmp/ovs-$1/db.sock add-br br-$1
