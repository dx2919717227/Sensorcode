sda = 2
scl = 1
local wifi1 = require "wifi1"

GYdata = {}
    GYdata["sensor"] = "GY2"
    GYdata["msg"] = 0

function initGY30()
    i2c.setup(0, sda, scl, i2c.SLOW)    
end

function readGY30(mode, func)
  
    i2c.start(0)
    i2c.address(0, 0x23, i2c.TRANSMITTER)
    i2c.write(0, 0x01)
    i2c.stop(0)
    
    i2c.start(0)
    i2c.address(0, 0x23, i2c.TRANSMITTER)
    i2c.write(0, mode)
    i2c.stop(0)
    
    tmr.create():alarm(130, tmr.ALARM_SINGLE, function()

        i2c.start(0)
        i2c.address(0, 0x23, i2c.RECEIVER)
        local c = i2c.read(0, 2)
       
        i2c.stop(0)
        if string.byte(c,1)~=0 then       
            local lx=string.byte(c, 1)*256+string.byte(c, 2)
            func(lx)
        else
            local lx=string.byte(c, 2)
            func(lx)
        end
    end)
end

initGY30()
tmr.create():alarm(3000,tmr.ALARM_AUTO,function()
    readGY30(0x20,function(lx)
        print('light intensity:'..lx)    
        GYdata["msg"] = lx;    
        --print_mob()
    end) 
end)
