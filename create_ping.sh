# connect 3 namespaces: source-router-destination. In this exact order!
connect() {
    source=$1
    router=$2
    dest=$3

    rate_src=$4
    rate_dest=$5
    delay_src=$6
    delay_dest=$7

    sudo ip netns exec $router ip link set up $router-$dest
    sudo ip netns exec $router ip link set up $router-$source
    sudo ip netns exec $router ovs-ofctl mod-flows br-$router  in_port=$router-$source,actions=output:$router-$dest

    sudo ip netns exec $router tc qdisc del dev $router-$dest root
    sudo ip netns exec $router tc qdisc del dev $router-$source root
    sudo ip netns exec $router tc qdisc add dev $router-$dest root netem rate $rate_dest delay $delay_dest
    sudo ip netns exec $router tc qdisc add dev $router-$source root netem rate $rate_src delay $delay_src

}

# set roles to configure the ping client to server
connect client R1 R4 1Mbit 2Mbit 10ms 10ms
connect R1 R4 R7 5Mbit 2Mbit 10ms 20ms
connect R4 R7 server 10Mbit 2Mbit 10ms 30ms

# set roles to configure return ping server to client
connect server R7 R5 5Mbit 2Mbit 30ms 20ms
connect R7 R5 R1 1Mbit 20Mbit 15ms 20ms
connect R5 R1 client 1Mbit 2Mbit 5ms 20ms


