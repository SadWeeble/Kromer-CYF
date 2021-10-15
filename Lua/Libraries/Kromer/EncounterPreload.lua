-- Clever Coverup --
local cover = CreateSprite("px","BelowBullet")
cover.Scale(640,480)
cover.color = {0.5,0.75,0.75}



-- Encounter Starting --
__enemies = enemies
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
     for i = 1, #heroes do
          -- Replace string with hero object.
          local heroname = heroes[i]
          heroes[i] = {}
          AddHero(heroname,heropositions[i],i)
     end
     KROMER_LOG("Heroes Loaded",3)

     UI.RefreshHeroUI()

     -- Convert Enemies from strings
     for i = 1, #__enemies do
          -- Replace string with enemy object.
          local enemyname = __enemies[i]
          __enemies[i] = {}
          AddEnemy(enemyname,enemypositions[i])
     end
     __enemies = nil
     KROMER_LOG("Enemies Loaded",3)

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
     FRAME = FRAME + 1

     -- if FRAME % 2 == 0 then
     --      SingleFrame()
     --      SingleFrame()
     -- end
     SingleFrame()
end

function SingleFrame()
     if Input.GetKey("Escape") == 1 then
          KROMER_LOG("Exit Requested",3)
          if Kromer_DebugLevel > 0 then KROMER_PrintTraceback(false) end
          State("DONE")
     end

     if GetCurrentState() == "INTRO" then
          local pass = true
          for i = 1, #heroes do
               if not heroes[i].sprite.animcomplete then
                    pass = false
               end
          end
          if pass then
               activehero = 1
               State("ACTIONSELECT")
          end
     elseif GetCurrentState() == "ACTIONSELECT" then
          if Input.Left == 1 then
               currentaction = ((currentaction + 3) % 5) + 1
               Audio.PlaySound("menumove")
          end
          if Input.Right == 1 then
               currentaction = (currentaction % 5) + 1
               Audio.PlaySound("menumove")
          end

          if Input.Confirm == 1 then
               hero_actions[activehero] = currentaction
               activehero = activehero + 1
               currentaction = hero_actions[activehero] or 1
               Audio.PlaySound("menuconfirm")
          end

          if Input.Cancel == 1 then
               activehero = activehero - 1
               --hero_actions[activehero] =
               currentaction = hero_actions[activehero] or 1
               Audio.PlaySound("menumove")
          end

          hero_actions[activehero] = currentaction
     end

     Interp.Update()

     for i = 1, #heroes do
          heroes[i].Update()
     end
     for i = 1, #enemies do
          enemies[i].Update()
     end

     UI.Update()

     __u()
end



KROMER_LOG("Encounter Preloaded",3)
