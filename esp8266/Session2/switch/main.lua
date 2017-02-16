----------------------
-- Global Variables --
----------------------
sw_pin = 2
sw_state = 0

----------------
-- GPIO Setup --
----------------
print("Setting Up GPIO...")
gpio.mode(sw_pin, gpio.INPUT)

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
   else
      print("Switch released")
   end
end

tmr.alarm(0, 1000, 1, esp_update)
