#!/bin/bash

#get script path
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

clear

NONE='\033[00m'
CYAN='\033[36m'
FUSCHIA='\033[35m'
UNDERLINE='\033[4m'

cd $SCRIPTPATH

#if not root user, restart script as root
if [ "$(whoami)" != "root" ]; then
	echo "Switching to root user..."
	sudo bash $SCRIPT
	exit 1
fi

echo -e "${CYAN}"
echo -e "Starting installation of Retropie Status Overlay"
echo -e "${NONE}"
echo "--------------------------------------------------"
echo "Press ENTER to proceed or CTRL+C to abort"
echo "--------------------------------------------------"
read -r _

echo "Default config.ini assumes Carbon theme at 1080p."
read -p "Use [D]efault config values or [b]uild from scratch? " CONFIG
if [[ $CONFIG = [bB] ]] ; then
  echo ""
  echo -e "${CYAN}"
  echo "Building config file..."
  echo -e "${NONE}"
  echo "--------------------------------------------------"
  echo -n "" > config.ini
  echo "# Created using install.sh" >> config.ini
  echo "" >> config.ini

  echo "[Icons]" >> config.ini 
  echo "# Icon Size: 24, 36 or 48" >> config.ini 
  while [[ $PIXEL != "24" && $PIXEL != "36" && $PIXEL != "48" ]]
  do
    echo "Choose icon size. 36px or lower recommened for low res screens."
    read -p "24/36/48 [48]: " PIXEL
    if [[ $PIXEL = "" ]] ; then
      PIXEL="48"
    fi
  done
  echo "Size = $PIXEL" >> config.ini 
  echo "# Icon Color: white or black" >> config.ini
  while [[ "$COLOR" != "white" && "$COLOR" != "black" ]]
  do
    echo "Choose icon color"
    read -p "[b]lack or [W]hite: " COLOR
    if [[ $COLOR = [bB] ]] ; then
      COLOR="black"
    elif [[ $COLOR = [wW] || $COLOR = "" ]] ; then
      COLOR="white"
    fi
  done
  echo "Color = $COLOR" >> config.ini
  echo "# Horizontal Position: left or right" >> config.ini
  while [[ "$XPOS" != "left" && "$XPOS" != "right" ]]
  do
    read -p "Shall icons align [l]eft or [R]ight? " XPOS
    if [[ $XPOS = [lL] ]] ; then
      XPOS="left"
    elif [[ $XPOS = [rR] || $XPOS = "" ]] ; then
      XPOS="right"
    fi
  done
  echo "Horizontal = $XPOS" >> config.ini
  echo "# Vertical Position: top or bottom" >> config.ini
  while [[ "$YPOS" != "top" && "$YPOS" != "bottom" ]]
  do
    read -p "Shall icons align [t]op or [B]ottom? " YPOS
    if [[ $YPOS = [tT] ]] ; then
      YPOS="top"
    elif [[ $YPOS = [bT] || $YPOS = "" ]] ; then
      YPOS="bottom"
    fi
  done
  echo "Vertical = $YPOS" >> config.ini
  echo "# Padding from corner and between icons" >> config.ini
  PAD=51
  while [[ "$PAD" -lt 0 || "$PAD" -gt 50 ]]
  do
    read -p "Icon Padding [8]: " PAD
    if [[ $PAD = "" ]] ; then
      PAD="8"
    fi
  done
  echo "Padding = $PAD" >> config.ini
  
  echo "" >> config.ini
  echo "[Detection]" >> config.ini
  echo "Enable Wifi icon?"
  read -p "[Y]es or [n]o: " WIFI
  if [[ $WIFI = [nN] ]] ; then
    WIFI="False"
  else
    WIFI="True"
  fi
  echo "Wifi = $WIFI" >> config.ini
  
  echo "Enable Blutooth icon?"
  read -p "[Y]es or [n]o: " BT
  if [[ $BT = [nN] ]] ; then
    BT="False"
  else
    BT="True"
  fi
  echo "Bluetooth = $BT" >> config.ini
 
  echo "Enable Audio icon?"
  read -p "[Y]es or [n]o: " AUDIO
  if [[ $AUDIO = [nN] ]] ; then
    AUDIO="False"
  else
    AUDIO="True"
  fi
  echo "Audio = $AUDIO" >> config.ini
  
  echo "Enable Battery Voltage detection using ADC? (Requires specific hardware)"
  read -p "[Y]es or [N]o: " BATADC
  if [[ $BATADC = [yY] ]] ; then
    BATADC="True"
  else
    BATADC="False"
  fi
  
  
  echo "BatteryADC = $BATADC" >> config.ini 
  
  if [[ $BATADC = "True" ]] ; then 
 
  
	  echo "What hardware are you using for ADC?"
	  read -p "[MCP] or [ADS1]: " CHIPTYPE
	  if [[ $CHIPTYPE = "MCP" ]] ; then
		CHIPTYPE="MCP"
	  else
		CHIPTYPE="ADS1"
	  fi
	  echo "Type = $CHIPTYPE" >> config.ini 
		
	  if [[ $CHIPTYPE = "MCP" ]] ; then
	  echo "GPIO for CLK?"	
	  read -p "GPIO : " CLK
	  else
		CLK=0	
	  fi
	  
	  if [[ $CHIPTYPE = "MCP" ]] ; then
	  echo "GPIO for MISO?"	
	  read -p "GPIO : " MISO  
	  else
		MISO=0	
	  fi
	  
	  if [[ $CHIPTYPE = "MCP" ]] ; then
	  echo "GPIO for MOSI?"	
	  read -p "GPIO: " MOSI  
	  else
		MOSI=0	
	  fi
	  
	  if [[ $CHIPTYPE = "MCP" ]] ; then
	  echo "GPIO for CS?"	
	  read -p "GPIO : " CS    
	  else
		CS=0	
	  fi
		
	  echo "clk = $CLK" >> config.ini 
	  echo "miso = $MISO" >> config.ini 
	  echo "mosi = $MOSI" >> config.ini 
	  echo "cs = $CS" >> config.ini   

	  echo "ADCShutdown = N" >> config.ini    
	  
	  echo "Multiplier = 1" >> config.ini 	
	  echo "VMaxDischarging = 3.95" >> config.ini 	
	  echo "VMaxCharging = 4.5" >> config.ini 	
	  echo "VMinDischarging = 3.2" >> config.ini 		  
 	  echo "VMinCharging = 4.25" >> config.ini 	
	  
  fi
  
  echo "Enable Low Battery protection using GPIO (LDO)? (Requires specific hardware)"
  read -p "[y]es or [N]o: " BATLDO
  if [[ $BATLDO = [yY] ]] ; then
	BATLDO="True"
	LDOGPIO=28
	while [[ "$LDOGPIO" -lt 0 || "$LDOGPIO" -gt 27 ]]
	do
	  read -p "LDO GPIO pin [0 - 27]: " LDOGPIO
	done
	read -p "LDO GPIO Active [L]ow or Active [h]igh? " LDOPOL
  else
	BATLDO="False"
  fi
  echo "BatteryLDO = $BATLDO" >> config.ini  

  echo "Enable Shutdown via GPIO Button? (Requires specific hardware)"
  read -p "[y]es or [N]o: " SD
  if [[ $SD = [yY] ]] ; then
    SD="True"
    SDGPIO=28
    while [[ "$SDGPIO" -lt 0 || "$SDGPIO" -gt 27 ]]
    do
      read -p "Shutdown GPIO pin [0 - 27]: " SDGPIO
    done
    read -p "Shutdown GPIO Active [L]ow or Active [h]igh? " SDPOL
  else
    SD="False"
  fi
  echo "ShutdownGPIO = $SD" >> config.ini
  
  echo "Hide Overlay When In-Game"
  read -p "[y]es or [N]o: " SD
  if [[ $SD = [yY] ]] ; then
	EOIG="True"
  else
    EOIG="False"
  fi
  echo "HideInGame = $EOIG" >> config.ini  
  
  echo "Hide Env Warnings (Low Voltage, Thermal Throttle etc)"
  read -p "[y]es or [N]o: " SD
  if [[ $SD = [yY] ]] ; then
	HEW="True"
  else
    HEW="False"
  fi
  echo "HideEnvWarnings = $HEW" >> config.ini    
  
  echo "" >> config.ini 
  echo "[BatteryLDO]" >> config.ini
  echo "GPIO = $LDOGPIO" >> config.ini
  if [[ $LDPOL = [hH] ]] ; then
    echo "ActiveLow = False" >> config.ini
  else
    echo "ActiveLow = True" >> config.ini
  fi
  
  echo "" >> config.ini  

  echo "[ShutdownGPIO]" >> config.ini 
  echo "GPIO = $SDGPIO" >> config.ini 
  if [[ $SDPOL = [hH] ]] ; then
    echo "ActiveLow = False" >> config.ini
  else
    echo "ActiveLow = True" >> config.ini
  fi
  echo "" >> config.ini
  echo "config.ini creation complete"
