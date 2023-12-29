local parse, msj, msj2 = parse, msg, msg2
local find = string.find

k2 = {}
k2staff = {}
secs = array(32,0)

color = {
	"\169255255255", -- 1 chat (white)
	"\169255000000", -- 2 ADM/GM (red)
	"\169255255102", -- 3 Headmod (yellow)
	"\169000220000", -- 4 Moderation Team (green)
	"\169000128255", -- 5 Trainee (blue)
	"\169255153255", -- 6 Vip
	"\169121247003", -- 7 Member
	"\169255220000", -- 8 CS2D (yellow)
	"\169255255255", -- 9 white
	"\169255000000", -- 10 red
	"\169000255000", -- 11 green
	"\169000000255", -- 12 blue
	"\169220220220", -- 13 light grey
	"\169163229222", -- 14 PM - light blue
	"\169255025000", -- 15 T
	"\169050150255"  -- 16 CT
}

levelData = {
	[1] = {tag = "MVP", color = "\169255153255", icon = ""},
	[2] = {tag = "Trainee", color = "\169000128255", icon = ""},
	[3] = {tag = "M", color = "\169000220000", icon = ""},
	[4] = {tag = "HMOD", color = "\169255255102", icon = ""},
	[5] = {tag = "ADM", color = "\169255000000", icon = ""},
	[6] = {tag = "GM", color = "\169255000000", icon = ""}
}

addhook("join","join2",2) --3.
addhook("say","_say2")
addhook("sayteam","sayteam2")

function join2(id)
	k2[id] = {}

	if playerdata[id].Player.Level > 0 then
		playerLevel = playerdata[id].Player.Level
		k2staff[id] = levelData[playerLevel]
	end

	data = {name = "name", usgn = "usgn", steamid = "steamid", ip = "ip"}
	for key, value in pairs(data) do
		k2[id][key] = player(id, value)
	end

	msj2(id,color[9].."Welcome to "..color[4]..""..game("sv_name").."@C")
	
		local pd = playerdata[id].Player.Level
		local name = player(id,"name")

		if (pd < 2) and (find(name, "Kgb2d") or find(name, "kgb2d")) then
		timer(4000,"checkname",id)
		end
end
		
function checkname(id)
id=tonumber(id)
   msj(color[10]..""..k2[id].name.." "..color[9].."got auto-kicked.")
   parse('kick '..id..' "'..color[10]..''..k2[id].name..', Please remove the tag from your nickname, only Kgb2d staff members can use the tags."')
end

local errors = {
    "Insufficient privilege",
    "No player found with that ID",
    "You cannot ban bots",
    "You are muted and cannot talk",
    "Value is too high. 1-10 allowed",
    "Your score is already nullified",
    "Value is too high. 1-60 allowed",
    "You cannot send PM to yourself",
    "You can't use this command when you're a spectator",
    "You did not type the destination ID",
    "You did not enter the message",
    "You did not enter a reason",
    "You did not type the target ID",
    "You did not type a map name",
    "You did not enter a weapon ID",
    "You did not enter a mask to unban",
    "Target ID is not connected to USGN",
    "You cannot mute yourself",
    "Something that is not alive cannot be killed",
    "Target player is already in spectators",
    "This command can't be used when you're dead",
    "You did not type a value", --22
    "You do not have enough ammo packs",
    "The command cannot be used on this server",
	"The player doesn't accept private messages" --25
}

function error(id, txt, error)
    if errors[error] then
        msj2(id, color[10] .. "Command: " .. txt)
        msj2(id, color[10] .. "Error: " .. errors[error])
    end
end

