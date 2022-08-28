@echo off
cls
netsh wlan show profiles | find "Profile"  


set /p ssid=Your ESSID: 
set /p pwd=Password: 

echo #!/bin/bash > C:\Downloads\startwifi.sh
echo essid=%ssid% >> C:\Downloads\startwifi.sh
echo password=%pwd%  >>  C:\Downloads\startwifi.sh
echo sudo nmcli dev wifi connect "%ssid%" password "%pwd%" >> C:\Downloads\startwifi.sh
