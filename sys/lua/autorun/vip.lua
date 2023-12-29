local parse = parse
local random = math.random
local image, imagealpha, imagescale, freeimage = image, imagealpha, imagescale, freeimage
local sound2 = "kgb2d/vip/bell.ogg"
userrank = {}

addhook("spawn","spawnHandler")
function spawnHandler(id)
	if userrank[id] then
		freeimage(userrank[id])
		timer(300,"showRankIcon",id)	
	elseif not userrank[id] then
		timer(300,"showRankIcon",id)	
	end
end

function showRankIcon(id)
	local id = tonumber(id)
	ico = ranks[playerdata[id].Stat.RankLvl].icon
	userrank[id] = image(ico, 0, 0, 200+id)
	imagealpha(userrank[id], 0.75)
	imagescale(userrank[id], 0.75, 0.75)
end

function updateRankIcon(id)
	local id = tonumber(id)
	if userrank[id] then
		freeimage(userrank[id])
	end

	ico = ranks[playerdata[id].Stat.RankLvl].icon
	userrank[id] = image(ico, 0, 0, 200+id)
	imagealpha(userrank[id], 0.75)
	imagescale(userrank[id], 0.75, 0.75)
end

	

addhook("leave","_sleave")
function _sleave(id)
	if userrank[id] then
		freeimage(userrank[id])
		userrank[id] = false
	end
end

addhook("hit","_hit")
function _hit(victim, attacker, wpn, hpdmg)
	local pd = playerdata[attacker].Vip
	local atk, vct = player(attacker, "team"), player(victim, "team")
		if pd.Status and atk ~= vct and attacker ~= 0 and hpdmg ~= 0 and pd.Hs == "On" then
		--if pd.Hs == "On" then
			local sound = "kgb2d/vip/hit" .. random(1, 5) .. ".ogg"
			parse("sv_sound2 " .. attacker .. " " .. sound)
		--end
	end
end

addhook("kill","_kill")
function _kill(killer, victim)
	local pd = playerdata[killer].Vip
    if pd.Status and pd.Ks == "On" then
        parse("sv_sound2 " .. killer .. " " .. sound2)
    end
end