fi

echo ""
echo -e "${CYAN}"
echo "Installing pngview by AndrewFromMelbourne"
echo -e "${NONE}"
echo "--------------------------------------------------"
cd $SCRIPTPATH
git clone https://github.com/AndrewFromMelbourne/raspidmx
cd $SCRIPTPATH/raspidmx/lib
make
cd $SCRIPTPATH/raspidmx/pngview
make
sudo cp pngview /usr/local/bin/

echo ""
echo -e "${CYAN}"
echo "Installing required packages..."
echo -e "${NONE}"
echo "--------------------------------------------------"
sudo apt-get install python3-psutil python3-rpi.gpio python3-pip

echo ""
echo -e "${CYAN}"
echo "Installing MCP Adafruit..."
echo -e "${NONE}"
echo "--------------------------------------------------"
sudo pip3 install Adafruit_MCP3008

echo ""
echo -e "${CYAN}"
echo "Installing ADS1 Adafruit..."
echo -e "${NONE}"
echo "--------------------------------------------------"
sudo pip3 install Adafruit_ADS1x15

echo ""
echo -e "${CYAN}"
echo "Downloading RetroPie Status Overlay"
echo -e "${NONE}"
echo "--------------------------------------------------"

cd $SCRIPTPATH

echo -e "${CYAN}"
echo "Installing As Service..."
echo -e "${NONE}"
echo "--------------------------------------------------"
echo 

servicefile=$SCRIPTPATH"/retropie-status-overlay.service"
cp $servicefile /lib/systemd/system/

sed -i 's@WORKING_DIRECTORY@'"$SCRIPTPATH"'@g' /lib/systemd/system/$servicefile

systemctl enable retropie-status-overlay
service retropie-status-overlay start

echo ""
echo "--------------------------------------------------"
echo -e "${CYAN}"
echo "Retropie Status Overlay installation complete!"
echo -e "${NONE}"
echo "--------------------------------------------------"
echo "Retropie Status Overlay will now run automatically at boot as a service."
echo ""
echo "$SCRIPTPATH/config.ini may be edited at any time."
echo ""
echo "You can stop and start the overlay service at anytime by doing sudo service overlay [stop|stop]"
echo ""
echo "Use remove.sh at anytime to uninstall Retropie status overlay"
echo ""
echo "There a number of additional options to configure in your $SCRIPTPATH/config.ini file, see readme for more details"
