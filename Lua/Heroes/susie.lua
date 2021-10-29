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

dialogbubble = "Automatic"                             -- Chapter 2's automatic dialogue bubble, very similar to CYF's

magic     = 1                                          -- MAGIC stat of the Hero. Can be used in spells, has no effect by default.
magicuser = true                                       -- Does the Hero use magic or act?
canact    = true                                       -- If the Hero is a magic user, do they have X-ACTION?
statuses  = {}                                         -- Status effects that can be applied to a Hero.

herocolor      = { 1, 0, 1 }                           -- Color used in this Hero's main UI
attackbarcolor = { 0.5, 0, 0.5 }                       -- Color used in this Hero's attack bar
damagecolor    = { 234/255, 121/255, 200/255 }         -- Color used in this Hero's damage text
actioncolor    = { 1, 0.5, 1 }                         -- Color used in this Hero's X-Action text

-- Spell name, desc, cost, target type, party members required
AddSpell("Rude Buster", "Rude\nDamage", 50, "Enemy")


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

animations = {
     Intro          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {12,11}, addition = GetAddition, refer = "Attack" } },
     Idle           = { "Auto",    1/6,      { offset = {-10,0}, addition = GetAddition } },
     AttackReady    = { "Auto",    1,        { next = "Attack", offset = {10,11}, addition = GetAddition, onselect = "fight" } },
     Attack         = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {12,11}, addition = GetAddition } },
     ActReady       = { "Auto",    1/6,      { next = "Act", offset = {14,11}, addition = GetAddition, onselect = "act" } },
     Act            = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {14,11}, addition = GetAddition } },
     ItemReady      = { "Auto",    1/6,      { next = "Item", offset = {-9.5,0}, addition = GetAddition, onselect = "item" } },
     Item           = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {-9.5,0}, addition = GetAddition } },
     SpellReady     = { "Auto",    1/6,      { next = "Spell", offset = {4,5.5}, addition = GetAddition, onselect = "magic" } },
     Spell          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {4,13}, addition = GetAddition, immediate = true } },
     --MercyReady     = { "Auto",    1/6,      { next = "Mercy", offset = {14,11}, addition = GetAddition, refer = "ActReady", onselect = "mercy" } },
     Mercy          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {4,13}, addition = GetAddition, refer = "Spell", immediate = true } },
     Defend         = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {-7,12}, addition = GetAddition, onselect = "defend" } },
     Hurt           = { "Auto",    1,        { next = "Idle", offset = {-10,0}, addition = GetAddition } },
     Down           = { "Auto",    1,        { offset = {-10,0}, addition = GetAddition } },
     Victory        = { "Auto",    1/15,     { loopmode = "ONESHOT", offset = {-13,3}, addition = GetAddition } },
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
