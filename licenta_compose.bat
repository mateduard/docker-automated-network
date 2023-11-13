@echo off
cd C:\Users\HP\Desktop\dckr_comp_licenta
docker-compose up -d

echo:
echo Network settings are being applied. Press any key to continue
pause >nul
echo:

docker exec -it CMc /bin/sh -c "ip route add 172.20.0.0/16 via 172.18.0.5 dev eth0"
docker exec -it CMc /bin/sh -c "ip route add 172.21.0.0/16 via 172.18.0.5 dev eth0"
docker exec -it CMc /bin/sh -c "ip route add 172.22.0.0/16 via 172.19.0.5 dev eth1" 
echo CMc OK...

docker exec -it R2c /bin/sh -c "ip route add 172.18.0.0/16 via 172.19.0.2 dev eth0"
docker exec -it R2c /bin/sh -c "ip route add 172.20.0.0/16 via 172.19.0.2 dev eth0"
docker exec -it R2c /bin/sh -c "ip route add 172.21.0.0/16 via 172.19.0.2 dev eth0"
docker exec -it R2c /bin/sh -c "route add default gw 172.19.0.2 eth0"
docker exec -it R2c /bin/sh -c "ip route del default via 172.19.0.1 dev eth0"
echo R2c OK...

docker exec -it R1c /bin/sh -c "ip route add 172.21.0.0/16 via 172.20.0.5 dev eth1"
docker exec -it R1c /bin/sh -c "ip route add 172.19.0.0/16 via 172.18.0.2 dev eth0"
docker exec -it R1c /bin/sh -c "ip route add 172.22.0.0/16 via 172.18.0.2 dev eth0" 
docker exec -it R1c /bin/sh -c "route add default gw 172.18.0.2 eth0"
docker exec -it R1c /bin/sh -c "ip route del default via 172.18.0.1 dev eth0"
echo R1c OK...

docker exec -it R3c /bin/sh -c "ip route add 172.18.0.0/16 via 172.20.0.2 dev eth0"
docker exec -it R3c /bin/sh -c "ip route add 172.19.0.0/16 via 172.20.0.2 dev eth0"
docker exec -it R3c /bin/sh -c "ip route add 172.22.0.0/16 via 172.20.0.2 dev eth0"
docker exec -it R3c /bin/sh -c "route add default gw 172.20.0.2 eth0"
docker exec -it R3c /bin/sh -c "ip route del default via 172.20.0.1 dev eth0"
echo R3c OK...

echo:
echo The network has been generated successfully! Press any key to exit the console
pause >nul