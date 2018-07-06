
function gpio_init()
  gpio.mode(0, gpio.OUTPUT,gpio.PULLUP)  -- led 1
  gpio.mode(4, gpio.OUTPUT,gpio.PULLUP) -- led 2
  gpio.mode(8, gpio.OUTPUT,gpio.PULLUP) -- txd
  gpio.mode(7, gpio.INPUT,gpio.PULLUP)  -- rxd
end

function led2_off()
  gpio.mode(4, gpio.OUTPUT)
  gpio.write(4, gpio.HIGH)
end

function led2_on()
  gpio.mode(4, gpio.OUTPUT)
  gpio.write(4, gpio.LOW)
end

function led1_off()
  gpio.mode(0, gpio.OUTPUT)
  gpio.write(0, gpio.HIGH)
end

function led1_on()
  gpio.mode(0, gpio.OUTPUT)
  gpio.write(0, gpio.LOW)
end

function led1_flash1()
  led1_on()
  tmr.delay(50*1000)
  led1_off()
end

function led1_flash2()
  led1_on()
  tmr.delay(100*1000)
  led1_off()
  led1_on()
  tmr.delay(100*1000)
  led1_off()
end

function led2_flash1()
  led2_on()
  tmr.delay(50*1000)
  led2_off()
end

function led2_flash2()
  led2_on()
  tmr.delay(100*1000)
  led2_off()
  led2_on()
  tmr.delay(100*1000)
  led2_off()
end
