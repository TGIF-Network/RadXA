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
declare -i GWPage
((GWPage=1))
export GWPage

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

function CheckSetModes(){
md1=$(sed -nr "/^\[D-Star\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
md2=$(sed -nr "/^\[DMR\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
md3=$(sed -nr "/^\[System Fusion\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
md4=$(sed -nr "/^\[NXDN\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
md5=$(sed -nr "/^\[P25\]/ { :l /Enable[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)

dm1=$(sed -nr "/^\[DMR Network 1\]/ { :l /Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm2=$(sed -nr "/^\[DMR Network 2\]/ { :l /Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm3=$(sed -nr "/^\[DMR Network 3\]/ { :l /Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm4=$(sed -nr "/^\[DMR Network 4\]/ { :l /Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm5=$(sed -nr "/^\[DMR Network 5\]/ { :l /Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm6=$(sed -nr "/^\[DMR Network 6\]/ { :l /Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
echo "DMR Net4 Enabled = $dm4"

 opmodes=$(dialog \
        --title "Modes and Enables Screen" \
        --ok-label "Submit" \
        --backtitle "MMDVM Host Configurator - VE3RD" \
	--stdout \
        --ascii-lines \
        --mixedform "Modes Enable and DMRGateay Enables (Editable)" 25 60 20 \
        "Op Modes"    	1 1 "Op Modes"  	1 15 35 0 2 \
        "D-Star"       	2 1 "$md1"     		2 15 35 0 0 \
        "DMR"          	3 1 "$md2"     		3 15 35 0 0 \
        "YSF"       	4 1 "$md3"     		4 15 35 0 0 \
        "NXDN"      	5 1 "$md4"     		5 15 35 0 0 \
        "P25"          	6 1 "$md5"     		6 15 35 0 0 \
        "DMRGateway"    7 1 "DMRGateway"     	7 15 35 0 2 \
        "Net 1"    	8 1 "$dm1"     		8 15 35 0 0 \
        "Net 2"    	9 1 "$dm2"     		9 15 35 0 0 \
        "Net 3"   	10 1 "$dm3"    		10 15 35 0 0 \
        "Net 4"     	11 1 "$dm4"   		11 15 35 0 0 \
        "Net 5"         12 1 "$dm5"   		12 15 35 0 0 \
        "Net 6"      	13 1 "$dm6"    		13 15 35 0 0) 

errorcode=$?
echo "$errorcode"
echo "$opmodes"

if [ $errorcode -eq 1 ]; then
echo "Cancelled"
	MenuMain
fi

DStar=$(echo "$opmodes" | sed -n '2p' )
DMR=$(echo "$opmodes" | sed -n '3p' )
YSF=$(echo "$opmodes" | sed -n '4p' )
NXDN=$(echo "$opmodes" | sed -n '5p' )
P25=$(echo "$opmodes" | sed -n '6p' )

Net1=$(echo "$opmodes" | sed -n '8p' )
Net2=$(echo "$opmodes" | sed -n '9p' )
Net3=$(echo "$opmodes" | sed -n '10p' )
Net4=$(echo "$opmodes" | sed -n '11p' )
Net5=$(echo "$opmodes" | sed -n '12p' )
Net6=$(echo "$opmodes" | sed -n '13p' )



echo "Net3 - $Net3"
if [ "$DStar" != "$md1" ]; then 
        sudo sed -i '/^\[/h;G;/D-Star]/s/\(Enable=\).*/\1'"$DStar"'/m;P;d' /etc/mmdvmhost
fi
if [ "$DMR" != "$md2" ]; then 
        sudo sed -i '/^\[/h;G;/DMR]/s/\(Enable=\).*/\1'"$DMR"'/m;P;d' /etc/mmdvmhost
fi
if [ "$YSF" != "$md3" ]; then 
        sudo sed -i '/^\[/h;G;/System Fusion]/s/\(Enable=\).*/\1'"$YSF"'/m;P;d' /etc/mmdvmhost
fi
if [ "$NXDN" != "$md4" ]; then 
        sudo sed -i '/^\[/h;G;/NXDM]/s/\(Enable=\).*/\1'"$NXDN"'/m;P;d' /etc/mmdvmhost
fi
if [ "$P25" != "$md5" ]; then 
        sudo sed -i '/^\[/h;G;/P25]/s/\(Enable=\).*/\1'"$P25"'/m;P;d' /etc/mmdvmhost
fi


if [ "$Net1" != "$dm1" ]; then 
        sudo sed -i '/^\[/h;G;/DMR Network 1]/s/\(Enabled=\).*/\1'"$Net1"'/m;P;d' /etc/dmrgateway
fi
if [ "$Net2" != "$dm2" ]; then 
        sudo sed -i '/^\[/h;G;/DMR Network 2]/s/\(Enabled=\).*/\1'"$Net2"'/m;P;d' /etc/dmrgateway
fi
if [ "$Net3" != "$dm3" ]; then 
        sudo sed -i '/^\[/h;G;/DMR Network 3]/s/\(Enabled=\).*/\1'"$Net3"'/m;P;d' /etc/dmrgateway
fi
if [ "$Net4" != "$dm4" ]; then 
        sudo sed -i '/^\[/h;G;/DMR Network 4]/s/\(Enabled=\).*/\1'"$Net4"'/m;P;d' /etc/dmrgateway
fi
if [ "$Net5" != "$dm5" ]; then 
        sudo sed -i '/^\[/h;G;/DMR Network 5]/s/\(Enabled=\).*/\1'"$Net5"'/m;P;d' /etc/dmrgateway
fi
if [ "$Net6" != "$dm6" ]; then 
        sudo sed -i '/^\[/h;G;/DMR Network 6]/s/\(Enabled=\).*/\1'"$Net6"'/m;P;d' /etc/dmrgateway
fi

MenuMain
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

function EditModeGroup(){
   dialog --ascii-lines --infobox "Not Yet Implemented - Sleeping 2 seconds" 10 40 ; sleep 2
	MenuMain
}
function EditModeHangs(){
   dialog --ascii-lines --infobox "Not Yet Implemented - Sleeping 2 seconds" 10 40 ; sleep 2
	MenuMain
}


function EditDMRGate23(){

if [ $GWPage -gt 3]; then
   (( GWPage=1 ))
	EditDMRGate
fi 

if [ "$GWPage" -eq 2 ]; then
	Sect1="DMR Network 1"
	Sect2="DMR Network 2"
	Sect3="DMR Network 3"
	DMRNeta="DMR Net 1"
	DMRNetb="DMR Net 2"
	DMRNetc="DMR Net 3"
	elabel="Net 456"
fi
if [ "$GWPage" -eq 3 ]; then
	Sect1="DMR Network 4"
	Sect2="DMR Network 5"
	Sect3="DMR Network 6"
	DMRNeta="DMR Net 4"
	DMRNetb="DMR Net 5"
	DMRNetc="DMR Net 6"
	elabel="MainGW"
fi

# sed -nr "/^\[$Sect2/ 

dm1a=$(sed -nr "/^\[$Sect1/ { :l /^Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm2a=$(sed -nr "/^\[$Sect1/ { :l /^Name[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm3a=$(sed -nr "/^\[$Sect1/ { :l /^Id[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm4a=$(sed -nr "/^\[$Sect1/ { :l /^Address[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm5a=$(sed -nr "/^\[$Sect1/ { :l /^Password[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm6a=$(sed -nr "/^\[$Sect1/ { :l /^Port[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm7a=$(sed -nr "/^\[$Sect1/ { :l /^Local[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm8a=$(sed -nr "/^\[$Sect1/ { :l /^TGRewrite0[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm9a=$(sed -nr "/^\[$Sect1/ { :l /^TGRewrite1[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm10a=$(sed -nr "/^\[$Sect1/ { :l /^PCRewrite0[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm11a=$(sed -nr "/^\[$Sect1/ { :l /^SrcRewrite0[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)

dm1b=$(sed -nr "/^\[$Sect2/ { :l /^Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm2b=$(sed -nr "/^\[$Sect2/ { :l /^Name[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm3b=$(sed -nr "/^\[$Sect2/ { :l /^Id[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm4b=$(sed -nr "/^\[$Sect2/ { :l /^Address[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm5b=$(sed -nr "/^\[$Sect2/ { :l /^Password[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm6b=$(sed -nr "/^\[$Sect2/ { :l /^Port[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm7b=$(sed -nr "/^\[$Sect2/ { :l /^Local[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm8b=$(sed -nr "/^\[$Sect2/ { :l /^TGRewrite0[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm9b=$(sed -nr "/^\[$Sect2/ { :l /^TGRewrite1[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm10b=$(sed -nr "/^\[$Sect2/ { :l /^PCRewrite0[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm11b=$(sed -nr "/^\[$Sect2/ { :l /^SrcRewrite0[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)

dm1c=$(sed -nr "/^\[$Sect3/ { :l /^Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm2c=$(sed -nr "/^\[$Sect3/ { :l /^Name[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm3c=$(sed -nr "/^\[$Sect3/ { :l /^Id[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm4c=$(sed -nr "/^\[$Sect3/ { :l /^Address[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm5c=$(sed -nr "/^\[$Sect3/ { :l /^Password[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm6c=$(sed -nr "/^\[$Sect3/ { :l /^Port[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm7c=$(sed -nr "/^\[$Sect3/ { :l /^Local[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm8c=$(sed -nr "/^\[$Sect3/ { :l /^TGRewrite0[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm9c=$(sed -nr "/^\[$Sect3/ { :l /^TGRewrite1[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm10c=$(sed -nr "/^\[$Sect3/ { :l /^PCRewrite0[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
dm11c=$(sed -nr "/^\[$Sect3/ { :l /^SrcRewrite0[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)


exec 3>&1

 dmrg=$(dialog \
        --title "DMRGateway Networks Section - Page $GWPage" \
        --ok-label "Submit" \
	--extra-button \
	--colors \
	--extra-label "Next Page" \
        --backtitle "MMDVM Host Configurator - VE3RD" \
        --ascii-lines \
        --mixedform "DMRGateway Configuration Items (Editable)" 0 60 0 \
        "DMR Neta A"  	1 1 "$DMRNeta"  1 15 35 0 2 \
        "Enabled"  	2 1 "$dm1a"  	2 15 35 0 0 \
        "Name"     	3 1 "$dm2a"  	3 15 35 0 0 \
        "Id"      	4 1 "$dm3a"  	4 15 35 0 0 \
        "Password"      5 1 "$dm4a"  	5 15 35 0 0 \
        "Port"    	6 1 "$dm5a"  	6 15 35 0 0 \
        "Local"    	7 1 "$dm6a"  	7 15 35 0 0 \
        "TGRewrite0"    8 1 "$dm7a"  	8 15 35 0 0 \
        "TGRewrite1"    9 1 "$dm8a"  	9 15 35 0 0 \
        "SrcRewrite0" 	10 1 "$dm9a"  	10 15 35 0 0 \
        "Port"    	11 1 "$dm10a"  	11 15 35 0 0 \
        "Local"    	12 1 "$dm11a"  	12 15 35 0 0 \
    	"DMR Net B"     13 1 "$DMRNetb" 13 15 35 0 2 \
        "Enabled"       14 1 "$dm1b"    14 15 35 0 0 \
        "Name"          15 1 "$dm2b"    15 15 35 0 0 \
        "Id"            16 1 "$dm3b"    16 15 35 0 0 \
        "Password"      17 1 "$dm4b"    17 15 35 0 0 \
        "Port"          18 1 "$dm5b"    18 15 35 0 0 \
        "Local"         19 1 "$dm6b"    19 15 35 0 0 \
        "TGRewrite0"    20 1 "$dm7b"    20 15 35 0 0 \
        "TGRewrite1"    21 1 "$dm8b"    21 15 35 0 0 \
        "SrcRewrite0"   22 1 "$dm9b"    22 15 35 0 0 \
        "Port"          23 1 "$dm10b"   23 15 35 0 0 \
        "Local"         24 1 "$dm11b"   24 15 35 0 0 \
        "DMRNet C"      25 1 "$DMRNetc"  25 15 35 0 2 \
        "Enabled"       26 1 "$dm1c"    26 15 35 0 0 \
        "Name"          27 1 "$dm2c"    27 15 35 0 0 \
        "Id"            28 1 "$dm3c"    28 15 35 0 0 \
        "Password"      29 1 "$dm4c"    29 15 35 0 0 \
        "Port"          30 1 "$dm5c"    30 15 35 0 0 \
        "Local"         31 1 "$dm6c"    31 15 35 0 0 \
        "TGRewrite0"    32 1 "$dm7c"    32 15 35 0 0 \
        "TGRewrite1"    33 1 "$dm8c"    33 15 35 0 0 \
        "SrcRewrite0"   34 1 "$dm9c"    34 15 35 0 0 \
        "Port"          35 1 "$dm10c"   35 15 35 0 0 \
        "Local"         36 1 "$dm11c"   36 15 35 0 0 2>&1 1>&3 )


errorcode=$?
echo "$errorcode"



if [ $errorcode -eq 1 ]; then
   dialog --ascii-lines --infobox "Cancel selected - Sleeping 2 seconds" 10 40 ; sleep 2
        echo "$errorcode"
        EditDMRGate
fi

if [ $errorcode -eq 3 ]; then
	((GWPage++))
	if (( $GWPage >= 4 )); then
   		(( GWPage=1 ))
		EditDMRGate
	else
		EditDMRGate23
	fi
fi 

if [ $errorcode -eq 255 ]; then
MenuMain
fi

EditDMRGate
exit #$$$$

}

function EditDMRGate(){
((GWPage=1))
elabel="Net 123"

g1=$(sed -nr "/^\[General\]/ { :l /^RuleTrace[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g2=$(sed -nr "/^\[General\]/ { :l /^StartNet[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g3=$(sed -nr "/^\[General\]/ { :l /^GWMode[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g4=$(sed -nr "/^\[General\]/ { :l /^Daemon[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g5=$(sed -nr "/^\[General\]/ { :l /^RFTimeout[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g6=$(sed -nr "/^\[General\]/ { :l /^NetTimeout[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)

g7=$(sed -nr "/^\[Log\]/ { :l /^Displayevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g8=$(sed -nr "/^\[Log\]/ { :l /^FileLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g9=$(sed -nr "/^\[Log\]/ { :l /^FilePath[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g10=$(sed -nr "/^\[Log\]/ { :l /^FileRoot[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)

g11=$(sed -nr "/^\[Info\]/ { :l /^Latitude[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g12=$(sed -nr "/^\[Info\]/ { :l /^Longitude[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g13=$(sed -nr "/^\[Info\]/ { :l /^Description[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g14=$(sed -nr "/^\[Info\]/ { :l /^URL[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g15=$(sed -nr "/^\[Info\]/ { :l /^RXFrequency[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g16=$(sed -nr "/^\[Info\]/ { :l /^TXFrequency[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g17=$(sed -nr "/^\[Info\]/ { :l /^Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
g18=$(sed -nr "/^\[Info\]/ { :l /^Power[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)

echo "G6 = $g6"

exec 3>&1

  dmrg=$(dialog  \
        --title "DMRGateway Sections - Page $GWPage" \
        --ok-label "Submit" \
	--extra-button \
	--extra-label "$elabel" \
        --backtitle "MMDVM Host Configurator - VE3RD" \
        --ascii-lines \
        --mixedform "DMRGateway Configuration Items (Editable)" 0 50 0 \
        "General"    	1 1 "General"  	1 15 35 0 2 \
        "RuleTrace"    	2 1 "$g1"  	2 15 35 0 0 \
        "StartNet"     	3 1 "$g2"     	3 15 35 0 0 \
        "GWMode"       	4 1 "$g3"     	4 15 35 0 0 \
        "Daemon"      	5 1 "$g4"     	5 15 35 0 0 \
        "RFTimeout"   	6 1 "$g5"     	6 15 35 0 0 \
        "NetTimeout"  	7 1 "$g6"     	7 15 35 0 0 \
        "LOG"   	8 1 "LOG"     	8 15 35 0 2 \
        "DisplayLevel"  9 1 "$g7"     	9 15 35 0 0 \
        "File Level"  	10 1 "$g8"     	10 15 35 0 0 \
        "FilePath"  	11 1 "$g9"     	11 15 35 0 0 \
        "FileRoot"  	12 1 "$g10"     12 15 35 0 0 \
        "INFO"  	13 1 "INFO"     13 15 35 0 2 \
        "Latitude"  	14 1 "$g11"     14 15 35 0 0 \
        "Longitude"  	15 1 "$g12"     15 15 35 0 0 \
        "Location"  	16 1 "$g13"     16 15 35 0 0 \
        "Description"  	17 1 "$g14"     17 15 35 0 0 \
        "URL"  		18 1 "$g15"     18 15 35 0 0 \
        "RXFrequency"  	19 1 "$g16"     19 15 35 0 0 \
        "TXFrequency"  	20 1 "$g17"     20 15 35 0 0 \
        "Enabled"  	21 1 "$g18"     21 15 35 0 0 \
        "Power"  	22 1 "$g19"     22 15 35 0 0 2>&1 1>&3 )

errorcode=$?
echo "$errorcode"

if [ $errorcode -eq 1 ]; then
	MenuMain
fi

if [ $errorcode -eq 3 ]; then
	((GWPage++))
	EditDMRGate23
fi

if [ $errorcode -eq 255 ]; then
MenuMain
fi

exit
EditDMRGate

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
  TO=$(echo "$FilePath" | sed "s/\//\\\\\//g")
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
mm8=$(sed -nr "/^\[Modem\]/ { :l /^RFLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm9=$(sed -nr "/^\[Modem\]/ { :l /^DMRTXLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm10=$(sed -nr "/^\[Modem\]/ { :l /^YSFTXLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm11=$(sed -nr "/^\[Modem\]/ { :l /^P25TXLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm12=$(sed -nr "/^\[Modem\]/ { :l /^NXDNTXLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm13=$(sed -nr "/^\[Modem\]/ { :l /^Trace[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm14=$(sed -nr "/^\[Modem\]/ { :l /^UARTPort[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
mm15=$(sed -nr "/^\[Modem\]/ { :l /^UARTSpeed[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
exec 3>&1

Modems=$(dialog  --ascii-lines \
        --backtitle "MMDVM Host Configurator - VE3RD" \
        --separate-widget  $'\n'   \
        --ok-label "Save" \
        --title "Modem Section" \
        --mixedform "\n Modem Configuration Items (Editable)" 30 40 0 \
        "Port"        1 1 "$mm1"               1 15 35 0 0 \
        "TXDelay"     2 1 "$mm2"               2 15 35 0 0 \
        "RXOffset"    3 1 "$mm3"               3 15 35 0 0 \
        "TXOffset"    4 1 "$mm4"               4 15 35 0 0 \
        "DMRDelay"    5 1 "$mm5"       	       5 15 35 0 0 \
        "RXLevel"     6 1 "$mm6"               6 15 35 0 0 \
        "TXLevel"     7 1 "$mm7"               7 15 35 0 0 \
        "RFLevel"     8 1 "$mm8"               8 15 35 0 0 \
        "DMRTXLevel"  9 1 "$mm9"               9 15 35 0 0 \
        "YSFTXLevel"  10 1 "$mm10"              10 15 35 0 0 \
        "P25TXLevel"  11 1 "$mm11"              11 15 35 0 0 \
        "NXDNTXLevel" 12 1 "$mm12"              12 15 35 0 0 \
        "Trace"       13 1 "$mm13"              13 15 35 0 0 \
        "UARTPort"    14 1 "$mm14"              14 15 35 0 0 \
        "UARTSpeed"   15 1 "$mm15"              15 15 35 0 0 \
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

Port=$(echo "$Modems" | sed -n '1p' )
TXDelay=$(echo "$Modems" | sed -n '2p' )
RXOffset=$(echo "$Modems" | sed -n '3p' )
TXOffset=$(echo "$Modems" | sed -n '4p' )
DMRDelay=$(echo "$Modems" | sed -n '5p' )
RXLevel=$(echo "$Modems" | sed -n '6p' )
TXLevel=$(echo "$Modems" | sed -n '7p' )
RFLevel=$(echo "$Modems" | sed -n '8p' )
DMRTXLevel=$(echo "$Modems" | sed -n '9p' )
YSFTXLevel=$(echo "$Modems" | sed -n '10p' )
P25TXLevel=$(echo "$Modems" | sed -n '11p' )
NXDNTXLevel=$(echo "$Modems" | sed -n '12p' )
Trace=$(echo "$Modems" | sed -n '13p' )
UARTPort=$(echo "$Modems" | sed -n '14p' )
UARTSpeed=$(echo "$Modems" | sed -n '15p' )

if [ "$Port" != "$mm1" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(Port=\).*/\1'"$Port"'/m;P;d' /etc/mmdvmhost
fi
if [ "$TXDelay" != "$mm2" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(Port=\).*/\1'"$Port"'/m;P;d' /etc/mmdvmhost
fi
if [ "$RXOffset" != "$mm3" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(RXOffset=\).*/\1'"$RXOffset"'/m;P;d' /etc/mmdvmhost
fi
if [ "$TXOffset" != "$mm4" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(TXOffset=\).*/\1'"$TXOffset"'/m;P;d' /etc/mmdvmhost
fi
if [ "$DMRDelay" != "$mm5" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(DMRDelay=\).*/\1'"$DMRDelay"'/m;P;d' /etc/mmdvmhost
fi
if [ "$RXLevel" != "$mm6" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(RXLevel=\).*/\1'"$RXLevel"'/m;P;d' /etc/mmdvmhost
fi
if [ "$TXLevel" != "$mm7" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(TXLevel=\).*/\1'"$TXLevel"'/m;P;d' /etc/mmdvmhost
fi
if [ "$RFLevel" != "$mm8" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(RFLevel=\).*/\1'"$RFLevel"'/m;P;d' /etc/mmdvmhost
fi
if [ "$DMRTXLevel" != "$mm9" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(DMRTXLevel=\).*/\1'"$DMRTXLevel"'/m;P;d' /etc/mmdvmhost
fi
if [ "$YSFTXLevel" != "$mm10" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(YSFTXLevel=\).*/\1'"$YSFTXLevel"'/m;P;d' /etc/mmdvmhost
fi
if [ "$P25TXLevel" != "$mm11" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(P25TXLevel=\).*/\1'"$P25TXLevel"'/m;P;d' /etc/mmdvmhost
fi
if [ "$NXDNTXLevel" != "$mm12" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(NXDNTXLevel=\).*/\1'"$NXDNTXLevel"'/m;P;d' /etc/mmdvmhost
fi
if [ "$Trace" != "$mm13" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(Trace=\).*/\1'"$Trace"'/m;P;d' /etc/mmdvmhost
fi
if [ "$UARTPort" != "$mm14" ]; then
  TO=$(echo "$UARTPort" | sed "s/\//\\\\\//g")
        sudo sed -i '/^\[/h;G;/Modem]/s/\(UARTPort=\).*/\1'"$TO"'/m;P;d' /etc/mmdvmhost
fi
if [ "$UARTSpeed" != "$mm15" ]; then
        sudo sed -i '/^\[/h;G;/Modem]/s/\(UARTSpeed=\).*/\1'"$UARTSpeed"'/m;P;d' /etc/mmdvmhost
fi

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
		3 "Restart MMDVMHost" \
		4 "Restart DMRGateway" \
		5 "Restart ALL Services" \
		6 "Reboot Hotspot" \
		7 "Update Host Files" 2>&1 >/dev/tty)
exitcode=$?

if [ "$exitcode" -eq 3 ]; then
   echo "Exit 3 - Main Menu"
   MenuMain
fi

if [ "$exitcode" -eq 255 ]; then
   echo "Exit 3 - Main Menu"
   MenuMain
fi

if [ "$exitcode" -eq 1 ]; then
  echo "Abort Cancel 1"
        dialog --ascii-lines --infobox "Cancel Selected - Exiting Script\nSleeping 2 seconds" 5 40 ; sleep 2
	clear

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

if [ "$MAINT" -eq 3 ]; then
sudo mmdvmhost.services restart
fi
if [ "$MAINT" -eq 4 ]; then
sudo dmrgateway.services restart
fi
if [ "$MAINT" -eq 5 ]; then
sudo mmdvmhost.service restart
sudo dmrgateway.service restar
sudo p25gateway.service restart
sudo ysfgateway.service restart
sudo nxdngateway.service restart
fi

if [ "$MAINT" -eq 6 ]; then
echo "Rebooting Hotspot - Log back in when it come up"
sudo reboot
exit

fi
if [ "$MAINT" -eq 7 ]; then
echo "Updating All Host Files"
echo "Please WAIT a few seconds"
sudo HostFilesUpdate.sh
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
MENU="Choose one of the following options\n --NYA Not Yet Available\n --UC Under Construction"

OPTIONS=(1 "Edit General Section" 
         2 "Edit Info Section" 
         3 "Edit Log Section" 
	 4 "Edit Modem Section" 
         5 "Edit DMR Section" 
         6 "Edit P25 Section" 
         7 "Edit NXDN Section - UC" 
         8 "Edit YSF Section - UC"
	 9 "Edit Nextion Sections" 
	10 "Edit Non Nextion Displays - NYA"
	11 "Edit Edit Mode Enables" 
	12 "Edit Mode Hangs - NYA" 
	13 "Edit DMRGateway" 
	14 "Maintenance & Backup/Restore" 
	15 "Check - Set Modes and Enables" 
	)
#		--extra-button \
#		--extra-label "Restart MMDVM" \

CHOICE=$(dialog --clear \
          	--ascii-lines \
		--cancel-label "EXIT" \
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
            echo "You chose Option 11"
          	EditModeGroup
	  ;;
        12)
            echo "You chose Option 12"
          	EditModeHangs
	  ;;
        13)
            echo "You chose Option 13"
          	EditDMRGate
	  ;;
        14)
            echo "You chose Option 14"
          	MenuMaint
	  ;;
        15)
            echo "You chose Option 15"
          	CheckSetModes
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


