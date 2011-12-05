#!/bin/bash

#This script will be a cronjob that will update the dns records of dnsmasq so that guzzoni.apple.com always points to our ip address

#This is a domain that points to our current ip (Dynamic)
domain=xtremd.no-ip.org

#This script uses commands that must be used as root or someone with superuser privs
#  Check if we are root
if [[ $EUID -ne 0 ]]; then
   echo "ERROR! Insufficient privlages. Run this script again as root. E.G use sudo"
   echo "ERROR! Script killed."   
exit 1
fi


#Stole the domain lookup script from arulmozhi at http://ubuntuexplore.blogspot.com/2010/05/ubuntu-how-to-get-ip-addressowener-of.html
#Thanks a million dude!
dynamicIpAddress=$(host $domain | grep 'has add' | head -1 | awk '{ print $4}')

#print out a debug message
echo "Our IP address is: $dynamicIpAddress"

#Set our dnsmasq resolve file to the correct ip address
echo "Restarting dnsmasq with our newly aquired IP address for the guzzoni.apple.com url"

#Stop dnsmasq
killall dnsmasq

#check if the command went through
if [ $? -eq 0 ] ; then
echo "dnsmasq stopped sucessfully!"

else
echo "ERROR! Service stopper exited with code $?. Was dnsmasq not already running?"
echo "Trying to restart dnsmasq anyway...."
fi

#Restart dnsmasq
dnsmasq --address=/guzzoni.apple.com/$dynamicIpAddress

if [ $? -eq 0 ] ; then
echo "dnsmasq started sucessfully!"
echo "Script done."
exit 0

else
echo "ERROR! dnsmasq started with code $?"
echo "ERROR! Script killed."
exit 1
fi
