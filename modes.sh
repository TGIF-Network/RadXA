#!/bin/bash
############################################################
#  This script will automate the process of                #
#  Switching Modes in /etc/mmdvmhost   	                   #
#                                                          #
#  VE3RD                              Created 2022/07/29   #
############################################################
#set -o errexit
#set -o pipefail
#set -e
export NCURSES_NO_UTF8_ACS=1
clear
m1=$(sed -nr "/^\[D-Star\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
m3=$(sed -nr "/^\[DMR\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
m5=$(sed -nr "/^\[System Fusion\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
m7=$(sed -nr "/^\[NXDN\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
m9=$(sed -nr "/^\[P25\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)


DStar=0
DMR=0
YSF=0
NXDN=0
P25=0



#echo "$m1 $m2 $m3 $m4 $m5"
if [ "$m1" == "1" ]; then 
	m1="ON"
	m2="OFF"
else 
	m1="OFF" 
	m2="ON"
fi

if [ "$m3" == "1" ]; then 
	m3="ON"
	m4="OFF"
else 
	m3="OFF"
	m4="ON"
fi

if [ "$m5" == "1" ]; then 
	m5="ON"
	m6="OFF"
else 
	m5="OFF"
	m6="ON" 
fi

if [ "$m7" == "1" ]; then 
	m7="ON"
	m8="OFF"
else 
	m7="OFF"
	m8="ON" 
fi

if [ "$m9" == "1" ]; then 
	m9="ON"
	m10="OFF"
else 
	m9="OFF"
	m10="ON" 
fi


 #sudo sed -i '/^\[/h;G;/D-Star/s/\(Enable=\).*/\1'"$2"'/m;P;d'  /etc/mmdvmhost
 #sudo sed -i '/^\[/h;G;/D-Star Network/s/\(Enable=\).*/\1'"$2"'/m;P;d'  /etc/mmdvmhost



declare -a choices=( $(dialog \
		--ascii-lines \
                --backtitle "  Operational Mode Selector  " \
                --title "  Main Modes  " \
                --checklist " Choose Modes to Enable:" 30 30 12 \
                1 "DStar On" "$m1" \
                2 "DMR On" "$m3" \
                3 "YSF On" "$m5" \
                4 "NXDN On" "$m7" \
                5 "P25 On" "$m9" 2>&1 >/dev/tty) )
CS=0
for sel in "${choices[@]}"; do
    case "$sel" in
        1) DStar="1"
		CS=1
	;;
        2) DMR="1"
		CS=1
	;;
        3) YSF="1"
		CS=1
	;;
        4) NXDN="1"
		CS=1
	;;
       	5) P25="1"
		CS=1
   	;;
     	*) echo "Unknown option!"
		CS=0
		clear
		exit
	;;
    esac
done

if [ "$CS" == "1" ]; then
clear
if [ "$DStar" == "1" ]; then
       echo "DStar Mode selected ON"
		sudo sed -i '/^\[/h;G;/D-Star/s/\(Enable=\).*/\11/m;P;d'  /etc/mmdvmhost	
else
       echo "DStar Mode selected OFF"
		sudo sed -i '/^\[/h;G;/D-Star/s/\(Enable=\).*/\10/m;P;d'  /etc/mmdvmhost	
fi

if [ "$DMR" == "1" ]; then
	echo "DMR Mode selected ON"
		sudo sed -i '/^\[/h;G;/DMR/s/\(Enable=\).*/\11/m;P;d'  /etc/mmdvmhost
else
	echo "DMR Mode selected OFF"
		sudo sed -i '/^\[/h;G;/DMR/s/\(Enable=\).*/\10/m;P;d'  /etc/mmdvmhost

fi

if [ "$YSF" == "1" ]; then
	echo "YSF Mode selected ON"
		sudo sed -i '/^\[/h;G;/System Fusion/s/\(Enable=\).*/\11/m;P;d'  /etc/mmdvmhost
else
    	echo "YSF Mode selected OFF"
		sudo sed -i '/^\[/h;G;/System Fusion/s/\(Enable=\).*/\10/m;P;d'  /etc/mmdvmhost
fi

if [ "$NXDN" == "1" ]; then
	echo "NXDN Mode selected ON"
		sudo sed -i '/^\[/h;G;/NXDN/s/\(Enable=\).*/\11/m;P;d'  /etc/mmdvmhost
else
	echo "NXDN Mode selected OFF"
		sudo sed -i '/^\[/h;G;/NXDN/s/\(Enable=\).*/\10/m;P;d'  /etc/mmdvmhost
fi

if [ "$P25" == "1" ]; then
	echo "P25 Mode selected ON"
		sudo sed -i '/^\[/h;G;/P25/s/\(Enable=\).*/\11/m;P;d'  /etc/mmdvmhost
else
	echo "P25 Mode selected OFF"
		sudo sed -i '/^\[/h;G;/P25/s/\(Enable=\).*/\10/m;P;d'  /etc/mmdvmhost
fi

fi



