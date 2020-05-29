wifi.setmode(wifi.SOFTAP)
cfg={}
cfg.ssid="config" 
cfg.pwd="00000000"
wifi.ap.config(cfg)

cfg2 =
{
ip="192.168.1.1",
netmask="255.255.255.0",
gateway="192.168.1.1"
}
wifi.ap.setip(cfg2)

dofile('HttpServer.lua')

function saveDataServer()
  if file.open('dataserver.txt', "w+") then
    file.write(cjson.encode(data_server))
    file.close()
  end
end

httpServer:use('/config', function(req, res)
    if req.query.ssid ~= nil and req.query.pwd ~= nil then
        print(req.query.ssid..req.query.pwd)
        config={
        auto = true,
        save = true,
        ssid = req.query.ssid,
        pwd = req.query.pwd
        }
        data_server.interval = tonumber(req.query.interval)
        data_server.ssid = req.query.ssid
        data_server.pwd = req.query.pwd
        data_server.ip = req.query.ip
        data_server.port = tonumber(req.query.port)
        saveDataServer()
    end
    res:send('<head><meta charset="UTF-8"><title>Config</title></head><h1>'..cjson.encode(data_server)..'Restart after 10 seconds.</h1>')

    tmr.alarm(0,10000, tmr.ALARM_SINGLE, function() 
        wifi.setmode(wifi.STATION)
        wifi.sta.config(config)
        node.restart() 
    end)
end)

httpServer:listen(80) 
