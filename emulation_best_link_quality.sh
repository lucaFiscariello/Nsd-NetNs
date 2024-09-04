# connect 3 namespaces: source-router-destination. In this exact order!
Connect() {
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

# remove connection between 3 namespaces: source-router-destination. In this exact order!
Close() {
    source=$1
    router=$2
    dest=$3

    sudo ip netns exec $router ip link set down $router-$dest
    sudo ip netns exec $router ip link set down $router-$source
    sudo ip netns exec $router ovs-ofctl del-flows br-$router  in_port=$router-$source
}

while true
do
    #set roles to configure the ping client to server – Best quality link time 0
    Connect client R2 R5 12Mbit 12Mbit 8ms 6ms
    Connect R2 R5 R8 12Mbit 12Mbit 6ms 6ms
    Connect R5 R8 server 12Mbit 12Mbit 6ms 8ms

    #set roles to configure return ping server to client – best quality link time 0
    Connect server R8 R5 12Mbit 12Mbit 8ms 6ms
    Connect R8 R5 R2 12Mbit 12Mbit 6ms 6ms
    Connect R5 R2 client 12Mbit 12Mbit 6ms 8ms

    sleep 5
    # clean old roles ping from client to server at time 0
    Close client R2 R5
    Close R2 R5 R8
    Close R5 R8 server

    # clean old roles ping from server to client at time 0
    Close server R8 R5 
    Close R8 R5 R2
    Close R5 R2 client

    # set role to configure the ping client to server – best quality link time 5
    Connect client R1 R6 12Mbit 10Mbit 8ms 7ms
    Connect R1 R6 R7 10Mbit 9Mbit 7ms 11ms
    Connect R6 R7 server 9Mbit 12Mbit 11ms 8ms

    #set role to configure the ping server to client – best quality link time 5
    Connect server R7 R5 12Mbit 10Mbit 8ms 10ms
    Connect R7 R5 R1 10Mbit 8Mbit 10ms 8ms
    Connect R5 R1 client 8Mbit 12Mbit 8ms 8ms

    sleep 5
    #clean old roles ping from client to server at time 5
    Close client R1 R6
    Close R1 R6 R7
    Close R6 R7 server

    # clean old roles ping from server to client at time 5
    Close server R7 R5
    Close R7 R5 R1
    Close R5 R1 client
    
    # set role to configure the ping client to server – best quality link time 10
    Connect client R1 R6 10Mbit 8Mbit 10ms 12ms
    Connect R1 R6 R7 8Mbit 8Mbit 12ms 15ms
    Connect R6 R7 server 8Mbit 10Mbit 15ms 10ms

    #set role to configure the ping server to client – best quality link time 10
    Connect server R7 R6 10Mbit 8Mbit 10ms 15ms
    Connect R7 R6 R1 8Mbit 8Mbit 15ms 12ms
    Connect R6 R1 client 8Mbit 10Mbit 12ms 10ms

    sleep 5
    #clean old roles ping from client to server at time 10
    Close client R1 R6
    Close R1 R6 R7
    Close R6 R7 server

    #clean old roles ping from server to client at time 10
    Close server R7 R6
    Close R7 R6 R1
    Close R6 R1 client

    # set role to configure the ping client to server – best quality link time 15
    Connect client R1 R6 8Mbit 7Mbit 12ms 15ms
    Connect R1 R6 R7 7Mbit  7Mbit 15ms 21ms
    Connect R6 R7 server 7Mbit 8Mbit 21ms 12ms

    #set role to configure the ping server to client – best quality link time 15
    Connect server R7 R6 8Mbit 7Mbit 12ms 21ms
    Connect R7 R6 R1 7Mbit 7Mbit 21ms 15ms
    Connect R6 R1 client 7Mbit 8Mbit 15ms 12ms

    sleep 5
    #clean old roles ping from client to server at time 15
    Close client R1 R6
    Close R1 R6 R7
    Close R6 R7 server

    #clean old roles ping from server to client at time 15
    Close server R7 R6
    Close R7 R6 R1
    Close R6 R1 client

    # set role to configure the ping client to server – best quality link time 20
    Connect client R1 R6 6Mbit 6Mbit 14ms 18ms
    Connect R1 R6 R7 6Mbit 6Mbit 18ms 23ms
    Connect R6 R7 R8 6Mbit 7Mbit 23ms 9ms
    Connect R7 R8 R9 7Mbit 10Mbit 9ms 13ms
    Connect R8 R9 server 10Mbit 2Mbit 13ms 22ms

    #set role to configure the ping server to client – best quality link time 20
    Connect server R7 R8 6Mbit 7Mbit 14ms 9ms 
    Connect R7 R8 R9 7Mbit 10Mbit 9ms 13ms
    Connect R8 R9 R6 10Mbit 3Mbit 13ms 26ms
    Connect R9 R6 R1 3Mbit 6Mbit 26ms 18ms
    Connect R6 R1 client 6Mbit 6Mbit 18ms 14ms

done
