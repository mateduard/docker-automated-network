@echo off
SetLocal EnableDelayedExpansion
echo:
echo The script will generate a database or a site that will run in a container
echo:
echo Select the desired service ^(database/site^)
set /p imagine= "Service: "
echo:
echo Specify the maximum allocated memory ^(MB, not less than 6^)
set /p memorie= "Memory: "
echo:
echo Choose the network that the container will be a part of ^(structured like 172.X.0.0/16^):
set /p retea= "X= "
echo:
echo Precizati numele containerului
set /p nume= "Name: "
echo:

set /a dif= %retea%-17

IF "%imagine%"=="site" (
	echo Select the running port
	set /p port= "Port:"
	echo:
	echo A site container will be created with %memorie% MB RAM in network%dif% ^(172.%retea%.0.0/16^) on port !port!.
	echo The container will be named %nume%.
	echo Press any key to confirm.
	echo:
	pause >nul
	docker run -d -p !port!:80 -m="%memorie%m" --network reteaua%dif% --name %nume% --cap-add=NET_ADMIN site-http
	echo | set /p provizoriu="Success. The container received the IP address " && docker inspect -f {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}} %nume%
	echo Press any key to continue with the network settings
	echo:
	pause >nul
	echo Applying network settings...
	docker exec -it %nume% /bin/sh -c "route add default gw 172.%retea%.0.2 eth0"
	docker exec -it %nume% /bin/sh -c "ip route del default via 172.%retea%.0.1 dev eth0"
	echo The settings have been applied successfully^^!
) ELSE (
	echo A database container will be created with %memorie% MB RAM in network%dif% ^(172.%retea%.0.0/16^).
	echo The container will be named %nume%.
	echo Press any key to confirm.
	echo:
	pause >nul
	docker run -d -i -m="%memorie%m" --network reteaua%dif% --name %nume% --cap-add=NET_ADMIN ubuntu
	echo | set /p provizoriu="Success. The container received the IP address " && docker inspect -f {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}} %nume%
	echo:
	echo Press any key to continue with container utilities
	pause >nul
	docker exec -it %nume% /bin/sh -c "apt update && apt-get install -y net-tools && apt install -y iproute2"
	docker exec -it %nume% /bin/sh -c "apt install -y iputils-ping && apt-get install -y tcpdump"
	echo The utilities have been successfully configured^^!
	echo:
	echo Applying network settings...
	echo Press any key
	pause >nul
	echo:
	docker exec -it %nume% /bin/sh -c "route add default gw 172.%retea%.0.2 eth0"
	docker exec -it %nume% /bin/sh -c "ip route del default via 172.%retea%.0.1"
	echo Network settings have been successfully applied^^!
)
echo:
echo End of the program. Press any key to exit the console
pause >nul