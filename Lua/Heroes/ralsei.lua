-- A basic Hero Entity you can copy and modify for your own creations.

sprite   = "Idle/0"
name     = "Ralsei"
hooded   = false      -- Set to true
hp       = 70
attack   = 8
defense  = 2
immortal = false

dialogbubble = "automatic"                             -- Chapter 2's automatic dialogue bubble, very similar to CYF's

magic     = 7                                          -- MAGIC stat of the Hero. Can be used in spells, has no effect by default.
magicuser = true                                       -- Does the Hero use magic or act?
canact    = true                                       -- If the Hero is a magic user, do they have X-ACTION?
statuses  = {}                                         -- Status effects that can be applied to a Hero.

herocolor      = { 0, 1, 0 }                           -- Color used in this Hero's main UI
attackbarcolor = { 0, .5, 0 }                          -- Color used in this Hero's attack bar
damagecolor    = { 180/255, 230/255, 29/255 }          -- Color used in this Hero's damage text
actioncolor    = { 0.5, 1, 0.5 }                       -- Color used in this Hero's X-Action text

-- Spell name, desc, cost, target type, party members required
AddSpell("Pacify", "Spare\nTIRED Foe", 16, "Enemy")
AddSpell("Heal Prayer", "Heal\nAlly", 32, "Hero")

-- The animations table --
-- KROMER searches "Heroes/<hero name>/<animation name or refer><addition>/<frame name>"
-- The first argument is the name of the frames
-- The second argument is the speed of the animation (Seconds per frame)
-- The third argument contains various miscellaneous information
     -- loopmode  - The animation's loop mode
     -- next      - Queues an animation after the current one
     -- immediate - If the animation doesn't loop, the queued animation plays immediately after
     -- offset    - The X & Y offset of the animation
     -- addition  - An additional string added to the search path of the animation, after the animation name. supply a function, and it's run every time the animation switches
     -- refer     - Replaces the animation name portion of the search path, if supplied
     -- onselect  - If supplied, this animation will play when the hero selects the supplied action.

-- Because hooded and unhooded Ralsei have different numbers of frames, I just use auto to fill the table, which returns the folder's sprites in order.
animations = {
     Intro          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {16,3}, addition = ((hooded and "/Hooded/") or "") } },
     Idle           = { "Auto",    1/6,      { offset = {16,3}, addition = ((hooded and "/Hooded/") or "") } },
     AttackReady    = { "Auto",    1,        { next = "Attack", offset = {12,3}, addition = ((hooded and "/Hooded/") or ""), onselect = "fight" } },
     Attack         = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {12,3}, addition = ((hooded and "/Hooded/") or "") } },
     ActReady       = { "Auto",    1/6,      { next = "Act", offset = {16,3}, addition = ((hooded and "/Hooded/") or ""), onselect = "act" } },
     Act            = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", immediate = true, offset = {16,3}, addition = ((hooded and "/Hooded/") or "") } },
     ItemReady      = { "Auto",    1,        { next = "Item", offset = {13.5,7}, addition = ((hooded and "/Hooded/") or ""), onselect = "item" } },
     Item           = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", immediate = true, offset = {13.5,7}, addition = ((hooded and "/Hooded/") or "") } },
     SpellReady     = { "Auto",    1/6,      { next = "Spell", offset = {11.5,3}, addition = ((hooded and "/Hooded/") or ""), onselect = "magic" } },
     Spell          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", immediate = true, offset = {11.5,3}, addition = ((hooded and "/Hooded/") or "") } },
     --MercyReady     = { "Auto",    1/6,      { next = "Mercy", offset = {16,3}, addition = ((hooded and "/Hooded/") or ""), refer = "ActReady", onselect = "mercy" } },
     Mercy          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", immediate = true, offset = {16,3}, addition = ((hooded and "/Hooded/") or ""), refer = "Spell" } },
     Defend         = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {16,3}, addition = ((hooded and "/Hooded/") or ""), onselect = "defend" } },
     Hurt           = { "Auto",    1,        { next = "Idle", offset = {15,0}, addition = ((hooded and "/Hooded/") or "") } },
     Down           = { "Auto",    1,        { offset = {20,0}, addition = ((hooded and "/Hooded/") or "") } },
     Victory        = { "Auto",    1/15,     { loopmode = "ONESHOT", offset = {16,3}, addition = ((hooded and "/Hooded/") or "") } },
}

function OnDown() end

function OnRevive() end

-- Started when this Hero casts a spell through the MAGIC command.
function HandleCustomSpell(spell) end

-- Function called whenever this entity's animation is changed.
-- It should return the next animation to play in string form, or false to not change animation
function HandleAnimationChange(oldAnim, newAnim)
     return newAnim
end
