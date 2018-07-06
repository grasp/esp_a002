-- record table for memory latest data
-- note : start from 1
th_record={

}

record_counter={
  correct=0,
  checksum=0,
  error=0
}

max_record_length=20
-- index for record
record_index=0

-- to get current index
function get_record_index()
  print("record index="..record_index)
  record_index=record_index+1
  if record_index<max_record_length then
    return record_index
  else
   return  record_index % 20
  end
end
-- to insert data into table
function insert_temp_humi(temp,humi)
  sec_time,msec_time = tmr.time()
  local record_pos=get_record_index()
  th_record[record_pos]={sec_time,temp,humi,false}
  return th_record,record_pos
end

-- single read temp and humi
function read_dht()
  local read_succ = 0
  --tmr.alarm(3, 2000, 1, function()
    status, temp, humi, temp_dec, humi_dec = dht.read(4)
    --sec_time,msec_time = rtctime.get()
    sec_time,msec_time = tmr.time()
    if status == dht.OK then
      --print(rtctime.get())
      --print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
      --math.floor(temp),
      --temp_dec,
      --math.floor(humi),
      --humi_dec))
      record_counter.correct=record_counter.correct+1
      return temp,humi
      elseif status == dht.ERROR_CHECKSUM then
        record_counter.checksum=record_counter.checksum+1
      elseif status == dht.ERROR_TIMEOUT then
        record_counter.error=record_counter.error+1
      elseif sec_time == 0 then
        print "we could not got rtc time from server"
      end

    --end)
    return -100,-100
end
