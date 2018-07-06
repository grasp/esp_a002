require "led"

command_index=1
echo_data={}
count=0
chipid=node.chipid()
local_temp=-100
local_humi=-100

url_host_base="http://noki.s1.natapp.cc/devices/post_data/"

function generate_url(abase,achipid,atemp,ahumi)
  local url=abase..achipid.."/"..atemp.."/"..ahumi
  return '"'..url..'"'
end


http_command={

  {"AT+HTTPTERM","OK"},
  {"AT+HTTPINIT","OK"},
  {'AT+HTTPPARA="CID",1',"OK"},
  {'AT+HTTPPARA="URL",'..generate_url(url_host_base,chipid,local_temp,local_humi),"OK"},
  {"AT+HTTPACTION=0","OK"}
  --{"AT+HTTPREAD","OK"},
  --{"AT+HTTPTERM","OK"}
}



function http_request_body(device_state,temp,humi)

  count=count+1
  uart.alt(1)
  uart.setup(0, 115200, 8, 0, 1,0)

  for command_index,command_pair in ipairs(http_command) do

    command=http_command[command_index][1]

    if command_index==1 then
      echo_data={}
      device_state.http_request=true
    elseif command_index ==4 then
      new_string=generate_url(url_host_base,chipid,temp,humi)
      command='AT+HTTPPARA="URL",'..new_string
    elseif command_index==5 then
        device_state.http_request=false
    end

    tmr.delay(50*1000)
    uart.write(0,command.."\r")
  end

  uart.on("data",function(data)
    led1_flash1()
    if command_index==5  then
       if device_state.debug_flag==true then
         uart.alt(0)
         for i,v in ipairs(echo_data) do
           print(i,v)
         end
       end
    end

    table.insert(echo_data,data)

  end,0)
end

function http_request()
  tmr.alarm(1,2000,1,function()

  end)
end