--[[function banz(id,txt,error)
	if error==1 then
			msj2(id,color[10].."Error: No ban type selected!@C")
			msj2(id,color[11].."Example Usage: !ban bantype id reason@C")
			msj2(id,color[11].."Ban Types: 1:Ban IP, 2:Ban USGN, 3:Ban Steam@C")
	elseif error==2 then
			msj2(id,color[10].."Error: The target id is not defined!@C")
	elseif error==3 then
			msj2(id,color[10].."Error: There is no ban reason defined@C")
	elseif error==4 then
			msj2(id,color[10].."Error: The target player doesn't have USGN ID.@C")
	elseif error==5 then
			msj2(id,color[10].."Error: The target player doesnt't have Steam account.@C")
	elseif error==6 then
			msj2(id,color[10].."Command: "..txt)
			msj2(id,color[10].."Error: You can't use this command on Staff Members!@C")
	end
end]]--

function banz(id,txt,error)
    local messages = {
        {"No ban type selected!", "Example Usage: !ban bantype id reason", "Ban Types: 1:Ban IP, 2:Ban USGN, 3:Ban Steam"},
        {"The target id is not defined!"},
        {"There is no ban reason defined"},
        {"The target player doesn't have USGN ID."},
        {"The target player doesn't have Steam account."},
        {"You can't use this command on Staff Members!"}
    }

    local msg = messages[error]
    if msg then
        for i = 1, #msg do
            msj2(id, color[10] .. (i == 1 and "Error: " or "") .. msg[i] .. "@C")
        end
    end
end

function _say2(id,txt)
if (playerdata[id].Player.Mute == true) then
	return 1
end
if txt:sub(1,5)=="!kick" then
	if playerdata[id].Player.Level >= 2 then
		local t, r = tonumber(txt:sub(7,8)), txt:sub(9)
		if tonumber(t) == nil then error(id,txt,13) return 1 end
		if tonumber(t) == id then return 1 end
		if r == "" then error(id,txt,12) return 1 end
		if not player(t,"exists") then error(id,txt,2) return 1 end
		parse('kick '..t..' "'..r)
		msj(k2staff[id].color..k2[id].name..""..color[8].." kicked "..color[10]..""..k2[t].name.." (Reason: "..color[9]..""..r..""..color[10]..")")
		--return 1
	--else
		--return 1
	end 
	return 1
end

if txt:sub(1,4)=="!ban" then
	if playerdata[id].Player.Level >= 3 then
		local t, s, r = tonumber(txt:sub(6,7)), tonumber(txt:sub(8,9)), txt:sub(10)
		if tonumber(t) == nil then banz(id,txt,1) return 1 end
		if tonumber(s) == nil then banz(id,txt,2) return 1 end
		if playerdata[s].Player.Level >= 3 then banz(id,txt,6) return 1 end
		if r == "" then banz(id,txt,3) return 1 end
		if not player(s,"exists") then error(id,txt,2) return 1 end
		if player(s,"bot")==true then error(id,txt,3) return 1 end
		if tonumber(t) == 1 then --banip
		--parse('banip '..player(s,"ip")..' 0 "'..r)
		--os.execute("iptables -A INPUT -s "..ip.." -j ACCEPT")
		os.execute("iptables -A INPUT -s "..player(s,"ip").." -j DROP")
		msj(color[9]..k2[id].name..color[8].." banned(IP) "..color[10]..k2[s].name.." (Reason: "..color[9]..r..color[10]..")")
		return 1 
		end
		if tonumber(t) == 2 then --banusgn
			if player(s,"usgn") == 0 then banz(id,txt,4) return 1 end
		parse('banusgn '..player(s,"usgn")..' 0 "'..r)
		msj(color[9]..k2[id].name..color[8].." banned (USGN) "..color[10]..k2[s].name.." (Reason: "..color[9]..r..color[10]..")")
		return 1 
		end
		if tonumber(t) == 3 then --bansteam
			if player(s,"steamname") == "" then banz(id,txt,5) return 1 end
		parse('bansteam '..player(s,"steamid")..' 0 "'..r)
		msj(color[9]..k2[id].name..color[8].." banned (Steam) "..color[10]..k2[s].name.." (Reason: "..color[9]..r..color[10]..")")
		return 1 
		end
	--else
		--return 1
	end
	return 1
end

