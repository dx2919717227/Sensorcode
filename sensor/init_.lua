gpio.mode(3, gpio.INT)



data_server = {}

dofile('blink.lua')

function reConfig(level, pulse2)
    local mytimer = tmr.create()
    mytimer:register(2000, tmr.ALARM_SINGLE, function()
        if gpio.read(3) == 0 then
            print('reset!') 
            file.remove('dataserver.txt')
            node.restart()    
        else
            print('connect to:'..data_server.port..':'..data_server.ip)       
            srv:connect(data_server.port, data_server.ip)
        end
    end)
    mytimer:start()
end

gpio.trig(3, "down", reConfig)

if file.exists("dataserver.txt") then
    node.egc.setmode(node.egc.ALWAYS, 4096)
    dofile('GY30.lua')
else
    node.egc.setmode(node.egc.ALWAYS)
    dofile('WebPage.lua')
end

