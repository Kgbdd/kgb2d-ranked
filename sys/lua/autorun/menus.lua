local menu, parse, tonumber = menu, parse, tonumber
local sound = "env/click2.wav"

function isEligible(id)
	return playerdata[id].Vip.Status == true
end

function isEligible2(id)
	return checkrank(id) <= 50 and checkrank(id) ~= 0
end

function checkrank(id)
    local usgn, steam = player(id,"usgn"), player(id,"steamid")
    local usgnrank, steamrank = tonumber(stats(usgn,"rank")), tonumber(steamstats(steam,"rank"))
    return player(id, "steamid") ~= "0" and (usgn ~= 0 and usgnrank or steamrank) or (usgn ~= 0 and usgnrank or 0)
end

function checkVip(id)
	local rank = checkrank(id)
	local player = player(id,"name")
	if playerdata[id] and rank <= 50 and rank ~= 0 then
		playerdata[id].Vip.Status = true
		print(color[4]..player.." is in top50, gained VIP")
	else 
		playerdata[id].Vip.Status = false
	end
end

addhook("serveraction", "_serveraction")
function _serveraction(id, ac)
    local pd, pd2 = playerdata[id].Options, playerdata[id].Vip

    if ac == 1 and isPlayerLoggedIn(id) then
        menu(id, "Options@b,Weapon Deploy Sounds|"..pd.Deploy..",Ultimate Sound Effects|"..pd.Utsfx..",Announcer Messages & Sound Effects|"..pd.Announcer..",Private Messages|"..pd.Pm)
    elseif ac == 2 and isEligible(id) then
        menu(id, "Vip Options@b,Hit Sounds|"..pd2.Hs..",Kill Sound|"..pd2.Ks..",Show Damage|"..pd2.SDamage)
    elseif ac == 3 and isPlayerLoggedIn(id) then
        local point, level, r = playerdata[id].Stat.Points, playerdata[id].Stat.RankLvl, ranks[playerdata[id].Stat.RankLvl]
        menu(id, "Rank Menu@b,Current Rank|"..r.rank..",Current Elo Points|"..point..",Point per Kill|"..r.ppk..",Point Loss on Death|"..r.pointloss..",,Next Rank|"..(r.tag ~= "Global" and ranks[level+1].rank or "none")..",Next Rank at|"..(r.tag ~= "Global" and ranks[level+1].elostart or "none"))
    end
end

addhook("menu","_options")
function _options(id,title,button)
	if title=="Options" then
		if button >= 1 and button <= 4 then
			local option = (button == 1) and "Deploy" or 
			((button == 2) and "Utsfx") or
			((button == 3) and "Announcer") or
			((button == 4) and "Pm")
			change(id, 1, option, "Enabled", "Disabled")
		end
	end
	if title=="Vip Options" then
		if button >= 1 and button <= 4 and playerdata[id].Vip.Status == true then
			local options = {"Hs", "Ks", "SDamage"}
			change(id, 2, options[button], "On", "Off")
		end
	end
end

function change(id, opt, key, value, value2)
	parse("sv_sound2 "..id.." "..sound)
	local data = (opt == 1) and playerdata[id].Options or playerdata[id].Vip
	data[key] = (data[key] == value) and value2 or value
end