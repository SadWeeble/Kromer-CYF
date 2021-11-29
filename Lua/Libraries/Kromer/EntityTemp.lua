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

currentdialogue = nil
currentanimation = "NONE"

local __u = Update or function() end

--local s = CreateSprite("ut-heart","LowerUI")

sprite["glow"] = CreateSprite("px")
sprite["glow"].Scale(1000,1000)
sprite["glow"].SetParent(sprite)
sprite["glow"].alpha = 0

sprite["shaketimer"] = 0
sprite["shakeoffset"] = {0,0}

function Update(ind)

     __INDEX = ind

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
          if __envtype ~= "m" then return end
          for i,v in ipairs(Kromer_DefinedStatuses[sname]["linked_action"]) do
               Encounter.all_linked_status_actions[v] = true -- It took me an embarrasingly long amount of time to remember I had implemented the whole "Encounter." thing.
          end
          KROMER_LOG("Entity "..name.." given status "..sname,3)
     else
          KROMER_LOG("STATUS \""..sname.."\" DOES NOT EXIST!",1)
     end
end

function RemoveStatus(sname)
     local success = false
     for i = #statuses, 1, -1 do
          if statuses[i]["name"] == sname then
               KROMER_LOG("Entity "..name.." removed status "..statuses[i]["name"],3)
               table.remove(statuses,i)
               success = true
          end
     end

     if success == false then
          KROMER_LOG("Entity "..name.." Attempted to Remove Nonexistent Status.",2)
          return false
     else
          local unrelated_linkedactions = {}
          for ene = 1, #Encounter.enemies do
               for stat = 1, #Encounter.enemies[ene].statuses do
                    for la,v in ipairs(Encounter.enemies[ene].statuses[stat].linked_action) do
                         unrelated_linkedactions[v] = true
                    end
                    if Encounter.enemies[ene].statuses[stat].name == sname then
                         return true
                    end
               end
          end

          for la,v in ipairs(Kromer_DefinedStatuses[sname].linked_action) do
               success = true
               for i,_ in pairs(unrelated_linkedactions) do
                    if v == i then
                         success = false
                         break
                    end
               end

               if success then Encounter.all_linked_status_actions[v] = nil end

          end

          KROMER_LOG("Final "..sname.." status removed.",3)
          return true
     end
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

function Move(x,y)
     sprite.Move(x,y)
end

function MoveTo(x,y)
     sprite.MoveTo(x,y)
end

function MoveToAbs(x,y)
     sprite.MoveAbs(x,y)
end

_set = nil