if txt:sub(1,5)=="!mute" then --done
	if playerdata[id].Player.Level >= 4 then
		local t, reason = tonumber(txt:sub(7,8)), txt:sub(9)
		if tonumber(t) == nil then error(id,txt,13) return 1 end
		if reason == "" then error(id,txt,12) return 1 end
		if not player(t,"exists") then error(id,txt,2) return 1 end
		if player(id,"name") == player(t,"name") then error(id,txt,18) return 1 end
		if playerdata[t].Player.Level >= 3 then banz(id,txt,6) return 1 end
		if (playerdata[t].Player.Mute == false) then
			playerdata[t].Player.Mute = true
			playerdata[t].Player.MuteReason = reason
			msj(k2staff[id].color..""..k2[id].name..""..color[8].." muted "..color[10]..k2[t].name.." (Reason: "..color[9]..reason..color[10]..")")
			msj2(t,color[10].."You have been muted by "..color[9]..""..k2[id].name.."@C")
			msj2(t,color[10].."Reason: "..color[9]..""..reason.."@C")
			--return 1
		else
			playerdata[t].Player.Mute = false
			playerdata[t].Player.MuteReason = reason
			msj(color[9]..""..k2[id].name..color[8].." unmuted "..color[10]..k2[t].name.." (Quote: "..color[9]..reason..color[10]..")")
			msj2(t,color[9]..""..k2[id].name.." "..color[11].."unmuted you.@C")
			msj2(t,color[10].."Quote: "..color[9]..reason.."@C")
			--return 1
		end
	--else
		--return 1
	end
	return 1
end

if txt:sub(1, 5) == "!role" then
	if playerdata[id].Player.Level == 6 then
	local pid, role = tonumber(txt:sub(7,8)), tonumber(txt:sub(9))
	if tonumber(pid) == nil or tonumber(role) == nil then return 1 end
	if playerdata[pid].Player.Level == 6 then return 1 end
		k2staff[pid] = levelData[role]
		playerdata[pid].Player.Level = role
		msj2(id,"You gave "..k2[pid].name.." role level = "..k2staff[pid].tag.."@C")
		msj2(pid,k2[id].name.." gave you role level = "..k2staff[pid].tag.."@C")
	end
	return 1
end

if txt:sub(1, 8) == "!restart" then
	if playerdata[id].Player.Level >= 4 then
		local t = tonumber(txt:sub(10, 11))
		if not t then t = 1 end
		parse("sv_restart " .. t)
		msj(k2staff[id].color .. k2[id].name .. color[8] .. ' used ' .. color[9] .. 'sv_restart ' .. color[8] .. 'command.')
		--return 1
	end
	return 1
end

if txt:sub(1,5)=="!kill" then --done
	if playerdata[id].Player.Level >= 4 then
		local t = tonumber(txt:sub(7,8))
		if tonumber(t) == nil then error(id,txt,13) return 1 end
		if not player(t,"exists") then error(id,txt,2) return 1 end
		if playerdata[t].Player.Level >= 3 then banz(id,txt,6) return 1 end
		if player(t,"health") == 0 then error(id,txt,19) return 1 end
		parse("killplayer "..t)
		msj(k2staff[id].color..k2[id].name..color[8].." command-killed "..color[10]..k2[t].name)
		--return 1
	--else
		--return 1
	end 
	return 1
end

if txt:sub(1,5)=="!spec" then --done
	if playerdata[id].Player.Level >= 3 then
		local t = tonumber(txt:sub(7,8))
		if tonumber(t) == nil then error(id,txt,13) return 1 end
		if not player(t,"exists") then error(id,txt,2) return 1 end
		if player(t,"team") == 0 then error(id,txt,20) return 1 end
		local roleColor = isCT(t) and color[16] or isT(t) and color[15] or ""
		local name1 = player(id,"name")
		local name2 = player(t,"name")
		parse("makespec "..t)
		msj(k2staff[id].color..name1..color[8].." sent "..roleColor..name2.." "..color[8].."to spectators.")
		--return 1
	--else
		--return 1
	end
	return 1
