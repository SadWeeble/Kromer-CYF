local _set = function(item,msg,def)
     if _ENV[item] == nil then
          _ENV[item] = def
          KROMER_LOG(msg,1)
     end
end

_set("sprite", "Entity "..__ID..".lua is missing a SPRITE!",     "missing_sprite_error")

_set("magic", "Hero "..__ID..".lua is missing MAGIC (number)!", 0)
_set("magicuser", "Hero "..__ID..".lua is missing MAGICUSER (boolean)!", false)
if magicuser then _set("canact", "Hero "..__ID..".lua is missing CANACT (boolean)!", false) end
_set("herocolor", "Hero "..__ID..".lua is missing HEROCOLOR (table)!", {1, 1, 1})
_set("attackbarcolor", "Hero "..__ID..".lua is missing ATTACKBARCOLOR (table)!", {1, 1, 1})
_set("damagecolor", "Hero "..__ID..".lua is missing DAMAGECOLOR (table)!", {1, 1, 1})

_set("HandleCustomSpell", "Hero "..__ID..".lua is missing HandleCustomSpell (function)", function() end)
_set("HandleAnimationChange", "Hero "..__ID..".lua is missing HandleAnimationChange (function)", function() end)

_set("OnDown", "Hero "..__ID..".lua is missing ONDOWN (function)!", function() end)
_set("OnRevive", "Hero "..__ID..".lua is missing ONREVIVE (function)!", function() end)

_set = nil

function Set(spritename)
     sprite.Set(Kromer_FindSprite("Heroes/"..__ID.."/"..spritename))
end

local olds = sprite
sprite = CreateSprite("missing_sprite_error","Entity")
sprite["offset"] = {0,0}
Set(olds)
