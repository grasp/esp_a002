require "check_attached"
require "check_ip"
require "activate_bear"
require "temp_humi"
require "http_data"

debug_flag=true
nbiot_registed=false
attach_ip=""
attached=false

device_state={
 ["attached"]=false,
 ["debug_flag"]=true,
 ["ip_checked"]=false,
 ["ip_addr"]=""
}

--function a002_main()
  --init
  gpio_init()

  tmr.alarm(0,2000,1,function()
   --check registed
    if device_state.attached == false then

       check_lte_registed_body(device_state)

    elseif device_state.ip_checked==false  then

       check_ip_body(device_state)

    elseif string.len(device_state.ip_addr)==0 then

      --will run each at command in that file per this timer
      activate_bearer_body(device_state)

    elseif string.len(device_state.ip_addr)>0 then
      --uart.alt(0)
    --  print(device_state.ip_addr)
      temp,humi=read_dht()
      tmr.interval(0,10000)
      --print(temp,humi)
     http_request_body(device_state,temp,humi)
    --print("I am prepare for http")

        -- read dht

        -- http send data

        -- http receive data
    else

     print("i am idle")

    end
  end)
--end

-- activate bear

-- check ip



--a002_main()
