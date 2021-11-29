-- This handles most of the things you'll see on screen outside of the Arena. --

local UI = {}

UI.backgroundvisible = true

local background2 = CreateSprite("UI/Battle/background2","Background")
local background1 = CreateSprite("UI/Battle/background1","Background")

function HideBackground()
     background1.alpha = 0
     background2.alpha = 0
     UI.backgroundvisible = false
end

function ShowBackground()
     background1.alpha = 1
     background2.alpha = 1
     UI.backgroundvisible = true
end

UI.baseui = CreateSprite("baseui","LowerUI")
UI.baseui.y = 0

-- Ignore my lazy workaround, it shouldn't cause problems... right?
UI.EntitySelectCover = CreateSprite("px","Arena")
UI.EntitySelectCover.color = {0,0,0,1}
UI.EntitySelectCover.Scale(640,0)
UI.EntitySelectCover.ypivot = 0
UI.EntitySelectCover.y = 0
UI.EntitySelectCover.Mask("box")

UI.ActMenuCover = CreateSprite("px","Arena")
UI.ActMenuCover.color = {0,0,0,1}
UI.ActMenuCover.Scale(640,0)
UI.ActMenuCover.ypivot = 0
UI.ActMenuCover.y = 0
UI.ActMenuCover.Mask("box")

UI.MagicMenuCover = CreateSprite("px","Arena")
UI.MagicMenuCover.color = {0,0,0,1}
UI.MagicMenuCover.Scale(640,0)
UI.MagicMenuCover.ypivot = 0
UI.MagicMenuCover.y = 0
UI.MagicMenuCover.Mask("box")

UI.ItemMenuCover = CreateSprite("px","Arena")
UI.ItemMenuCover.color = {0,0,0,1}
UI.ItemMenuCover.Scale(640,0)
UI.ItemMenuCover.ypivot = 0
UI.ItemMenuCover.y = 0
UI.ItemMenuCover.Mask("box")

-- Hero UI --

UI.HeroUIWidth = 213     -- The width of the heroes' information boxes. This will change based on the size of the party and widescreen mode.

UI.HeroUI = {}

