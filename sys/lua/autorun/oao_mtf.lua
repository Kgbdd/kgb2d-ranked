local msg, parse, pairs = msg, parse, pairs
local ttColor, ttColor2 = "\169255025000", "\169150110100"
local ctColor, ctColor2 = "\169050150255", "\169110130150"
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

	if #tt == 1 and #ct ~= 1 and #ct ~= 0 then
		announceAndPlaySound(tt, ttColor, ttColor2)
	elseif #ct == 1 and #tt ~= 1 and #tt ~= 0 then
		announceAndPlaySound(ct, ctColor, ctColor2)
	--end

	--if #tt == 1 and #ct == 1 then
	elseif #tt == 1 and #ct == 1 then
		local msg1 = ttColor .. player(tt[1], "name") .. " \169255255255VS " .. ctColor .. player(ct[1], "name") .. "@C"
		local msg2 = ttColor .. player(tt[1], "health") .. "HP \169255255255- " .. ctColor .. player(ct[1], "health") .. "HP@C"
		msg(msg1)
		msg(msg2)
		parse("sv_sound2 " .. tt[1] .. " " .. sound2)
		parse("sv_sound2 " .. ct[1] .. " " .. sound2)
	end
end