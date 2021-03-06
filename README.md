

# RetroPie Status Overlay
Originally based on [gbz_overlay](https://github.com/d-rez/gbz_overlay) script by [d-rez](https://github.com/d-rez)

Forked from [retropie_status_overlay] https://github.com/bverc/retropie_status_overlay script by (https://github.com/bverc/)

This repository contains a script to display lovely slightly-transparent overlays on top of your RetroPie games and emulationstation menus

![Bluetooth, wifi connected, audio on](_images/240_icons.png)

## Features
- display battery level (Requires appropiate Hardware)
- display WiFi state (connected/disconnected/disabled)
- display Bluetooth state (connected/disconnected/disabled)
- display under-voltage state
- display warning if frequency-capped
- display warning if throttling
- gracefully shut down the Pi after 60s from when voltage goes below 3.2V of low voltage detected (abort shutdown when power is restored)
- show a big imminent shutdown warning when the counter starts ticking
- Only critical icons displayed in game
- Shutdown from button press
- Voltage multiplier to ensure ADC values come out correctly
- Support MCP and ADS1 Chips

## More Screenshots

![Overlay on TFT theme at 240p](_images/240_allicons.png)  
*Overlay on TFT theme at 240p*

![Overlay on Carbon theme at 1080p](_images/1080_carbon.png)  
*Overlay on Carbon theme at 1080p*

![Overlay on terminal](_images/1080_terminal.png)  
*Overlay on terminal*

![Battery Critical](_images/240_lowbat.png)  
*Battery Critical icon*

# Automatic Install Instructions

SSH into your device, or access the terminal using F4.
	
## Run RetroPie Status Overlay

    cd ~
    git clone https://github.com/louisvarley/retropie_status_overlay
    cd retropie_status_overlay
	sudo bash install.sh

## Follow the onscreen instructions

retropie_status_overlay will run as a service automatically at boot, and is called "retropie-status-overlay"
	
You can stop and start this service by running 
	
	sudo service retropie-status-overlay stop
	sudo service retropie-status-overlay start


## Battery Detection

During setup you can choose if you are using a ADS1 or a MCP based chip. 
MCP requires SPI pins and you set these during setup. 

## After Installation

After install, you will need to make some changes to config.ini to ensure everything works correctly with your battery and setup.	

## Calibration

Depending on many factors, from my experience with MCP based chips. 
The ADC (the number that the MCP chip returns from the given voltage) can vary depending on various factors such as VREF voltage. Some batterys have slight voltage variences, different chips sometimes seem to give slight different ADC values. 

You can use the config setting "Multiplier" to calibrate this. 
	
To do this. 
- Insert a fully charged battery
- Stop overlay service `sudo service retropie-status-overlay  stop`
- Run overlay manually using the command from your working directory `sudo python3 overlay.py`
- Make note of the voltage when the device is running using a multimeter
- Compare this to the voltage displayed by overlay
- Increase the multiplier in the config.ini file (2 decimal increments may be needed) until overlay and your multimeter have the same voltage. 

**Optionally** run down the battery and run the check again when it is low to ensure voltages still match. 
	
**For example**. My battery reads 3.56 volts. My ADC without multiplier comes in at 2.7v. I added a multiplier of 1.35 which brings me my voltage from ADC to 3.564v which is close enough. 

If you fail to calibrate you will have issues, such as the device not knowing its charged, thinking its empty when not, or full when not. 

## VMax, VMin, Charging and Discharging
These lines in config.ini dictate what is considered the Max and Min Thresholds and what there charging and discharging voltages are. This will really help narrow down when overlay considers the system charging or discharging. If these are not correct, symptoms include

- Shutting down before the battery has run low enough
- Showing charging when the battery is full but not charging
- Not showing charging when charger is plugged in

These can be calculated by again using a multimeter.  

**VMax Charging**
Battery Voltage when the battery is full and on charge. 

**VMax Discharging**
Battery Voltage when the battery is full and not being charged

**VMinCharging**
When Battery is almost dead and is being charged

**VMinDischarging**
When Battery is almost dead and not being charged

## ADCShutdown

With your multipiers and VMax/VMin Configured and confirmed as working you can enable ADCShutdown. This will shutdown your PI When the battery Reaches the VMin State. 

If you enable this before you have properly calibrated or set your VMINs and VMAXs, You can get stuck in a loop where by the PI boots and shutdowns down again, giving you only 60 seconds to disable the service. 

## Troubleshooting

### Stuck in Shutdown Loop
As above if you are stuck in a shutdown loop you will find the console wants to shutdown within 60 seconds of boot. You have a limited time to issue this command. 

 `systemctl disable retropi-status-overlay`

This will stop overlay running on boot. 
You can then edit your config. (maybe disable ADCShutdown) and then when confirmed working, re-enable

 `systemctl enable retropi-status-overlay`
## Change Log

**12/10/2020 - louisvarley**
- Moved some of the VMin/VMax settings from hard coded to config.ini
 - renamed service from overlay to retropie_status_overlay to prevent clashes

**13/10/2020- louisvarley**
- install.sh for MCP Chip and API Settings
- Added some color to install.sh
- Added Adafruit_MCP3008 to install.sh
- Configured install.sh to just use directory it is in for install and service
- Added multiplier in config, mainly for MCP Chip reasons
- overlay.py to use MCP Chip
- config.ini to enable or disable overlay in game
- config.ini to disable environmental warnings
- Changed from a crontab based job to a systemd based service 

**30/10/2020 louisvarley**
- Fixed name of service, change underscore to dash
