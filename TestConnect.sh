#!/bin/bash


# CONFIG VARIABLES
timeout=2		# timeout for the nc command
interval=2		# interval between each scan
num_runs=100000		# how many scans in loop


# SAVED PORTS
declare -A saved_ports	# create an associative array (for BASH v4 and above)
saved_ports['ssh']=22
saved_ports['rdp']=3389
saved_ports['vnc']=5900
saved_ports['http']=80
saved_ports['http-alt']=8080
saved_ports['https']=443
saved_ports['https-alt']=8443

# SAVED HOSTS
declare -A saved_hosts
saved_hosts['one']=1.1.1.1
saved_hosts['goog']=google.com


#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
# INITIAL CHECKS

printHelp() {
	local column_format="\t\t %-14s%-5s%s\n"
	echo -e "\n\n\n"
	echo -e "\t Script that uses the 'nc' command in a loop to test connection to a specific port on a host.\n\n"
	echo -e "\t Usage:  $0 <host> <port> [time_interval]\n\n"
	echo -e "\t\t - The time interval between each test is an optional argument and it's in seconds. Default value is $interval seconds.\n\n\n"
	echo -e "\t These are the keywords for saved hosts:"
	for key in "${!saved_hosts[@]}" ; do
		printf "$column_format" "$key" "=" "${saved_hosts[$key]}"
	done
	echo -e "\n\t These are the keywords for saved ports that this script acceps:"
	for key in "${!saved_ports[@]}" ; do
		printf "$column_format" "$key" "=" "${saved_ports[$key]}"
	done
	echo -e "\n\n"
}

if [ $# -gt 0 ] && ([ $1 = "-h" ] || [ $1 = "-help" ] || [ $1 = "--help" ]); then
	# if first argument is one of the above

	printHelp
	exit 0

elif [ $# -lt 2 ] || [ $# -gt 3 ] ; then
	# if number of arguments is not 2 or 3

	printHelp
	exit 1

elif [ $# -eq 3 ] ; then
	if [ $3 -eq $3 2> /dev/null ] && [ $3 -ge 0 ] ; then
		# test if third argument is an integer and that it is above zero

		interval=$3
	else
		echo -e "\n\n\t Error: The 3rd argument must an integer above or equal to zero!\n\n"
		exit 2
	fi
fi

if [ $1 -eq $1 2> /dev/null ] ; then	# suppress the error message of this test if $1 is not an integer
	# if it's an integer 

	echo -e "\n\n\t Error: The 1st argument must an IP or hostname!\n\n"
	exit 2
fi

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
# GET HOST

host="0"

for key in "${!saved_hosts[@]}" ; do
	if [ "$key" = "$1" ] ; then
		host=${saved_hosts[$key]}	# check if the first argument is one of the saved hosts
	fi
done

if [ "$host" = "0" ] ; then
	host=$1
fi

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
# GET PORT

port=0

for key in "${!saved_ports[@]}" ; do
	if [ "$key" = "$2" ] ; then
		port=${saved_ports[$key]}	# check if second argument is one of the saved ports
	fi
done

if [ $port -eq 0 ] ; then
	if [ $2 -eq $2 2> /dev/null ] && [ $2 -gt 0 ] && [ $2 -le 65535 ] ; then
		# test if it's an integer and if it is between the boundaries ]0, 65535]

		port=$2		# because the 'nc' command can take some ports as strings (http and https, for example) I
				# will not be testing if the port argument is an integer 
	else
		echo -e "\n\n\t Error: the port must be an integer between 1 and 65535!\n\n"
		exit 2
	fi
fi

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

echo -e "\n\n"
echo -e "\t IP Address   ----------------- $host"
echo -e "\t Destination Port   ----------- $port"
echo -e "\t Time Interval   -------------- $interval"
echo -e "\n\n"

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

for i in $( seq 0 $num_runs )
do
	output=$( nc -w $timeout -z -v $host $port 2>&1 )	# capture stderr of nc

	if [ $? -eq 1 ] ; then
		>&2 echo "[$(date '+%Y/%m/%d %H:%M:%S')]  [!]  Connection to $host on port $port timed out  [!]"   #print errors to stderr
		# the default error message from nc might be confusing to some users
	else
		echo "[$(date '+%Y/%m/%d %H:%M:%S')]  $output"		# if connection is successful or there is a special error
	fi

	sleep $interval
done

exit 0
