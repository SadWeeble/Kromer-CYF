-- Clever Coverup --
local cover = CreateSprite("px","BelowBullet")
cover.Scale(640,480)
cover.color = {0,0,0}
--cover.color = {0.5,0.75,0.75}


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
               local pass = false
               for i = 1, #Kromer_States do
                    if state_to_go_to == Kromer_States[i] then
                         pass = true
                         break
                    end
               end
               if not pass then
                    KROMER_LOG("Invalid State \""..state_to_go_to.."\"!",1)
                    return false
               end
               --KROMER_LOG("State Was: "..Kromer_State, 3)
               KROMER_LOG("State Now: "..state_to_go_to, 3)
               local old = Kromer_State
               Kromer_State = state_to_go_to
               Kromer_EnteringState(Kromer_State, old)
               if EnteringState ~= nil then EnteringState(Kromer_State, old) end
          end
     end

     -- Convert Heroes from strings
     for i = 1, #heroes do
          previoushero[i] = 1
          hero_actions[i] = {action="none",targets={},parameters={}}
          past_actions[i] = 1
          linked_actions[i] = 0
          UI_Positions[heroes[i]] = {fight=1,act=1,magic=1,command={1,1},item={1,1},mercy=1}
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

     -- Initialize Libraries
     UI.Init()
     TP.Init()

     -- Music
     Audio.LoadFile(music or "mus_battle1")
     Audio.Pause()

     -- Run normal function
     State("INTRO")
     __es()
     KROMER_LOG("Encounter Starting Ran",3)
end

local particles = {}

-- Update --
__u = Update or function() end
function Update()
     Kromer_StateAge = Kromer_StateAge + Time.dt
     FRAME = FRAME + 1

     --if FRAME % 10 == 0 then
           --SingleFrame()
     --      SingleFrame()
     --end
     SingleFrame()
end

