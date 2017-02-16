-- Network Variables
ssid = "HSC"
pass = "youdidittoyourself"

-- Configure Wireless Internet
wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')\n')
print('MAC Address: ',wifi.sta.getmac())
print('Chip ID: ',node.chipid())
print('Heap Size: ',node.heap(),'\n')

-- Configure WiFi
wifi.sta.config(ssid,pass)

function runmain()
   dofile("main.lua")
end

-- Byline
print('\nNodeMCU init. Will run main.lua in 10 seconds')

tmr.alarm(0, 10000, tmr.ALARM_SINGLE, runmain)
