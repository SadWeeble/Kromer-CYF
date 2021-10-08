-- A basic Hero Entity you can copy and modify for your own creations.

sprite = "Idle/0"
name = "Susie"
emo = false
serious = false
unarmed = false
hp = 110
attack = 14
defense = 2
immortal = false

dialogbubble = "CustomBubble2"

magic = 1                                           -- MAGIC stat of the Hero. Can be used in spells, has no effect by default.
magicuser = true                                    -- Does the Hero use magic or act?
canact = true                                       -- If the Hero is a magic user, do they have X-ACTION?
herocolor = { 1, 0, 1 }                             -- Color used in this Hero's main UI
attackbarcolor = { 0.5, 0, 0.5 }                    -- Color used in this Hero's atk bar
damagecolor = { 234/255, 121/255, 200/255 }         -- Color used in this Hero's damage text

-- Spell name, desc, cost, target type, party members required
AddSpell("Rude Buster", "Rude Damage", 50, "Enemy")


function GetAddition()
     local t = ""
     if emo and Misc.DirExists("Sprites/Heroes/"..__ID.."/"..sprite["refer"]..t.."/Emo") then t = t .. "/Emo" end
     if unarmed and Misc.DirExists("Sprites/Heroes/"..__ID.."/"..sprite["refer"]..t.."/Unarmed") then
          t = t .. "/Unarmed/"
     elseif serious and Misc.DirExists("Sprites/Heroes/"..__ID.."/"..sprite["refer"]..t.."/Serious") then
          t = t .. "/Serious/"
     else
          t = t .. "/"
     end

     return t
end

animations = {
     Intro          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {12,11}, addition = GetAddition, refer = "Attack" } },
     Idle           = { "Auto",    1/6,      { offset = {-10,0}, addition = GetAddition } },
     AttackReady    = { "Auto",    1,        { next = "Attack", offset = {10,11}, addition = GetAddition } },
     Attack         = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {12,11}, addition = GetAddition } },
     ActReady       = { "Auto",    1/6,      { next = "Act", offset = {14,11}, addition = GetAddition } },
     Act            = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {14,11}, addition = GetAddition } },
     ItemReady      = { "Auto",    1/6,      { next = "Item", offset = {-9.5,0}, addition = GetAddition } },
     Item           = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {-9.5,0}, addition = GetAddition } },
     SpellReady     = { "Auto",    1/6,      { next = "Spell", offset = {4,5.5}, addition = GetAddition } },
     Spell          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {4,13}, addition = GetAddition } },
     MercyReady     = { "Auto",    1/6,      { next = "Mercy", offset = {14,11}, addition = GetAddition, refer = "ActReady" } },
     Mercy          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {14,11}, addition = GetAddition, refer = "Act" } },
     Defend         = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {-7,12}, addition = GetAddition } },
     Hurt           = { "Auto",    1,        { next = "Idle", offset = {-10,0}, addition = GetAddition } },
     Down           = { "Auto",    1,        { offset = {-10,0}, addition = GetAddition } },
     Victory        = { "Auto",    1/15,     { loopmode = "ONESHOT", offset = {-13,3}, addition = GetAddition } },
}

function OnDown() end

function OnRevive() end

-- Started when this Hero casts a spell through the MAGIC command.
function HandleCustomSpell(spell) end

-- Function called whenever this entity's animation is changed.
-- Make it return true if you want the animation to be changed like normal, otherwise do your own stuff here!
function HandleAnimationChange(oldAnim, newAnim)
     return true
end
