#!/bin/bash
############################################################
#  This script will automate the process of                #
#  Switching DMR Servers     		                   #
#                                                          #
#  VE3RD                              Created 2022/07/20   #
############################################################
set -o errexit
set -o pipefail
set -e


function currentserver(){
	Name=$(sed -nr "/^\[DMR Network\]/ { :l /^Name[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
	echo "Current Server = $Name"
}

function badparam() {
	echo "No Server String supplied"
	echo "Options = TGIF, MNET, STATUS"
	currentserver
  	exit
}


if [ -z "$1" ]; then
  badparam
fi

var="$1" 
VARIABLE=$(echo "$var" | tr '[:lower:]' '[:upper:]') 

Server="$VARIABLE"

if [ "$VARIABLE" == "MNET" ]; then
	Name="MNET_Network"
	Addr="mnet.hopto.org"
	Pwd=$(sed -nr "/^\[MNET\]/ { :l /^Password[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/passwords)
	sudo sed -i '/^\[/h;G;/DMR Network]/s/\(Type=\).*/\1Direct/m;P;d' /etc/mmdvmhost

elif [ "$VARIABLE" == "TGIF" ]; then
	Name="TGIF_Network"
	Addr="tgif.network"
	Pwd=$(sed -nr "/^\[TGIF\]/ { :l /^Password[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/passwords)
	sudo sed -i '/^\[/h;G;/DMR Network]/s/\(Type=\).*/\1Direct/m;P;d' /etc/mmdvmhost

elif [ "$VARIABLE" == "DMRGateway" ]; then
	Name="DMRGateway"
	Addr="127.0.0.1"
	Pwd="None"
	sudo sed -i '/^\[/h;G;/DMR Network]/s/\(Type=\).*/\1Gateway/m;P;d' /etc/mmdvmhost

elif [ "$VARIABLE" == "STATUS" ]; then
	currentserver
else
  badparam

fi

sudo sed -i '/^\[/h;G;/DMR Network]/s/\(Name=\).*/\1'"$Name"'/m;P;d' /etc/mmdvmhost
sudo sed -i '/^\[/h;G;/DMR Network]/s/\(Address=\).*/\1'"$Addr"'/m;P;d' /etc/mmdvmhost
sudo sed -i '/^\[/h;G;/DMR Network]/s/\(Password=\).*/\1'"$Pwd"'/m;P;d' /etc/mmdvmhost
 
echo "Sleeping 5 Seconds "
sleep 5
currentserver
echo "restarting MMDVMHost"
sudo mmdvmhost.service restart
