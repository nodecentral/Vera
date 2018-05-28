local d, n
local file = io.open("/www/last_trip_table.html", "w")
  
  file:write("<html><head><meta charset=\"utf-8\"> <meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\">")
  
   file:write("<style type=\"text/css\">body {font-family: monospace;font-size: 13px; white-space: pre-wrap;}.custom { font-size: 1em; font-family: Gill Sans Extrabold, sans-serif; padding:5px; border-collapse: collapse; border: 1px solid black; } table { width:100% } .th { width:50% }</style></head>\n")

   file:write("<body><table class=custom><tr class=custom><th class=custom>Security Sensor</th><th class=custom>Last Tripped</th></tr><br/>\n")

local tt = {}
for n,d in pairs(luup.devices) do

    if d.category_num == 4 then
    -- local lasttrip = tonumber(luup.variable_get("urn:micasaverde-com:serviceId:SecuritySensor1", "LastTrip", n) or 0,10)
    local lasttrip = tonumber(luup.variable_get ("urn:micasaverde-com:serviceId:SecuritySensor1", "LastTrip", n) or os.time())
    local timeString = os.date(" %Y/%m/%d - %X", lasttrip)
    
    if lasttrip > 0 then
        table.insert(tt, { devnum=n, last=lasttrip, ltime=timeString })
    end
  end
end

table.sort(tt, function(a,b) return a.last > b.last end) -- sort highest to lowest

for n,d in ipairs(tt) do
    
   file:write("<tr class=custom><td class=custom>" .. luup.devices[d.devnum].description .. "</td><td class=custom>".. d.ltime .. "</td></tr>\n")

    print (
    d.ltime ..
   ' : ' .. luup.devices[d.devnum].description .. " Sensor was last tripped")
end
file:write("</table>\n")
file:close()
