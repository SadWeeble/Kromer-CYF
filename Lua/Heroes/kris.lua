-- A basic Hero Entity you can copy and modify for your own creations.

sprite = "Idle/0"
name = "Kris"
hp = 90
attack = 10
defense = 2
immortal = false

dialogbubble = "CustomBubble2"

magic = 0                             -- MAGIC stat of the Hero. Can be used in spells, has no effect by default.
abilities = { "Act" }                 -- Abilities of the Player. If the Player has "Act", they won't be able to use spells!
herocolor = { 0, 1, 1 }               -- Color used in this Hero's main UI
attackbarcolor = { 0, 0, .5 }         -- Color used in this Hero's atk bar
damagecolor = { 0, 162/255, 232/255 } -- Color used in this Hero's damage text

animations = {
     Intro          = { {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},  1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {17,5.5} } },
     Idle           = { {0, 1, 2, 3, 4, 5},                      1/6,      { offset = {5,2} } },
     AttackReady    = { {0},                                     1,        { next = "Attack", offset = {18.5,1} } },
     Attack         = { {0, 1, 2, 3, 4, 5, 6},                   1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {18.5,1} } },
     ActReady       = { {0, 1},                                  1/6,      { next = "Act", offset = {18.5,4} } },
     Act            = { {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},      1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {18.5,4} } },
     ItemReady      = { {0},                                     1,        { next = "Item", offset = {12,4} } },
     Item           = { {0, 1, 2, 3, 4, 5, 6},                   1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {12,4} } },
     MercyReady     = { {0, 1},                                  1/6,      { next = "Mercy", offset = {18.5,4}, refer = "ActReady" } },
     Mercy          = { {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},      1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {18.5,4}, refer = "Act" } },
     Defend         = { {0, 1, 2, 3, 4, 5},                      1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {5,3} } },
     Hurt           = { {0},                                     1,        { next = "Idle", offset = {18,4} } },
     Down           = { {0},                                     1,        { offset = {6,3} } },
     Victory        = { {0, 1, 2, 3, 4, 5, 6, 7, 8},             1/15,     { loopmode = "ONESHOT", offset = {6,1.5} } },
}

function OnDown() end

function OnRevive() end

function Update()
end

-- Started when this Hero casts a spell through the MAGIC command.
-- Kris has the ability "Act", so this function won't be used.
function HandleCustomSpell(spell) end

-- Function called whenever this entity's animation is changed.
-- Make it return true if you want the animation to be changed like normal, otherwise do your own stuff here!
function HandleAnimationChange(oldAnim, newAnim)
     return true
end
