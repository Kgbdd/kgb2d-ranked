local parse = parse
local max = math.max
local ipairs = ipairs
local insert = table.insert
local sort = table.sort
local winRoundCount = 4

local image = "\174gfx/kgb2d/minute/announce.png"
local white, green = "\169255255255", "\169000255000"

function sortAndAssign()
    local ctPlayers = player(0, "team1")
    local ttPlayers = player(0, "team2")
    local kdaTable = {}
	--local players = player(0, "team1")
	
	for _, id in ipairs(ttPlayers) do
		insert(ctPlayers,id)
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
    local stronger = winrow_ct > winrow_t and "\169050150255Counter-Terrorist" or "\169255025000Terrorist"
    local rearrangeMsg = white.."The "..stronger..white.." Team is too stronger. Teams will be rearranged.@C"
    if winrow_ct == winRoundCount or winrow_t == winRoundCount then
        msg(rearrangeMsg)
		timer(3000, "sortAndAssign")
	else
		local cMessage = image..white.." Win row \169050150255Counter-Terrorists: "..winrow_ct..white.."/"..green..winRoundCount
		local tMessage = image..white.." Win row \169255025000Terrorists: "..winrow_t..white.."/"..green..winRoundCount
		local m = (winrow_ct > winrow_t and cMessage or (winrow_t > winrow_ct and tMessage or ""))
		msg(m)
    end
end