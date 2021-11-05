Kromer_DebugLevel = 2
require "Kromer/Init"
---------------------

ItemManager.AddDefaultItems()

--encountertext = "[character:Heroes/ralsei/Faces/][expression:2]What you're calling [highlight:0000ff]Linux[endhighlight] is\ractually [highlight:00ff00]GNU Linux[endhighlight], or as I\rlike to call it, [highlight:aaaaaa]compooter[endhighlight]."
encountertext = "[character:Heroes/susie/Faces/][expression:18][voice:susie]Wait, you aren't Nubert![smallface:Heroes/noelle/Faces/14,W-who's Nubert?!,bottom,50,0]"
--encountertext = "[character:Heroes/ralsei/Faces/][expression:14][voice:ralsei]I am going to commit several\r[highlight:ff0000]WAR CRIMES[endhighlight]![smallface:Heroes/susie/Faces/17,Ralsei{_COMMA_} NOOO!!,bottom,0,-50]"
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
     enemies[1].AddStatus("spareable",{1,1,0})
     enemies[2].AddStatus("tired",{0,180/255,1})
     enemies[3].AddStatus("spareable",{1,1,0})
     enemies[3].AddStatus("tired",{0,180/255,1})
     enemies[4].AddStatus("spareable",{1,1,0})
     enemies[4].AddStatus("tired",{0,180/255,1})
     enemies[4].AddStatus("asleep",{0.5,0.5,0.5})
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

function HandleAct(hero, target, act)
     -- Runs when the attack prompt appears
end

function HandleMagic(hero, target, spell)
     -- Runs when magic is cast (This does NOT include acts! For that, use HandleAct())
end

function HandleItem(hero, target, item)
     -- Runs when an item is used
     if item.use ~= nil then
          item.use() -- Follow in the footsteps of the default items if you can. See ItemManager for more.
     else
     end
end

-- function __item__()
--      hero.SetAnimation("Item")
--      hero.AnimationEndFunction = target[]
-- end
-- BattleDialog(hero.name.." used the [func:__item__]"..string.upper(item.name).."!")
-- __item__ = nil

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
