salt = {}
playerdata = {}

-- compressed is optional, if true it will not include unneccesary spaces, indentation, or line endings
function salt.save(tbl,file,compressed)

    local f,err = io.open(file,"w")
    if err then print(err) return end
    local indent = 1

    -- local functions to make things easier
    local function exportstring(s)
        s=string.format("%q",s)
        s=s:gsub("\\\n","\\n")
        s=s:gsub("\r","")
        s=s:gsub(string.char(26),"\"..string.char(26)..\"")
        return s
    end
    local function serialize(o)
        if type(o) == "number" then
            f:write(o)
        elseif type(o) == "boolean" then
            if o then f:write("true") else f:write("false") end
        elseif type(o) == "string" then
            f:write(exportstring(o))
        elseif type(o) == "table" then
            f:write("{" .. (compressed and "" or "\n"))
            indent = indent + 1
            local tab = ""
            for i=1,indent do tab = tab .. "    " end
            for k,v in pairs(o) do
                f:write((compressed and "" or tab) .. "[")
                serialize(k)
                f:write("]" .. (compressed and "=" or " = "))
                serialize(v)
                f:write("," .. (compressed and "" or "\n"))
            end
            indent = indent - 1
            tab = ""
            for i=1,indent do tab = tab .. "    " end
            f:write((compressed and "" or tab) .. "}")
        else
            print("unable to serialzie data: "..tostring(o))
            f:write("nil," .. (compressed and "" or " -- ***ERROR: unsupported data type: "..type(o).."!***"))
        end
    end

    f:write("return {" .. (compressed and "" or "\n"))
    local tab = "    "
    for k,v in pairs(tbl) do
        f:write((compressed and "" or tab) .. "[")
        serialize(k)
        f:write("]" .. (compressed and "=" or " = "))
        serialize(v)
        f:write("," .. (compressed and "" or "\n"))
    end
    f:write("}")
    f:close()
end

function salt.load(file)
    local data,err = loadfile(file)
    if err then return nil,err else return data() end
end

addhook("join","join3",0) --1.
function join3(id)
    load_player(id)
    checkVip(id)
end

function defaultData(id)
    print("No data found and creating default tables.")
	playerdata[id] = {
		Player = {Level = 0, Tag = false, Mute = false, MuteReason = ""},
		Options = {Utsfx = "Disabled", Deploy = "Disabled", Announcer = "Disabled", Pm = "Enabled"},
		Vip = {Status = false, Hs = "On", Ks = "On", SDamage = "On"},
		Stat = {Points = 0, RankLvl = 0}
	}

    if next(playerdata[id]) then
        print("[SUCCESS] table is written")
    else 
        print("[FAILURE] table is empty")
    end
end

addhook("leave","disconnect_server")
function disconnect_server(id)
	save_player(id)
    playerdata[id] = nil
end

addhook("endround","endSave")
function endSave()
    local playerlist = player(0,"table")
    for _,id in pairs(playerlist) do
        save_player(id)
    end
end

function load_player(id)
    local loggedInUSGN, loggedInSteam = isPlayerLoggedInUSGN(id), isPlayerLoggedInSteam(id)
    
	if loggedInSteam and loggedInUSGN then --steami ve usgnsi varsa = USGN
        print(color.cs2dyellow.."[LOAD TRY1] via usgn")
		load_pre(id,"usgn")
	elseif loggedInSteam and not loggedInUSGN then -- steam var ama usgn yok = STEAM
        print(color.cs2dyellow.."[LOAD TRY2] via steam")
		load_pre(id,"steamid")
	elseif not loggedInSteam and loggedInUSGN then --steami yok ama usgnsi varsa = USGN
        print(color.cs2dyellow.."[LOAD TRY3] via usgn")
		load_pre(id,"usgn")
	else 
        defaultData(id)
	end
end
    
function load_pre(id,opt)
    local name = player(id,"name")
    local data = salt.load("sys/lua/database/"..opt.."/"..player(id,""..opt.."")..".lua")
    if data then
        playerdata[id] = data
        msg2(id,color.white.."Your save has been loaded "..color.success.."successfully!@C")
        msg2(id,color.white.."Your data save will be based on your "..color.success..""..string.upper(opt).."@C")

        print(color.cgreen.."[LOAD SUCCESS] "..name.." Data found and loaded via "..string.upper(opt))
        print("[LOAD] "..name.." ranklvl:"..playerdata[id].Player.Level.." point:"..playerdata[id].Stat.Points)
    else 
        msg2(id,color.red.."No data found. "..color.white.."Your data save will be based on your "..color.success..""..string.upper(opt).."@C")
        defaultData(id)
    end
end

function save_player(id)
    if not isPlayerLoggedInSteam(id) and not isPlayerLoggedInUSGN(id) then
        return
    else
        local usgn, steam, name = player(id, "usgn"), player(id, "steamid"), player(id,"name")
        local path = isPlayerLoggedInUSGN(id) and "usgn" or "steamid"

        if playerdata[id] then
            salt.save(playerdata[id], "sys/lua/database/" .. path .. "/" .. (path == "usgn" and usgn or steam) .. ".lua")
            print(color.cgreen.."[SAVE SUCCESS] saved "..name.." via ".. (path == "usgn" and usgn or steam))
            print("[SAVE] "..name.." ranklvl:"..playerdata[id].Player.Level.." point:"..playerdata[id].Stat.Points)
        else
            print(color.red.."[SAVE FAILURE] no table found for "..name)
        end
    end
end

function load_options()
    local data = salt.load("sys/lua/autorun/config.cfg")
    if data then
        serveroptions = data
        local option = serveroptions.Fow and 3 or 0
        parse("sv_fow "..option)
        parse("mp_freezetime "..serveroptions.Freeze)

        print(color.green.."Server Options Loaded Successfully!")
    else
        print(color.red.."Error: Server Options couldn't loaded!")
    end
end
load_options()