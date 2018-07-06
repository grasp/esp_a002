require "led"
readed=false




function http_response_body()

  uart.alt(1)
  uart.setup(0, 115200, 8, 0, 1,0)
  led2_flash1()
  echo_data={}
  uart.write(0,"AT+HTTPREAD".."\r")

  uart.on("data",'\r',function(data)
    table.insert(echo_data,data)
    if string.find(data,"OK") then
      tmr.delay(100*1000)
      uart.alt(0)
      for i,v in ipairs(echo_data) do
        print(i,v)
      end
       uart.alt(1)
    end

  end,0)
end
