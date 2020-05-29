station_cfg={}
station_cfg.ssid="onion"
station_cfg.pwd="dbdx10c482"
station_cfg.save=true

wifi.setmode(wifi.STATION)
wifi.sta.connect()
wifi.sta.config(station_cfg)

local modname = 'wifi1'
local M = {}
_G[modname] = M
package.loaded[modname] = M

flag = 0
gpio.mode(4,gpio.OUTPUT)
sk = net.createConnection(net.TCP, 0)

function print_mob()
    if flag == 1 then
        sk:send(sjson.encode(SR1data))
--        sk:send(sjson.encode(SR2data))
        sk:send(sjson.encode(HCdata))
        sk:send(sjson.encode(GYdata))
      --  sk:send(sjson.encode(table))
    end 
end

function serverconnect()
    mytimer:stop()
    SERVER_PORT = 8010
    SERVER_IP = '192.168.199.198'
    
    sk:on("connection", function(sck, c)
        print('connected')
        dofile("GY-30.lua")
        dofile("HC-SR04.lua")
        dofile("SR505.lua")
        flag = 1
    end)

    sk:on("disconnection", function(c)
        print('disconnect')
        flag = 0
        timer1 = tmr.create()
        timer1:alarm(3000, tmr.ALARM_SINGLE, function()
            mytimer:start()
        end) 
    end)
    sk:connect(SERVER_PORT, SERVER_IP)   
    sk:on("receive", dispatch)
end

mytimer = tmr.create()

mytimer:alarm(1000, tmr.ALARM_AUTO, function()
    if wifi.sta.getip() == nil then
        print('Waiting for IP ...')
        gpio.write(4,gpio.HIGH)
    else
        print('IP is ' .. wifi.sta.getip())
        gpio.write(4,gpio.LOW)
        
        serverconnect()
    end
end)
