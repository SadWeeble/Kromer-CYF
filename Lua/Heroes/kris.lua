-- A basic Hero Entity you can copy and modify for your own creations.

sprite = "Idle/0"
name = "Kris"
hp = 90
attack = 10
defense = 2
immortal = false

dialogbubble = "Automatic"                   -- Chapter 2's automatic dialogue bubble, very similar to CYF's

magic     = 0                                -- MAGIC stat of the Hero. Can be used in spells, has no effect by default.
magicuser = false                            -- Does the Hero use magic or act?
statuses  = {}                               -- Status effects that can be applied to a Hero.

herocolor      = { 0, 1, 1 }                 -- Color used in this Hero's main UI
attackbarcolor = { 0, 0, .5 }                -- Color used in this Hero's attack bar
damagecolor    = { 0, 162/255, 232/255 }     -- Color used in this Hero's damage text

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
     Intro          = { {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},  1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {17,5.5} } },
     Idle           = { {0, 1, 2, 3, 4, 5},                      1/6,      { offset = {5,2} } },
     AttackReady    = { {0},                                     1,        { next = "Attack", offset = {18.5,1}, onselect = "fight" } },
     Attack         = { {0, 1, 2, 3, 4, 5, 6},                   1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {18.5,1} } },
     ActReady       = { {0, 1},                                  1/6,      { next = "Act", offset = {18.5,4}, onselect = "act" } },
     Act            = { {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},      1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {18.5,4} } },
     ItemReady      = { {0},                                     1,        { next = "Item", offset = {12,4}, onselect = "item" } },
     Item           = { {0, 1, 2, 3, 4, 5, 6},                   1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {12,4} } },
     --MercyReady     = { {0, 1},                                  1/6,      { next = "Mercy", offset = {18.5,4}, refer = "ActReady", onselect = "mercy" } },
     Mercy          = { {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},      1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {18.5,4}, refer = "Act" } },
     Defend         = { {0, 1, 2, 3, 4, 5},                      1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {5,3}, onselect = "defend" } },
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
-- It should return the next animation to play in string form, or false to not change animation
function HandleAnimationChange(oldAnim, newAnim)
     return newAnim
end
