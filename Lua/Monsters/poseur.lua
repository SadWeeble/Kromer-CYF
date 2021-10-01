-- A basic Enemy Entity you can copy and modify for your own creations.
comments = { "Smells like the work of an enemy stand.[w:5]\nAnd shady deals.", "Poseur is posing like his money depends on it.", "Poseur's limbs shouldn't be contorting in this way." }
randomdialogue = {
    { "Check it out.",            "Please"                     },
    { "Check it out again.",      "...",      "For real now"   },
    { "I'll show you [[THE LIGHT].", "Trust me."                  },
    { "Keep [[DYING]!",            "[KROMER]!",  "I SAID [[KROMER]!" },
      "It's [[Everyone's Favorite Marvel Character]."
}

-- Act name, act description, TP cost, party members required, party members viewable from
AddAct("Check", "", 0)
AddAct("Talk", "", 0)
AddAct("Mock", "", 10, { "Susie" })
AddAct("Dance", "", 30, { "Ralsei" })

sprite = "Idle/0"
name = "Poseur"
hp = 250
attack = 10
defense = 2
immortal = false

dialogbubble = "CustomBubble2" -- CustomBubble2 is identical to that of Chapter 2.

targetables = "heroes"   -- "heroes", "enemies", or "all".
targettype = 1      -- If a number, that many targets based off of targetables. If a string / table of strings, target those entities.
tired = false       -- If true, the enemy can be spared through a pacify spell or something of that sort.
mercy = 0 -- From 0 to 1, the value of the mercy bar.

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
end

-- Function called whenever this entity's animation is changed.
-- Make it return true if you want the animation to be changed like normal, otherwise do your own stuff here!
function HandleAnimationChange(oldAnim, newAnim)
     return true
end
