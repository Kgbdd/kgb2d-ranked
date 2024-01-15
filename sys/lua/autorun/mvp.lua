local parse = parse
parse("mp_hudscale 1")
local msg, msg2 = msg, msg2
local max = math.max
local image, image2 = "\174gfx/kgb2d/minute/announce.png", "\174gfx/kgb2d/serverinfo/kgb2d2.png"
local ttColor, ctColor, white = color.t, color.ct, color.white

sd={
	damage = array(32),
	damage2 = array(32),
	damage3 = array(32)
} 

addhook('hit','sd.hit')
function sd.hit(id,src,wpn,hp)
	local source, victim = player(src,"team"), player(id,"team")
	local pd = playerdata[src].Vip
	if source ~= victim and src ~= 0 and hp ~= 0 then
		sd.damage[src], sd.damage2[src], sd.damage3[src] = sd.damage[src] + hp, sd.damage2[src] + hp, sd.damage3[src] + hp
		if pd.Status and pd.SDamage == "On" then
			sd.show(src)
		end
	end
end

function sd.show(id)
	parse('hudtxt2 '..id..' 0 "©255255255-'..sd.damage3[id]..' HP" 400 200 0 0 10')
	parse('hudtxtalphafade '..id..' 0 500 0.0')
	parse('hudtxtmove '..id..' 0 500 400 195')

	timer(550,"clearHud",id)
end

function clearHud(id)
	local id = tonumber(id)
	sd.damage3[id] = 0
	parse('hudtxtclear '..id)
end

addhook('endround', 'sd.endround')
function sd.endround()
	local mvp = max(unpack(sd.damage))

	if mvp == 0 then 
		return 
	end
	
	local playerlist = player(0,"table")
	for _,id in pairs(playerlist) do
		if mvp == sd.damage[id] then
			if playerdata[id].Options.Announcer == "Enabled" then
				local lastround, total = sd.damage[id], sd.damage2[id]
				local color = player(id,"team") == 1 and ttColor or ctColor
				local player = player(id, "name")
				local m = white.."___________________"
				local m2 = image..white.." Highest Damage by" .. image2 .. color .. player .. white .. " - DMG: " .. color .. mvp .. white.. " HP"
				msg(m)
				msg(m2)

				if total ~= 0 then
					local m2 = image..white.." Your DMG Last Round: ".. color .. lastround .. white .." HP, In Total: ".. color .. total .. white .." HP"
					msg2(id, m2)
				end
			end
		end
	end
	sd.setNull()
end

function sd.setNull()
	local playerlist=player(0,"table")
	for _,i in pairs(playerlist) do
		sd.damage[i] = 0 
	end
end

addhook('leave','sd.leave')
function sd.leave(id)
sd.damage[id], sd.damage2[id], sd.damage3[id] = 0, 0, 0
end