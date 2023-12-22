--[[parse("mp_buymenu '0,1,2,3,4,5,6|10,11|20,21,22,23,24|30,32,31,33,34,35,36,37,38|40,90|51,52,53,72,73,56,58,60")

local items = {
	{ name = "MP5", damage = 19 },
	{ name = "TMP", damage = 17 },
	{ name = "P90", damage = 18 }
}

function damages()
    for i=1,#items do
        parse("mp_wpndmg "..items[i].name.." "..items[i].damage)
    end
end
damages()]]--