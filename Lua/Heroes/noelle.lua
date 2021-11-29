-- A basic Hero Entity you can copy and modify for your own creations.

sprite    = "Idle/0"
name      = "Noelle"
sideb     = false       -- Deltarune internally refers to the Snowgrave route as "sideb". So that's what I'll call it.
hp        = 90
attack    = 3
defense   = 1
immortal  = false

dialogbubble = "Automatic"                             -- Chapter 2's automatic dialogue bubble, very similar to CYF's

magic     = 12                                         -- MAGIC stat of the Hero. Can be used in spells, has no effect by default.
magicuser = true                                       -- Does the Hero use magic or act?
canact    = true                                       -- If the Hero is a magic user, do they have X-ACTION?
statuses  = {}                                         -- Status effects that can be applied to a Hero.

herocolor      = { 1, 1, 0 }                           -- Color used in this Hero's main UI
attackbarcolor = { 1, 1, 0 }                           -- Color used in this Hero's attack bar
damagecolor    = { 255/255, 255/255, 76/255 }          -- Color used in this Hero's damage text
actioncolor    = { 1, 1, 0.5 }                         -- Color used in this Hero's X-Action text

-- Spell name, desc, cost, target type, party members required
AddSpell("Heal Prayer", "Heal\nAlly", 32, "Hero")
AddSpell("Sleep Mist", "Spare\nTIRED Foes", 32, "AllEnemy")
AddSpell("IceShock", "Damage\nw/ ICE", 16, "Enemy")
AddSpell("Suselle", "Hoochi\nMamma!", 100, "AllHero", {"susie"})
--AddSpell("SnowGrave", "Fatal", 100, "Enemy")

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
     StartBattle    = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {-5.5,6.5}, addition = ((sideb and "/SideB/") or "") } },
     Idle           = { "Auto",    1/6,      { offset = {-2,3}, addition = ((sideb and "/SideB/") or "") } },
     AttackReady    = { "Auto",    1,        { next = "Attack", offset = {-0.5,3}, onselect = "fight" } },
     Attack         = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {0,3} } },
     ActReady       = { "Auto",    1/6,      { next = "Act", offset = {10.5,3}, onselect = "act" } },
     Act            = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", immediate = true, offset = {10.5,3} } },
     ItemReady      = { "Auto",    1/6,      { next = "Item", offset = {-0.5,3}, onselect = "item" } },
     Item           = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", immediate = true, offset = {-1.5,3} } },
     SpellReady     = { "Auto",    1/6,      { next = "Spell", offset = {-0.5,3}, onselect = "magic" } },
     Spell          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", immediate = true, offset = {2.5,3} } },
     --MercyReady     = { "Auto",    1/6,      { next = "Mercy", offset = {10.5,3}, refer = "ActReady", onselect = "mercy" }, },
     Mercy          = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", immediate = true, offset = {2.5,3}, refer = "Spell", immediate = true } },
     Defend         = { "Auto",    1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {0.5,3}, addition = ((sideb and "/SideB/") or ""), onselect = "defend" } },
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
-- It should return the next animation to play in string form, or false to not change animation
function HandleAnimationChange(oldAnim, newAnim)
     return newAnim
end
