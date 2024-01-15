local p = pairs
local sg = string.gmatch

local EMOJIS = {
    ["^Cool$"]                		    = "cool",
    ["^[:=8xX]['][-^o]?%($"]            = "crying", -- :'(
    ["^<3$"]                            = "heart", -- <3
    ["^[:=8][-^o]?[D]$"]                = "laughing", -- :D
    ["^[lL][oOe][lL]$"] 			    = "lol", -- omg
    ["^:|$"]                			= "neutral", -- :|
    ["^[:=8][-^o]?[)%]3>]$"]            = "smile", -- :)
    ["^[(%[<][-^o]?[(:=8]$"]            = "rsmile", -- (:
    ["^[:=8][-^o]?[(%[]$"]              = "sad", -- :(
    ["^sch$"]                		    = "sch",
    ["^strong$"]                        = "strong", 
    ["^[;:=8][-^o]?[oO0]$"]             = "surprised", -- :O
    ["^YES$"]                		    = "tup",
    ["^NO$"]                		    = "tdown",
    ["^hmm$"]                		    = "thinking",
    ["^[:=8xX][-^o]?[pPbq]$"]           = "tongueout", -- :P
    ["^[;][-^o]?[)%]D]$"]               = "winking", -- ;)
    ["^bcy$"]                			= "bcy",
    ["^bob$"]                			= "bob",
    ["^cavebob$"]                		= "cavebob",
    ["^coolstory$"]                		= "coolstory",
    ["^cringe$"]                		= "cringe",
    ["^doge$"]                		    = "doge",
    ["^dolan$"]                		    = "dolan",
    ["^[eE][zZ]$"] 			            = "ez",
    ["^feelsgood$"]                		= "feelsgoodman",
    ["^[hH][uU][hH]$"] 			        = "huh",
    ["^illuminati$"] 			        = "illuminati",
    ["^kappa$"]                			= "kappa",
    ["^[kK][eE][kK][wW]$"] 			    = "kekw", -- omg
    ["^tom$"]                			= "tom"
}

function cs2d_emojis_check(id, txt)
	txt_return = ""
	flag = false
    for word in sg(txt, "[^%s]+") do
        for smiley, emoticon in p(EMOJIS) do
			if word:match(smiley) then
				txt_return = txt_return .." \174gfx/kgb2d/emojis/" .. emoticon .. ".png"
				flag = true
            end
		end
		if flag == false then
			txt_return = txt_return.." "..word
		else
			flag = false
		end
	end
	return txt_return
end