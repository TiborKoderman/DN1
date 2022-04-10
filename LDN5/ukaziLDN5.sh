A=0
B=1
C=5
D=1

# 10.0.0.0/24
# 10.0.1.0/24
# 192.168.5.0/24
# 172.16.1.0/24
# 2001:db8:e:0::/64
# 2001:db8:1:f::/64
# 2001:db8:ef:5::/64
# 2001:db8:1:ef::/64


#!PC1
ip addr add 192.168.5.2/24 dev eth0
ip route add default via 192.168.5.1 dev eth0

ip -6 addr add 2001:db8:ef:5::2/64 dev eth0
ip -6 route add default via 2001:db8:ef:5::1 dev eth0

#!PC2
ip addr add 172.16.1.2/24 dev eth0
ip route add default via 172.16.1.1 dev eth0

ip -6 addr add 2001:db8:1:ef::2/64 dev eth0
ip -6 route add default via 2001:db8:1:ef::1 dev eth0

#!R1
sudo ip addr add 192.168.5.1/24 dev eth1
sudo ip addr add 10.0.0.2/24 dev eth0

ip route add 10.0.1.0/24 via 10.0.0.1 dev eth0
ip route add 172.16.1.0/24 via 10.0.0.1 dev eth0

sudo ip -6 addr add 2001:db8:ef:5::1/64 dev eth1
sudo ip -6 addr add 2001:db8:e:0::2/64 dev eth0

sudo ip -6 route add 2001:db8:1:f::/64 via 2001:db8:e:0::1 dev eth0
sudo ip -6 route add 2001:db8:1:ef::/64 via 2001:db8:e:0::1 dev eth0

#!R2
sudo ip addr add 10.0.0.1/24 dev eth1
sudo ip addr add 10.0.1.1/24 dev eth0

sudo ip -6 addr add 2001:db8:e:0::1/64 dev eth1
sudo ip -6 addr add 2001:db8:1:f::1/64 dev eth0


sudo ip route add 192.168.5.0/24 via 10.0.0.2 dev eth1
sudo ip route add 172.16.1.0/24 via 10.0.1.2 dev eth0

sudo ip -6 route add 2001:db8:ef:5::/64 via 2001:db8:e:0::2 dev eth1
sudo ip -6 route add 2001:db8:1:ef::/64 via 2001:db8:1:f::2 dev eth0

#!R3
sudo ip addr add 10.0.1.2/24 dev eth0
sudo ip addr add 172.16.1.1/24 dev eth1

sudo ip -6 addr add 2001:db8:1:f::2/64 dev eth0
sudo ip -6 addr add 2001:db8:1:ef::1/64 dev eth1

sudo ip route add 10.0.0.0/24 via 10.0.1.1 dev eth0
sudo ip route add 192.168.5.0/24 via 10.0.1.1 dev eth0

sudo ip -6 route add 2001:db8:e:0::/64 via 2001:db8:1:f::1 dev eth0
sudo ip -6 route add 2001:db8:ef:5::/64 via 2001:db8:1:f::1 dev eth0