function SingleFrame()
     --if Input.Menu == 1 then State("STARTBATTLE") end
     -- Leaving
     if Input.GetKey("Escape") == 1 then
          KROMER_LOG("Exit Requested",3)
          if Kromer_DebugLevel > 0 then KROMER_PrintTraceback(false) end
          State("DONE")
     end
     -- Glide to positions
     if GetCurrentState() == "STARTBATTLE" then
          if FRAME % 2 == 0 then
               local finish = true
               for i = 1, #heroes do
                    if not heroes[i].sprite["interp_finish"] then
                         finish = false
                         local p = CreateSprite(heroes[i].sprite.spritename,"Background")
                         p.Scale(heroes[i].sprite.xscale,heroes[i].sprite.yscale)
                         p.MoveToAbs(heroes[i].sprite.absx,heroes[i].sprite.absy)
                         p.SetPivot(heroes[i].sprite.xpivot,heroes[i].sprite.ypivot)
                         p.alpha = 0.5
                         p["type"] = "heroghost"
                         table.insert(particles,p)
                    end
               end
               for i = 1, #enemies do
                    if not enemies[i].sprite["interp_finish"] then
                         finish = false
                    end
               end
               if finish then
                    State("INTRO")
               end
          end
     -- If all entity animations have stopped, proceed to ACTIONSELECT
     elseif GetCurrentState() == "INTRO" then
          local pass = true
          for i = 1, #heroes do
               if not heroes[i].sprite.animcomplete  and heroes[i].sprite.loopmode ~= "LOOP" then
                    pass = false
               end
          end
          for i = 1, #enemies do
               if not enemies[i].sprite.animcomplete and enemies[i].sprite.loopmode ~= "LOOP" then
                    pass = false
               end
          end
          if pass then
               activehero = 1
               State("ACTIONSELECT")
          end
     -- Action Select
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
               if currentaction == 1 then menucontext = "fight" end
               if currentaction == 2 and heroes[activehero].magicuser == false then menucontext = "act" end
               if currentaction == 4 then menucontext = "mercy" end
               if currentaction == 1 or (currentaction == 2 and heroes[activehero].magicuser == false) or currentaction == 4 then State("ENEMYSELECT") end

               if currentaction == 2 and heroes[activehero].magicuser == true then
                    menucontext = heroes[activehero]
                    State("MAGICMENU")
               end

               if currentaction == 3 then State("ITEMMENU") end

               if currentaction == 5 then
                    SetHeroAction(activehero,"defend",{},{tpchange=16})
                    NextHero()
               end

               Audio.PlaySound("menuconfirm")
          end

          if Input.Cancel == 1 then
               PreviousHero()
               Audio.PlaySound("menumove")
          end
     -- Move between entities
     elseif GetCurrentState() == "ENTITYSELECT" or GetCurrentState() == "HEROSELECT" or GetCurrentState() == "ENEMYSELECT" then
          local pos = UI_Positions[heroes[activehero].__ID][menucontext]
          if Input.Up == 1 and pos > 1 then
               UI_Positions[heroes[activehero].__ID][menucontext] = pos - 1
               Audio.PlaySound("menumove")
          end
          if Input.Down == 1 and pos < #uimenurefs then
               UI_Positions[heroes[activehero].__ID][menucontext] = pos + 1
               Audio.PlaySound("menumove")
          end

          if Input.Confirm == 1 then
               if menucontext == "fight" then
                    SetHeroAction(activehero,"fight",{uimenurefs[pos]},{})
                    State("ACTIONSELECT")
                    NextHero()
               elseif menucontext == "act" then
                    if heroes[activehero].magicuser and heroes[activehero].canact then
                         SetHeroAction(activehero,"act",{uimenurefs[pos]},{act={name="Standard"}})
                         State("ACTIONSELECT")
                         NextHero()
                    else
                         menucontext = uimenurefs[pos]
                         State("ACTMENU")
                    end
               elseif menucontext == "magic" then
                    local spellpos = UI_Positions[heroes[activehero].__ID]["command"]
                    local spell = heroes[activehero].spells[(spellpos[2]-1)*2+spellpos[1]-(heroes[activehero].canact and 1 or 0)]
                    SetHeroAction(activehero,"magic",{uimenurefs[pos]},{spell=spell,tpchange=-spell.tpcost})
                    State("ACTIONSELECT")
                    NextHero()
               elseif menucontext == "mercy" then
                    SetHeroAction(activehero,"mercy",{uimenurefs[pos]},{})
                    State("ACTIONSELECT")
                    NextHero()
               end
               Audio.PlaySound("menuconfirm")
          end

          if Input.Cancel == 1 then
               State("ACTIONSELECT")
               Audio.PlaySound("menumove")
          end
     -- Move between commands
     elseif GetCurrentState() == "ACTMENU" then
          local pos = UI_Positions[heroes[activehero].__ID]["command"]
          if (Input.Left == 1 or Input.Right == 1) and (pos[1] == 2 or uimenurefs[pos[1]+(pos[2]-1)*2+1] ~= nil) then
               UI_Positions[heroes[activehero].__ID]["command"][1] = 3 - pos[1]
               Audio.PlaySound("menumove")
          end
          if Input.Up == 1 and pos[2] > 1 then
               UI_Positions[heroes[activehero].__ID]["command"][2] = pos[2] - 1
               Audio.PlaySound("menumove")
          end
          if Input.Down == 1 and uimenurefs[pos[1]+(pos[2]+1-1)*2] ~= nil then
               UI_Positions[heroes[activehero].__ID]["command"][2] = pos[2] + 1
               Audio.PlaySound("menumove")
          end

          if Input.Confirm == 1 then
               if uimenurefs[pos[1]+(pos[2]-1)*2].selectable then
                    SetHeroAction(activehero,"act",{menucontext},{act=uimenurefs[pos[1]+(pos[2]-1)*2],tpchange=-uimenurefs[pos[1]+(pos[2]-1)*2].tpcost})
                    if uimenurefs[pos[1]+(pos[2]-1)*2].partymembersrequired ~= nil then
                         for i = 1, #uimenurefs[pos[1]+(pos[2]-1)*2].partymembersrequired do
                              for a = 1, #heroes do
                                   if heroes[a].__ID == uimenurefs[pos[1]+(pos[2]-1)*2].partymembersrequired[i] then
                                        SetHeroAction(a,"act")
                                   end
                              end
                         end
                    end
                    State("ACTIONSELECT")
                    NextHero()
                    Audio.PlaySound("menuconfirm")
               else
               end
          end

          if Input.Cancel == 1 then
               -- Don't remember hero command ui position
               UI_Positions[heroes[activehero].__ID]["command"] = {1,1}
               State("ACTIONSELECT")
               Audio.PlaySound("menumove")
          end
     -- Move between spells
     elseif GetCurrentState() == "MAGICMENU" then
          local pos = UI_Positions[heroes[activehero].__ID]["command"]
          if (Input.Left == 1 or Input.Right == 1) and (pos[1] == 2 or uimenurefs[pos[1]+(pos[2]-1)*2+1] ~= nil) then
               UI_Positions[heroes[activehero].__ID]["command"][1] = 3 - pos[1]
               Audio.PlaySound("menumove")
          end
          if Input.Up == 1 and pos[2] > 1 then
               UI_Positions[heroes[activehero].__ID]["command"][2] = pos[2] - 1
               Audio.PlaySound("menumove")
          end
          if Input.Down == 1 and uimenurefs[pos[1]+(pos[2]+1-1)*2] ~= nil then
               UI_Positions[heroes[activehero].__ID]["command"][2] = pos[2] + 1
               Audio.PlaySound("menumove")
          end

          if Input.Confirm == 1 then
               if uimenurefs[pos[1]+(pos[2]-1)*2].selectable then
                    if uimenurefs[pos[1]+(pos[2]-1)*2].targettype == "Entity" then
                         menucontext = "magic"
                         State("ENTITYSELECT")
                    elseif uimenurefs[pos[1]+(pos[2]-1)*2].targettype == "Hero" then
                         menucontext = "magic"
                         State("HEROSELECT")
                    elseif uimenurefs[pos[1]+(pos[2]-1)*2].targettype == "Enemy" then
                         menucontext = "magic"
                         State("ENEMYSELECT")
                    elseif uimenurefs[pos[1]+(pos[2]-1)*2].targettype == "AllEntity" or uimenurefs[pos[1]+(pos[2]-1)*2].targettype == "AllHero" or uimenurefs[pos[1]+(pos[2]-1)*2].targettype == "AllEnemy" then
                         local targets = {}
                         local spellpos = UI_Positions[heroes[activehero].__ID]["command"]
                         local spell = heroes[activehero].spells[(spellpos[2]-1)*2+spellpos[1]-(heroes[activehero].canact and 1 or 0)]
                         SetHeroAction(activehero,"magic",targets,{spell=spell,tpchange=-spell.tpcost})
                         if spell.partymembersrequired ~= nil then
                              for i = 1, #spell.partymembersrequired do
                                   for a = 1, #heroes do
                                        if heroes[a].__ID == spell.partymembersrequired[i] then
                                             if hero_actions[a].parameters.tpchange ~= nil then AddTP(-hero_actions[a].parameters.tpchange) end
                                             SetHeroAction(a,"magic")
                                        end
                                   end
                              end
                         end
                         State("ACTIONSELECT")
                         NextHero()
                    elseif pos[1]+(pos[2]-1)*2 == 1 and heroes[activehero].canact then
                         menucontext = "act"
                         State("ENEMYSELECT")
                    end
                    Audio.PlaySound("menuconfirm")
               else
               end
          end

          if Input.Cancel == 1 then
               -- Don't remember hero command ui position
               UI_Positions[heroes[activehero].__ID]["command"] = {1,1}
               State("ACTIONSELECT")
               Audio.PlaySound("menumove")
          end

     elseif GetCurrentState() == "DIALOGUE" then
          if EncounterText == nil then -- No encounter text
               if #dialogue_actionqueue == 0 then -- All actions completed
                    State("ENTITYDIALOGUE")
               else
                    for i,v in ipairs(dialogue_actionqueue) do
                         if v.action == "fight" then
                              if GetCurrentState() ~= "ATTACKING" then State("ATTACKING") end
                              HandleAttack(heroes[v.heroNum].__ID,v.targets)
                         elseif v.action == "act" then
                              heroes[v.heroNum].StopAnimation()
                              HandleAct(heroes[v.heroNum].__ID,v.targets,v.parameters.act)
                              v.targets[1]["HandleCustomCommand__WithAutoCheck"](heroes[v.heroNum].__ID,v.parameters.act.name)
                              table.remove(dialogue_actionqueue,i)
                              break
                         elseif v.action == "magic" then
                              HandleMagic(heroes[v.heroNum].__ID,v.targets,v.parameters.spell)
                         elseif v.action == "item" then
                              HandleItem(heroes[v.heroNum].__ID,v.targets,v.parameters.item)
                         elseif v.action == "mercy" then
                              HandleSpare(heroes[v.heroNum].__ID,v.targets)
                         elseif v.action == "defend" then
                              HandleDefend(heroes[v.heroNum].__ID)
                              table.remove(dialogue_actionqueue,i)
                              break
                         end
                    end
               end
          elseif not EncounterText.text.isactive then
               EncounterText = nil
          end
     elseif GetCurrentState() == "ENTITYDIALOGUE" then
          if #TextSystem.EntityText == 0 and Kromer_StateAge > 0 then
               State("WAVE")
          end
     end

     Interp.Update()

     for i = 1, #heroes do
          heroes[i].Update(i)
     end
     for i = 1, #enemies do
          enemies[i].Update(i)
     end

     for i,p in ipairs(particles) do
          if p["type"] == "heroghost" then
               p.alpha = p.alpha - 0.02
               if p.alpha <= 0 then
                    p.Remove()
                    table.remove(particles,i)
               end
          end
     end

     TextSystem.Update()
     UI.Update()
     TP.Update()
     Arena.Update()
     Player.Update()

     __u()