end

if txt:sub(1,5)=="!slap" then --done
	if playerdata[id].Player.Level >= 3 then
		local t = tonumber(txt:sub(7,8))
		if not tonumber(t) then error(id,txt,13) return 1 end
		if not player(t,"exists") then error(id,txt,2) return 1 end
		local name1 = player(id,"name")
		local name2 = player(t,"name")
		print(name1.." slapped "..name2)
		--msj(k2staff[id].color..k2[id].name..color[8].." slapped "..roleColor..name)
		parse("slap "..t)
		--return 1
	--else
		--return 1
	end 
	return 1
end

if txt:sub(1,6)=="!unban" then --done
	if playerdata[id].Player.Level >= 4 then
		local mask = txt:sub(8)
		if tonumber(mask) == nil then error(id,txt,16) return 1 end
		parse("unban "..mask)
		msj2(id,color[1].."Info:"..color[2].." Successfully unbanned "..color[4]..""..mask)
		--return 1
	--else
		--return 1
	end 
	return 1
end

--[[if txt:sub(1,6)=="!strip" then --done
	if playerdata[id].Player.Level >= 4 then
		local t = tonumber(txt:sub(8,9))
		item = tonumber(txt:sub(10,12))
		if tonumber(t) == nil then error(id,txt,13) return 1 end
		if tonumber(item) == nil then error(id,txt,15) return 1 end
		if not player(t,"exists") then error(id,txt,2) return 1 end
		msj(color[9]..""..k2[id].name..""..color[8].." stripped "..color[9]..""..k2[t].name)
		parse("strip "..t.." "..item)
		return 1
	else
		return 1 
	end
end]]--
if txt:sub(1,5) == "!time" then
	if playerdata[id].Player.Level >= 5 then
		local time = tonumber(txt:sub(7))
		parse("sv_daylighttime " .. (time == 1 and 1 or time == 2 and 173 or time == 3 and 180 or -1))
		return 1
	end
	return 1
end

if txt:sub(1,6) == "!equip" then
	if playerdata[id].Player.Level >= 5 then
	local t, item = tonumber(txt:sub(8,9)), tonumber(txt:sub(10,12))
	if not t or not item or (t ~= 0 and not player(t, "exists")) then error(id, txt, (not t and 13) or (not item and 15) or 2) return 1 end

	local function equipItem(target)
		parse("equip " .. target .. " " .. item)
		parse("setweapon " .. target .. " " .. item)
		msj2(target, k2staff[id].color .. k2[id].name .. color[1] .. " gave you item " .. color[11] .. "#" .. item)
	end

	if t == 0 then
		for _, id2 in pairs(player(0, "tableliving")) do
			equipItem(id2)
		end
	else
		equipItem(t)
	end

	return 1
	end
end	

if txt:sub(1,6)=="!check" then --done
	if playerdata[id].Player.Level >= 3 then
		local t = tonumber(txt:sub(8,9))
		if not tonumber(t) then error(id,txt,13) return 1 end
		if not player(t,"exists") then error(id,txt,2) return 1 end
		if playerdata[id].Player.Level < playerdata[t].Player.Level then banz(id,txt,6) return 1 end
		msj2(id,color[9].."Name: "..k2[t].name)
		msj2(id,color[9].."USGN: "..k2[t].usgn)
		msj2(id,color[9].."Steam: "..k2[t].steamid)
		msj2(id,color[9].."IP: "..k2[t].ip)
		return 1
	end
	return 1 
end		

if txt == "!color" then
	if playerdata[id].Player.Level >= 1 then
		playerdata[id].Player.Tag = not playerdata[id].Player.Tag
		local status = playerdata[id].Player.Tag and (color[11].."ON") or (color[10].."OFF")
		msj2(id, color[1].."Chat Color: "..status.."@C")
		return 1
	end
	return 1
end

