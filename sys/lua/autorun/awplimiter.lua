local msg2 = msg2
local parse = parse
local ctAWPbought, tAWPbought = 0, 0
local awpLimit = 1
local amountcheck = (awpLimit == 1) and " AWP" or " AWPs"
local sound = "wpn_denyselect.wav"

addhook("endround","endroundSet")
function endroundSet()
	ctAWPbought, tAWPbought = 0, 0
end

addhook("spawn","spawnCheck")
function spawnCheck(id)
	local itemlist = playerweapons(id)
	local team = player(id,"team") 
	if team == 2 and table_contains(itemlist,35) then
		ctAWPbought = ctAWPbought + 1
	elseif team == 1 and table_contains(itemlist,35) then
		tAWPbought = tAWPbought + 1
	end
end

addhook("buy","buyCheck",1)
function buyCheck(id,item)
	local team = player(id,"team")
    timer(10,"call2p2",id)
	if team == 1 and item == 35 then
		if tAWPbought == awpLimit then
			msg2(id,"Only "..awpLimit..amountcheck.." can be bought per team.")
			parse("sv_sound2 "..id.." "..sound)
			return 1
		else
			tAWPbought = tAWPbought + 1
		end
	elseif team == 2 and item == 35 then
		if ctAWPbought == awpLimit then
			msg2(id,"Only "..awpLimit..amountcheck.." can be bought per team.")
			parse("sv_sound2 "..id.." "..sound)
			return 1
		else
			ctAWPbought = ctAWPbought + 1
		end
    end
end