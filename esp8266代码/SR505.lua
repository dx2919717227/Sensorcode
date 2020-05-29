PIRpin1=5
PIRpin2=6
require "wifi1"

SR1data = {}
    SR1data["sensor"] = "SR3"
    SR1data["msg"] = 0

SR2data = {}
    SR2data["sensor"] = "SR4"
    SR2data["msg"] = 0

gpio.mode(PIRpin1,gpio.INT)
gpio.trig(PIRpin1,'both',function(a)
    if a == 1 then
        --print("pir3 come")
        SR1data["msg"]=a
        print_mob()
    else 
      --  print("pir3 leave")
        SR1data["msg"]=a
        print_mob()
    end
end)

--gpio.mode(PIRpin2,gpio.INT)
--gpio.trig(PIRpin2,'both',function(b)
--    if b == 1 then
--       -- print("pir4 come")
--        SR2data["msg"]=b
--        print_mob()
--    else 
--       -- print("pir4 leave")
--        SR2data["msg"]=b
--        print_mob()
--    end
--end)
