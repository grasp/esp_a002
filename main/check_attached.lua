require "led"
attached=false
count=1
echo_data={}

--single timer loop main body
function check_lte_registed_body(device_state)

  uart.alt(1)
  uart.setup(0, 115200, 8, 0, 1,0)
  led2_flash1()
  count=count+1

  if attached==false then
    uart.write(0,"AT+CGREG?".."\r")
  end

  uart.on("data",'\r',function(data)
    
    table.insert(echo_data,data)
    if string.find(data,"CGREG: 0,1") then
      device_state.attached=true
      led1_flash1()
      attached=true
      if device_state.debug_flag == true then
        uart.alt(0)
        for i,v in ipairs(echo_data) do
          print(i,v)
        end
      end
    end

  end,0)
end

--self test funciton
function  check_lte_registed()
  tmr.alarm(0,2000,1,function()
    attached=false
    check_lte_registed_body()
    if attached==true then
      tmr.stop(0)
    end

  end)
end

--gpio_init()
--check_lte_registed()
