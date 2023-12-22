local s, msg2 = 0, msg2
local messages = {
" \174gfx/kgb2d/minute/warning.png \169255000000\169255255255This is a playtest, \169255025000your user data may not be saved or may be deleted.",
" \174gfx/kgb2d/minute/announce.png \174gfx/kgb2d/skins/gem.png\169114137218TOP50 players get \169255255255VIP features",
" \174gfx/kgb2d/minute/announce.png \174gfx/kgb2d/minute/dc.png\169114137218Join our Community Discord Server! >> \169255255255DSC.GG/KGB2D",
" \174gfx/kgb2d/minute/announce.png \169255255255You can send private messages! >> \169000220000@id message",
" \174gfx/kgb2d/minute/announce.png \169255069000Knifing, \169255025000Bomb Exploding \169255255255and \169050150255Bomb Defusing \169255255255gives you \169000220000extra points!",
" \174gfx/kgb2d/minute/announce.png \169255255255Press >\169000220000F2\169255255255< for \169000220000Options Menu"
}

addhook("minute","minuteHandler")
function minuteHandler()
	local playerlist = player(0,"table")
	s= s + 1
	for _,id in pairs(playerlist) do
		if playerdata[id] and playerdata[id].Options.Announcer == "Enabled" then
			msg2(id,messages[s])
		end
	end
	if s == #messages then
		s = 0
	end
end