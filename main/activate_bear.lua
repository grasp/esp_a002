require "led"

activate_commands={
  {"AT+CNMP=38","CNMP"},
  {"AT+CMNB=2","CMNB"},
  {"AT+CSTT=cmnbiot","CSTT"},
  {"AT+SAPBR=1,1","OK"},
  {"AT+SAPBR=2,1","OK"}
}

activate_cmd_index=1
activate_echo_data={}

function  activate_bearer_body(device_state)

  uart.alt(1)
  uart.setup(0, 115200, 8, 0, 1, 0) -- no AT command self echo
  command=activate_commands[activate_cmd_index][1]

  if activate_cmd_index==1 then
    uart.write(0,command.."\r")
  end

  uart.on("data",'\r',function(data)
    if activate_cmd_index==5 then
      --check whether activated here
       activate_cmd_index=1  -- loop again
       tmr.delay(500*1000) --waiting activate

       if debug_flag == true then
         uart.alt(0)
         for i,v in ipairs(activate_echo_data) do
           print(i,v)
         end
       end
    end

  if data==nil or string.len(data)==1  then
  
  elseif data:match("%d+.%d+.%d+.%d+") then
       ip = data:match("%d+.%d+.%d+.%d+")
       if (ip and string.len(ip)> 7) then
         device_state.ip_addr=ip
       end
       
  -- do nothing for those empty data
  elseif string.find(data,"ERROR") then
      table.insert(activate_echo_data,data)

  elseif string.find(data,"OK") then
      -- check up after activate

      
      table.insert(activate_echo_data,data)
      activate_cmd_index=activate_cmd_index+1
      command=activate_commands[activate_cmd_index][1]
      uart.write(0,command.."\r")
  else
    table.insert(activate_echo_data,data)
 end

  end,0)
end

function activate_bearer()
  tmr.alarm(0,1000,1,function()

    activate_bearer_body()

  end)
end


--gpio_init()
--activate_bearer()
