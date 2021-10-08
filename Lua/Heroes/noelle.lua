-- A basic Hero Entity you can copy and modify for your own creations.

sprite = "Idle/0"
name = "Noelle"
sideb = false       -- Deltarune internally refers to the Snowgrave route as "sideb". So that's what I'll call it.
hp = 90
attack = 3
defense = 1
immortal = false

dialogbubble = "CustomBubble2"

magic = 12                                          -- MAGIC stat of the Hero. Can be used in spells, has no effect by default.
magicuser = true                                    -- Does the Hero use magic or act?
canact = true                                       -- If the Hero is a magic user, do they have X-ACTION?
herocolor = { 1, 1, 0 }                             -- Color used in this Hero's main UI
attackbarcolor = { 1, 1, 0 }                        -- Color used in this Hero's attack bar
damagecolor = { 255/255, 255/255, 76/255 }          -- Color used in this Hero's damage text

-- Spell name, desc, cost, target type, party members required
AddSpell("Heal Prayer", "Heal Ally.", 32, "Hero")
AddSpell("Sleep Mist", "Spare TIRED foes.", 32, "AllEnemy")
AddSpell("IceShock", "Damage w/ ICE", 16, "Enemy")
--AddSpell("SnowGrave", "Fatal", 100, "Enemy")

animations = {
     Intro          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {-5.5,6.5}, addition = ((sideb and "/SideB/") or "") } },
     Idle           = { "Auto",    1/6,      { offset = {-2,3}, addition = ((sideb and "/SideB/") or "") } },
     AttackReady    = { "Auto",    1,        { next = "Attack", offset = {-0.5,3} } },
     Attack         = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {0,3} } },
     ActReady       = { "Auto",    1/6,      { next = "Act", offset = {10.5,3} } },
     Act            = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {10.5,3} } },
     ItemReady      = { "Auto",    1/6,      { next = "Item", offset = {-0.5,3} } },
     Item           = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {-1.5,3} } },
     SpellReady     = { "Auto",    1/6,      { next = "Spell", offset = {-0.5,3} } },
     Spell          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {2.5,3} } },
     MercyReady     = { "Auto",    1/6,      { next = "Mercy", offset = {10.5,3}, refer = "ActReady" } },
     Mercy          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {10.5,3}, refer = "Act" } },
     Defend         = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {0.5,3}, addition = ((sideb and "/SideB/") or "") } },
     Hurt           = { "Auto",    1,        { next = "Idle", offset = {0.5,3}, addition = ((sideb and "/SideB/") or "") } },
     Down           = { "Auto",    1,        { offset = {0,0} } },
     Victory        = { "Auto",    1/6,      { loopmode = "ONESHOT", offset = {-0.5,3} } },
}

function OnDown() end

function OnRevive() end

-- Started when this Player casts a spell through the MAGIC command.
-- Kris has the ability "Act", so this function won't be used.
function HandleCustomSpell(spell) end

-- Function called whenever this entity's animation is changed.
-- Make it return true if you want the animation to be changed like normal, otherwise do your own stuff here!
function HandleAnimationChange(oldAnim, newAnim)
     return true
end
