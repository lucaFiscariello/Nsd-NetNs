# Nsd-NetNs

## How to download code
To download the code, inside your pc run the following command:
```
git clone https://github.com/lucaFiscariello/Nsd-NetNs/
scp -r Nsd-NetNs ubuntu@ip-vm:/home/ubuntu
```

## Make scripts executable
Inside **the virtual machine** execute:
```
cd Nsd-NetNs
chmod +x buildNet
chmod +x cleanNet
chmod +x create_ping.sh
chmod +x emulation.sh
chmod +x ovs-ns/createBr.sh
chmod +x ovs-ns/createBr.sh
chmod +x ovs-ns/startOvs.sh
chmod +x ovs-ns/startOvsDb.sh
```


## How to build network
The following command creates a network of 11 namespaces.
```
cd Nsd-NetNs
./buildNet
```

Specifically, a network consisting of a client, a server and 9 routers is created. The routers are organized in a mesh topology consisting of 3 columns and 3 rows.
You can check what name spaces are created by the *./buildNet* script with the following command:
```
sudo ip netns show
```

To view connections between routers you can go into each namespace and see what other namespaces it can talk to. To do this you can run the following command:
```
#You can use also R2 or R3 or ..R9
sudo ip netns exec R1 ip a  
```

The output of the command *"sudo ip netns exec R1 ip a"* shows how many interfaces the namespaces has. Each interface has the name "Rx-Ry." The interface name lets you know which namespaces are connected to each other. For example, if an interface is named "R1-R2" it means that the namespaces R1 and R2 are connected to each other. 
Note well that not all routers talk to all routers. The routers in each column can only talk to the "bottom" and "top" router and all the routers in the next column.

## How to create ping
To make the client and server communicate with each other through routers you can execute the following command:
```
./create_ping.sh
```

To test the ping you can run:
```
sudo ip netns exec client ping 192.168.5.1
```

While ping is running, to check if the traffic passing through a namespaces, you can run the following command from **another terminal**: 
```
#You can use also R2 or R3 or ..R9
sudo ip netns exec R1 tcpdump 
```

## Modify ping dinamically
You can change routes in routers dynamically by running the command:
```
./emulation.sh
```
This script updates the communication routes between routers every 5 seconds. Example of what a command in emulation.sh script does:

![Consegna5 drawio(9)](https://github.com/lucaFiscariello/Nsd-NetNs/assets/80633764/81631efc-e3f2-4f52-9317-38a112b0c68c)

To study the routing algoritm you can execute the following command from two new terminals:
```
#inside one new terminal
sudo ip netns exec server iperf3 -s 
```

```
#inside another one terminal
sudo ip netns exec client iperf3 -c 192.168.5.1 -t0 -u -b 20Mbit
```

## Clean net

```
./cleanNet.sh
```

