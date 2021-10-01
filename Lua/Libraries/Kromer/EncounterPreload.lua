-- Clever Coverup --
local cover = CreateSprite("px","BelowBullet")
cover.Scale(640,480)
cover.color = {0,0,0}



-- Encounter Starting --
__heroes = {}
for i = 1, #heroes do
     __heroes[i] = heroes[i]
end
heroes = {}

__enemies = {}
for i = 1, #enemies do
     __enemies[i] = enemies[i]
end
enemies = {}

__es = EncounterStarting
function EncounterStarting()
     ModName = GetModName()

     -- Set and Replace State
     State("NONE")

     __s = State

     function State(state_to_go_to)
          if state_to_go_to == "DONE" then
               __s("DONE")
          else
               KROMER_LOG("State Was: "..Kromer_State, 3)
               KROMER_LOG("State Now: "..state_to_go_to, 3)
               local old = Kromer_State
               Kromer_State = state_to_go_to
               Kromer_EnteringState(Kromer_State, old)
               if EnteringState ~= nil then EnteringState(Kromer_State, old) end
          end
     end

     -- Convert Heroes from strings
     for i = 1, #__heroes do
          -- Replace string with hero object.
          local heroname = __heroes[i]
          __heroes[i] = {}
          AddHero(heroname,__heroes[i])
     end
     KROMER_LOG("Heroes Loaded",3)

     -- Replace Heroes Table
     heroes = __heroes
     __heroes = nil

     -- Convert Enemies from strings
     for i = 1, #__enemies do
          -- Replace string with enemy object.
          local enemyname = __enemies[i]
          __enemies[i] = {}
          AddEnemy(enemyname,__enemies[i])
     end
     KROMER_LOG("Enemies Loaded",3)

     -- Replace Enemy Table
     enemies = __enemies
     __enemies = nil

     -- Music
     Audio.LoadFile(music or "mus_battle1")
     Audio.Pause()

     -- Run normal function
     State("INTRO")
     __es()
     KROMER_LOG("Encounter Starting Ran",3)
end



-- Update --
__u = Update or function() end
function Update()
     if Input.GetKey("Escape") == 1 then
          KROMER_LOG("Exit Requested",3)
          if Kromer_DebugLevel > 0 then KROMER_PrintTraceback(false) end
          State("DONE")
     end
     -- if Input.Menu == 1 then
     --      mi = mi + 1
     --      _ind = mi
     --      DEBUG("\n\n\n\n\n\n\n\n")
     --      for k,v in pairs(_G) do
     --           DEBUG(k .. " = " .. tostring(v))
     --           _ind = _ind - 1
     --           if _ind <= 0 then break end
     --      end
     -- end
     __u()
end



KROMER_LOG("Encounter Preloaded",3)
