function initGY30(sda ,scl)
     i2c.setup(0, sda, scl, i2c.SLOW)    
end

function readGY30(mode,func)
     i2c.start(0)
     i2c.address(0, 0x23, i2c.TRANSMITTER)
     i2c.write(0, 0x01)
     i2c.stop(0)
     i2c.start(0)
     i2c.address(0, 0x23, i2c.TRANSMITTER)
     i2c.write(0, mode)
     i2c.stop(0)
     tmr.alarm(2,129,tmr.ALARM_SINGLE,function()
       i2c.start(0)
       i2c.address(0, 0x23, i2c.RECEIVER)
       local c = i2c.read(0, 2)
       i2c.stop(0)
       if string.byte(c,1)~=0 then
           local lx=string.byte(c,1) * 256 + string.byte(c,2)
           func(lx)
       else
           local lx=string.byte(c,2)
           func(lx)
       end
     end)
end

initGY30(2,1)

dofile('SendData.lua')