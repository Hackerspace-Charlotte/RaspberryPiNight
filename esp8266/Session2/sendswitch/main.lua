----------------------
-- Global Variables --
----------------------
sw_pin = 2
sw_state = 0

http = require("http")
serverurl = "http://nnn.nnn.nnn.nnn:1880/alert"

----------------
-- GPIO Setup --
----------------
print("Setting Up GPIO...")
gpio.mode(sw_pin, gpio.INPUT)


------------------
-- State Sender --
------------------

function httpcb(code, data)
   if (0 > code) then
      print("HTTP request failed")
   else
      print(code, data)
   end
end

function state_sender()
   print("Sending HTTP request")
   http.get(serverurl, nil, httpcb)
end
-------------------
-- Switch Reader --
-------------------

function esp_update()
   -- print("Reading switch")
   sw_state = gpio.read(sw_pin)
   -- print("GPIO reading")
   -- print(sw_state)
   if 0 == sw_state then
      print("Switch pressed")
      state_sender()
   else
      print("Switch released")
   end
end


----------------------------------
-- WiFi Connection Verification --
----------------------------------
function initwifi()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...\n")
   else
      ip, nm, gw=wifi.sta.getip()
      print("IP Info: \nIP Address: ",ip)
      print("Netmask: ",nm)
      print("Gateway Addr: ",gw,'\n')
      -- Now that we are connected, stop timer that repeatedly tries to connect.
      tmr.stop(0)
      -- Start timer that checks state of switch
      tmr.alarm(0, 5000, 1, esp_update)
   end
end

-- Start by initializing wifi
tmr.alarm(0, 1000, 1, initwifi)
