local parse, timer = parse, timer
local lastwpn = {}

local wpntable = {
	[1] = "pikachu/wpn_deploy/usp_deploy.ogg",
	[2] = "pikachu/wpn_deploy/glock_deploy.ogg",
	[20] = "pikachu/wpn_deploy/mp5_deploy.ogg",
	[22] = "pikachu/wpn_deploy/p90_deploy.ogg",
	[30] = "pikachu/wpn_deploy/ak47_deploy.ogg",
	[32] = "pikachu/wpn_deploy/m4a1_deploy.ogg",
	[35] = "pikachu/wpn_deploy/awp_deploy.ogg",
	[40] = "pikachu/wpn_deploy/m249_deploy.ogg",
	[50] = "pikachu/wpn_deploy/knife_deploy.ogg",
	[90] = "pikachu/wpn_deploy/m249_deploy.ogg",
	[91] = "pikachu/wpn_deploy/ak47_deploy.ogg",
}

addhook("select", "wpnsndscall")
function wpnsndscall(id,weapon)
    local pd = playerdata[id].Options

    if pd.Deploy == "Enabled" and lastwpn[id] ~= weapon and wpntable[weapon] then
        parse("sv_sound2 " .. id .. " \"" .. wpntable[weapon] .. "\"")
    end

    lastwpn[id] = weapon
end

addhook("drop","call2p1")
function call2p1(id)
	timer(10,"call2p2",id)
end

function call2p2(id)
	id = tonumber(id)
	wpnsndscall(id,player(id,"weapontype"))
end

addhook("spawn","wpnsndsspawn")
function wpnsndsspawn(id)
	call2p1(id)
end

addhook("die","wpnsndsreset")
function wpnsndsreset(id,k,wpn,x,y)
	lastwpn[id] = 0
end

addhook("join","wpnsndsconnect")
function wpnsndsconnect(id)
	lastwpn[id] = 0
end

addhook("leave","wpnsndsdisconnect")
function wpnsndsdisconnect(id)
	lastwpn[id] = nil
end

addhook("bombplant","wpnsndsbombplant")
function wpnsndsbombplant(id,x,y)
	parse("sv_soundpos \"pikachu/wpn_deploy/c4_plant.ogg\" "..(x*32+16).." "..(y*32+16))
end