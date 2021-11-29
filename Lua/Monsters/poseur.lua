-- A basic Enemy Entity you can copy and modify for your own creations.
comments = { "Smells like the work of an enemy stand.[w:5]\nAnd shady deals.", "Poseur is posing like his money depends on it.", "Poseur's limbs shouldn't be contorting in this way." }
randomdialogue = {
    { "Check it [[out\nat my store!]",                  "Please"                           },
    { "Check it out\nagain.",                           "...",         "For real now"      },
    { "I'll show you [[THE LIGHT].",                   "Trust me."                        },
    { "Keep [[track of\nyour chickens]!",                                                  },
      "It's [[Everyone's\nFavorite Marvel\nCharacter]."
}

-- Act name, act description, TP cost, party members required, party members viewable from
--AddAct("Check", "", 0)
AddAct("Talk",  "", 0,  {})
AddAct("Mock",  "", 10, { "susie" })
AddAct("Dance", "", 30, { "ralsei" })

sprite   = "Idle/0"
name     = "Poseur"
hp       = 250
attack   = 10
defense  = 2
immortal = false

dialogbubble = "automatic"                        -- Chapter 2's automatic dialogue bubble, very similar to CYF's

targetables  = "heroes"                            -- "Hero", "Enemy", or "Entity".
targettype   = 1                                   -- If a number, at most that many targets based off of targetables. If a string / table of strings, target those entities.
statuses     = {}
mercy        = 0                                   -- From 0 to 1, the value of the mercy bar.
cancheck     = true                                -- Inserts the default CHECK behavior into the commands
canspare     = true                                -- Can this enemy be spared?
checkmessage = "This poor mannequin has\rbeen subject to all sorts\rof cruel tests."

talks = 0
mocks = 0
dance = 0

-- The animations table --
-- KROMER searches "Enemies/<enemy name>/<animation name or refer><addition>/<frame name>"
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

local s = {}
local r = math.random(1,4)
for i = 1, r do
     s[i] = 0
end
local r2 = math.random(2,10)
for i = r, r+r2 do
     s[i] = math.random(1,4)
end

s[#s+1] = 5

local t = {}
local r = math.random(5,15)
for i = 1, r do
     t[i] = 0
end
for i = r, r+2 do
     t[i] = i-r+1
     if i == r+2 then t[i] = 1 end
end

animations = {
     Intro          = { s,         1/15,     { loopmode = "ONESHOT", next = "Idle", offset = {0,0}, } },
     Idle           = { t,         1/12,     { offset = {0,0}, } },
     Hurt           = { "Auto",    1,        { next = "Idle", offset = {0,0}, } },
     Flee           = { "Auto",    1,        { offset = {0,0} } },
}


-- Triggered just before computing an attack on this target
function BeforeDamageCalculation(attacker, damageCoeff)
    -- Good location to set the damage dealt to this enemy using self.SetDamage()
    if damageCoeff > 0 then
        --SetDamage(666)
    end
end

-- Triggered when a Hero attacks (or misses) this enemy in the ATTACKING state
function HandleAttack(attacker, attackstatus)
    if currentdialogue == nil then
        currentdialogue = { }
    end

    if attackstatus == -1 then
        -- Player pressed fight but didn't press Z afterwards
        table.insert(currentdialogue, "Do no [DRUGS], " .. attacker.name .. ".\n")
    else
        -- Player did actually attack
        if attackstatus < 50 then
            table.insert(currentdialogue, "You're strong, " .. attacker.name .. "!\n")
        else
            table.insert(currentdialogue, "Too strong, " .. attacker.name .. "...\n")
        end
    end
end

function OnDeath(hero) end

function OnSpare(hero) end

-- Triggered when a Hero uses an Act on this enemy.
-- You don't need an all-caps version of the act commands here.
function HandleCustomCommand(hero, command)
     if command == "Standard" then
          if hero == "noelle" then
               AddMercy(0.15)
               BattleDialogue({"Noelle compliments Poseur's\rforeboding posture."})
          elseif hero == "ralsei" then
               AddMercy(0.15)
               BattleDialogue({"Ralsei offers tips on being\rcute and/or adorable to Poseur."})
          elseif hero == "susie" then
               if not GetStatus("Tired") then AddStatus("Tired") end
               BattleDialogue({"Susie cracks her neck so loudly,\rPoseur's bones tremble in fear.","Poseur became [highlight:00B4FF]TIRED[endhighlight]!"})
          end
     end

     if command == "Talk" then
          talks = talks + 1
          if talks == 1 then
               AddMercy(0.50)
               BattleDialogue({"You try to strike up a\rconversation with Poseur.", "He seems a little out of it."})
               currentdialogue = "[[CONGRATS! YOUR ARE OUR 100TH]"
          elseif talks == 2 then
               AddMercy(0.50)
               BattleDialogue({"You mention bullets.", "Poseur seems to remember something."})
               currentdialogue = "...[[LET'S GET MOVING!!]"
          end
     end
end

-- Function called whenever this entity's animation is changed.
-- Make it return true if you want the animation to be changed like normal, otherwise do your own stuff here!
function HandleAnimationChange(oldAnim, newAnim)
     return true
end
