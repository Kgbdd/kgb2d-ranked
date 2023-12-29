local msg2 = msg2
local parse = parse
local awpCount = { 0, 0}
local awpLimit = 1
local amountcheck = (awpLimit == 1) and " AWP" or " AWPs"
local message = "Only " .. awpLimit .. amountcheck .. " can be bought per team."
local sound = "wpn_denyselect.wav"

addhook("endround","endroundSet")
function endroundSet()
	awpCount = { 0, 0}
end

addhook("spawn","spawnCheck")
function spawnCheck(id)
	local itemlist = playerweapons(id)
	local team = player(id,"team") 
	if table_contains(itemlist, 35) then
		awpCount[team] = awpCount[team] + 1
	end
end

--Be careful if you have multiple buy hooks, if you have more than 1 this won't work, keep that in mind!
addhook("buy","buyCheck",1)
function buyCheck(id,item)
	local team = player(id,"team")
    timer(10,"call2p2",id)
	if item == 35 and (awpCount[team] >= awpLimit) then
		msg2(id, message)
		parse("sv_sound2 " .. id .. " " .. sound)
		return 1	
	else
		awpCount[team] = awpCount[team] + 1
		return 0
	end
end
