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
    #set roles to configure the ping client to server – Best latency link time 0
    Connect client R2 R5 12Mbit 12Mbit 8ms 6ms
    Connect R2 R5 R8 12Mbit 12Mbit 6ms 6ms
    Connect R5 R8 server 12Mbit 12Mbit 6ms 8ms

    #set roles to configure return ping server to client – Best latency link at time 0
    Connect server R8 R5 12Mbit 12Mbit 8ms 6ms
    Connect R8 R5 R2 12Mbit 12Mbit 6ms 6ms
    Connect R5 R2 client 12Mbit 5Mbit 6ms 7ms

    sleep 5
    #clean old roles ping from client to server at time 0
    Close client R2 R5
    Close R2 R5 R8
    Close R5 R8 server

    #clean old roles ping from server to client at time 0
    Close server R8 R5
    Close R8 R5 R2
    Close R5 R2 client

    #set roles to configure the ping client to server – Best latency link time 5
    Connect client R1 R6 12Mbit 10Mbit 8ms 7ms
    Connect R1 R6 R5 10Mbit 6Mbit 7ms 8ms
    Connect R6 R5 R7 6Mbit 10Mbit 8ms 10ms
    Connect R5 R7 server 10Mbit 12Mbit 10ms 8ms

    #set roles to configure return ping server to client – Best Latency link at time 5
    Connect server R7 R8 12Mbit 7Mbit  8ms 9ms
    Connect R7 R8 R6 7Mbit 8Mbit 9ms 10ms
    Connect R8 R6 R1 8Mbit 10Mbit 10ms 7ms
    Connect R6 R1 client 10Mbit 5Mbit 7ms 7ms

    sleep 5

    #clean old roles ping from client to server at time 5
    Close client R1 R6
    Close R1 R6 R5
    Close R6 R5 R7
    Close R5 R7 server


    #clean old roles ping from server to client at time 5
    Close server R7 R8
    Close R7 R8 R6
    Close R8 R6 R1
    Close R6 R1 client

    #set roles to configure the ping client to server – Best latency link time 10
    Connect client R1 R2 10Mbit 5Mbit 10ms 7ms 
    Connect R1 R2 R3 5Mbit 11Mbit 7ms 14ms
    Connect R2 R3 R6 11Mbit 5Mbit 14ms 18ms
    Connect R3 R6 R5 5Mbit 6Mbit 18ms 8ms
    Connect R6 R5 R4 6Mbit 8Mbit 8ms 12ms
    Connect R5 R4 R7 8Mbit 5Mbit 12ms 18ms
    Connect R4 R7 R8 5Mbit 7Mbit 18ms 9ms
    Connect R7 R8 server 7Mbit 8Mbit 9ms 12ms

    #set roles to configure return ping server to client – Best Latency link at time 10
    Connect server R8 R7 7Mbit 10Mbit 9ms 13ms
    Connect R8 R7 R4 10Mbit 5Mbit 13ms 17ms
    Connect R7 R4 R5 5Mbit 6Mbit 17ms 8ms
    Connect R4 R5 R6 6Mbit 8Mbit 8ms 12ms
    Connect R5 R6 R3 8Mbit  6Mbit 12ms 18ms
    Connect R6 R3 R2 6Mbit 5Mbit 18ms 7ms
    Connect R3 R2 R1 11Mbit 5Mbit 14ms 18ms
    Connect R2 R1 client 10Mbit 5Mbit 10ms 7ms 

    sleep 5
    #clean old roles ping from client to server at time 10
    Close client R1 R2
    Close R1 R2 R3
    Close R2 R3 R6
    Close R3 R6 R5
    Close R6 R5 R4
    Close R5 R4 R7
    Close R4 R7 R8
    Close R7 R8 server

    #clean old roles ping from server to client at time 10
    Close server R8 R7 
    Close R8 R7 R4 
    Close R7 R4 R5 
    Close R4 R5 R6 
    Close R5 R6 R3
    Close R4 R3 R2 
    Close R3 R2 R1
    Close R2 R1 client  

    #set roles to configure the ping client to server – Best latency link time 15
    Connect client R3 R6 11Mbit 4Mbit 14ms 22ms
    Connect R3 R6 R5 4Mbit 6Mbit 22ms 8ms
    Connect R6 R5 R4 6Mbit 8Mbit 8ms 12ms
    Connect R5 R4 R7 8Mbit 4Mbit 12ms 22ms
    Connect R4 R7 R8 4Mbit 7Mbit 22ms 9ms
    Connect R7 R8 R9 7Mbit 10Mbit 9ms 13ms
    Connect R8 R9 server 10Mbit 4Mbit 13ms 19ms

    #set roles to configure return ping server to client – Best Latency link at time 15
    Connect server R7 R8 8Mbit 7Mbit 12ms 9ms
    Connect R7 R8 R9 7Mbit 10Mbit 9ms 13ms
    Connect R8 R9 R6 10Mbit 4Mbit 13ms 23ms
    Connect R9 R6 R5 4Mbit 6Mbit 23ms 8ms
    Connect R6 R5 R4 6Mbit 8Mbit 8ms 12ms
    Connect R5 R4 R1 8Mbit 5Mbit 12ms 22ms
    Connect R4 R1 R2 5Mbit 5Mbit 22ms 7ms
    Connect R1 R2 R3 5Mbit 11Mbit 7ms 14ms
    Connect R2 R3 client 11Mbit 4Mbit 14ms 19ms

    sleep 5
    #clean old roles ping from client to server at time 15
    Close client R3 R6
    Close R3 R6 R5
    Close R6 R5 R4
    Close R5 R4 R7
    Close R4 R7 R8
    Close R7 R8 R9
    Close R8 R9 server

    #clean old roles ping from server to client at time 15
    Close server R7 R8
    Close R7 R8 R9
    Close R8 R9 R6
    Close R9 R6 R5
    Close R6 R5 R4
    Close R5 R4 R1
    Close R4 R1 R2
    Close R1 R2 R3
    Close R2 R3 client

    #set roles to configure the ping client to server – Best latency link time 20
    Connect client R3 R6 11Mbit 3Mbit 14ms 25ms
    Connect R3 R6 R7 3Mbit 6Mbit 25ms 23ms
    Connect R6 R7 R8 6Mbit 7Mbit 23ms 9ms
    Connect R7 R8 R9 7Mbit 10Mbit 9ms 13ms
    Connect R8 R9 server 10Mbit 2Mbit 13ms 22ms

    #set roles to configure return ping server to client – Best Latency link at time 20
    Connect server R7 R6 6Mbit 6Mbit 14ms 23ms
    Connect R7 R6 R5 6Mbit 6Mbit 23ms 8ms
    Connect R6 R5 R4 6Mbit 8Mbit 8ms 12ms
    Connect R5 R4 R1 8Mbit 4Mbit 12ms 27ms
    Connect R4 R1 R2 4Mbit 5Mbit 27ms 7ms
    Connect R1 R2 R3 5Mbit 11Mbit 7ms 14ms
    Connect R2 R3 client 11Mbit 2Mbit 14ms 22ms

    Close client R3 R6 
    Close R3 R6 R7 
    Close R6 R7 R8 
    Close R7 R8 R9 
    Close R8 R9 server 

    Close server R7 R6 
    Close R7 R6 R5 
    Close R6 R5 R4 
    Close R5 R4 R1 
    Close R4 R1 R2 
    Close R1 R2 R3 
    Close R2 R3 client 

done
