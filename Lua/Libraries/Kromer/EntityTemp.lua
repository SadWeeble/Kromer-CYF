local _set = function(item,msg,def)
     if _ENV[item] == nil then
          _ENV[item] = def
          KROMER_LOG(msg,1)
     end
end

_set("name",   "Entity "..__ID..".lua is missing a NAME!", "No-name Entity")
_set("hp", "Entity "..__ID..".lua is missing HP (number)!",     1)
maxhp = maxhp or hp
_set("attack", "Entity "..__ID..".lua is missing ATTACK (number)!",     0)
_set("defense",     "Entity "..__ID..".lua is missing DEFENSE (number)!",    0)
_set("immortal",    "Entity "..__ID..".lua is missing IMMORTAL (boolean)!",  false)
_set("dialogbubble",     "Entity "..__ID..".lua is missing DIALOGBUBBLE (string)!",    "CustomBubble2")
_set("animations",  "Entity "..__ID..".lua is missing ANIMATIONS (table)!",   {})
_set("statuses", "Entity "..__ID..".lua is missing STATUSES (table)!", {})

_set("HandleAnimationChange", "Entity "..__ID..".lua is missing HANDLEANIMATIONCHANGE (function)",    function() end)

currentdialogue = {}
currentanimation = "NONE"

local __u = Update or function() end

--local s = CreateSprite("ut-heart","LowerUI")

function Update()
     if sprite.animcomplete and animations[currentanimation][3].immediate and sprite["nextanimation"] ~= false then
          SetAnimation(sprite["nextanimation"])
     end
     sprite.SetPivot(0.5-sprite["offset"][1]/sprite.width, 0.5-sprite["offset"][2]/sprite.height)
     --s.MoveTo(sprite.x,sprite.y)


     __u()
end

_set = nil
