require "led"

activated=false

echo_data={}

function check_ip_body(device_state)
  device_state.ip_checked=true
  
  uart.alt(1)
  uart.setup(0, 115200, 8, 0, 1,0)
  led1_flash1()
  if activated==false then
    uart.write(0,"AT+SAPBR=2,1".."\r")
  end

  uart.on("data",'\r',function(data)
    led1_flash1()
    table.insert(echo_data,data)
    if data==nil or string.len(data)==0 then
    else
    ip = data:match("%d+.%d+.%d+.%d+")
    if (ip and string.len(ip)> 7) then
    
      device_state.ip_addr=ip
      activated=true
      
      if device_state.debug_flag==true then
        uart.alt(0)
        for i,v in ipairs(echo_data) do
          print(i,v)
        end
        print(ip)
      end
    end
   end

  end,0)
end

function check_ip()

  tmr.alarm(0,1000,1,function()
    check_ip_body()
  end)

end

 --gpio_init()
 --check_ip()
