require "led"
readed=false
count=1
echo_data={}

gpio_init()
tmr.alarm(0,2000,1,function()
  uart.alt(1)
  uart.setup(0, 115200, 8, 0, 1,0)
  led2_flash1()
  count=count+1

  if readed==false then
    uart.write(0,"AT+HTTPREAD".."\r")
  end

  uart.on("data",'\r',function(data)
    led1_flash1()
    table.insert(echo_data,data)
    if string.find(data,"OK") or count==5 then
      readed=true
      uart.alt(0)
      for i,v in ipairs(echo_data) do
        print(i,v)
      end
      tmr.stop(0)
    end

  end,0)


end)
