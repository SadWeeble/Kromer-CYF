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
_set("mercy", "Enemy "..__ID..".lua is missing MERCY (number)!", 0)
_set("cancheck", "Enemy "..__ID..".lua is missing CANCHECK (boolean)!", true)
_set("checkmessage", "Enemy "..__ID..".lua is missing CHECKMESSAGE (string)!", "Missing Check Text!")
_set("canspare", "Enemy "..__ID..".lua is missing CANSPARE (boolean)!", true)
_set("standardactname", "Enemy "..__ID..".lua is missing STANDARDACTNAME (string)!", "Standard")

_set("BeforeDamageCalculation", "Enemy "..__ID..".lua is missing BEFOREDAMAGECALCULATION (function)!", function() end)
_set("HandleAttack", "Enemy "..__ID..".lua is missing HANDLEATTACK (function)!", function() end)
_set("HandleCustomCommand", "Enemy "..__ID..".lua is missing HANDLECUSTOMCOMMAND (function)!", function() end)

_set("OnSpare", "Enemy "..__ID..".lua is missing ONSPARE (function)!", function() end)
_set("OnDeath", "Enemy "..__ID..".lua is missing ONDEATH (function)!", function() end)

function SetMercy(value)
     if not canspare then
          KROMER_LOG("Enemy "..__ID..".lua cannot be spared, but tried to modify mercy value.",2)
          return
     end
     local oldm = mercy
     mercy = math.min(math.max(value,0),1)
     Audio.PlaySound("mercyadd")
     --UI.CreateDamageNumber("[font:BattleMessage]+"..math.floor((mercy-oldm)*100), {sprite.absx+sprite.width,sprite.absy}, {1,1,0}, "Entrance_Bounce", "Exit_FlyUpLinear", 2)
     CreateDamageNumber("[font:BattleMessage]+"..math.floor((mercy-oldm)*100), {sprite.absx+30,sprite.absy-((1-sprite.ypivot)*sprite.height)*sprite.yscale}, {1,242/255,0}, "Entrance_Bounce", "Exit_FlyUpLinear", 2)

     if mercy == 1 then
          if not GetStatus("Spareable") then AddStatus("Spareable") end
     else
          if GetStatus("Spareable") then RemoveStatus("Spareable") end
     end

end

function AddMercy(value)
     if not canspare then
          KROMER_LOG("Enemy "..__ID..".lua cannot be spared, but tried to modify mercy value.",2)
          return
     end
     local oldm = mercy
     mercy = math.max(math.min(mercy + value,1),0)
     Audio.PlaySound("mercyadd")
     --CreateDamageNumber("[font:BattleMessage]+"..math.floor((mercy-oldm)*100), {sprite.absx+sprite.width,sprite.absy}, {1,1,0}, "Entrance_Bounce", "Exit_FlyUpLinear", 2)
     CreateDamageNumber("[font:BattleMessage]+"..math.floor((mercy-oldm)*100), {sprite.absx+30,sprite.absy-((1-sprite.ypivot)*sprite.height)*sprite.yscale}, {1,242/255,0}, "Entrance_Bounce", "Exit_FlyUpLinear", 2)

     if mercy == 1 then
          if not GetStatus("Spareable") then AddStatus("Spareable") end
     else
          if GetStatus("Spareable") then RemoveStatus("Spareable") end
     end
     
end

function HandleCustomCommand__WithAutoCheck(hero, command)
     if command == "Check" and cancheck == true then
          BattleDialogue(name:upper().." - "..checkmessage)
     else
          HandleCustomCommand(hero, command)
     end
end

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
sprite.Mask("sprite")
Set(olds)