if txt:sub(1,7)=="!freeze" then
	if playerdata[id].Player.Level >= 4 then
		local opt = tonumber(txt:sub(9))
		local freezeTime = opt and (opt >= 1 and opt <= 3 and opt or 0) or 0

		parse("mp_freezetime " .. freezeTime)
		serveroptions.Freeze = freezeTime
		salt.save(serveroptions, "sys/lua/autorun/config.cfg")
		--return 1
	end
	return 1
end

if txt=="!fow" then
	if playerdata[id].Player.Level >= 4 then
		serveroptions.Fow = not serveroptions.Fow
		local option = serveroptions.Fow and 3 or 0
		parse("sv_fow "..option)
		salt.save(serveroptions, "sys/lua/autorun/config.cfg")
		return 1
	end
	return 1
end

if txt:sub(1,5)=="!rcon" then
	if playerdata[id].Player.Level >= 6 then 
		local cmd = txt:sub(7)
		if cmd == "" then return 1 end
		parse(cmd)
		msj2(id,color[11].."Successfully parsed "..color[8]..""..cmd)
		return 1
	end
	return 1
end

if txt:sub(1,4)=="!map" then
	if playerdata[id].Player.Level >= 5 then
		local nmap = txt:sub(6)
		if nmap == "" then error(id,txt,14) return 1 end
		msj(k2staff[id].color..""..k2staff[id].tag.." "..color[1]..""..k2[id].name.." changed "..color[10]..""..tostring(map("name")).." "..color[1].."to "..color[11]..""..nmap)
		timer(5000,"parse","map "..nmap)
		return 1
	end
return 1
end

if txt=="!reload" then
	if playerdata[id].Player.Level >= 4 then
		local map = map("name")
		msj(k2staff[id].color..k2staff[id].tag.." "..color[1]..k2[id].name.." "..color[8].."reloaded the map.")
		timer(5000,"parse","map "..map)
		return 1
	end
	return 1
end

if txt:sub(1, 1) == "@" then
    local t, message = tonumber(txt:sub(2, 3)), txt:sub(4)
	if not t or message == "" or not player(t, "exists") or player(id, "name") == player(t, "name") then
        error(id, txt, not t and 10 or message == "" and 11 or not player(t, "exists") and 2 or 8)
        return 1
    end
	local receiverOpt = playerdata[t].Options.Pm 
	if receiverOpt == "Disabled" then error(id, txt, 25) return 1 end
    local senderName, receiverName = player(id,"name"), player(t,"name")
	local receiverColor, senderColor = isCT(t) and color[16] or isT(t) and color[15] or "", isCT(id) and color[16] or isT(id) and color[15] or ""
    local sender = color[9].."[PM] Sent "..receiverColor..receiverName..color[9].." [ID:"..color[11]..t..color[9].."]: "..color[14]..message
	local receiver = color[9].."[PM] "..senderColor..senderName..color[9].." [ID:"..color[11]..id..color[9].."] sent: "..color[14]..message
    msj2(id, sender)
    msj2(t, receiver)
	if playerdata[t].Options.Announcer == "Enabled" then
		local sound = "kgb2d/announce.ogg"
		parse("sv_sound2 " .. t .." " .. sound)
	end
    return 1
end
	
if txt=="!resetscore" or txt=="!rs" or txt=="!RS" or txt=="!reset" then
	local deaths, score = player(id, "deaths"), player(id, "score")
    if deaths > 0 or score > 0 then
		parse("setscore "..id.." 0")
		parse("setassists "..id.." 0")
		parse("setdeaths "..id.." 0")
		msj2(id,color[11].."Info: "..color[9].."You have nullified your score.@C")
	end
	return 1
end

