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

sprite["glow"] = CreateSprite("px")
sprite["glow"].Scale(1000,1000)
sprite["glow"].SetParent(sprite)
sprite["glow"].alpha = 0

sprite["shaketimer"] = 0
sprite["shakeoffset"] = {0,0}

function Update()

     if sprite["shaketimer"] >= 0 then
          sprite["shakeoffset"][1] = -(sprite["shaketimer"] ^ 1.5)/2
          sprite["shaketimer"] = sprite["shaketimer"] - 1
     end

     if sprite.animcomplete and animations[currentanimation][3].immediate and sprite["nextanimation"] ~= false then
          SetAnimation(sprite["nextanimation"])
     end
     sprite.SetPivot(0.5-(sprite["offset"][1]+sprite["shakeoffset"][1])/sprite.width, 0.5-(sprite["offset"][2]+sprite["shakeoffset"][2])/sprite.height)
     --s.MoveTo(sprite.x,sprite.y)

     sprite["glow"].alpha = 0

     __u()
end

function AddStatus(sname)
     if Kromer_DefinedStatuses[sname] ~= nil then
          statuses[#statuses+1] = Kromer_DefinedStatuses[sname]
     else
          KROMER_LOG("STATUS \""..sname.."\" DOES NOT EXIST!",1)
     end
end

function RemoveStatus(sname)
     for i = 1, #statuses do
          if statuses[i][name] ~= nil then
               table.remove(statuses,i)
               return true
          end
     end
     KROMER_LOG("Entity "..name.." Attempted to Remove Nonexistent Status.",2)
     return false
end

function GetStatus(sname)
     for i = 1, #statuses do
          if statuses[i][name] == sname then
               return true
          end
     end
     return false
end

function Shake(length)
     sprite["shaketimer"] = length or 10
end

_set = nil
