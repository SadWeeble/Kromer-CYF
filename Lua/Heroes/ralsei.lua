-- A basic Hero Entity you can copy and modify for your own creations.

sprite = "Idle/0"
name = "Ralsei"
hooded = false      -- Set to true
hp = 70
attack = 8
defense = 2
immortal = false

dialogbubble = "CustomBubble2"

magic = 7                                           -- MAGIC stat of the Hero. Can be used in spells, has no effect by default.
magicuser = true                                    -- Does the Hero use magic or act?
canact = true                                       -- If the Hero is a magic user, do they have X-ACTION?
herocolor = { 0, 1, 0 }                             -- Color used in this Hero's main UI
attackbarcolor = { 0, .5, 0 }                       -- Color used in this Hero's atk bar
damagecolor = { 180/255, 230/255, 29/255 }          -- Color used in this Hero's damage text

-- Spell name, desc, cost, target type, party members required
AddSpell("Pacify", "Spare TIRED foe", 16, "Enemy")
AddSpell("Heal Prayer", "Heal Ally", 32, "Hero")

-- Because hooded and unhooded Ralsei have different numbers of frames, I just use auto to fill the table, which returns the folder's sprites in order.
animations = {
     Intro          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {16,3}, addition = ((hooded and "/Hooded/") or "") } },
     Idle           = { "Auto",    1/6,      { offset = {16,3}, addition = ((hooded and "/Hooded/") or "") } },
     AttackReady    = { "Auto",    1,        { next = "Attack", offset = {12,3}, addition = ((hooded and "/Hooded/") or "") } },
     Attack         = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {12,3}, addition = ((hooded and "/Hooded/") or "") } },
     ActReady       = { "Auto",    1/6,      { next = "Act", offset = {16,3}, addition = ((hooded and "/Hooded/") or "") } },
     Act            = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {16,3}, addition = ((hooded and "/Hooded/") or "") } },
     ItemReady      = { "Auto",    1,        { next = "Item", offset = {13.5,7}, addition = ((hooded and "/Hooded/") or "") } },
     Item           = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {13.5,7}, addition = ((hooded and "/Hooded/") or "") } },
     SpellReady     = { "Auto",    1/6,      { next = "Spell", offset = {11.5,3}, addition = ((hooded and "/Hooded/") or "") } },
     Spell          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {11.5,3}, addition = ((hooded and "/Hooded/") or "") } },
     MercyReady     = { "Auto",    1/6,      { next = "Mercy", offset = {16,3}, addition = ((hooded and "/Hooded/") or ""), refer = "ActReady" } },
     Mercy          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {16,3}, addition = ((hooded and "/Hooded/") or ""), refer = "Act" } },
     Defend         = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {16,3}, addition = ((hooded and "/Hooded/") or "") } },
     Hurt           = { "Auto",    1,        { next = "Idle", offset = {15,0}, addition = ((hooded and "/Hooded/") or "") } },
     Down           = { "Auto",    1,        { offset = {20,0}, addition = ((hooded and "/Hooded/") or "") } },
     Victory        = { "Auto",    1/15,     { loopmode = "ONESHOT", offset = {16,3}, addition = ((hooded and "/Hooded/") or "") } },
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
