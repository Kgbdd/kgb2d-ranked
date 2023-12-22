local parse, player, msg2 = parse, player, msg2
local sound = "kgb2d/vip/point.ogg"

ranks = {
    [0] = {rank = "Unranked", tag = "Unranked", elostart = 0, elofinish = 50, ppk = 10, pointloss = 5, color = "\169182182182", icon = "gfx/kgb2d/ranks/unranked.png"},
    [1] = {rank = "Silver 1", tag = "S1", elostart = 50, elofinish = 200, ppk = 10, pointloss = 5, color = "\169182182182", icon = "gfx/kgb2d/ranks/s1.png"},
    [2] = {rank = "Silver 2", tag = "S2", elostart = 200, elofinish = 350, ppk = 10, pointloss = 5, color = "\169182182182", icon = "gfx/kgb2d/ranks/s2.png"},
    [3] = {rank = "Silver 3", tag = "S3", elostart = 350, elofinish = 500, ppk = 10, pointloss = 5, color = "\169182182182", icon = "gfx/kgb2d/ranks/s3.png"},
    [4] = {rank = "Silver 4", tag = "S4", elostart = 500, elofinish = 650, ppk = 10, pointloss = 5, color = "\169182182182", icon = "gfx/kgb2d/ranks/s4.png"},
    [5] = {rank = "Silver Elite", tag = "SE", elostart = 650, elofinish = 800, ppk = 10, pointloss = 5, color = "\169182182182", icon = "gfx/kgb2d/ranks/se.png"},
    [6] = {rank = "Silver Elite Master", tag = "SEM", elostart = 800, elofinish = 950, ppk = 10, pointloss = 5, color = "\169182182182", icon = "gfx/kgb2d/ranks/sem.png"},
--300,400,500,600
    [7] = {rank = "Gold Nova 1", tag = "GN1", elostart = 950, elofinish = 1250, ppk = 9, pointloss = 6, color = "\169255222126", icon = "gfx/kgb2d/ranks/gn1.png"},
    [8] = {rank = "Gold Nova 2", tag = "GN2", elostart = 1250, elofinish = 1650, ppk = 9, pointloss = 6, color = "\169255222126", icon = "gfx/kgb2d/ranks/gn2.png"},
    [9] = {rank = "Gold Nova 3", tag = "GN3", elostart = 1650, elofinish = 2150, ppk = 9, pointloss = 6, color = "\169255222126", icon = "gfx/kgb2d/ranks/gn3.png"},
    [10] = {rank = "Gold Nova Master", tag = "GN Master", elostart = 2150, elofinish = 2750, ppk = 9, pointloss = 6, color = "\169255222126", icon = "gfx/kgb2d/ranks/gnmaster.png"},
--700,800,900,1000
    [11] = {rank = "Master Guardian 1", tag = "MG1", elostart = 2750, elofinish = 3450, ppk = 8, pointloss = 7, color = "\169126177255", icon = "gfx/kgb2d/ranks/mg1.png"},
    [12] = {rank = "Master Guardian 2", tag = "MG2", elostart = 3450, elofinish = 4250, ppk = 8, pointloss = 7, color = "\169126177255", icon = "gfx/kgb2d/ranks/mg2.png"},
    [13] = {rank = "Master Guardian Elite", tag = "MGE", elostart = 4250, elofinish = 5150, ppk = 8, pointloss = 7, color = "\169126177255", icon = "gfx/kgb2d/ranks/mge.png"},
    [14] = {rank = "Distinguished Master Guardian", tag = "DMG", elostart = 5150, elofinish = 6150, ppk = 8, pointloss = 7, color = "\169126177255", icon = "gfx/kgb2d/ranks/dmg.png"},
--1000,1000,1000
    [15] = {rank = "Legendary Eagle", tag = "LE", elostart = 6150, elofinish = 7150, ppk = 7, pointloss = 6, color = "\169255086078", icon = "gfx/kgb2d/ranks/le.png"},
    [16] = {rank = "Legendary Eagle Master", tag = "LEM", elostart = 7150, elofinish = 8150, ppk = 7, pointloss = 6, color = "\169255086078", icon = "gfx/kgb2d/ranks/lem.png"},
    [17] = {rank = "Supreme Master First Class", tag = "Supreme", elostart = 8150, elofinish = 10000, ppk = 7, pointloss = 6, color = "\169255086078", icon = "gfx/kgb2d/ranks/supreme.png"},
    [18] = {rank = "Global Elite", tag = "Global", elostart = 10000, elofinish = 10000, ppk = 7, pointloss = 6, color = "\169255086078", icon = "gfx/kgb2d/ranks/globalelite.png"}
}