end

-- Set a Hero's action, with optional targets and parameters
function SetHeroAction(heroNum,newaction,newtarget,newparam)
     newtarget = newtarget or {}
     newparam = newparam or {}

     local oldtp = TP.tp
     if newparam.tpchange ~= nil then AddTP(newparam.tpchange) end
     newparam.tpchange = TP.tp - oldtp -- Prevent Spamton from taking our TP

     hero_actions[heroNum] = {action=newaction,targets=newtarget,parameters=newparam,heroNum=heroNum}
     past_actions[heroNum] = currentaction
     local anim = heroes[heroNum].currentanimation
     for k,v in pairs(heroes[heroNum].animations) do
          local a = v
          if a[3].onselect == hero_actions[heroNum].action then
               anim = k
          end
     end
     heroes[heroNum].SetAnimation(anim)
     linked_actions[heroNum] = (heroNum ~= activehero and activehero) or 0
     if Kromer_DebugLevel == 3 then
          local targettext = "{ "
          for i = 1, #newtarget do
               if i == #newtarget then
                    targettext = targettext .. newtarget[i].name
               else
                    targettext = targettext .. newtarget[i].name .. ", "
               end
          end
          targettext = targettext .. " }"
          local paramtext = "{ "
          for k,v in pairs(newparam) do
               paramtext = paramtext .. k .. " = " .. tostring(newparam[k]) .. ", "
          end
          paramtext = paramtext .. " }"
          KROMER_LOG("Hero "..heroes[heroNum].name.." Action Set: \""..newaction.."\", Targets: "..targettext..", Parameters: "..paramtext..", Linked To: "..(linked_actions[heroNum] == 0 and "No One" or heroes[linked_actions[heroNum]].name).."'s Action",3)
     end
