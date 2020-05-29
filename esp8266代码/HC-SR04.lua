
trigPin = 8	
echoPin = 7	

duration = 0
distance = 0
start = 0

require "wifi1"

HCdata = {}
    HCdata["sensor"] = "HC2"
    HCdata["msg"] = 3000

function setup()
	gpio.mode(trigPin,gpio.OUTPUT)
	gpio.mode(echoPin,gpio.INPUT)
end

function loop()
	--clear trigPin
	gpio.write(trigPin,gpio.LOW)
	tmr.delay(2)
	
	-- trigPin high 0.01ms
	gpio.write(trigPin,gpio.HIGH)
	tmr.delay(10)
	gpio.write(trigPin,gpio.LOW)
	
	-- read echoPin
	while gpio.read(echoPin)==gpio.LOW do 
	end
	start = tmr.now()
	while gpio.read(echoPin)==gpio.HIGH do
	end
    duration = tmr.now()
    if (duration < start)
	then duration = duration+2147283648-start
    else
    duration = duration-start
    end
	
	-- calculate distance(cm)
	distance = duration*0.034/2
	print(distance.."cm")
    HCdata["msg"] = distance
    print_mob()
end

setup()
tmr.create():alarm(3000,tmr.ALARM_AUTO,loop)
	
	