addhook("join","_rjoin",1) --2.
function _rjoin(id)
    local data = playerdata[id].Stat
    local level = data.RankLvl
    local rankInfo = ranks[level]
    
    if isPlayerLoggedIn(id) then
        msg2(id, "Your rank: " .. rankInfo.color .. rankInfo.rank .. " (" .. rankInfo.tag .. ")")
        msg2(id, "Elo point: " .. data.Points .. ", Elo point per kill: " .. rankInfo.ppk)

        if rankInfo.tag ~= "Global" then
            local nextRank = ranks[level + 1]
            msg2(id, "Next rank at point: " .. nextRank.color .. nextRank.elostart)
            msg2(id, "Next rank: " .. nextRank.color .. nextRank.rank)
        end
    end
end

addhook("kill","_rkill")
function _rkill(killer,victim,weapon)
    local pk, pv = playerdata[killer].Stat, playerdata[victim].Stat
    local rk, rv = ranks[pk.RankLvl], ranks[pv.RankLvl]
    local playerlist=player(0,"table")
    --Oldurene puan artisi
    --pk.Points = pk.Points + (weapon == 50 and 20 or rk.ppk) 
    pk.Points = pk.Points + ((weapon == 50 and #playerlist > 4) and 20 or rk.ppk)
    --Olenden puan dususu
    if pv.Points ~= 0 then
    --pv.Points = pv.Points - (weapon == 50 and 20 or rv.pointloss)
    pv.Points = pv.Points - ((weapon == 50 and #playerlist > 4) and 10 or rv.pointloss)
    end

    if pk.Points % 500 >= 0 and pk.Points % 500 <= 9 then
        for _,id2 in pairs(playerlist) do
            if playerdata[id2].Options.Announcer == "Enabled" then
            local teamColor = player(killer, "team") == 2 and "\169114137218" or "\169255058036"
            local gemIcon = player(killer, "team") == 2 and "\174gfx/kgb2d/skins/gem2.png" or "\174gfx/kgb2d/skins/gem1.png"
            local message = teamColor .. player(killer, "name") .. " \169180180180has just reached: " .. teamColor .. pk.Points .. " \169180180180points."
            msg2(id2,message)
            parse("sv_sound2 "..id2.." "..sound)
            end
        end
    end
    --puanimiz mevcut rankin bitis elo puanindan buyuk veya esitse rank atla
    if pk.Points >= rk.elofinish then
        pk.RankLvl = pk.RankLvl + 1
        updateRankIcon(killer)
        local msg = "You just got promoted to " .. rk.color .. ranks[pk.RankLvl].rank .. " \nPoints: " .. rk.color .. pk.Points .. "@C"
        msg2(killer, msg)
        parse("sv_sound2 "..killer.." "..sound)
    end
    --puanimiz mevcut rankin baslangic elo puanindan kucukse ve puanimiz 0a esit degilse rank dusur
    if pv.Points < rv.elostart and pv.Points ~= 0 then
        pv.RankLvl = pv.RankLvl - 1
        updateRankIcon(victim)
        local msg = "You just got demoted to " .. rv.color .. ranks[pv.RankLvl].rank .. " \nPoints: " .. rv.color .. pv.Points .. "@C"
        msg2(victim, msg)
    end
end

local function updatePoints(id, pointsToAdd)
    local playerCount = #player(0, "table")
    local playerData = playerdata[id].Stat.Points

    if playerCount > 3 then
        playerData = playerData + pointsToAdd
    end
end

addhook("bombexplode","_bombexplode")
function _bombexplode(id)
    updatePoints(id, 10)
end

addhook("bombdefuse","_bombdefuse")
function _bombdefuse(id)
    updatePoints(id, 20)
end