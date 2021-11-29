Kromer_DebugLevel = 2
require "Kromer/Init"
---------------------

ItemManager.AddDefaultItems()

--encountertext = "[character:Heroes/ralsei/Faces/][expression:2]What you're calling [highlight:0000ff]Linux[endhighlight] is\ractually [highlight:00ff00]GNU Linux[endhighlight], or as I\rlike to call it, [highlight:aaaaaa]compooter[endhighlight]."
--encountertext = "[character:Heroes/susie/Faces/][expression:18][voice:susie]Wait, you aren't Nubert![smallface:Heroes/noelle/Faces/14,W-who's Nubert?!,bottom,50,0]"
--encountertext = "[character:Heroes/ralsei/Faces/][expression:14][voice:ralsei]I am going to commit several\r[highlight:ff0000]WAR CRIMES[endhighlight]![smallface:Heroes/susie/Faces/17,Ralsei{_COMMA_} NOOO!!,bottom,0,-50]"
encountertext = "[character:Heroes/susie/Faces/][expression:29][voice:susie]Oh my god.\nKris, what is it doing?"
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

enemies = {"poseur","poseur","poseur","poseur"}
enemypositions = {
     {550, 380},
     {470, 320},
     {570, 310},
     {530, 240}
}

possible_attacks = {"bullettest_bouncy", "bullettest_chaserorb", "bullettest_touhou"}

-- Starting / Ending functions --

function EncounterStarting()
     -- for i = 1, #heroes do
     --      heroes[i].Move(math.random()*200,math.random()*200)
     -- end
     -- for i = 1, #enemies do
     --      enemies[i].Move(math.random()*200,math.random()*200)
     -- end

     enemies[2].AddStatus("Spareable")
     enemies[2].AddStatus("Spareable")
     enemies[2].AddStatus("Spareable")
     enemies[2].AddStatus("Spareable")
     enemies[2].AddStatus("Spareable")
     enemies[3].AddStatus("Tired")
     enemies[3].AddStatus("Spareable")
     enemies[4].AddStatus("Spareable")
     enemies[4].AddStatus("Tired")
     enemies[4].AddStatus("Asleep")
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
     -- target is a table containing references to entities
end

function HandleAct(hero, target, act)
     -- Runs when an act is used.
     -- Does NOT run for heroes that are "linked" to the act, only the original act-er.
     -- If a magic user has selected a "standard" act, "act" will be "Standard", and not a table.
     -- target is a table containing references to entities, although if you're acting on more than one enemy at once, you're doing this wrong.
end

function HandleMagic(hero, target, spell)
     -- Runs when magic is cast (This does NOT include acts, even magic users' X-Actions! For that, use HandleAct())
     -- Does NOT run for heroes that are "linked" to the spell, only the original spellcaster.
     -- target is a table containing references to entities
end

function HandleItem(hero, target, item)
     -- Runs when an item is used
     if item.use ~= nil then
          item.use() -- Follow in the footsteps of the default items if you can. See ItemManager for more.
     else
     end
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
