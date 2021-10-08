local _set = function(item,msg,def)
     if _ENV[item] == nil then
          _ENV[item] = def
          KROMER_LOG(msg,1)
     end
end

_set("sprite", "Entity "..__ID..".lua is missing a SPRITE!",     "missing_sprite_error")

_set("comments", "Enemy "..__ID..".lua is missing COMMENTS (table)!", {})
_set("randomdialogue", "Enemy "..__ID..".lua is missing RANDOMDIALOGUE (table)!", {})
_set("targetables", "Enemy "..__ID..".lua is missing TARGETABLES (string)!", "heroes")
_set("targettype", "Enemy "..__ID..".lua is missing TARGETTYPE (string)!", 1)
--_set("tired", "Enemy "..__ID..".lua is missing TIRED (boolean)!", false)
_set("mercy", "Enemy "..__ID..".lua is missing MERCY (number)!", 0)

_set("BeforeDamageCalculation", "Enemy "..__ID..".lua is missing BEFOREDAMAGECALCULATION (function)!", function() end)
_set("HandleAttack", "Enemy "..__ID..".lua is missing HANDLEATTACK (function)!", function() end)
_set("HandleCustomCommand", "Enemy "..__ID..".lua is missing HANDLECUSTOMCOMMAND (function)!", function() end)

_set("OnSpare", "Enemy "..__ID..".lua is missing ONSPARE (function)!", function() end)
_set("OnDeath", "Enemy "..__ID..".lua is missing ONDEATH (function)!", function() end)

if #commands == 0 then
     KROMER_LOG("Enemy "..__ID..".lua has no COMMANDS!", 1)
end

_set = nil

function Set(spritename)
     sprite.Set(Kromer_FindSprite("Enemies/"..__ID.."/"..spritename))
end

local olds = sprite
sprite = CreateSprite("missing_sprite_error","Entity")
sprite["offset"] = {0,0}
Set(olds)
