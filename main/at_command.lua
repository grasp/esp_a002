function init_at_command()

  led_off()
  init_at_commands = {
    {"AT","OK"},
    {"AT+CGMR","CGMR"},
    {"AT+CSUB","CSUB"},
    {"AT+CNMP=38","CNMP"},
    {"AT+CMNB=2","CMNB"},
    {"AT+CSTT=cmnbiot","CSTT"},
    {"AT+CGATT?","CGATT"},
    {"AT+COPS?","COPS"},
    {"AT+CSQ","CSQ"},
    {"AT+CIICR","CIICR"},
    {"AT+CIFSR","CIFSR"},
    {"AT+SAPBR=2,1"}
  }

  echo_data={}
  command_index=1
  at_error=false

  finish_uart=true
  ip_init=false


end

function led_off()
 gpio.mode(0, gpio.OUTPUT)
 gpio.write(0, gpio.HIGH)
end

function led_on()
 gpio.mode(0, gpio.OUTPUT)
 gpio.write(0, gpio.LOW)
end

function set_uart_gpio()
  gpio.mode(8, gpio.OUTPUT,gpio.PULLUP)
  gpio.mode(7, gpio.INPUT,gpio.PULLUP)
end

function print_data(data)
 uart.alt(0)
 print(data)
end

function setup_at_command()
  set_uart_gpio()
  uart.alt(1)
  uart.setup(0, 115200, 8, 0, 1,1)
end


function register_uart_on(command,index,match_string)

 uart.on("data",0,function(data)
   led_on()
   if data==nil then
    return ""
    end

   if echo_data[index]==nil then
     echo_data[index]=""
   end

   echo_data[index]=echo_data[index]..data

  if string.find(data,"OK") then
    uart.on("data")
    led_off()
    command_index=command_index+1
  elseif string.find(data,"ERROR") then
    at_error=true
    command_index=command_index+1
  else
    --continue receive data
  end

  end, 0)
end

function write_at_command(command,index,match_string)
  led_off()
  setup_at_command()
  uart.write(0,command.."\r")
  register_uart_on(command,index,match_string)
end

function print_at_result()
  uart.alt(0)
  for key,value in ipairs(echo_data) do
   o_cmd=command_list[key][1]
   print("\r\n"..o_cmd.."\r\n")
   print(value)
   print("\r\n")
  end
end


 init_at_command()

 tmr.alarm(0,1000,1,function()

   if ip_init==false then
    command_list=init_at_commands
   end

   max_index=table.maxn(command_list)
   if (command_index < max_index) then
     command=command_list[command_index][1]
     match_string=command_list[command_index][2]
     write_at_command(command,command_index,match_string)
   else
     print_at_result()
   end

end)
