# Nsd-NetNs

## How to download code
To download the code, inside the **virtual machine** run the following command:
```
git clone https://github.com/lucaFiscariello/Nsd-NetNs/
```

## How to build network
The following command creates a network of 52 namespaces.
```
cd Nsd-NetNs
./buildNet
```

Specifically, a network consisting of a client, a server and 50 routers is created. The routers are organized in a mesh topology consisting of 5 columns and 10 rows as visible in the image below.
![Untitled Diagram drawio](https://github.com/lucaFiscariello/Nsd-NetNs/assets/80633764/29dff7a1-9165-4dfa-91dd-df29cc50b8f3)

You can check what name spaces are created by the *./buildNet* script with the following command:
```
sudo ip netns show
```

To view connections between routers you can go into each namespace and see what other namespaces it can talk to. To do this you can run the following command:
```
#You can use also R2 or R3 or ..R50
sudo ip netns exec R1 ip a  
```

As output you will see something like this:
![2024-05-10_10-18](https://github.com/lucaFiscariello/Nsd-NetNs/assets/80633764/d1c92242-303d-4a7e-97de-8ebb7ac66398)

The output of the command *"sudo ip netns exec R1 ip a"* shows how many interfaces the namespaces has. Each interface has the name "Rx-Ry." The interface name lets you know which namespaces are connected to each other. For example, if an interface is named "R1-R2" it means that the namespaces R1 and R2 are connected to each other. In the case of namespace R1 you can see that it is connected to the napesmaces R2, R11, R12, R13 ... R20. 
Note well that not all routers talk to all routers. The routers in each column can only talk to the "bottom" and "top" router and all the routers in the next column. For example, router R1 is connected with all routers in the range [R11-R20] but NOT with routers in the range [R21-R30]. And it is also connected with the "bottom" router R2.


## How to create ping
To make the client and server communicate with each other through routers you can execute the following command:
```
./create_ping.sh
```
To test the ping you can run:
```
sudo ip netns exec client ping 192.168.5.1
```

The *./create_ping.sh* script modifies the routing rules within each namespaces and creates the connections visible in the image below.

![ping](https://github.com/lucaFiscariello/Nsd-NetNs/assets/80633764/97995f96-6f85-4238-bcd7-9d72cc533cb7)
For the outbound path a packet that is generated from the client to the server passes through R1-R11-R21-R31-R41.
For the return path a packet that is generated from the server to the client passes through R41-R32-R22-R12-R1.

## How to modify ping
You can also change the routing of packets in the network by running the command :
```
./modify_ping.sh
```

By running the command *./modify_ping.sh* you will see that the ping between client and server continues to work. However, packets in the network will follow different paths. 

## Modify ping dinamically
You can change routes in routers dynamically by running the command:
```
./emulate.sh
```
This script updates the communication routes between routers every 5 seconds.

## Clean net

```
./cleanNet.sh
```

