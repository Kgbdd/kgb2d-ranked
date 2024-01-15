local parse = parse
local max = math.max
local ipairs = ipairs
local insert = table.insert
local sort = table.sort
local winRoundCount = 4

local image = "\174gfx/kgb2d/minute/announce.png"
local white, green = color.white, color.green
local ctColor, ttColor = color.ct, color.t

function sortAndAssign()
    local ctPlayers = player(0, "team1")
    local ttPlayers = player(0, "team2")
    local kdaTable = {}
	--local players = player(0, "team1")
	
	for _, id in ipairs(ttPlayers) do
		insert(ctPlayers, id)
	end

    for _, id in ipairs(ctPlayers) do
        local kills = player(id, "score")
        local deaths = player(id, "deaths")
        local assists = player(id, "assists")

        local kdaRatio = (kills + assists) / max(1, deaths)
        insert(kdaTable, { playerID = id, kdaRatio = kdaRatio })
    end

    sort(kdaTable, function(p1, p2) return p1.kdaRatio > p2.kdaRatio end)

    parse("restart")

    for i, data in ipairs(kdaTable) do
        local playerId = data.playerID
        if i % 2 == 1 then
            parse("makect " .. playerId)
        else
            parse("maket " .. playerId)
        end
    end
end

addhook("startround_prespawn", "prespawn")
function prespawn()
    local winrow_ct, winrow_t = game("winrow_ct"), game("winrow_t")
    local stronger = winrow_ct > winrow_t and color.ct.."Counter-Terrorist" or color.t.."Terrorist"
    local rearrangeMsg = white.."The "..stronger..white.." Team is too stronger. Teams will be rearranged.@C"
    if winrow_ct == winRoundCount or winrow_t == winRoundCount then
        msg(rearrangeMsg)
		timer(3000, "sortAndAssign")
	else
		local ctMessage = image..color.ct.." Counter-Terrorist "..white.."Team Win Row: "..winrow_ct.."/"..winRoundCount
		local ttMessage = image..color.t.." Terrorist "..white.."Team Win Row: "..winrow_t.."/"..winRoundCount
		local m = (winrow_ct > winrow_t and ctMessage or (winrow_t > winrow_ct and ttMessage or nil))
        if m then msg(m) end
    end
end