local debug = false
local parse = parse
local image, imagescale = image, imagescale
local pairs = pairs
local HUDImage = {}
local img = "gfx/backgrounds/1.png"

addhook("join","onlyloggedJoin",3)
function onlyloggedJoin(id)
	id = tonumber(id)
	if not isPlayerLoggedIn(id) then
		HUDImage[id] = image(img, 960, 500, 2, id)
		imagescale(HUDImage[id], 1920, 1200)
		local message = "©255255255You need to be logged into a USGN or Steam Account!"
        parse('hudtxt2 ' .. id .. ' 1 "' .. message .. '" 200 100 0 0 20')
	end
end

addhook("startround","engel")
function engel()
	local playerlist = player(0,"table")
	for _,id in pairs(playerlist) do
	onlyloggedJoin(id)
	end
end

addhook("leave","lengel")
function lengel(id)
	if HUDImage[id] then
		freeimage(HUDImage[id])
		HUDImage[id] = nil
		parse('hudtxtclear '..id)
	end
end		

addhook("team","team2")
function team2(id, team)
	if not debug then
		if team == 1 or team == 2 then
			return not isPlayerLoggedIn(id) and 1 or 0
		end
	end
end