if txt=="!help" then
	local white, green, red = "\169255255255", "\169000255000", "\169255000000"
	local message = "Check your console!@C"
	local b = "________"
	msg2(id,green..message)
	local msg = {
		green..b,
		green.."INFORMATIONS ABOUT THE SERVER OVERALL",
		white.."By pressing "..green.."F2 "..white.."you can access to your customizable options menu. You can deactive the features that you don't want to use.",
		white.."If you are in "..green.."TOP50 "..white.."in rank list you will become a "..green.."VIP Player "..white.."on server join. You can access "..green.."VIP Options menu "..white.."via "..green.."F3 menu.",
		white.."By pressing "..green.."F4 "..white.."you can access your rank informations.",
		white.."You can send private messages by typing "..green.."@id message "..white..",for example "..green.."@1 hi dude "..white.."sends 'hi dude' to player id 1",
		white.."You can reset your score by typing "..green.."!rs "..white.."or "..green.."!RS "..white.."in chat.",
		white.."Your data will be "..green.."loaded on server join "..white.."and will be "..green.."saved at the end of rounds and when leaving and disconnecting the server.",
		green..b,
		green.."INFORMATIONS ABOUT THE RANKED SYSTEM:",
		white.."You can check what your current rank offers as "..green.."Elo Points "..white.."per "..green.."Kill and Elo Points Loss on Death "..white.."via "..green.."F4 menu.",
		white.."Killing a player with a "..green.."knife "..white.."will "..green.."gain you 20 elo points "..white.."only if there are at least 4 or more players in game.",
		white.."Getting killed with a "..red.."knife "..white.."will cause you to "..red.."lose 10 elo points "..white.."only if there are at least 4 or more players in game.",
		white.."If you can get to explode the bomb, you will gain 10 Elo Points and if you can manage to defuse the bomb you will gain 20 Elo Points.",
		green..b,
		white.."Extra emoticons:",
		"cool, bcy, bob, cavebob, coolstory, cringe, doge, dolan, ez, feelsgood, huh, illuminati, kappa, kekw, tom",
		green..b,
		white.."If you need to contact the staff about anything you need, consider joining our official Discord server:",
		green.."DSC.GG/KGB2D",
		green..b
	}
	if secs[id] == 0 then
		secs[id] = 3
		for i=1,#msg do parse('cmsg '..msg[i]..' "'..id..'"') end
	else
		return 1
	end
	return 1
end

if txt=="!rknife" then
	if player(id,"health") == 0 then error(id,txt,21) return 1 end
	parse("strip "..id.." 50")
	local msg = color[11].."Info: "..color[9].."Your knife has been removed!@C"
	msj2(id,msg)
	return 1
end

	local value = cchat(id,txt)
	if value == 1 then
		return 1
	else 
		return 0
	end
end

function cchat(id, txt)
    id = tonumber(id)
    local pd, rankData = playerdata[id].Player, ranks[playerdata[id].Stat.RankLvl]
	local name = player(id,"name")

	if string.lower(txt) == "rank" then return 0 end
    if pd.Level ~= 0 and pd.Tag then
        msj(k2staff[id].color.."["..k2staff[id].tag.."] "..rankData.color.."["..rankData.tag.."] "..color[1]..name..":"..color[1]..cs2d_emojis_check(id, txt))
        return 1
	else
		if secs[id] == 0 and isPlayerLoggedIn(id) then
			local roleColor = isCT(id) and color[16] or isT(id) and color[15] or ""
			local tagPrefix = isSpec(id) and "" or rankData.color.."["..rankData.tag.."] "
			local status = player(id,"health") ~= 0 and "" or " *DEAD*"
			local teamIcons = {"\174gfx/kgb2d/skins/gem1.png ", "\174gfx/kgb2d/skins/gem2.png ", ""}
			local icon = isEligible(id) and teamIcons[player(id, "team")] or ""

			secs[id] = 2
			msj(icon..tagPrefix..roleColor..name..""..color[1]..status..":"..cs2d_emojis_check(id, txt).." ")
			return 1
		else
			return 1
		end
	end
end

function sayteam2(id,message)
	if not isPlayerLoggedIn(id) then
		return 1
	else
		return 0
	end
end

addhook("second","second_hook")
function second_hook()
	local playerlist = player(0,"table")
	for _,id in pairs(playerlist) do
		if secs[id] ~= 0 then
			secs[id] = secs[id] - 1
		end
	end
end