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
    local rank, player = checkrank(id), player(id, "name")
    local vipStatus = playerdata[id] and rank <= 50 and rank ~= 0
    playerdata[id].Vip.Status = vipStatus
    print(vipStatus and color.green .. player .. " is in top50, gained VIP" or "")
end

function returnStats(id, opt)
	local usgn, steam = player(id,"usgn"), player(id,"steamid")
	local usgnrank, steamrank = stats(usgn, opt), steamstats(steam, opt)
	local option = steam ~= "0" and (usgn ~= 0 and usgnrank or steamrank) or (usgn ~= 0 and usgnrank)
	return option
end

addhook("serveraction", "_serveraction")
function _serveraction(id, ac)
    if ac == 1 and isPlayerLoggedIn(id) then
		local pd = playerdata[id].Options
		local opt = isEligible(id) and "VIP Options|YOU GAINED ACCESS" or ""
        menu(id, "Options@b,Ultimate Sound Effects|"..pd.Utsfx..",Announcer Messages & Sound Effects|"..pd.Announcer..",Private Messages|"..pd.Pm..",,"..opt)
    --[[elseif ac == 3 and isPlayerLoggedIn(id) then
        local point, level, r = playerdata[id].Stat.Points, playerdata[id].Stat.RankLvl, ranks[playerdata[id].Stat.RankLvl]
		local nextRankTxt, nextRankAtPoint = r.tag ~= "Global" and ranks[level+1].rank or "none", r.tag ~= "Global" and ranks[level+1].elostart or "none"
		local final, total = Round(returnStats(id,"killsperdeath"), 2), stats(0,"count") + steamstats("0","count")
        menu(id, "Rank Menu@b,Current Rank|"..r.rank.." | "..point..",Earn and Loss|"..r.ppk.." | "..r.pointloss..",Next Rank|"..nextRankTxt.." | "..nextRankAtPoint..",,Rank|"..checkrank(id).." of "..total..",Frags|"..returnStats(id,"frags")..",Deaths|"..returnStats(id,"deaths")..",KPD|"..final..",MVP|"..returnStats(id,"mvp"))]]--
    end
end

addhook("menu","_options")
function _options(id,title,button)
	if title=="Options" then
		if button >= 1 and button <= 3 then
			local options = {"Utsfx", "Announcer", "Pm"}
			change(id,1, options[button], "Enabled", "Disabled")
		elseif button == 5 then
			local pd = playerdata[id].Vip
			menu(id, "VIP Options@b,Hit Sounds|"..pd.Hs..",Kill Sound|"..pd.Ks..",Show Damage|"..pd.SDamage)
		end
	end
	if title=="VIP Options" then
		if button >= 1 and button <= 4 then
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