end

-- Select the next hero
function NextHero()
     if hero_actions[activehero].action == "none" then SetHeroAction(activehero,UI.HeroUI[activehero]["options"][currentaction]["type"]) end
     local i = activehero
     while hero_actions[activehero].action ~= "none" and activehero < #heroes do
          activehero = activehero + 1
     end
     if activehero == #heroes and hero_actions[activehero].action ~= "none" then
          State("DIALOGUE")
     end
     previoushero[activehero] = i
     currentaction = past_actions[activehero] or 1
end

-- Select the previous hero
function PreviousHero()
     activehero = previoushero[activehero]

     if hero_actions[activehero].parameters.tpchange ~= nil then AddTP(-hero_actions[activehero].parameters.tpchange) end

     hero_actions[activehero] = {action="none",targets={},parameters={}}
     heroes[activehero].SetAnimation("Idle")
     for i = 1, #heroes do
          if linked_actions[i] == activehero then
               linked_actions[i] = 0
               hero_actions[i] = {action="none",targets={},parameters={}}
               heroes[i].SetAnimation("Idle")
          end
     end

     for i = 1, #heroes do -- Funk to un-funk my funky code. Specifically, requiring previous heroes who have already chosen an action in actions
          if hero_actions[i].action == "none" then
               activehero = i
               break
          end
     end

     currentaction = past_actions[activehero] or 1
end

KROMER_LOG("Encounter Preloaded",3)
