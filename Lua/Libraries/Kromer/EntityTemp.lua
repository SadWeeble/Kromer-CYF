local _set = function(item,msg,def)
     if _ENV[item] == nil then
          _ENV[item] = def
          KROMER_LOG(msg,1)
     end
end

_set("name",   "Entity "..__ID..".lua is missing a NAME!", "No-name Entity")
_set("attack", "Entity "..__ID..".lua is missing ATTACK (number)!",     0)
_set("defense",     "Entity "..__ID..".lua is missing DEFENSE (number)!",    0)
_set("immortal",    "Entity "..__ID..".lua is missing IMMORTAL (boolean)!",  false)
_set("dialogbubble",     "Entity "..__ID..".lua is missing DIALOGBUBBLE (string)!",    "CustomBubble2")
_set("animations",  "Entity "..__ID..".lua is missing ANIMATIONS (table)",   {})

_set("HandleAnimationChange", "Entity "..__ID..".lua is missing HANDLEANIMATIONCHANGE (function)",    function() end)

currentdialogue = {}
currentanimation = "NONE"

_set = nil
