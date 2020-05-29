if file.open('dataserver.txt', "r") then
   data_server = cjson.decode(file.readline())
   file.close()
else
   node.restart()
end

srv = net.createConnection(net.TCP, 0)

function sendData()
    readGY30(0x10, function(num) 
        srv:send("{\"sensor\":\"GY1\",\"msg\":" .. tostring(num) .. "}") 
    end)
end

srv:on("receive", function(sck, c) print(c) end)

srv:on("connection", function(sck, c)
    print("connection established!")
    dataTimer = tmr.create()
    dataTimer:register(data_server.interval * 1000, tmr.ALARM_AUTO, sendData)
    dataTimer:start()
end)

srv:connect(data_server.port, data_server.ip)
