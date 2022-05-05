#!/bin/bash


# Maybe add feature to specify test timeout



if [ $# -lt 2 ] || [ $# -gt 3 ] ; then
	echo -e "\n\n\n    This script is used to test if a certain port is open, using the 'nc' command.\n\n    Syntax:    testconnect <host> <dest_port> [time_interval]\n\n    - The time interval between each test is an optional argument and it's in seconds. Default value is 2 seconds."
	echo -e "\n\n\n    These are the keywords for ports that this script acceps:"
	echo "        vnc          =    5900"
	echo "        ssh          =    22"
	echo "        http         =    80"
	echo "        http-alt     =    8080"
	echo "        https        =    443"
	echo "        https-alt    =    8443"
	echo "    These are the keywords for hosts:"
	echo "        itecons      =    62.48.170.53    → vpn1.itecons.pt   (it accepts connections in port 443)"
	echo -e "\n\n"
	exit 1

elif [ $# -eq 3 ] ; then
	if [ $3 -eq $3 ] ; then
		interval=$3
	else
		echo -e "\n\n        Error: The 3rd argument must an integer!"
		exit 1
	fi
else
	interval=2		#The default Interval
fi

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

case $2 in
	vnc)
		port=5900
		;;
	rdp)
		port=3389
		;;
	ssh)
		port=22
		;;
	http)
		port=80
		;;
	http-alt)
		port=8080
		;;
	https)
		port=443
		;;
	https-alt)
		port=8443
		;;
	*)
		port=$2
		;;
esac

case $1 in
        itecons)
                host='62.48.170.53'
                ;;
        *)
                host=$1
                ;;
esac

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

echo -e "\n\n    IP Address   -----------------" $host
echo "    Destination Port   -----------" $port
echo "    Time Interval   --------------" $interval
echo -e "\n\n\n\n"

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


for i in {0..100000}
do
	$(nc -w 2 -z -v $host $port)
	$(sleep $interval)
done

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

echo "\n\n\n        You have reached the end of the test cycle (100000 loops).\n\n\n"

exit 0
