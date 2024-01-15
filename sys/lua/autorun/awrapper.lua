local pairs = pairs
local player = player

function isPlayerLoggedIn(id)
	return player(id,"steamid") ~= "0" or player(id,"usgn") ~= 0
end

function isPlayerLoggedInSteam(id)
	return player(id,"steamid") ~= "0"
end

function isPlayerLoggedInUSGN(id)
	return player(id,"usgn") ~= 0
end

function isCT(id)
	return player(id,"team") == 2
end

function isT(id)
	return player(id,"team") == 1
end

function isSpec(id)
	return player(id,"team") == 0
end

function isAlive(id)
    return player(id,"health") > 0
end

function Round(num, dp)
    --[[
    examples
        173.2562 rounded to 0 dps is 173.0
        173.2562 rounded to 2 dps is 173.26
        173.2562 rounded to -1 dps is 170.0
    ]]--
    local mult = 10^(dp or 0)
    return math.floor(num * mult + 0.5)/mult
end

function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours, mins, secs
end

function secondsToHMS(seconds)
    -- Calculate the number of hours, minutes, and seconds
    local days = math.floor(seconds / 86400)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
  
    -- Return the result as a formatted string
    return string.format("%2dd %2dh %02dm", days, hours, minutes)
  end

function table_contains(tbl, x)
    found = false
    for _, v in pairs(tbl) do
        if v == x then 
            found = true 
        end
    end
    return found
end

function table_removekey(table, key)
    local element = table[key]
    table[key] = nil
    return element
 end

function array(length,mode)
	local array = {}
	if mode == nil then 
	mode = 0 end
	for i = 1,length do 
		array[i] = mode	
	end
	return array
end

function math.average(...)
    local sum = 0
    local i = 0
    while (i < #arg) do
        i = i + 1
        sum = sum + arg[i]
    end
    return sum/#arg
end