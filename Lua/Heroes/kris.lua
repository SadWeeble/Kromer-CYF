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
