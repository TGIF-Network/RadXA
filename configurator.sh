#!/bin/bash
############################################################
#  This script will automate the process of                #
#  Configring MMDVMHost 		   	           #
#                                                          #
#  VE3RD                              Created 2022/08/01   #
############################################################
#set -o errexit
#set -o pipefail
#set -e
export NCURSES_NO_UTF8_ACS=1
clear
echo -e "\e[1;97;44m"
tput setab 4
clear

: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}

CallSign=""
DID=""

RED='\033[0;31m'
NC='\033[0m' # No Color
#printf "I ${RED}love${NC} Stack Overflow\n"

function exitcode
{
txt='Abort Function\n\n
This Script will Now Stop'"\n$exittext"

dialog --title "  Programmed Exit  " --ascii-lines --msgbox "$txt" 8 78

tput setab 9 mode="" clear echo -e '\e[1;40m' run="Done" exit

}

function CheckMode(){
md1=$(sed -nr "/^\[D-Star\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
md2=$(sed -nr "/^\[P25\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
md3=$(sed -nr "/^\[System Fusion\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
md4=$(sed -nr "/^\[NXDN\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
md5=$(sed -nr "/^\[P25\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
tm1="OFF"
tm2="OFF"
tm3="OFF"
tm4="OFF"
tm5="OFF"

if [ "$md1" == "1" ]; then
	tmode="D-Star"
	tm1="ON"
	return
elif [ "$md2" == "1" ]; then
        tmode="P25"
	tm2="ON"
        return
elif [ "$md3" == "1" ]; then
        tmode="D-Star"
	tm3="ON"
        return
elif [ "$md3" == "1" ]; then
        tmode="D-Star"
	tm4="ON"
        return
elif [ "$md3" == "1" ]; then
        tmode="D-Star"
	tm5="ON"
        return
else
	tmode="P25"
	tm2="ON"
fi
}

function CheckDisplay(){
d=$(sed -nr "/^\[General\]/ { :l /Display[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d1="OFF"
d2="OFF"
d3="OFF"
d4="OFF"
d5="OFF"
d6="OFF"

case "$d" in
  "None") d1="ON" ;;
  "OLED") d2="ON" ;;
  "Nextion") d4="ON" ;;
  "HD44780") d5="ON" ;;
  *) d6="ON" ;;
esac

}

function EditLog(){
#3
echo "Setting Varibles"
l1=$(sed -nr "/^\[Log\]/ { :l /DisplayLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
l2=$(sed -nr "/^\[Log\]/ { :l /FileLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
l3=$(sed -nr "/^\[Log\]/ { :l /FilePath[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
l4=$(sed -nr "/^\[Log\]/ { :l /FileRoot[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
l5=$(sed -nr "/^\[Log\]/ { :l /FileRotate[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)

exec 3>&1
  Logd=$(dialog  \
        --title "MMDVM Log Section" \
	--ok-label "Submit" \
        --backtitle "MMDVM Host Configurator - VE3RD" \
        --ascii-lines \
        --mixedform "MMDVM Log  Configuration Items (Editable)" \
        20 50 0 \
        "DisplayLevel"	1 1 "$l1"  1 15 35 0 0 \
        "FileLevel"  	2 1 "$l2"  2 15 35 0 0 \
        "FilePath"  	3 1 "$l3"  3 15 35 0 0 \
        "FileRoot"  	4 1 "$l4"  4 15 35 0 2 \
        "FileRotate"  	5 1 "$l5"  5 15 35 0 0 \
	2>&1 1>&3)


errorcode=$?
if [ $errorcode -eq 1 ]; then
   dialog --ascii-lines --infobox "Cancel selected - Sleeping 2 seconds" 10 40 ; sleep 2
 	echo "$errorcode"
	MenuMain
fi

DisplayLevel=$(echo "$Logd" | sed -n '1p' )
FileLevel=$(echo "$Logd"  | sed -n '2p' )
FilePath=$(echo "$Logd"  | sed -n '3p' )
FileRoot=$(echo "$Logd"  | sed -n '4p' )
FileRotate=$(echo "$Logd"  | sed -n '5p' )

if [ -z $FilePath ]; then
   dialog --ascii-lines --infobox "Bad Data - Aborting - Sleeping 2 seconds" 10 40 ; sleep 2
  MenuMain
fi

if [ "$DisplayLevel" != "$l1" ]; then 
        sudo sed -i '/^\[/h;G;/Log]/s/\(DisplayLevel=\).*/\1'"$DisplayLevel"'/m;P;d' /etc/mmdvmhost
fi
if [ "$FileLevel" != "$l2" ]; then 
        sudo sed -i '/^\[/h;G;/Log]/s/\(FileLevel=\).*/\1'"$FileLevel"'/m;P;d' /etc/mmdvmhost
fi
if [ "$FilePath" != "$l3" ]; then 
 # FROM=$(echo "$d8" | sed "s/\//\\\\\//g")
  TO=$(echo "$FilePath" | sed "s/\//\\\\\//g")
#  sed -i "/^\[Log\]/,/^$/s/^FilePath=$FROM/FilePath=$TO/" /etc/p25gateway
        sudo sed -i '/^\[/h;G;/Log]/s/\(FilePath=\).*/\1'"$TO"'/m;P;d' /etc/mmdvmhost
fi
if [ "$FileRotate" != "$l5" ]; then 
        sudo sed -i '/^\[/h;G;/Log]/s/\(FileRotate=\).*/\1'"$FileRotate"'/m;P;d' /etc/mmdvmhost
fi

MenuMain
}

function EditGeneral(){
#1
eg1=$(sed -nr "/^\[General\]/ { :l /Callsign[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
eg2=$(sed -nr "/^\[General\]/ { :l /Id[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
eg3=$(sed -nr "/^\[General\]/ { :l /Timeout[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
eg4=$(sed -nr "/^\[General\]/ { :l /Duplex[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
eg5=$(sed -nr "/^\[General\]/ { :l /RFModeHang[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
eg6=$(sed -nr "/^\[General\]/ { :l /NetModeHang[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
eg7=$(sed -nr "/^\[General\]/ { :l /Display[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
eg8=$(sed -nr "/^\[General\]/ { :l /Daemon[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)

returncode=0
returncode=$?
exec 3>&1

Gen=$(dialog  --ascii-lines \
        --backtitle "MMDVM Host Configurator - VE3RD" \
	--separate-widget  $'\n'   \
	--ok-label "Save" \
	--title "General Section" \
	--form "\n MMDVM General Configuration Items (Editable)" 20 70 12\
	"Callsign"  	1 1 "$eg1"  1 15 35 0 \
	"Id"  		2 1 "$eg2"  2 15 35 0 \
	"Timeout" 	3 1 "$eg3"  3 15 35 0 \
	"Duplex"  	4 1 "$eg4"  4 15 35 0 \
	"RFModeHang"  	5 1 "$eg5"  5 15 35 0 \
	"NetModeHang"  	6 1 "$eg6"  6 15 35 0 \
	"Display"  	7 1 "$eg7"  7 15 35 0 \
	"Daemon"  	8 1 "$eg8"  8 15 35 0 \
 	2>&1 1>&3)

returncode=$?

#echo "$Gen"
Callsign=$(echo "$Gen" | sed -n '1p')
echo "$Callsign"
echo "Return Code = $returncode"

if [  $returncode -nq 0 ]; then 
   echo "Abort 1 Cancel " 
	dialog --ascii-lines --infobox "Cancel Selected - Function Aborted\nSleeping 2 seconds" 10 40 ; sleep 2
 	MenuMain
fi

if [ -z "$Callsign" ]; then 
	echo "Nodata"
        dialog --ascii-lines --infobox " No Call Sign - Function Aborted\nSleeping 2 seconds" 10 40 ; sleep 2
        MenuMain
fi


Id=$(echo "$Gen" | sed -n '2p' )
Timeout=$(echo "$Gen"  | sed -n '3p' )
Duplex=$(echo "$Gen"  | sed -n '4p' )
RFModeHang=$(echo "$Gen"  | sed -n '5p' )
NetModeHang=$(echo "$Gen"  | sed -n '6p')
Display=$(echo "$Gen"  | sed -n '7p' )
Daemon=$(echo "$Gen" | sed -n '8p' )

echo "All Good Ready to Write Data"

##  Write Values Back
if [ "$Callsign" != "$eg1" ]; then 
        sudo sed -i '/^\[/h;G;/General]/s/\(Callsign=\).*/\1'"$Callsign"'/m;P;d' /etc/mmdvmhost
fi
if [ "$Id" != "$eg2" ]; then 
        sudo sed -i '/^\[/h;G;/General]/s/\(Id=\).*/\1'"$Id"'/m;P;d' /etc/mmdvmhost
fi
if [ "$Timeout" != "$eg3" ]; then 
        sudo sed -i '/^\[/h;G;/General]/s/\(Timeout=\).*/\1'"$Timeout"'/m;P;d' /etc/mmdvmhost
fi
if [ "$Duplex" != "$eg4" ]; then 
        sudo sed -i '/^\[/h;G;/General]/s/\(Duplex=\).*/\1'"$Duplex"'/m;P;d' /etc/mmdvmhost
fi
if [ "$RFModeHang" != "$eg5" ]; then 
        sudo sed -i '/^\[/h;G;/General]/s/\(RFModeHang=\).*/\1'"$RFModeHang"'/m;P;d' /etc/mmdvmhost
fi
if [ "$NetModeHang" != "$eg6" ]; then 
        sudo sed -i '/^\[/h;G;/General]/s/\(NetModeHang=\).*/\1'"$NetModeHang"'/m;P;d' /etc/mmdvmhost
fi
if [ "$Display" != "$eg7" ]; then 
        sudo sed -i '/^\[/h;G;/General]/s/\(Display=\).*/\1'"$Display"'/m;P;d' /etc/mmdvmhost
fi
if [ "$Daemon" != "$eg8" ]; then 
        sudo sed -i '/^\[/h;G;/General]/s/\(Daemon=\).*/\1'"$Daemon"'/m;P;d' /etc/mmdvmhost
fi
  

MenuMain
}





function EditModem(){
#4

mm1=$(sed -nr "/^\[Modem\]/ { :l /^Port[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm2=$(sed -nr "/^\[Modem\]/ { :l /^TXDelay[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm3=$(sed -nr "/^\[Modem\]/ { :l /^RXOffset[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm4=$(sed -nr "/^\[Modem\]/ { :l /^TXOffset[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm5=$(sed -nr "/^\[Modem\]/ { :l /^DMRDelay[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm6=$(sed -nr "/^\[Modem\]/ { :l /^RXLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm7=$(sed -nr "/^\[Modem\]/ { :l /^TXLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm8=$(sed -nr "/^\[Modem\]/ { :l /RFLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm9=$(sed -nr "/^\[Modem\]/ { :l /DMRTXLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm10=$(sed -nr "/^\[Modem\]/ { :l /YSFTXLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm11=$(sed -nr "/^\[Modem\]/ { :l /P25TXLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm12=$(sed -nr "/^\[Modem\]/ { :l /NXDNTXLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm13=$(sed -nr "/^\[Modem\]/ { :l /Trace[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm14=$(sed -nr "/^\[Modem\]/ { :l /^UARTPort[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm15=$(sed -nr "/^\[Modem\]/ { :l /UARTSpeed[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
exec 3>&1

Modems=$(dialog  --ascii-lines \
        --backtitle "MMDVM Host Configurator - VE3RD" \
        --separate-widget  $'\n'   \
        --ok-label "Save" \
        --title "Modem Section" \
        --mixedform "\n Modem Configuration Items (Editable)" 20 70 12\
        "Port"        1 1 "$mm1"               1 25 35 0 0 \
        "TXDelay"     2 1 "$mm2"               2 25 35 0 0 \
        "RXOffset"    3 1 "$mm3"               3 25 35 0 0 \
        "TXOffset"    4 1 "$mm4"               4 25 35 0 0 \
        "DMRDelay"    5 1 "$mm5"       	      5 25 35 0 0 \
        "RXLevel"     6 1 "$mm6"               6 25 35 0 0 \
        "TXLevel"     7 1 "$mm7"               7 25 35 0 0 \
        "RFLevel"     8 1 "$mm8"               8 25 35 0 0 \
        "DMRTXLevel"  9 1 "$mm9"               9 25 35 0 0 \
        "YSFTXLevel"  10 1 "$mm10"              10 25 35 0 0 \
        "P25TXLevel"  11 1 "$mm11"              11 25 35 0 0 \
        "NXDNTXLevel" 12 1 "$mm12"              12 25 35 0 0 \
        "Trace"       13 1 "$mm13"              13 25 35 0 0 \
        "UARTPort"    14 1 "$mm14"              14 25 35 0 0 \
        "UARTSpeed"   15 1 "$mm15"              15 25 35 0 0 \
 	2>&1 1>&3)

returncode=$?

#echo "$Gen"
Port=$(echo "$Modems" | sed -n '1p')
echo "Return Code = $returncode"


if [  $returncode -eq 1 ]; then 
   echo "Abort 1 Cancel " 
	dialog --ascii-lines --infobox "Cancel Selected - Function Aborted\nSleeping 2 seconds" 10 40 ; sleep 2
 	MenuMain
fi

dialog \
        --backtitle "MMDVM Host Configurator - VE3RD" \
	--title " Edit Modem Parameters "  \
	--ascii-lines --msgbox "This function uder development\nData Write Not Yet Implemented" 13 50 ; sleep 2

result=$?
echo "$result"
MenuMain
}

function EditDMR(){
#5
echo "Setting Varibles"
d1=$(sed -nr "/^\[DMR\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d2=$(sed -nr "/^\[DMR\]/ { :l /CallHang[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d3=$(sed -nr "/^\[DMR\]/ { :l /TXHang[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d4=$(sed -nr "/^\[DMR\]/ { :l /Id[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d5=$(sed -nr "/^\[DMR Network\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d6=$(sed -nr "/^\[DMR Network\]/ { :l /Address[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d7=$(sed -nr "/^\[DMR Network\]/ { :l /ModeHang[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d8=$(sed -nr "/^\[DMR Network\]/ { :l /Type[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d9=$(sed -nr "/^\[DMR Network\]/ { :l /Port[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d10=$(sed -nr "/^\[DMR Network\]/ { :l /LocalPort[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)

echo "Varibales all set"

exec 3>&1

DMRs=$(dialog  --ascii-lines \
        --backtitle "MMDVM Host Configurator - VE3RD" \
	--extra-button \
	--extra-label "Options" \
        --separate-widget  $'\n'   \
        --ok-label "Save" \
        --title "DMR Section" \
        --mixedform "\n DMR Configuration Items (Editable)" 20 70 12\
        "DMR General"   1 1 "General" 	 	1 25 35 0 2 \
        "Enable"      	2 1 "$d1" 	 	2 25 35 0 0 \
        "CallHang"    	3 1 "$d2" 	 	3 25 35 0 0 \
        "TXHang" 	4 1 "$d3" 	 	4 25 35 0 0 \
        "Id x9"         5 1 "$d4"  	 	5 25 35 0 0 \
        "DMR Network"   6 1 "DMR Network" 	6 25 35 0 2 \
        "Enable"    	7 1 "$d5" 	 	7 25 35 0 0 \
        "Address"   	8 1 "$d6" 	 	8 25 35 0 0 \
        "ModeHang"  	9 1 "$d7" 	 	9 25 35 0 0 \
        "Type"         10 1 "$d8" 	       10 25 35 0 0 \
        "Port"         11 1 "$d9" 	       11 25 35 0 0 \
        "LocalPort"    10 1 "$d10"	       12 25 35 0 0 \
         2>&1 1>&3 )

returncode=$?

if [ $returncode -eq 1 ]; then 
   echo "Abort 1" 
	dialog --ascii-lines --infobox "Cancel Selected1 - Function Aborted\nSleeping 2 seconds" 10 40 ; sleep 2
	MenuMain
fi



Enable=$(echo "$DMRs" | sed -n '1p' )
CallHang=$(echo "$DMRs" | sed -n '2p' )
TXHang=$(echo "$DMRs"  | sed -n '3p' )
Id=$(echo "$DMRs"  | sed -n '4p' )
NetEnable=$(echo "$DMRs"  | sed -n '5p' )
NetAddress=$(echo "$DMRs"  | sed -n '6p')
NetModeHang=$(echo "$DMRs"  | sed -n '7p' )
NetType=$(echo "$DMRs" | sed -n '8p' )
NetPort=$(echo "$DMRs" | sed -n '9p' )
NetLocalPort=$(echo "$DMRs" | sed -n '10p' )

echo "NetAddress = $NetAddress"
echo "All Good Ready to Write Data"

##  Write Values Back
if [ "$Enable" != "$d1" ]; then
        sudo sed -i '/^\[/h;G;/DMR]/s/\(Enable=\).*/\1'"$Enable"'/m;P;d' /etc/mmdvmhost
fi
if [ "$CallHang" != "$d2" ]; then
        sudo sed -i '/^\[/h;G;/DMR]/s/\(CallHang=\).*/\1'"$CallHang"'/m;P;d' /etc/mmdvmhost
fi
if [ "$TXHang" != "$d3" ]; then
        sudo sed -i '/^\[/h;G;/DMR]/s/\(TXHang=\).*/\1'"$TXHang"'/m;P;d' /etc/mmdvmhost
fi
if [ "$Id" != "$d4" ]; then
        sudo sed -i '/^\[/h;G;/DMR]/s/\(Id=\).*/\1'"$Id"'/m;P;d' /etc/mmdvmhost
fi
if [ "$NetEnable" != "$d5" ]; then
        sudo sed -i '/^\[/h;G;/DMR Network]/s/\(Enable=\).*/\1'"$NetEnable"'/m;P;d' /etc/mmdvmhost
fi
if [ "$NetAddress" != "$d6" ]; then
        sudo sed -i '/^\[/h;G;/DMR Network]/s/\(Address=\).*/\1'"$NetAddress"'/m;P;d' /etc/mmdvmhost
        sudo sed -i '/^\[/h;G;/DMR Network]/s/\(RemoteAddress=\).*/\1'"$NetAddress"'/m;P;d' /etc/mmdvmhost
fi
if [ "$NetModeHang" != "$d7" ]; then
        sudo sed -i '/^\[/h;G;/DMR Network]/s/\(ModeHang=\).*/\1'"$NetModeHang"'/m;P;d' /etc/mmdvmhost
fi
if [ "$NetType" != "$d8" ]; then
        sudo sed -i '/^\[/h;G;/DMR Network]/s/\(Type=\).*/\1'"$NetType"'/m;P;d' /etc/mmdvmhost
fi
if [ "$NetPort" != "$d9" ]; then
        sudo sed -i '/^\[/h;G;/DMR Network]/s/\(Port=\).*/\1'"$NetPort"'/m;P;d' /etc/mmdvmhost
        sudo sed -i '/^\[/h;G;/DMR Network]/s/\(RemotePort=\).*/\1'"$NetPort"'/m;P;d' /etc/mmdvmhost
        sudo sed -i '/^\[/h;G;/DMR Network]/s/\(LocalPort=\).*/\1'"$NetPort"'/m;P;d' /etc/mmdvmhost
fi
if [ "$NetLocalPort" != "$d10" ]; then
        sudo sed -i '/^\[/h;G;/DMR Networl]/s/\(LocalPort=\).*/\1'"$NetLocalPort"'/m;P;d' /etc/mmdvmhost
fi

echo "Data Write OK"
	
dialog --ascii-lines --infobox "DMR Data Write Complete " 10 30 ; sleep 1


MenuMain
}

function EditP25(){
#6

echo "Setting Varibles"
#P25 Section
d1=$(sed -nr "/^\[P25\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d2=$(sed -nr "/^\[P25\]/ { :l /NAC[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d3=$(sed -nr "/^\[P25\]/ { :l /ModeHang[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d4=$(sed -nr "/^\[P25\]/ { :l /TXHang[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
#P25 Network
d5=$(sed -nr "/^\[P25 Network\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
d6=$(sed -nr "/^\[P25 Network\]/ { :l /ModeHang[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)

#P25 Gateway 
# Network Section
d7=$(sed -nr "/^\[General\]/ { :l /Callsign[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/p25gateway)
d8=$(sed -nr "/^\[Log\]/ { :l /FilePath[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/p25gateway)
d9=$(sed -nr "/^\[Log\]/ { :l /DisplayLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/p25gateway)
d10=$(sed -nr "/^\[Log\]/ { :l /FileLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/p25gateway)
d11=$(sed -nr "/^\[Network\]/ { :l /HostsFile1[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/p25gateway)
d12=$(sed -nr "/^\[Network\]/ { :l /HostsFile2[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/p25gateway)
d13=$(sed -nr "/^\[Network\]/ { :l /P252DMRAddress[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/p25gateway)
d14=$(sed -nr "/^\[Network\]/ { :l /P252DMRPort[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/p25gateway)
d15=$(sed -nr "/^\[Network\]/ { :l /Static[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/p25gateway)
d16=$(sed -nr "/^\[Network\]/ { :l /RFHangTime[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/p25gateway)
d17=$(sed -nr "/^\[Network\]/ { :l /NetHangTime[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/p25gateway)

echo "Varibales all set"

returncode=0
returncode=$?
exec 3>&1

#echo "Default DIALOG_CANCEL = $DIALOG_CANCEL"
#echo "Default DIALOG_OK = $DIALOG_OK"


P25d=$(dialog  --ascii-lines \
        --backtitle "MMDVM Host Configurator - VE3RD" \
        --separate-widget  $'\n'   \
        --ok-label "Save" \
        --title "P25 Section" \
        --mixedform "\n P25 Configuration Items (Editable)" 30 70 25\
        "P25 General"     	1 1 "General"  	1 25 35 0 2 \
        "Enable"        	2 3 "$d1"  	2 25 35 0 0 \
        "NAC"           	3 3 "$d2"  	3 25 35 0 0 \
        "ModeHang"      	4 3 "$d3"  	4 25 35 0 0 \
        "TXHang"        	5 3 "$d4"  	5 25 35 0 0 \
        "P25 Network"   	6 1 "Network" 	6 25 35 0 2 \
        "Enable"        	7 3 "$d5"  	7 25 35 0 0 \
        "ModeHang"      	8 3 "$d6"  	8 25 35 0 0 \
        "P25Gateway General"   	9 1 "General"  	9 25 35 0 2 \
        "Callsign"             10 3 "$d7"      10 25 35 0 0 \
        "P25Gateway Log"       11 1 "Log"      11 25 35 0 2 \
        "FilePath"             12 3 "$d8"      12 25 35 0 0 \
        "DisplayLevel"         13 3 "$d9"      13 25 35 0 0 \
        "FileLevel"            14 3 "$d10"     14 25 35 0 0 \
        "P25Gateway Network"   15 1 "Network"  15 25 35 0 2 \
        "HostsFile1"           16 3 "$d11"     16 25 35 0 0 \
        "HostsFile2"           17 3 "$d12"     17 25 35 0 0 \
        "P252DMRAddress"       18 3 "$d13"     18 25 35 0 0 \
        "P252DMRPort"          19 3 "$d14"     19 25 35 0 0 \
        "Static Talk Group"    20 3 "$d15"     20 25 35 0 0 \
        "RFHangTime"           21 3 "$d16"     21 25 35 0 0 \
        "NetHangTime"          22 3 "$d17"     22 25 35 0 0 \
 	2>&1 1>&3)

returncode=$?

if [ $returncode -eq 1 ]; then
   echo "Abort 2 - Return Code = 1"
        dialog --ascii-lines --infobox "Cancel Selected - Function Aborted!"
	MenuMain
fi
if [ $returncode -eq 0 ]; then
   echo "All OK - Return Code = 0"
        dialog --ascii-lines --infobox "P25 Updating P25 Parameters"
fi

Enable1=$(echo "$P25d" | sed -n '2p')
NAC=$(echo "$P25d" | sed -n '3p')
ModeHang1=$(echo "$P25d" | sed -n '4p')
TXHang1=$(echo "$P25d" | sed -n '5p')

#P25 Network
Enable2=$(echo "$P25d" | sed -n '7p')
ModeHang2=$(echo "$P25d" | sed -n '8p')

#P25Gateway General
Callsign=$(echo "$P25d" | sed -n '10p')

#P25Gateway Log
FilePath=$(echo "$P25d" | sed -n '12p')
DisplayLevel=$(echo "$P25d" | sed -n '13p')
FileLevel=$(echo "$P25d" | sed -n '14p')

#P25Gateway Network
HostsFile1=$(echo "$P25d" | sed -n '16p')
HostsFile2=$(echo "$P25d" | sed -n '17p')
P252DMRAddress=$(echo "$P25d" | sed -n '18p')
P252DMRPort=$(echo "$P25d" | sed -n '19p')
Static=$(echo "$P25d" | sed -n '20p')
RFHangTime=$(echo "$P25d" | sed -n '21p')
NetHangTime=$(echo "$P25d" | sed -n '22p')


if [ "$Enable" != "$d1" ]; then
        sudo sed -i '/^\[/h;G;/P25]/s/\(Enable=\).*/\1'"$Enable1"'/m;P;d' /etc/mmdvmhost
fi
if [ "$NAC" != "$d2" ]; then
        sudo sed -i '/^\[/h;G;/P25]/s/\(NAC=\).*/\1'"$NAC"'/m;P;d' /etc/mmdvmhost
fi
if [ "$ModeHang" != "$d3" ]; then
        sudo sed -i '/^\[/h;G;/P25]/s/\(ModeHang=\).*/\1'"$ModeHang1"'/m;P;d' /etc/mmdvmhost
fi
if [ "$TXHang" != "$d4" ]; then
        sudo sed -i '/^\[/h;G;/P25]/s/\(TXHang=\).*/\1'"$TXHang1"'/m;P;d' /etc/mmdvmhost
fi
if [ "$Enable" != "$d5" ]; then
        sudo sed -i '/^\[/h;G;/P25 Network]/s/\(Enable=\).*/\1'"$Enable2"'/m;P;d' /etc/mmdvmhost
fi
if [ "$ModeHang" != "$d6" ]; then
        sudo sed -i '/^\[/h;G;/P25 Network]/s/\(ModeHang=\).*/\1'"$ModeHang2"'/m;P;d' /etc/mmdvmhost
fi
if [ "$Callsign" != "$d7" ]; then
        sudo sed -i '/^\[/h;G;/General]/s/\(Callsign=\).*/\1'"$Callsign"'/m;P;d' /etc/p25gateway
fi

if [ "$FilePath" != "$d8" ]; then
  FROM=$(echo "$d8" | sed "s/\//\\\\\//g")
  TO=$(echo "$FilePath" | sed "s/\//\\\\\//g")
  sed -i "/^\[Log\]/,/^$/s/^FilePath=$FROM/FilePath=$TO/" /etc/p25gateway
fi
if [ "$DisplayLevel" != "$d9" ]; then
        sudo sed -i '/^\[/h;G;/Log]/s/\(DisplayLevel=\).*/\1'"$DisplayLevel"'/m;P;d' /etc/p25gateway
fi

if [ "$FileLevel" != "$d10" ]; then
        sudo sed -i '/^\[/h;G;/Log]/s/\(FileLevel=\).*/\1'"$FileLevel"'/m;P;d' /etc/p25gateway
fi

if [ "$HostsFile1" != "$d11" ]; then
  FROM=$(echo "$d11" | sed "s/\//\\\\\//g")
  TO=$(echo "$HostsFile1" | sed "s/\//\\\\\//g")
  sed -i "/^\[Network\]/,/^$/s/^HostsFile1=$FROM/HostsFile1=$TO/" /etc/p25gateway
fi
if [ "$HostsFile2" != "$d12" ]; then
  FROM=$(echo "$d12" | sed "s/\//\\\\\//g")
  TO=$(echo "$HostsFile2" | sed "s/\//\\\\\//g")
  sed -i "/^\[Network\]/,/^$/s/^HostsFile2=$FROM/HostsFile2=$TO/" /etc/p25gateway
fi
if [ "$P252DMRAddress" != "$d13" ]; then
        sudo sed -i '/^\[/h;G;/Network]/s/\(P252DMRAddress=\).*/\1'"$P252DMRAddress"'/m;P;d' /etc/p25gateway
fi
if [ "$P252DMRPort" != "$d14" ]; then
        sudo sed -i '/^\[/h;G;/Network]/s/\(P252DMRPort=\).*/\1'"$P252DMRPort"'/m;P;d' /etc/p25gateway
fi
if [ "$Static" != "$d15" ]; then
        sudo sed -i '/^\[/h;G;/Network]/s/\(Static=\).*/\1'"$Static"'/m;P;d' /etc/p25gateway
fi
if [ "$RFHangTime" != "$d16" ]; then
        sudo sed -i '/^\[/h;G;/Network]/s/\(RFHangTime=\).*/\1'"$RFHangTime"'/m;P;d' /etc/p25gateway
fi
if [ "$NetHangTime" != "$d17" ]; then
        sudo sed -i '/^\[/h;G;/Network]/s/\(NetHangTime=\).*/\1'"$NetHangTime"'/m;P;d' /etc/p25gateway
fi

dialog --ascii-lines --infobox "P25 Data Write Complete " 10 30 ; sleep 1

MenuMain
}

function EditNXDN(){
#7
dialog \
        --backtitle "MMDVM Host Configurator - VE3RD" \
	--title " Edit Nextion Sections "  \
	--ascii-lines --msgbox " This function not yet impemented" 13 50

result=$?
echo "$result"
MenuMain

}
function EditYSF(){
#8

echo "Setting Varibles"
#YSF Section
y1=$(sed -nr "/^\[System Fusion\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
y2=$(sed -nr "/^\[System Fusion\]/ { :l /LowDeviation[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
y3=$(sed -nr "/^\[System Fusion\]/ { :l /TXHang[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
y4=$(sed -nr "/^\[System Fusion\]/ { :l /ModeHang[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
#YSF Network Network
y5=$(sed -nr "/^\[System Fusion Network\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
y6=$(sed -nr "/^\[System Fusion Network\]/ { :l /ModeHang[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)

#YSF Gateway 
# General Section
y7=$(sed -nr "/^\[General\]/ { :l /Callsign[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y8=$(sed -nr "/^\[General\]/ { :l /Suffix[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y9=$(sed -nr "/^\[General\]/ { :l /WiresXCommandPassthrough[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y10=$(sed -nr "/^\[General\]/ { :l /Id[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y11=$(sed -nr "/^\[General\]/ { :l /Daemon[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
#Info Section
y12=$(sed -nr "/^\[Info\]/ { :l /RXFrequency[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y13=$(sed -nr "/^\[Info\]/ { :l /TXFrequency[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y14=$(sed -nr "/^\[Info\]/ { :l /Power[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y15=$(sed -nr "/^\[Info\]/ { :l /Latitude[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y16=$(sed -nr "/^\[Info\]/ { :l /Longitude[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y17=$(sed -nr "/^\[Info\]/ { :l /Name[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y18=$(sed -nr "/^\[Info\]/ { :l /Description[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)

#Log

y19=$(sed -nr "/^\[Log\]/ { :l /DisplayLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y20=$(sed -nr "/^\[Log\]/ { :l /FileLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y21=$(sed -nr "/^\[Log\]/ { :l /FilePath[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y22=$(sed -nr "/^\[Log\]/ { :l /FileRoot[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)

#Network
y23=$(sed -nr "/^\[Network\]/ { :l /Startup[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)

#YSF Network
y24=$(sed -nr "/^\[YSF Network\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)
y25=$(sed -nr "/^\[YSF Network\]/ { :l /Hosts[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/ysfgateway)



echo "Varibales all set"

returncode=0
returncode=$?
exec 3>&1

ysfd=$(dialog  --ascii-lines \
        --backtitle "MMDVM Host Configurator - VE3RD" \
        --separate-widget  $'\n'   \
        --ok-label "Save" \
        --title "YSF Section" \
        --mixedform "\n YSF Configuration Items (Editable)" 30 70 25\
        "YSF General"     	1 1 "YSF General"  		1 25 35 0 2 \
        "Enable"        	2 3 "$y1"  			2 25 35 0 0 \
        "LowDeviation"          3 3 "$y2"  			3 25 35 0 0 \
        "TXHang"	      	4 3 "$y3"  			4 25 35 0 0 \
        "ModeHang"        	5 3 "$y4"  			5 25 35 0 0 \
        "YSF Network"   	6 1 "YSF Network" 		6 25 35 0 2 \
        "Enable"        	7 3 "$y5"  			7 25 35 0 0 \
        "ModeHang"      	8 3 "$y6"  			8 25 35 0 0 \
        "YSFGateway General"   	9 1 "YSF Gateway General"  	9 25 35 0 2 \
        "Callsign"             	10 3 "$y7"      		10 25 35 0 0 \
        "Suffix"	       	11 3 "$y8"      		11 25 35 0 0 \
        "WiresXPassthrough"    	12 3 "$y9"      		12 25 35 0 0 \
        "Id"                   	13 3 "$y10"     		13 25 35 0 0 \
        "Daemon"               	14 3 "$y11"     		14 25 35 0 0 \
        "P25Gateway Info"      	15 1 "YSFGateway Info"  	15 25 35 0 2 \
        "RXFrequency"          	16 3 "$y12"     		16 25 35 0 0 \
        "TXFrequency"          	17 3 "$y13"     		17 25 35 0 0 \
        "Power"       		18 3 "$y14"     		18 25 35 0 0 \
        "Latitude"          	19 3 "$y15"     		19 25 35 0 0 \
        "Longitude"    		20 3 "$y16"     		20 25 35 0 0 \
        "Name"           	21 3 "$y17"     		21 25 35 0 0 \
        "Description"          	22 3 "$y18"     		22 25 35 0 0 \
        "YSFGateway Log"       	23 1 "YSFGateway Log"     	23 25 35 0 2 \
        "DisplayLevel"          24 3 "$y19"     		24 25 35 0 0 \
        "FileLevel"          	25 3 "$y20"     		25 25 35 0 0 \
        "FilePath"          	26 3 "$y21"     		26 25 35 0 0 \
        "FileRoot"          	27 3 "$y22"     		27 25 35 0 2 \
        "YSGGateway Network"   	28 1 "YSFGateway Network"     	28 25 35 0 2 \
        "Startup"          	29 3 "$y23"     		29 25 35 0 0 \
        "YSFGateway YSF Net"   	30 1 "$YSFGateway YSF Net"     	30 25 35 0 2 \
        "Hosts"          	31 3 "$y24"     		31 25 35 0 0 \
 	2>&1 1>&3)

returncode=$?

dialog \
        --backtitle "MMDVM Host Configurator - VE3RD" \
	--title " Edit Nextion Sections "  \
	--ascii-lines --msgbox " This function Under Construction\nData Writes Not Yet Enabled"  13 50

MenuMain

}

function MenuMaint()
{
if [ ! -d /etc/backups ]; then
  mkdir /etc/backups
fi


HEIGHT=25
WIDTH=40
CHOICE_HEIGHT=15
BACKTITLE="MMDVM Host Configurator - VE3RD"
TITLE="Maintnance Menu"
MENU="Choose one of the following options:"


MAINT=$(dialog --clear \
                --ascii-lines \
                --extra-button \
                --extra-label "MainMenu" \
                --cancel-label "EXIT" \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                1 "Backup Config Files" \
		2 "Restore Config Files" \
		3 "TBA" \
		4 "TBA" \
                2>&1 >/dev/tty)
exitcode=$?

if [ "$exitcode" -eq 3 ]; then
   echo "Exit 3 - Main Menu"
   MenuMain
fi
if [ "$exitcode" -eq 1 ]; then
  echo "Abort Cancel 1"
        dialog --ascii-lines --infobox "Cancel Selected - Exiting Script\nSleeping 2 seconds" 5 40 ; sleep 2
        exit
fi

echo "Exit Code = $exitcode"

echo "Choice = $MAINT"

if [ "$MAINT" -eq 1 ]; then
        echo "You chose Option 1 - Bacup Config Files"
		dates=$(date +%F)
                cp /etc/mmdvmhost /etc/backups/mmdvmhost"-$dates"
                cp /etc/ysfgateway /etc/backups/ysfgateway"-$dates"
                cp /etc/nxdngateway /etc/backups/nxdngateway"-$dates"
                cp /etc/p25gateway /etc/backups/p25gateway"-$dates"
                cp /etc/dmrgateway /etc/backups/dmrgateway"-$dates"
        	dialog --ascii-lines --infobox "Backups Complete - Reloading Menu" 5 40 ; sleep 2
		MenuMaint
fi
if [ "$MAINT" -eq 2 ]; then
       	echo "You chose Option 2 - Restore Config Files"

     F1=$(dialog \
        --ascii-lines \
        --title "Select a file" \
        --stdout \
        --title "Please choose a file" \
        --fselect /etc/backups/ 14 48 )

	exitcode=$?

	echo "Exit Code = $exitcode"
	echo "File = $F1"
        if [ ! -z "$F1" ]; then
 		bf=$(echo "$F1" | cut -d "-" -f 1 )
		fn=$(echo "$bf" | cut -d "/" -f 4 )	
           	echo "File to Backup = $bf"
			dest='/etc/'
	            	cp $bf $dest
			err=$?
		if [ $err -eq 0 ]; then
			dialog --ascii-lines --infobox "Backup Config File $F1\nRestored to $dest$fn" 5 60 ; sleep 5
		else
			dialog --ascii-lines --infobox "Restore Operation Failed" 5 40 ; sleep 2
		
		fi

	else
		echo "No File "
		dialog --ascii-lines --infobox "ERR - No File\nFunction Aborted" 5 40 ; sleep 2
        fi
fi

MenuMaint

}

function EditNextion(){
#10
n1=$(sed -nr "/^\[Nextion\]/ { :l /Port[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
n2=$(sed -nr "/^\[Nextion\]/ { :l /Brightness[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
n3=$(sed -nr "/^\[Nextion\]/ { :l /DisplayClock[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
n4=$(sed -nr "/^\[Nextion\]/ { :l /UTC[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
n5=$(sed -nr "/^\[Nextion\]/ { :l /ScreenLayout[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
n6=$(sed -nr "/^\[Nextion]/ { :l /IdleBrightness[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
n7=$(sed -nr "/^\[Nextion\]/ { :l /DisplayTempInFahrenheit[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)

nd1=$(sed -nr "/^\[NextionDriver\]/ { :l /Port[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd2=$(sed -nr "/^\[NextionDriver\]/ { :l /SendUserDataMask[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd3=$(sed -nr "/^\[NextionDriver\]/ { :l /DataFilesPath[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd4=$(sed -nr "/^\[NextionDriver\]/ { :l /LogLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd5=$(sed -nr "/^\[NextionDriver\]/ { :l /GroupsFile[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd6=$(sed -nr "/^\[NextionDriver\]/ { :l /DMRidFile[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd7=$(sed -nr "/^\[NextionDriver\]/ { :l /DMRidDelimiter[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd8=$(sed -nr "/^\[NextionDriver\]/ { :l /DMRidId[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd9=$(sed -nr "/^\[NextionDriver\]/ { :l /DMRidCall[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd10=$(sed -nr "/^\[NextionDriver\]/ { :l /DMRidName[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd11=$(sed -nr "/^\[NextionDriver\]/ { :l /DMRidX1[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd12=$(sed -nr "/^\[NextionDriver\]/ { :l /DMRidX2[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd13=$(sed -nr "/^\[NextionDriver\]/ { :l /DMRidX3[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd14=$(sed -nr "/^\[NextionDriver\]/ { :l /ShowModeStatus[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd15=$(sed -nr "/^\[NextionDriver\]/ { :l /RemoveDim[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd16=$(sed -nr "/^\[NextionDriver\]/ { :l /WaitForLan[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
nd17=$(sed -nr "/^\[NextionDriver\]/ { :l /SleepWhenInactive[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)


exec 3>&1

Next=$(dialog  --ascii-lines \
        --backtitle "MMDVM Host Configurator - VE3RD" \
        --separate-widget  $'\n'   \
        --ok-label "Save" \
        --title "Nextion Sections" \
        --mixedform "\n Nextion Configuration Items (Editable)" 30 70 30 \
        "Nextion"      		1 1 "General"   	1 20 35 0 2 \
        "Port"      		2 1 "$n1"   		2 20 35 0 0 \
        "Brightness"         	3 1 "$n2"   		3 20 35 0 0 \
        "DisplayClock"        	4 1 "$n3"   		4 20 35 0 0 \
        "UTC"         		5 1 "$n4"   		5 20 35 0 0 \
        "ScreenLayout"      	6 1 "$n5"   		6 20 35 0 0 \
        "IdleBrightness"        7 1 "$n6"   		7 20 35 0 0 \
        "DisplayTemp Deg F"     8 1 "$n7"   		8 20 35 0 0 \
        "Nextion Driver"        9 1 "Nextion Driver"   	9 20 35 0 2 \
        "Port"       	       10 1 "$nd1"   		10 20 35 0 0 \
        "SendUserDataMask"     11 1 "$nd2"   		11 20 35 0 0 \
        "DataFilesPath"       	12 1 "$nd3"   		12 20 35 0 0 \
        "LogLevel"       	13 1 "$nd4"   		13 20 35 0 0 \
        "GroupsFile"       	14 1 "$nd5"   		14 20 35 0 0 \
        "DMRidFile"       	15 1 "$nd6"   		15 20 35 0 0 \
        "DMRidDelimiter"       	16 1 "$nd7"   		16 20 35 0 0 \
        "DMRIdId"       	17 1 "$nd8"   		17 20 35 0 0 \
        "DMRidCall"       	18 1 "$nd9"   		18 20 35 0 0 \
        "DMRidName"       	19 1 "$nd10"   		19 20 35 0 0 \
        "DMRidX1"       	20 1 "$nd11"   		20 20 35 0 0 \
        "DMRidX2"       	21 1 "$nd12"   		21 20 35 0 0 \
        "DMRidX3"       	22 1 "$nd13"   		22 20 35 0 0 \
        "ShowModeStatus"       	23 1 "$nd14"   		23 20 35 0 0 \
        "RemoveDim"       	24 1 "$nd15"   		24 20 35 0 0 \
        "WaitForLan"       	25 1 "$nd16"   		25 20 35 0 0 \
        "SleepWhenInactive"     26 1 "$nd17"   		26 20 35 0 0 \
        2>&1 1>&3)

returncode=$?
echo "Return Code = $returncode"
#echo "$Next"

exec 3>&-

if [ $returncode -eq 1 ]; then
  echo "Abort Cancel 3"
        dialog --ascii-lines --infobox "No Data - Function Aborted\nSleeping 2 seconds" 10 30 ; sleep 2
   MenuMain
fi

#Nextion
Port=$(echo "$Next" | sed -n '2p')
echo "Port0 = $Port"

Brightness=$(echo "$Next" | sed -n '3p')
DisplayClock=$(echo "$Next" | sed -n '4p')
UTC=$(echo "$Next" | sed -n '5p')
ScreenLayout=$(echo "$Next" | sed -n '6p')
IdleBrightness=$(echo "$Next" | sed -n '7p')
TempInFahrenheit=$(echo "$Next" | sed -n '8p')

#NextionDriver"
Port=$(echo "$Next" | sed -n '10p')

SendDataMask=$(echo "$Next" | sed -n '11p')
DataFilesPath=$(echo "$Next" | sed -n '12p')
LogLevel=$(echo "$Next" | sed -n '13p')
GroupsFile=$(echo "$Next" | sed -n '14p')
DMRidFile=$(echo "$Next" | sed -n '15p')
DMRidDelimiter=$(echo "$Next" | sed -n '16p')
DMRidId=$(echo "$Next" | sed -n '17p')
DMRidCall=$(echo "$Next" | sed -n '18p')
DMRidName=$(echo "$Next" | sed -n '19p')


DMRidX1=$(echo "$Next" | sed -n '20p')
DMRidX2=$(echo "$Next" | sed -n '21p')
DMRidX3=$(echo "$Next" | sed -n '22p')
ShowModeStatus=$(echo "$Next" | sed -n '23p')
RemoveDim=$(echo "$Next" | sed -n '24p')
WaitForLan=$(echo "$Next" | sed -n '25p')
SleepWhenInactive=$(echo "$Next" | sed -n '25p')


if [ "$Port" != "$n1" ]; then
  FROM=$(echo "$n1" | sed "s/\//\\\\\//g")
  TO=$(echo "$Port" | sed "s/\//\\\\\//g")
  sed -i "/^\[Nextion\]/,/^$/s/^Port=$FROM/Port=$TO/" /etc/mmdvmhost
fi

if [ "$Brightness" != "$n2" ]; then
        sudo sed -i '/^\[/h;G;/Nextion]/s/\(Brightness=\).*/\1'"$Brightness"'/m;P;d' /etc/mmdvmhost
fi
if [ "$DisplayClock" != "$n3" ]; then
        sudo sed -i '/^\[/h;G;/Nextion]/s/\(DisplayClock=\).*/\1'"$DisplayClock"'/m;P;d' /etc/mmdvmhost
fi
if [ "$UTC" != "$n4" ]; then
        sudo sed -i '/^\[/h;G;/Nextion]/s/\(UTC=\).*/\1'"$UTC"'/m;P;d' /etc/mmdvmhost
fi
if [ "$ScreenLayout" != "$n5" ]; then
        sudo sed -i '/^\[/h;G;/Nextion]/s/\(ScreenLayout=\).*/\1'"$ScreenLayout"'/m;P;d' /etc/mmdvmhost
fi
if [ "$IdleBrightness" != "$n6" ]; then
        sudo sed -i '/^\[/h;G;/Nextion]/s/\(IdleBrightness=\).*/\1'"$IdleBrightness"'/m;P;d' /etc/mmdvmhost
fi
if [ "$TempInFahrenheit" != "$n7" ]; then
        sudo sed -i '/^\[/h;G;/Nextion]/s/\(DisplayTempInFahrenheit=\).*/\1'"$TempInFahrenheit"'/m;P;d' /etc/mmdvmhost
fi
sleep 1
## NextionDriver
if [ "$Port" != "$nd1" ]; then
  FROM=$(echo "$nd1" | sed "s/\//\\\\\//g")
  TO=$(echo "$Port" | sed "s/\//\\\\\//g")
  sed -i "/^\[NextionDriver\]/,/^$/s/^Port=$FROM/Port=$TO/" /etc/mmdvmhost
fi
if [ "$SendDataMask" != "$nd2" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(SendUserDataMask=\).*/\1'"$SendDataMask"'/m;P;d' /etc/mmdvmhost
fi
sleep 1
if [ "$DataFilesPath" != "$nd3" ]; then
  FROM=$(echo "$nd3" | sed "s/\//\\\\\//g")
  TO=$(echo "$DataFilesPath" | sed "s/\//\\\\\//g")
  sed -i "/^\[NextionDriver\]/,/^$/s/^DataFilesPath=$FROM/DataFilesPath=$TO/" /etc/mmdvmhost
fi
if [ "$LogLevel" != "$nd4" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(LogLevel=\).*/\1'"$LogLevel"'/m;P;d' /etc/mmdvmhost
fi
if [ "$GroupsFile" != "$nd5" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(GroupsFile=\).*/\1'"$GroupsFile"'/m;P;d' /etc/mmdvmhost
fi

#-------------
if [ "$DMRidFile" != "$nd6" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(DMRidFile=\).*/\1'"$DMRidFile"'/m;P;d' /etc/mmdvmhost
fi
if [ "DMRidDelimiter" != "$nd7" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(DMRidDelimiter=\).*/\1'"$DMRidDelimiter"'/m;P;d' /etc/mmdvmhost
fi
if [ "$DMRidId" != "$nd8" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(DMRidId\).*/\1'"$DMRidId"'/m;P;d' /etc/mmdvmhost
fi
if [ "$DMRidCall" != "$nd9" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(DMRidCall=\).*/\1'"$DMRidCall"'/m;P;d' /etc/mmdvmhost
fi
if [ "$DMRidName" != "$nd10" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(DMRidName=\).*/\1'"$DMRidName"'/m;P;d' /etc/mmdvmhost
fi
if [ "$DMRidX1" != "$nd11" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(DMRidX1=\).*/\1'"$DMRidX1"'/m;P;d' /etc/mmdvmhost
fi
if [ "$DMRidX2" != "$nd12" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(DMRidX2=\).*/\1'"$DMRidX2"'/m;P;d' /etc/mmdvmhost
fi
if [ "$DMRidX3" != "$nd13" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(DMRidX3=\).*/\1'"$DMRidX3"'/m;P;d' /etc/mmdvmhost
fi
#----------
if [ "$ShowModeStatus" != "$nd14" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(ShowModeStatus=\).*/\1'"$ShowModeStatus"'/m;P;d' /etc/mmdvmhost
fi
if [ "$RemoveDim" != "$nd15" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(RemoveDim=\).*/\1'"$RemoveDim"'/m;P;d' /etc/mmdvmhost
fi
if [ "$WaitForLan" != "$nd16" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(WaitForLan=\).*/\1'"$WaitForLan"'/m;P;d' /etc/mmdvmhost
fi
if [ "$SleepWhenInactive" != "$nd17" ]; then
        sudo sed -i '/^\[/h;G;/NextionDriver]/s/\(SleepWhenInactive=\).*/\1'"$SleepWhenInactive"'/m;P;d' /etc/mmdvmhost
fi
        
dialog --ascii-lines --infobox "Nextion Data Write Complete " 10 30 
MenuMain
}

function EditScreens(){
#10
dialog \
        --backtitle "MMDVM Host Configurator - VE3RD" \
	--title " Edit Non Nextion Screens "  \
	--ascii-lines --msgbox " This function not yet impemented" 13 50

result=$?
echo "$result"
MenuMain
}

function EditInfo(){
#2
RXF=$(sed -nr "/^\[Info\]/ { :l /RXFrequency[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
TXF=$(sed -nr "/^\[Info\]/ { :l /TXFrequency[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
Lat=$(sed -nr "/^\[Info\]/ { :l /Latitude[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost) 
Lon=$(sed -nr "/^\[Info\]/ { :l /Longitude[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost) 
Loc=$(sed -nr "/^\[Info\]/ { :l /Location[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost) 
Des=$(sed -nr "/^\[Info\]/ { :l /Description[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost) 
URLs=$(sed -nr "/^\[Info\]/ { :l /URL[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)

exec 3>&1

Infod=$(dialog  --ascii-lines \
        --backtitle "MMDVM Host Configurator - VE3RD" \
        --separate-widget  $'\n'   \
        --ok-label "Save" \
        --title "Info Section" \
        --form "\n Info Configuration Items (Editable)" 20 70 12\
        "RXFrequency"      1 1 "$RXF"  	1 15 35 0 \
        "TXFrequency"      2 1 "$TXF"  	2 15 35 0 \
        "Latitude"         3 1 "$Lat" 	3 15 35 0 \
        "Longitude"        4 1 "$Lon"  	4 15 35 0 \
        "Location"         5 1 "$Loc"  	5 15 35 0 \
        "Description"      6 1 "$Des"  	6 15 35 0 \
        "URL"              7 1 "$URLs"  7 15 35 0 \
        2>&1 1>&3)

returncode=$?


if [ "$returncode" -eq 1 ]; then
  echo "Abort Cancel 3"
        dialog --ascii-lines --infobox "No Data - Function Aborted\nSleeping 2 seconds" 10 30 ; sleep 2
        MenuMain
fi
Description=$(echo "$Infod" | sed -n '6p')
echo "$RXFrequency"
exec 3>&-


RXFrequency=$(echo "$Infod" | sed -n '1p' )
TXFrequency=$(echo "$Infod" | sed -n '2p' )
Latitude=$(echo "$Infod"  | sed -n '3p' )
Longitude=$(echo "$Infod"  | sed -n '4p' )
Location=$(echo "$Infod"  | sed -n '5p' )
Description=$(echo "$Infod"  | sed -n '6p')
URL=$(echo "$Infod"  | sed -n '7p' )


echo "All Good Ready to Write Data"


##  Write Values Back
if [ "$RXFrequency" != "$RXF" ]; then
        sudo sed -i '/^\[/h;G;/Info]/s/\(RXFrequency=\).*/\1'"$RXFrequency"'/m;P;d' /etc/mmdvmhost
fi
if [ "$TXFrequency" != "$TXF" ]; then
        sudo sed -i '/^\[/h;G;/Info]/s/\(TXFrequency=\).*/\1'"$TXFrequency"'/m;P;d' /etc/mmdvmhost
fi
if [ "$Latitude" != "$Lat" ]; then
        sudo sed -i '/^\[/h;G;/Info]/s/\(Latitude=\).*/\1'"$Latitude"'/m;P;d' /etc/mmdvmhost
fi
if [ "$Longitude" != "$Lon" ]; then
        sudo sed -i '/^\[/h;G;/Info]/s/\(Longitude=\).*/\1'"$Longitude"'/m;P;d' /etc/mmdvmhost
fi
if [ "$Location" != "$Loc" ]; then
        sudo sed -i '/^\[/h;G;/Info]/s/\(Location=\).*/\1'"$Location"'/m;P;d' /etc/mmdvmhost
fi
if [ "$Description" != "$Des" ]; then
        sudo sed -i '/^\[/h;G;/Info]/s/\(Description=\).*/\1'"$Description"'/m;P;d' /etc/mmdvmhost
fi
if [ "$URL" != "$URLs" ]; then
  FROM=$(echo "$URLs" | sed "s/\//\\\\\//g")
  TO=$(echo "$URL" | sed "s/\//\\\\\//g")
  sed -i "/^\[Info\]/,/^$/s/^URL=$FROM/URL=$TO/" /etc/mmdvmhost
fi

MenuMain
}


function MenuMain(){

HEIGHT=25
WIDTH=40
CHOICE_HEIGHT=15
BACKTITLE="MMDVM Host Configurator - VE3RD"
TITLE="Main Menu"
MENU="Choose one of the following options\n --NYA Not Yet Available"

OPTIONS=(1 "Edit General Section" 
         2 "Edit Info Section" 
         3 "Edit Log Section" 
	 4 "Edit Modem Section - NYA" 
         5 "Edit DMR Section" 
         6 "Edit P25 Section" 
         7 "Edit NXDN Section - NYA" 
         8 "Edit YSF Section - NYA"
	 9 "Edit Nextion Sections" 
	10 "Edit Non Nextion Displays - NYA"
	11 "Maintenance & Backup/Restore" 
	)

CHOICE=$(dialog --clear \
          	--ascii-lines \
		--cancel-label "EXIT" \
		--extra-button \
		--extra-label "Restart MMDVM" \
		--backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
exitcode=$?

if [ "$exitcode" -eq 3 ]; then
  mmdvmhost.service restart
fi
if [ "$exitcode" -eq 1 ]; then
  echo "Abort Cancel 3"
        dialog --ascii-lines --infobox "Cancel Selected - Exiting Script\nSleeping 2 seconds" 5 40 ; sleep 2
        exit
   
fi

echo "Exit Code = $exitcode"

if [ -z "$CHOICE" ]; then
 echo "Nothing Selected - Shutting Down"
 exit
fi

case $CHOICE in
        1)
            echo "You chose Option 1"
        	EditGeneral 
	   ;;
        2)
            echo "You chose Option 2"
		EditInfo
            ;;
        3)
            echo "You chose Option 3"
		EditLog
	    ;;
        4)
            echo "You chose Option 4"
		EditModem 
           ;;
        5)
            echo "You chose Option 5"
		EditDMR	
            ;;
        6)
            echo "You chose Option 6"
        	EditP25
	    ;;
        7)
            echo "You chose Option 7"
            	EditNXDN
		;;
        8)
            echo "You chose Option 8"
         	EditYSF
	   ;;
        9)
            echo "You chose Option 9"
		EditNextion	
            ;;
        10)
            echo "You chose Option 10"
          	EditScreens
	  ;;
        11)
            echo "You chose Option "
          	MenuMaint
	  ;;
	
esac


}


function LoadMain(){

m1=$(sed -nr "/^\[General\]/ { :l /Callsign[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
CallSign=$(echo "$m1" | tr '[:lower:]' '[:upper:]')

if [ -z "$CallSign" ]; then
        errtext=" Cancel Selected"
	exitcode
fi
m2=$(sed -nr "/^\[P25\]/ { :l /Id[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
DID2="$m2"
if [ -z "$DID2" ]; then
        errtext=" Cancel Selected"
	exitcode
fi
DID1=$(echo "$m2")

HostName=$(hostname)

extra="000000000"

RXFrequency=$(sed -nr "/^\[Info\]/ { :l /RXFrequency[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)


CheckMode

Display=$(sed -nr "/^\[General\]/ { :l /Display[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)

NetAddress=$(sed -nr "/^\[P25 Network\]/ { :l /Address[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)

} 

function searchNetHost(){

declare -a SearchTxt=( $(dialog --title " P25 Server Search Utility" \
        --ascii-lines \
        --clear \
        --colors \
        --backtitle "MMDVM Host Configurator - VE3RD" \
        --inputbox "Enter your Search Criteria" 8 70  "tgif" 2>&1 >/dev/tty) )



# get response
response=$?

grep "$SearchTxt" /usr/local/etc/P25_Hosts.txt | tr "\t" " " | sed 's/\( \)*/\1/g' | tail -5  | cut  -d " " -f1 > tmpfile1
grep "$SearchTxt" /usr/local/etc/P25_Hosts.txt | tr "\t" " " | sed 's/\( \)*/\1/g' | tail -5  | cut  -d " " -f4 > tmpfile4

 paste tmpfile1 tmpfile4 | pr -t -e24 > tmpfile

while read LINE
  do
   case $LINE in
	'/ >'*|---*|'/ > '*)
        continue;;
  esac
 echo -n " 1\"$LINE\"" >result
done < tmpfile

}


MenuMain
#EditInfo
#mmdvmhost.service restart


