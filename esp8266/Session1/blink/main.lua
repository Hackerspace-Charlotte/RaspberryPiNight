
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
      tmr.stop(0)
   end
end

tmr.alarm(0, 1000, 1, initwifi)

----------------------
-- Global Variables --
----------------------
led_pin = 1

-- Amy from Gargantia on the Verdurous Planet
led_high = "http://i.imgur.com/kzt3tO8.png"
led_low = "http://i.imgur.com/KS1dPa7.png"

led_state = 0
site_image = led_low

function setsiteimage()
   if 0 == led_state then
      site_image = led_low
   else
      site_image = led_high
   end
end
      
----------------
-- GPIO Setup --
----------------
print("Setting Up GPIO...")
print("LED")
gpio.mode(led_pin, gpio.OUTPUT)

----------------
-- Web Server --
----------------
print("Starting Web Server...")
-- Create a server object with 30 second timeout
srv = net.createServer(net.TCP, 30)

function esp_update(payload)
   mcu_do=string.sub(payload,postparse[2]+1,#payload)
   
   if mcu_do == "ON" then
      print("LED ON pressed")
      led_state = 1
   elseif mcu_do == "OFF" then
      print("LED OFF pressed")
      led_state = 0
   end
   gpio.write(led_pin, led_state)
   setsiteimage()
end

function finishsend(conn)
   conn:close()
end

function handlereceive(conn, payload)
   print(payload) -- Print data from browser to serial terminal

   --parse position POST value from header
   postparse={string.find(payload,"mcu_do=")}
   --If POST value exist, set LED power
   if postparse[2]~=nil then
      esp_update(payload)
   end

   -- CREATE WEBSITE (updated page to display)  --
   
   -- HTML Header Stuff
   conn:send('HTTP/1.1 200 OK\n\n')
   conn:send('<!DOCTYPE HTML>\n')
   conn:send('<html>\n')
   conn:send('<head><meta  content="text/html; charset=utf-8">\n')
   conn:send('<title>ESP8266 LED Blink</title></head>\n')
   conn:send('<body><h1>ESP8266 LED Blink</h1>\n')
   
   -- Images... just because
   conn:send('<IMG SRC="'..site_image..'" WIDTH="392" HEIGHT="196" BORDER="1"><br><br>\n')

   -- Buttons 
   conn:send('<form action="" method="POST">\n')
   conn:send('<input type="submit" name="mcu_do" value="ON">\n')
   conn:send('<input type="submit" name="mcu_do" value="OFF">\n')
   conn:send('</body></html>\n')
   conn:on("sent", finishsend)
end

-- if data received, print data to console,
-- then serve up a sweet little website
function onreceive(conn)
   conn:on("receive", handlereceive)
end

-- server listen on 80
srv:listen(80,onreceive)
