-- place this in a scene to run daily to check the level of the battery and send a PROWL alert if below the defined level

local test_for_below  = 20

local room       = ""
local level_to_report  = ""
local serviceId  = "urn:micasaverde-com:serviceId:HaDevice1"
local variableId = "BatteryLevel"
local warning    = "The battery in the "
local level

-- duplicate these lines for each device to test

level = luup.variable_get(serviceId, variableId, 304) or "0"
level = tonumber(level)
if (level <  test_for_below) then 
  room = "CONSERVATORY" 
  level_to_report = level 
end

-- end of duplicated lines

if (room=="") then 
  return false 
end

-- local message_out = warning..room.." is now at "..level_to_report.."%"


luup.inet.wget("http://www.prowlapp.com/publicapi/add?apikey=PROWLAPIKEY&application=Vera+Temperature+Notification&event=Alert&description=Conservatory+thermostat+battery+level+is+at+" .. level_to_report .. "+percent+replace+soon&priority=1")