-- Deletes all of the heroes' related UI and replaces them. You should never have to use this yourself.
UI.RefreshHeroUI = function()
     for i = 1, #UI.HeroUI do
          UI.HeroUI[i].Remove()
     end
     for i = 1, #heroes do

          local s = CreateSprite("px","LowerUI")
          s.Scale(UI.HeroUIWidth,35)
          s.color = {0,0,0}
          s.SetParent(UI.baseui)
          s["i"] = i

          local s_mask = CreateSprite("px","LowerUI")
          s_mask.Scale(UI.HeroUIWidth,35)
          s_mask.color = {1,0,0}
          s_mask.SetParent(s)
          s_mask.Mask("stencil")
          s["mask"] = s_mask

          local s_icon = CreateSprite(Kromer_FindSprite("Heroes/"..heroes[i].__ID.."/UI/icon"), "LowerUI")
          s_icon.SetParent(s)
          s_icon.xpivot = 0
          s_icon.x = -UI.HeroUIWidth/2 + 12
          s_icon.y = -4
          s["icon"] = s_icon

          local s_name = CreateText({"[font:PlayerNameFont][charspacing:"..(2-(#heroes[i].name/3)).."][instant]"..heroes[i].name:upper()},{320,240},640,"LowerUI",-1)
          s_name.HideBubble()
          s_name.progressmode = "none"
          s_name.SetParent(s)
          s_name.MoveTo(-UI.HeroUIWidth/2 + 51, s_name.y-s_name.GetTextHeight()/2-3)
          s["name"] = s_name

          local s_hptext = CreateSprite(Kromer_FindSprite("UI/HPText"),"LowerUI")
          s_hptext.SetParent(s)
          s_hptext.MoveTo(-UI.HeroUIWidth/2 + 116, -7)
          s["hptext"] = s_hptext

          local s_hp = CreateText({"[font:HPFont][instant]"..heroes[i].hp.."/ "..heroes[i].maxhp},{320,240},640,"LowerUI",-1)
          s_hp.HideBubble()
          s_hp.progressmode = "none"
          s_hp.SetParent(s)
          s_hp.MoveTo(99-s_hp.GetTextWidth(),0)
          s["hp"] = s_hp

          local s_hpbar = {}
          s_hpbar.maxvalue = heroes[i].maxhp
          s_hpbar.value = heroes[i].hp
          s_hpbar.emptycolor = {0.5,0,0}
          s_hpbar.filledcolor = heroes[i].herocolor

          s_hpbar.empty = CreateSprite("px","LowerUI")
          s_hpbar.empty.SetParent(s)
          s_hpbar.empty.color = s_hpbar.emptycolor
          s_hpbar.empty.xpivot = 0
          s_hpbar.empty.Scale(76,9)
          s_hpbar.empty.MoveTo(-UI.HeroUIWidth/2 + 128, -7)

          s_hpbar.fill = CreateSprite("px","LowerUI")
          s_hpbar.fill.SetParent(s)
          s_hpbar.fill.color = s_hpbar.filledcolor
          s_hpbar.fill.xpivot = 0
          s_hpbar.fill.Scale(76*(s_hpbar.value/s_hpbar.maxvalue),9)
          s_hpbar.fill.MoveTo(-UI.HeroUIWidth/2 + 128, -7)

          s["hpbar"] = s_hpbar


          local options = {}
          local o = {"fight","act","item","mercy","defend"}
          for j = 1, #o do
               if o[j] == "act" and heroes[i].magicuser then o[j] = "magic" end
               local a = CreateSprite(Kromer_FindSprite("UI/Buttons/"..o[j]),"LowerUI")
               a.SetParent(s_mask)
               a["select"] = CreateSprite(Kromer_FindSprite("UI/Buttons/"..o[j].."S"))
               --a.SetParent(s)
               a["select"].SetParent(a)
               a["select"].color = {1,1,0,0}
               a["select"].y = -3
               a["type"] = o[j]
               --a.MoveTo(lerp(s.x-88,s.x+88,(j-0.5)/#o)-1,s.y-34)
               table.insert(options,a)
          end

          s["options"] = options

          s.MoveTo(lerp(0,640,(i-0.5)/math.min(#heroes,3)),-50)
          s["select"] = false

          s["offset"] = 0
          s["x"] = s.x
          s["y"] = -50
          s["oldpos"] = {s["x"],s["y"]}
          s["based"] = true

          UI.HeroUI[i] = s

     end
end

-- For highlighting the current hero
local herohighlight = {}
herohighlight.color = {1,1,1}
herohighlight.parts = {}

herohighlight.top = CreateSprite("px","UpperUI")
herohighlight.top.Scale(UI.HeroUIWidth,2)
herohighlight.top.ypivot = -8.5
herohighlight.top["xoff"] = 0
herohighlight.top["yoff"] = 0
table.insert(herohighlight.parts,herohighlight.top)

herohighlight.left = CreateSprite("px","UpperUI")
herohighlight.left.Scale(2,37)
herohighlight.left.xpivot = UI.HeroUIWidth/4
herohighlight.left.ypivot = 1
herohighlight.left["xoff"] = 0
herohighlight.left["yoff"] = 19
table.insert(herohighlight.parts,herohighlight.left)

herohighlight.right = CreateSprite("px","UpperUI")
herohighlight.right.Scale(2,37)
herohighlight.right.xpivot = -UI.HeroUIWidth/4
herohighlight.right.ypivot = 1
herohighlight.right["xoff"] = -2
herohighlight.right["yoff"] = 19
table.insert(herohighlight.parts,herohighlight.right)

herohighlight.bottom = CreateSprite("px","UpperUI")
herohighlight.bottom.Scale(UI.HeroUIWidth,2)
herohighlight.bottom.ypivot = 8.5
herohighlight.bottom["xoff"] = 0
herohighlight.bottom["yoff"] = -3
table.insert(herohighlight.parts,herohighlight.bottom)

local heroparticles    = {}     -- The "particles" that emit in the current hero's information box
local spellpass        = nil

uimenurefs             = {}     -- A table that contains information that Kromer needs to properly display and navigate menus

UI_Text                = nil    -- Text that appears in UI menus (Excluding Encounter Text)
UI_Soul                = nil    -- The Soul that appears in UI menus (Excluding the Arena)


local modifiables      = {}     -- Only used in the entity select screen

UI_DescriptionText     = nil    -- Description text seen in ACT/MAGIC/ITEM menus

local names            = ""     -- Names in the entity select screen
local hpidentifier     = nil    -- The squished HP text in the entity select screen
local mercyidentifier  = nil    -- The squished MERCY text in the entity select screen

local entityselecttime = 0      -- Used in highlighting entities
local oldpos           = 0
local offset           = 0
local HeroNameWidth    = 0
local EnemyNameWidth   = 0

local damagenumbers    = {}     -- The several hundred numbers that appear when Sans uses his extremely unfair attacks on you
-- Entrance types: Entrance_Appear, Entrance_Fade, Entrance_Bounce, Entrance_SlideRight, Entrance_SlideLeft, Entrance_Unsquish
-- Exit types: Exit_Disappear, Exit_Fade, Exit_Bounce, Exit_SlideRight, Exit_SlideLeft, Exit_FlyUp, Exit_FlyUpLinear

-- Initializes various UI elements
UI.Init = function()
     UI_Soul = CreateSprite(Kromer_FindSprite("ut-heart"),"HighestUI")
     UI_Soul.SetParent(UI.EntitySelectCover)
     UI_Soul.MoveTo(63,87)

     UI_Text = TextSystem.CreateText("","BattleUIText",81,79,"HighestUI")

     UI_DescriptionText = TextSystem.CreateText("","BattleUIText",500,79,"HighestUI")

     hpidentifier = TextSystem.CreateText("[instant]".."HP","BattleUIText",420+5,95+15-12.5,"HighestUI")
     hpidentifier["text"].SetParent(UI.EntitySelectCover)
     hpidentifier["text"].Scale(1,0.5)

     mercyidentifier = TextSystem.CreateText("[instant]".."MERCY","BattleUIText",520+5,95+15-12.5,"HighestUI")
     mercyidentifier["text"].SetParent(UI.EntitySelectCover)
     mercyidentifier["text"].Scale(1,0.5)

     for i = 0, 3 do

          modifiables[i+1] = {}

          local hpempty = CreateSprite("px","HighestUI")
          hpempty.SetParent(UI.EntitySelectCover)
          hpempty.xpivot = 0
          hpempty.ypivot = 1
          hpempty.Scale(81,16)
          hpempty.color = {0.5,0,0}
          hpempty.MoveToAbs(420,95-30*i)
          hpempty["i"] = i
          modifiables[i+1]["hpempty"] = hpempty

          local hpfill = CreateSprite("px","HighestUI")
          hpfill.SetParent(UI.EntitySelectCover)
          hpfill.xpivot = 0
          hpfill.ypivot = 1
          hpfill.Scale(81*(1),16)
          hpfill.color = {0,1,0}
          hpfill.MoveToAbs(420,95-30*i)
          hpfill["i"] = i
          modifiables[i+1]["hp"] = hpfill

          local percentage = math.ceil((100)).."%"

          local hptext = TextSystem.CreateText("[instant]"..percentage,"BattleUIText",420+5,95-30*i-13.5,"HighestUI")
          hptext["text"].SetParent(UI.EntitySelectCover)
          hptext["text"].Scale(1,0.5)
          hptext["i"] = i
          modifiables[i+1]["hptext"] = hptext

          local mercyempty = CreateSprite("px","HighestUI")
          mercyempty.SetParent(UI.EntitySelectCover)
          mercyempty.xpivot = 0
          mercyempty.ypivot = 1
          mercyempty.Scale(81,16)
          mercyempty.color32 = {255,80,32}
          mercyempty.MoveToAbs(520,95-30*i)
          mercyempty["i"] = i
          modifiables[i+1]["mercyempty"] = mercyempty

          local mercyfill = CreateSprite("px","HighestUI")
          mercyfill.SetParent(UI.EntitySelectCover)
          mercyfill.xpivot = 0
          mercyfill.ypivot = 1
          mercyfill.Scale(81*(0),16)
          mercyfill.color = {1,1,0}
          mercyfill.MoveToAbs(520,95-30*i)
          mercyfill["i"] = i
          modifiables[i+1]["mercy"] = mercyfill

          local percentage = math.ceil((0)).."%"

          local mercytext = TextSystem.CreateText("[instant]"..percentage,"BattleUIText",520+5,95-30*i-13.5,"HighestUI")
          mercytext["text"].SetParent(UI.EntitySelectCover)
          mercytext["text"].Scale(1,0.5)
          mercytext["text"].color = {0.5,0,0}
          mercytext["i"] = i
          modifiables[i+1]["mercytext"] = mercytext

          modifiables[i+1]["values"] = {0,0}
     end
end

UI.CreateDamageNumber = function(text, position, color, entrance, exit, age)
     local dmg = damagenumbers[#damagenumbers+1]
     dmg = TextSystem.CreateText("[instant]"..text,"BattleUIText",position[1],position[2])
     dmg["text"].Scale(2,2)
     dmg["position"] = position
     dmg["color"]    = color
     dmg["entrance"] = entrance
     dmg["exit"]     = exit
     dmg["age"]      = age
     dmg["lifetime"] = 0
     dmg["firstframe"] = true
     table.insert(damagenumbers,dmg)
end

-- Updates UI
UI.Update = function()
     -- Update Background
     if UI.backgroundvisible then
          background1.MoveTo(320-(GetFrame()/2)%50,240+(GetFrame()/2)%50+10)
          background2.MoveTo(320+(GetFrame()/4)%50,240-(GetFrame()/4)%50)
     end

     local entityselectstate = (GetCurrentState() == "ENTITYSELECT" or GetCurrentState() == "ENEMYSELECT" or GetCurrentState() == "HEROSELECT")
     local selectable = (GetCurrentState() == "ACTIONSELECT" or GetCurrentState() == "ENEMYSELECT" or GetCurrentState() == "HEROSELECT" or GetCurrentState() == "ENTITYSELECT" or GetCurrentState() == "ACTMENU" or GetCurrentState() == "ITEMMENU" or GetCurrentState() == "MAGICMENU")
     local herooffset = math.min(math.max(activehero-2,0),#heroes-3)

     -- Spawn Hero Particles
     if GetFrame()%30 == 0 then
          if (activehero > 0 and activehero <= math.min(#heroes,#UI.HeroUI)) and selectable then
               for i = -1, 1, 2 do
                    local p = CreateSprite("px","LowerUI",2)
                    p.SetParent(UI.HeroUI[activehero])
                    p.SendToBottom()
                    p["xoff"] = math.min(i,0)*2
                    p["yoff"] = -19
                    p.xpivot = UI.HeroUIWidth/4*i
                    p.ypivot = 1
                    p["hero"] = activehero
                    p["i"] = i
                    p["speed"] = 0
                    p.color = heroes[p["hero"]].herocolor
                    table.insert(heroparticles,p)
               end
          end
     end

     -- Update Hero UI
     for i = 1, #UI.HeroUI do
          local s = UI.HeroUI[i]
          local x = lerp(0,640,(i-0.5-herooffset)/math.min(#heroes,3))
          local y = 135.5
          if (heroes[i].hp ~= s["hpbar"].value or heroes[i].maxhp ~= s["hpbar"].maxvalue) then
               s["hpbar"].value = heroes[i].hp
               s["hpbar"].fill.xscale = math.max(76*(s["hpbar"].value/s["hpbar"].maxvalue),0)
               s["hp"].SetText("[font:HPFont][instant]"..heroes[i].hp.."/ "..heroes[i].maxhp)
               s["hp"].MoveTo(99-s["hp"].GetTextWidth(),0)
          end
          if i == activehero and selectable then
               y = 167.5
               herohighlight.color = heroes[activehero].herocolor
               local ys = 68.5 - (167.5 - s.absy) - (UI.baseui.y-240)
               herohighlight.left.yscale = ys
               herohighlight.right.yscale = ys
          end

          local icon = "icon"

          icon = (hero_actions[i].action ~= "none" and hero_actions[i].action) or "icon"

          if s["icon"].spritename ~= "Heroes/"..heroes[i].__ID.."/UI/"..icon then s["icon"].Set(Kromer_FindSprite("Heroes/"..heroes[i].__ID.."/UI/"..icon)) end

          s["x"] = x
          s["y"] = y

          if s["oldpos"][1] ~= s["x"] or s["oldpos"][2] ~= s["y"] then
               -- if i-offset <= 0 or i-offset > 3 then
               --      s["x"] = s["oldpos"][1]
               --      s["y"] = 480-35/2
               --      s["based"] = false
               --      --s.MoveTo(s["x"],s["y"])
               -- else
               --      if s["based"] == false then
               --           if i < offset+2 then
               --                --s["x"] = lerp(0,640,(i-0.5-offset-1)/math.min(#heroes,3))
               --           else
               --                --s["x"] = lerp(0,640,(i-0.5-offset+1)/math.min(#heroes,3))
               --           end
               --           s["y"] = 135.5
               --           --s.MoveTo(s["x"],s["y"])
               --      end
               --      s["based"] = true
               -- end
               s["oldpos"] = {s["x"], s["y"]}
               Interp.ClearObjMovement(s)
               Interp.MoveObjTo(s,UI.baseui.x-320+s["x"],UI.baseui.y-240+s["y"],14,"easeout",false)
               --s.MoveTo(s["x"],s["y"])
               if i == activehero then
                    spellpass = false
                    for k,v in pairs(all_linked_status_actions) do
                         if heroes[i].spells[k] ~= nil and GetTP() >= heroes[i].spells[k].tpcost then
                              spellpass = true
                              break
                         end
                    end
               end
          end
          for o = 1, #s["options"] do
               --s["options"][o].MoveTo(lerp(s.absx-88,s.absx+88,(o-0.5)/#s["options"])-1,math.min(s.absy,135.5-1.5))
               s["options"][o].MoveToAbs(lerp(s.absx-88,s.absx+88,(o-0.5)/#s["options"])-1,math.min(s.absy,135.5-1.5))
               s["options"][o].alpha = 1
               if (currentaction == o and i == activehero) and (selectable) then
                    s["options"][o]["select"].color = {1,1,0,1}
               else
                    s["options"][o]["select"].color = {1,1,0,0}
               end

               if selectable and activehero == i and (all_linked_status_actions[s["options"][o]["type"]] ~= nil or (s["options"][o]["type"] == "magic" and spellpass)) then
                    local c = s["options"][o]["select"].color
                    local fadecol = math.abs(math.sin(Time.time*2.5))
                    s["options"][o]["select"].color = {math.max(c[1],fadecol),math.max(c[2],fadecol),fadecol,math.max(s["options"][o]["select"].alpha,fadecol)}
               end
          end
          s["mask"].MoveTo(0,-35)
     end

     -- Update Hero Highlight
     if (activehero > 0 and activehero <= math.min(#heroes,#UI.HeroUI)) and selectable then
          for i = 1, #herohighlight.parts do
               local p = herohighlight.parts[i]
               p.color = heroes[activehero].herocolor
               p.MoveTo(UI.HeroUI[activehero].absx+p["xoff"],UI.HeroUI[activehero].absy+p["yoff"])
          end
     else
          for i = 1, #herohighlight.parts do
               local p = herohighlight.parts[i]
               p.MoveTo(-640,-480)
          end
     end

     -- Update Hero Particles
     for i = #heroparticles, 1, -1 do
          local p = heroparticles[i]
          p["xoff"] = p["xoff"] + p["speed"]
          p["speed"] = p["speed"] + p["i"]*0.01
          p.alpha = p.alpha - 0.01
          p.MoveTo(p["xoff"],p["yoff"])
          p.Scale(2,math.max(30-167.5+UI.HeroUI[p["hero"]].absy,0))
          if p.alpha <= 0 then
               p.Remove()
               p = nil
               table.remove(heroparticles,i)
          end
     end

     -- Entity Select State
     if entityselectstate then
          if #uimenurefs == 0 then
               HeroNameWidth = 0
               EnemyNameWidth = 0
               for i = 1, #heroes do
                    UI_Text["text"].SetText("[font:uidialog]"..heroes[i].name)
                    HeroNameWidth = math.max(UI_Text["text"].GetTextWidth(),HeroNameWidth)
               end
               HeroNameWidth = HeroNameWidth + 25
               for i = 1, #enemies do
                    UI_Text["text"].SetText("[font:uidialog]"..enemies[i].name)
                    EnemyNameWidth = math.max(UI_Text["text"].GetTextWidth(),EnemyNameWidth)
               end
               EnemyNameWidth = EnemyNameWidth + 25
               entityselecttime = Time.time
               names = ""
               if GetCurrentState() == "HEROSELECT" or GetCurrentState() == "ENTITYSELECT" then
                    for i = 1, #heroes do
                         uimenurefs[#uimenurefs+1] = heroes[i]
                         UI_Text["text"].SetText("[font:uidialog]"..heroes[i].name)
                         local icons = ""
                         local name = heroes[i].name
                         names = names .. name .. "[charspacing:"..HeroNameWidth-UI_Text["text"].GetTextWidth().."]é[charspacing:default]" .. icons .. "\n"
                    end
               end

               if GetCurrentState() == "ENEMYSELECT" or GetCurrentState() == "ENTITYSELECT" then
                    local maxiconwidth = 0
                    for i = 1, #enemies do
                         maxiconwidth = math.max(maxiconwidth,#enemies[i].statuses*16)
                    end

                    for i = 1, #enemies do
                         uimenurefs[#uimenurefs+1] = enemies[i]
                         UI_Text["text"].SetText("[font:uidialog]"..enemies[i].name)
                         local icons = ""
                         local iconwid = 0
                         local statusdisplaytext = ""
                         local name = ""
                         if #enemies[i].statuses == 0 then
                              name = "[color:ffffff]"..enemies[i].name
                         else
                              local sn = math.max(#enemies[i].statuses,1)
                              for char = 1, #enemies[i].name do
                                   local color = "ffffff"
                                   local avgcolor = {0,0,0}

                                   local statuslerp = map(1,#enemies[i].name,1,#enemies[i].statuses,char)
                                   local col1 = enemies[i].statuses[math.floor(statuslerp)]["color"]
                                   local col2 = enemies[i].statuses[math.ceil(statuslerp)]["color"]
                                   local mix = statuslerp % 1

                                   avgcolor[1] = lerp(col1[1],col2[1],mix)
                                   avgcolor[2] = lerp(col1[2],col2[2],mix)
                                   avgcolor[3] = lerp(col1[3],col2[3],mix)
                                   color = NumberToHex(math.floor(avgcolor[1]*255)) .. NumberToHex(math.floor(avgcolor[2]*255)) .. NumberToHex(math.floor(avgcolor[3]*255))
                                   name = name .. "[color:"..color.."]" .. string.sub(enemies[1].name,char,char)
                              end

                              local numicons = 0
                              local highestpriority = 1

                              for status = 1, #enemies[i].statuses do
                                   highestpriority = math.max(highestpriority,enemies[i].statuses[status].displaypriority)
                                   if highestpriority == enemies[i].statuses[status].displaypriority then
                                        statusdisplaytext = "[color:808080]( "..enemies[i].statuses[status].name.." )"
                                   end
                                   local x = EnemyNameWidth + iconwid
                                   local y = 7-(i-1)*30
                                   numicons = numicons + 1
                                   local s = CreateSprite("UI/Battle/Statuses/" .. enemies[i].statuses[status]["name"])
                                   local w = s.width+2
                                   s.Remove()
                                   s = nil
                                   iconwid = iconwid + w
                                   icons = icons .. "[icon:UI/Battle/Statuses/"..enemies[i].statuses[status]["name"]..","..x..","..y..",EntitySelectCover]" .. string.rep("é",math.floor(w/3))
                              end

                              statusdisplaytext = string.rep("é",math.floor((maxiconwidth - iconwid)/3)+4) .. statusdisplaytext

                         end
                         if heroes[activehero].magicuser then -- Magic hero's standard acts
                              statusdisplaytext = "[color:"..NumberToHex(heroes[activehero].actioncolor[1]*255)..NumberToHex(heroes[activehero].actioncolor[2]*255)..NumberToHex(heroes[activehero].actioncolor[3]*255).."]"..(enemies[i].standardactname)
                              statusdisplaytext = string.rep("é",math.floor((maxiconwidth - iconwid)/3)+4) .. statusdisplaytext
                         end
                         names = names .. name .. "[charspacing:"..EnemyNameWidth-UI_Text["text"].GetTextWidth().."]é[charspacing:default]" .. icons .. statusdisplaytext .. "\n"
                    end
               end

               UI_Text["text"].SetText(TextSystem.formatstring(UI_Text, "[font:uidialog][instant]"..names, "BattleUIText"))
               UI_Text["text"].SetParent(UI.EntitySelectCover)
          end

          local pos = UI_Positions[heroes[activehero].__ID][menucontext]

          -- Reset Highlight Timer
          if pos ~= oldpos then entityselecttime = Time.time end

          oldpos = pos

          if pos-offset > 3 or pos-offset < 1 then
               offset = math.max(math.min(pos-2,#uimenurefs-3),0)
          end

          UI_Soul.MoveToAbs(63,87-30*(pos-1-offset))

          UI_Text["text"].MoveToAbs(81,79+30*offset)

          hpidentifier["text"].MoveToAbs(420+5,95+15-12.5)

          mercyidentifier["text"].MoveToAbs(520+5,95+15-12.5)

          local i = 1+offset
          for a = 1, 4 do

               if i <= #uimenurefs then
                    modifiables[a]["hpempty"].MoveToAbs(420,95-30*(a-1))
                    modifiables[a]["hp"].MoveToAbs(420,95-30*(a-1))
                    modifiables[a]["hp"].color = {0,1,0,1}
                    modifiables[a]["hptext"]["text"].MoveToAbs(420+5,95-30*(a-1)-13.5)
                    modifiables[a]["hptext"]["text"].color = {1,1,1,1}
                    if (uimenurefs[i].hp ~= modifiables[a]["values"][1]) then
                         modifiables[a]["values"][1] = uimenurefs[i].hp
                         modifiables[a]["hp"].Scale(81*math.min(math.max(uimenurefs[i].hp/uimenurefs[i].maxhp,0),1),16)
                         local percentage = math.ceil((uimenurefs[i].hp/uimenurefs[i].maxhp)*100).."%"
                         modifiables[a]["hptext"]["text"].SetText("[font:uidialog][instant]"..percentage)
                    end

                    if uimenurefs[i].mercy ~= nil and uimenurefs[i].canspare == true then
                         modifiables[a]["mercyempty"].MoveToAbs(520,95-30*(a-1))
                         modifiables[a]["mercy"].MoveToAbs(520,95-30*(a-1))
                         modifiables[a]["mercy"].color = {1,1,0,1}
                         modifiables[a]["mercy"].Set("px")
                         modifiables[a]["mercy"].Scale(81*math.min(math.max(uimenurefs[i].mercy,0),1),16)
                         modifiables[a]["mercytext"]["text"].color = {0.5,0,0,1}
                         modifiables[a]["mercytext"]["text"].MoveToAbs(520+5,95-30*(a-1)-13.5)
                         if (uimenurefs[i].mercy ~= modifiables[a]["values"][2]) then
                              modifiables[a]["values"][2] = uimenurefs[i].mercy
                              local percentage = math.ceil((uimenurefs[i].mercy)*100).."%"
                              modifiables[a]["mercytext"]["text"].SetText("[font:uidialog][instant]"..percentage)
                         end
                    elseif uimenurefs[i].mercy ~= nil then
                         modifiables[a]["mercy"].Scale(1,1)
                         modifiables[a]["mercy"].color = {1,1,1}
                         modifiables[a]["mercyempty"].MoveToAbs(520,95-30*(a-1))
                         modifiables[a]["mercy"].MoveToAbs(520,95-30*(a-1))
                         modifiables[a]["mercy"].Set(Kromer_FindSprite("UI/Battle/no-mercy"))
                         modifiables[a]["mercytext"]["text"].color = {0,0,0,0}
                    else
                         modifiables[a]["mercy"].Set("px")
                         modifiables[a]["mercy"].Scale(81*(1),16)
                         modifiables[a]["mercy"].color = {0,0,0}
                         modifiables[a]["mercytext"]["text"].color = {0,0,0,0}
                    end
               else
                    modifiables[a]["hp"].Scale(81*(1),16)
                    modifiables[a]["hp"].color = {0,0,0}
                    modifiables[a]["mercy"].Scale(81*(1),16)
                    modifiables[a]["mercy"].color = {0,0,0}
                    modifiables[a]["hptext"]["text"].color = {0,0,0}
                    modifiables[a]["mercytext"]["text"].color = {0,0,0}
               end
               i = i + 1
          end

          uimenurefs[pos]["sprite"]["glow"].alpha = math.abs(math.sin((Time.time-entityselecttime)*3))
     end

     -- Act Menu
     if GetCurrentState() == "ACTMENU" then
          if #uimenurefs == 0 then
               --UI_Positions[heroes[activehero].__ID]["command"] = {1,1}
               names = ""
               local x = 0
               local y = 0
               local numicons = 0
               local iconwid = 0
               local iconspre = false
               local iconspaces = "     "
               local arr = table.copy(menucontext.commands)
               if menucontext.cancheck then
                    table.insert(arr,1,{name="Check",description="",tpcost=0,partymembersrequired={}})
               end
               for i = 1, #arr do
                    uimenurefs[#uimenurefs+1] = arr[i]
                    local icons = ""
                    local selectable = true
                    arr[i]["selectable"] = true
                    numicons = 0
                    iconwid = 0
                    if arr[i].partymembersrequired ~= nil then
                         for a = 1, #arr[i].partymembersrequired do
                              x = ((i-1) % 2) * 180 + 16 + iconwid
                              y = -math.floor((i-1)/2)*30 + 10
                              numicons = numicons + 1
                              local s = CreateSprite("Heroes/" .. arr[i].partymembersrequired[a] .. "/UI/icon")
                              local w = s.width+2
                              s.Remove()
                              s = nil
                              iconwid = iconwid + w
                              icons = icons .. "[icon:Heroes/" .. arr[i].partymembersrequired[a] .. "/UI/icon,"..x..","..y.."]" .. string.rep("é",math.floor(w/3))
                              for b = 1, #heroes do
                                   if heroes[b].__ID == arr[i].partymembersrequired[a] then
                                        if heroes[b].hp <= 0 and not heroes[b].immortal then
                                             selectable = false
                                             arr[i]["selectable"] = false
                                        end
                                   end
                              end
                         end
                         if arr[i].tpcost > TP.tp then
                              selectable = false
                              arr[i]["selectable"] = false
                         end
                    end
                    local color = ""
                    if not selectable then color = "[color:808080]" end
                    if i % 2 == 1 then
                         names = names .. icons .. color .. arr[i].name .. "[color:ffffff]"
                         iconspre = numicons > 0
                    else
                         UI_Text["text"].SetText("[font:uidialog]" .. (iconspre and iconspaces or "") .. arr[i-1].name)
                         names = names .. "[charspacing:"..(175-UI_Text["text"].GetTextWidth()).."] [charspacing:default]" .. icons .. color .. arr[i].name .. "[color:ffffff]" ..  "\n"
                    end
               end
               UI_Text["text"].SetText(TextSystem.formatstring(UI_Text, "[font:uidialog][instant]"..names, "BattleUIText"))
               UI_Text["text"].SetParent(UI.ActMenuCover)
               UI_DescriptionText["text"].SetParent(UI.ActMenuCover)
          end
          local pos = UI_Positions[heroes[activehero].__ID]["command"]
          if pos[2]-offset > 3 or pos[2]-offset < 1 then
               offset = math.max(math.min(pos[2]-2,math.ceil(#uimenurefs/2)-3),0)
          end

          local act = uimenurefs[(pos[2]-1)*2+pos[1]]

          TP.highlighted = act.tpcost

          UI_Soul.MoveToAbs(63+180*(pos[1]-1),87-30*(pos[2]-1-offset))
          UI_Text["text"].MoveToAbs(81,79+30*offset)
          UI_DescriptionText["text"].MoveToAbs(500,79)

          local desc = ""
          if act.description ~= "" then desc = act.description .. "\n" end
          if act.tpcost ~= 0 then desc = desc .. "[color:"..NumberToHex(TP.color_fill[1]*255)..NumberToHex(TP.color_fill[2]*255)..NumberToHex(TP.color_fill[3]*255).."]"..act.tpcost.."% TP" end
          UI_DescriptionText["text"].SetText(TextSystem.formatstring(UI_Text, "[font:uidialog][instant]"..desc, "BattleUIText"))

          menucontext["sprite"]["glow"].alpha = math.abs(math.sin((Time.time-entityselecttime)*3))
     end
     -- Magic Menu
     if GetCurrentState() == "MAGICMENU" then
          if #uimenurefs == 0 then
               --UI_Positions[heroes[activehero].__ID]["command"] = {1,1}
               names = ""
               local x = 0
               local y = 0
               local numicons = 0
               local iconwid = 0
               local iconspre = false
               local iconspaces = "     "
               local arr = table.copy(menucontext.spells)
               if menucontext.canact then
                    table.insert(arr,1,{name="[color:"..NumberToHex(menucontext.actioncolor[1]*255)..NumberToHex(menucontext.actioncolor[2]*255)..NumberToHex(menucontext.actioncolor[3]*255).."]"..string.sub(menucontext.name,1,1).."-Action[color:ffffff]",description="",tpcost=0,partymembersrequired={}})
               end
               for i = 1, #arr do
                    uimenurefs[#uimenurefs+1] = arr[i]
                    local icons = ""
                    numicons = 0
                    iconwid = 0
                    local selectable = true
                    arr[i]["selectable"] = true
                    numicons = 0
                    iconwid = 0
                    if arr[i].partymembersrequired ~= nil then
                         for a = 1, #arr[i].partymembersrequired do
                              x = ((i-1) % 2) * 180 + 16 + iconwid
                              y = -math.floor((i-1)/2)*30 + 10
                              numicons = numicons + 1
                              local s = CreateSprite("Heroes/" .. arr[i].partymembersrequired[a] .. "/UI/icon")
                              local w = s.width+2
                              s.Remove()
                              s = nil
                              iconwid = iconwid + w
                              icons = icons .. "[icon:Heroes/" .. arr[i].partymembersrequired[a] .. "/UI/icon,"..x..","..y.."]" .. string.rep("é",math.floor(w/3))
                              for b = 1, #heroes do
                                   if heroes[b].__ID == arr[i].partymembersrequired[a] then
                                        if heroes[b].hp <= 0 and not heroes[b].immortal then
                                             selectable = false
                                             arr[i]["selectable"] = false
                                        end
                                   end
                              end
                         end
                         if arr[i].tpcost > TP.tp then
                              selectable = false
                              arr[i]["selectable"] = false
                         end
                    end
                    local color = ""
                    if not selectable then color = "[color:808080]" end
                    if i % 2 == 1 then
                         names = names .. icons .. color .. arr[i].name
                         iconspre = numicons > 0
                    else
                         UI_Text["text"].SetText("[font:uidialog]" .. (iconspre and iconspaces or "") .. arr[i-1].name)
                         names = names .. "[charspacing:"..(175-UI_Text["text"].GetTextWidth()).."] [charspacing:default]" .. icons .. color .. arr[i].name .. "\n"
                    end
               end
               UI_Text["text"].SetText(TextSystem.formatstring(UI_Text, "[font:uidialog][instant]"..names, "BattleUIText"))
               UI_Text["text"].SetParent(UI.MagicMenuCover)
               UI_DescriptionText["text"].SetParent(UI.MagicMenuCover)
          end
          local pos = UI_Positions[heroes[activehero].__ID]["command"]
          if pos[2]-offset > 3 or pos[2]-offset < 1 then
               offset = math.max(math.min(pos[2]-2,math.ceil(#uimenurefs/2)-3),0)
          end

          local spell = uimenurefs[(pos[2]-1)*2+pos[1]]

          TP.highlighted = spell.tpcost

          UI_Soul.MoveToAbs(63+180*(pos[1]-1),87-30*(pos[2]-1-offset))
          UI_Text["text"].MoveToAbs(81,79+30*offset)
          UI_DescriptionText["text"].MoveToAbs(500,79)

          local desc = ""
          if spell.description ~= "" then desc = "[color:808080]" .. spell.description .. "\n" end
          if spell.tpcost ~= 0 then desc = desc .. "[color:"..NumberToHex(TP.color_fill[1]*255)..NumberToHex(TP.color_fill[2]*255)..NumberToHex(TP.color_fill[3]*255).."]"..spell.tpcost.."% TP" end
          UI_DescriptionText["text"].SetText(TextSystem.formatstring(UI_Text, "[font:uidialog][instant]"..desc, "BattleUIText"))
     end

     for i = #damagenumbers, 1, -1 do
          local dmg = damagenumbers[i]
          dmg["text"].color = dmg.color

          if not dmg.firstframe then
               local speed = 5
               local entfac = dmg["lifetime"]/(dmg["age"]/speed)

               dmg["lifetime"] = dmg["lifetime"] + Time.dt

               dmg["text"].MoveTo(dmg.position[1],dmg.position[2])


               if dmg.entrance == "Entrance_Fade" then
                    dmg["text"].alpha = lerp(0,dmg.color[4] or 1,entfac)
               elseif dmg.entrance == "Entrance_SlideRight" then
                    dmg["text"].MoveTo(dmg.position[1]+math.min(0,-50*(0.1^entfac)),dmg.position[2])
                    dmg["text"].alpha = lerp(0,dmg.color[4] or 1,entfac)
               elseif dmg.entrance == "Entrance_SlideLeft" then
                    dmg["text"].MoveTo(dmg.position[1]-math.min(0,-50*(0.1^entfac)),dmg.position[2])
                    dmg["text"].alpha = lerp(0,dmg.color[4] or 1,entfac)
               elseif dmg.entrance == "Entrance_Unsquish" then
                    local squishfactor = lerp(0,20,entfac)
                    if squishfactor == 0 then
                         dmg["text"].xscale = 8
                         dmg["text"].yscale = 0
                         dmg.lerptimer = 0
                         dmg.hit5 = false
                         dmg.hit8 = false
                         dmg.hit10 = false
                    end
                    if squishfactor <= 5 then
                         dmg.lerptimer = dmg.lerptimer + 1
                         dmg["text"].xscale = lerp(dmg["text"].xscale, 2, (dmg.lerptimer / 10))
                         dmg["text"].yscale = lerp(dmg["text"].yscale, 2, (dmg.lerptimer / 10))
                    end
                    if squishfactor >= 5 and not dmg.hit5 then
                         dmg.hit5 = true
                         dmg.lerptimer = 0
                    end
                    if squishfactor >= 5 and squishfactor <= 8 then
                         dmg.lerptimer = dmg.lerptimer + 1
                         dmg["text"].xscale = lerp(dmg["text"].xscale, 1, (dmg.lerptimer / 6))
                         dmg["text"].yscale = lerp(dmg["text"].yscale, 4, (dmg.lerptimer / 6))
                    end
                    if squishfactor >= 8 and not dmg.hit8 then
                         dmg.hit8 = true
                         dmg.lerptimer = 0
                    end
                    if squishfactor >= 8 and squishfactor <= 10 then
                         dmg.lerptimer = dmg.lerptimer + 1
                         if dmg.lerptimer >= 4 then dmg.lerptimer = 4 end
                         dmg["text"].xscale = lerp(dmg["text"].xscale, 2, (dmg.lerptimer / 4))
                         dmg["text"].yscale = lerp(dmg["text"].yscale, 2, (dmg.lerptimer / 4))
                    end
                    if squishfactor >= 10 and not dmg.hit10 then
                         dmg.hit10 = true
                         dmg["text"].xscale = 2
                         dmg["text"].yscale = 2
                    end
                    if squishfactor <= 10 then
                         dmg["text"].MoveTo(dmg.position[1]-(dmg["text"].GetTextWidth()/2*dmg["text"].xscale)+dmg["text"].GetTextWidth(),dmg.position[2]-(dmg["text"].GetTextHeight()*dmg["text"].yscale)+dmg["text"].GetTextHeight()*2)
                    end
               elseif dmg.entrance == "Entrance_Bounce" then
                    if not dmg.init then
                         dmg.init = true
                         dmg.bounces = 0
                         dmg.stretch = 0.2
                         dmg.stretchgo = 1
                         dmg.hspeed = 5
                         dmg.vspeed = 2 + math.random()
                         dmg.vstart = dmg.vspeed
                         dmg.xoff = -27
                         dmg.yoff = 0
                    end

                    if dmg.stretchgo == 1 then
                         dmg.stretch = dmg.stretch + 0.2
                    end
                    if dmg.stretch >= 1.2 then
                         dmg.stretch = 1
                         dmg.stretchgo = 0
                    end

                    if dmg.bounces < 2 then
                         dmg.vspeed = dmg.vspeed - 0.5
                         if dmg.yoff < 0 then
                              dmg.yoff = 0
                              dmg.vspeed = dmg.vstart/2
                              dmg.bounces = dmg.bounces + 1
                              if dmg.bounces == 2 then
                                   dmg.vspeed = 0
                                   dmg.xoff = 0
                              end
                         end
                         dmg.xoff = dmg.xoff + dmg.hspeed
                         dmg.yoff = dmg.yoff + dmg.vspeed
                         dmg["text"].xscale = 4 - (dmg.stretch*2)
                         dmg["text"].yscale = dmg.stretch*2
                         dmg["text"].MoveTo(dmg.position[1]+dmg.xoff-(dmg["text"].GetTextWidth()*dmg["text"].xscale/2)+dmg["text"].GetTextWidth(),dmg.position[2]+dmg.yoff-(dmg["text"].GetTextHeight()*dmg["text"].yscale/2)+dmg["text"].GetTextHeight())
                    end


                    if dmg.hspeed > 0 then dmg.hspeed = dmg.hspeed - 0.5 end
                    if dmg.hspeed < 0 then dmg.hspeed = dmg.hspeed + 0.5 end
               end

               if dmg.exit == "Exit_Fade" and dmg["lifetime"]/dmg["age"] >= 1-1/speed then
                    dmg["text"].alpha = lerp(0,dmg.color[4] or 1,speed-entfac)
               elseif dmg.exit == "Exit_SlideRight" and dmg["lifetime"]/dmg["age"] >= 1-1/speed then
                    dmg["text"].MoveTo(dmg.position[1]+50*(0.01^(speed-entfac)),dmg.position[2])
                    dmg["text"].alpha = lerp(0,dmg.color[4] or 1,speed-entfac)
               elseif dmg.exit == "Exit_SlideLeft" and dmg["lifetime"]/dmg["age"] >= 1-1/speed then
                    dmg["text"].MoveTo(dmg.position[1]-50*(0.01^(speed-entfac)),dmg.position[2])
                    dmg["text"].alpha = lerp(0,dmg.color[4] or 1,speed-entfac)
               elseif dmg.exit == "Exit_FlyUp" and dmg["lifetime"]/dmg["age"] >= 1-1/speed then
                    dmg.position[2] = dmg.position[2] + (entfac-4) * 5
                    dmg["text"].yscale = dmg["text"].yscale + (entfac-4) / 10
                    dmg["text"].alpha = lerp(0,1,speed-entfac)
                    dmg["text"].MoveTo(dmg.position[1],dmg.position[2])
               elseif dmg.exit == "Exit_FlyUpLinear" and dmg["lifetime"]/dmg["age"] >= 1-1/speed then
                    dmg.position[2] = dmg.position[2] + 2
                    dmg["text"].alpha = dmg["text"].alpha - 0.04
                    dmg["text"].yscale = dmg["text"].yscale + 0.04
                    dmg["text"].MoveTo(dmg.position[1],dmg.position[2])
               end

               if dmg["lifetime"] > dmg["age"] then
                    dmg["text"].Remove()
                    dmg = nil
                    table.remove(damagenumbers,i)
               end
          else
               dmg.firstframe = false
          end
     end
end

KROMER_LOG("Kromer UI Initialized", 3)

return UI
