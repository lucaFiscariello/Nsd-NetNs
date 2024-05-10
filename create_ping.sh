# connect 3 namespaces: source-router-destination. In this exact order!
connect() {
    source=$1
    router=$2
    dest=$3

    sudo ip netns exec $router ip link set up $router-$dest
    sudo ip netns exec $router ip link set up $router-$source
    sudo ip netns exec $router ovs-ofctl mod-flows br-$router  in_port=$router-$source,actions=output:$router-$dest
}

# set roles to configure the ping client to server
connect client R1 R11
connect R1 R11 R21
connect R11 R21 R31
connect R21 R31 R41
connect R31 R41 server

# set roles to configure return ping server to client
connect server R41 R32
connect R41 R32 R22
connect R32 R22 R12
connect R22 R12 R1
connect R12 R1 client


