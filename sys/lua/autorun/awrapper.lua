local parse = parse
local pairs = pairs

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

function table_contains(tbl, x)
    found = false
    for _, v in pairs(tbl) do
        if v == x then 
            found = true 
        end
    end
    return found
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
