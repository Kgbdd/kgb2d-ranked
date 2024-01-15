local parse, msg, msg2 = parse, msg, msg2
local firstblood = "fun/firstblood.wav"
local humiliation = "fun/humiliation.wav"
local godlike = "fun/godlike.wav"

if sample==nil then sample={} end
sample.ut={
	level = array(32),
    fblood = 0
}

local levels = {}
levels[2] = {"173255047","made a Doublekill!","fun/doublekill.wav"}
levels[3] = {"026255525","made a Multikill!","fun/multikill.wav"}
levels[4] = {"000206209","made a Killingspree!@C","fun/killingspree.wav"}
levels[5] = {"132112255","is on Rampage!@C","fun/rampage.wav"}
levels[6] = {"138043226","is UNSTOPPABLE!@C","fun/unstoppable.wav"}
levels[7] = {"138043226","made a Ultrakill!@C","fun/ultrakill.wav"}
levels[8] = {"138043226","made a MO-O-O-O-ONSTERKILL-ILL-ILL!@C","fun/monsterkill.wav"}

addhook("startround","sample.ut.startround")
function sample.ut.startround()
	sample.ut.fblood=0
	sample.ut.level=array(32)
end

addhook("kill","sample.ut.kill")
function sample.ut.kill(killer,victim,weapon)
local playerlist=player(0,"table")
level=sample.ut.level[killer]
level=level+1
sample.ut.level[killer]=level
	if (sample.ut.fblood==0) then
		sample.ut.fblood=1
		for _,id2 in pairs(playerlist) do
			if playerdata[id2] and playerdata[id2].Options.Utsfx == "Enabled" then
				parse("sv_sound2 "..id2.." "..firstblood)
				local msg = "\169200000000"..player(killer,"name").." sheds FIRST BLOOD!@C"
				msg2(id2, msg)
			end
		end
	end
	if (weapon==50) then
		for _,id2 in pairs(playerlist) do
			if playerdata[id2] and playerdata[id2].Options.Utsfx == "Enabled" then
				parse("sv_sound2 "..id2.." "..humiliation)
				local msg = "\169255069000"..player(killer,"name").." humiliated "..player(victim,"name").."!"
				msg2(id2, msg)
			end
		end
	else
		local levelData = levels[level] and levels[level] or (level > #levels and {"000255000", "IS GODLIKE! " .. level .. " KILLS!@C", godlike} or nil)
		for _, id2 in pairs(playerlist) do
			if playerdata[id2] and playerdata[id2].Options.Utsfx == "Enabled" and levelData then
				parse("sv_sound2 " .. id2 .. " \"" .. levelData[3] .. "\"")
				local msg = "\169" .. levelData[1] .. player(killer, "name") .. " " .. levelData[2]
				msg2(id2, msg)
			end
		end
	end
end