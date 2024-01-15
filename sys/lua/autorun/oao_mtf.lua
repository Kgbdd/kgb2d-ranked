local msg, parse, pairs = msg, parse, pairs
local ttColor, ttColor2 = color.t, color.t2
local ctColor, ctColor2 = color.ct, color.ct2
local white = color.white
local sound1 = "fun/oneandonly.ogg"
local sound2 = "fun/maytheforce.ogg"

addhook('die', 'AA_die')
function AA_die(id)
local tt, ct = player(0, "team1living"), player(0, "team2living")
local function announceAndPlaySound(playerList, colorCode, colorCode2)
	local message = colorCode .. player(playerList[1], "name") .. colorCode2 .. " is one and only!@C" --player(playerID, "name")
	msg(message)
	parse("sv_sound " .. sound1)
end
	if #tt == 1 and #ct > 1 then --Only 1 T left while there are more than 1 CT
		announceAndPlaySound(tt, ttColor, ttColor2)
	elseif #ct == 1 and #tt > 1 then --Only 1 CT left while there are more than 1 T
		announceAndPlaySound(ct, ctColor, ctColor2)
	elseif #tt == 1 and #ct == 0 then --Only 1 T left, fight is over
		msg(ttColor .. player(tt[1], "name") .. ttColor2 .. " won the duel!@C")
	elseif #tt == 0 and #ct ==1 then --Only 1 CT left, fight is over
		msg(ctColor .. player(ct[1], "name") .. ctColor2 .. " won the duel!@C")
	elseif #tt == 1 and #ct == 1 then --Only 1 T and 1 CT left
		local msg1 = ttColor .. player(tt[1], "name") .. white .. " VS " .. ctColor .. player(ct[1], "name") .. "@C"
		local msg2 = ttColor .. player(tt[1], "health") .. "HP " .. white .. " - " .. ctColor .. player(ct[1], "health") .. "HP@C"
		msg(msg1)
		msg(msg2)
		parse("sv_sound2 " .. tt[1] .. " " .. sound2)
		parse("sv_sound2 " .. ct[1] .. " " .. sound2)
	end
end