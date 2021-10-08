Kromer_DebugLevel = 3
PACKAGE_ID = "Builtin_ExampleEncounter"
require "Kromer/Init"
---------------------

encountertext = "Poseur strikes a pose!"
encountertext = "Clover joins the stage!"
nextwaves = {"bullettest_chaserorb"}
wavetimer = 4.0
arenasize = {155, 130}

heroes = {"kris", "susie", "noelle", "ralsei"}
heropositions = {
     {110, 430},
     {140, 355},
     {100, 280},
     {130, 200}
}

enemies = {"poseur"}
enemypositions = {
     {500, 320}
}

possible_attacks = {"bullettest_bouncy", "bullettest_chaserorb", "bullettest_touhou"}

-- Starting / Ending functions --

function EncounterStarting()
end

function IntroEnding()
end

function DialogueStarting()
end

function DialogueEnding()
end

function WaveStarting()
     nextwaves = { possible_attacks[ math.random( #possible_attacks ) ] }
end

function WaveEnding()
     encountertext = RandomEncounterText()
end

-- Functions for handling actions / sudden events! Very useful! --

function HandleAttack(hero, target)
     -- Runs when the attack prompt appears
     -- This function can run multiple times per frame, depending on how many are attacking.
end

function HandleAct(hero, target, actID)
     -- Runs when the attack prompt appears
end

function HandleMagic(hero, target, magicID)
     -- Runs when magic is cast (This does NOT include acts! For that, use HandleAct())
end

function HandleItem(hero, target, itemID)
     -- Runs when an item is used
end

function HandleSpare(hero, target)
     -- Runs when a hero chooses to spare
end

function HandleDefend(hero)
     -- Runs when a hero's action would normally do something, and they're defending. You'll see what I mean.
end

function HandleDown(hero)
     -- Runs when a hero's HP drops to or below 0.
end

function HandleRevive(hero)
     -- Runs when a hero's HP becomes positive again.
end

function HandleGameOver()
     -- Runs when every party member is downed.
end

function HandleWin()
end

---------------------------------
require "Kromer/EncounterPreload"
