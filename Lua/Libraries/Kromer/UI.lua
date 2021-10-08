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

local baseui = CreateSprite("baseui","LowerUI")

local test_text = CreateSprite("texttest","LowerUI")
test_text.ypivot = 0
test_text.y = 0

-- Hero UI --

UI.HeroUIWidth = 213

UI.HeroUI = {}

UI.RefreshHeroUI = function()
     for i = 1, #UI.HeroUI do
          UI.HeroUI[i].Remove()
     end
     for i = 1, #heroes do

          local options = {}
          local o = {"fight","act","item","mercy","defend"}
          for j = 1, #o do
               if o[j] == "act" and heroes[i].magicuser then o[j] = "magic" end
               local a = CreateSprite(Kromer_FindSprite("UI/Buttons/"..o[j]),"LowerUI")
               a["select"] = CreateSprite(Kromer_FindSprite("UI/Buttons/"..o[j].."S"))
               --a.SetParent(s)
               a["select"].SetParent(a)
               a["select"].color = {1,1,0,0}
               a["select"].y = -3
               a["type"] = o[j]
               --a.MoveTo(lerp(s.x-88,s.x+88,(j-0.5)/#o)-1,s.y-34)
               table.insert(options,a)
          end

          local s = CreateSprite("px","LowerUI")
          s.Scale(UI.HeroUIWidth,35)
          s.color = {0,0,0}
          s["i"] = i

          local icon = CreateSprite(Kromer_FindSprite("Heroes/"..heroes[i].__ID.."/UI/icon"), "LowerUI")
          icon.SetParent(s)
          icon.xpivot = 0
          icon.x = -UI.HeroUIWidth/2 + 12
          icon.y = -4
          s["icon"] = icon

          local name = CreateText({"[font:PlayerNameFont][charspacing:"..(2-(#heroes[i].name/3)).."][instant]"..heroes[i].name:upper()},{320,240},640,"LowerUI",-1)
          name.HideBubble()
          name.progressmode = "none"
          name.SetParent(s)
          name.MoveTo(-UI.HeroUIWidth/2 + 51, name.y-name.GetTextHeight()/2-3)
          s["name"] = name

          local hptext = CreateSprite(Kromer_FindSprite("UI/HPText"),"LowerUI")
          hptext.SetParent(s)
          hptext.MoveTo(-UI.HeroUIWidth/2 + 116, -7)
          s["hptext"] = hptext

          local hp = CreateText({"[font:HPFont][instant]"..heroes[i].hp.."/ "..heroes[i].maxhp},{320,240},640,"LowerUI",-1)
          hp.HideBubble()
          hp.progressmode = "none"
          hp.SetParent(s)
          hp.MoveTo(99-hp.GetTextWidth(),0)
          s["hp"] = hp

          local hpbar = {}
          hpbar.maxvalue = heroes[i].maxhp
          hpbar.value = heroes[i].hp
          hpbar.emptycolor = {0.5,0,0}
          hpbar.filledcolor = heroes[i].herocolor

          hpbar.empty = CreateSprite("px","LowerUI")
          hpbar.empty.SetParent(s)
          hpbar.empty.color = hpbar.emptycolor
          hpbar.empty.xpivot = 0
          hpbar.empty.Scale(76,9)
          hpbar.empty.MoveTo(-UI.HeroUIWidth/2 + 128, -7)

          hpbar.fill = CreateSprite("px","LowerUI")
          hpbar.fill.SetParent(s)
          hpbar.fill.color = hpbar.filledcolor
          hpbar.fill.xpivot = 0
          hpbar.fill.Scale(76*(hpbar.value/hpbar.maxvalue),9)
          hpbar.fill.MoveTo(-UI.HeroUIWidth/2 + 128, -7)

          s["hpbar"] = hpbar

          s["options"] = options

          s.MoveTo(lerp(0,640,(i-0.5)/math.min(#heroes,3)),135.5)
          s["select"] = false

          s["offset"] = 0
          s["x"] = s.x
          s["y"] = 135.5
          s["oldpos"] = {s["x"],s["y"]}
          s["based"] = true

          UI.HeroUI[i] = s

     end
end

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

UI.Update = function()
     test_text.alpha = math.abs(math.sin(Time.time))
     if UI.backgroundvisible then
          background1.MoveTo(320-(GetFrame()/2)%50,240+(GetFrame()/2)%50+25)
          background2.MoveTo(320+(GetFrame()/4)%50,240-(GetFrame()/4)%50)
     end

     local offset = math.min(math.max(activehero-2,0),#heroes-3)

     for i = 1, #UI.HeroUI do
          local s = UI.HeroUI[i]
          local x = lerp(0,640,(i-0.5-offset)/math.min(#heroes,3))
          local y = 135.5
          if (heroes[i].hp ~= s["hpbar"].value or heroes[i].maxhp ~= s["hpbar"].maxvalue) then
               s["hpbar"].value = heroes[i].hp
               s["hpbar"].fill.xscale = math.max(76*(s["hpbar"].value/s["hpbar"].maxvalue),0)
               s["hp"].SetText("[font:HPFont][instant]"..heroes[i].hp.."/ "..heroes[i].maxhp)
               s["hp"].MoveTo(99-s["hp"].GetTextWidth(),0)
          end
          if i == activehero then
               y = 167.5
               herohighlight.color = heroes[activehero].herocolor
               local ys = 68.5 - (167.5 - s.y)
               herohighlight.left.yscale = ys
               herohighlight.right.yscale = ys
          end

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
               Interp.MoveObjTo(s,s["x"],s["y"],14,"easeout",false)
               --s.MoveTo(s["x"],s["y"])
          end
          for o = 1, #s["options"] do
               s["options"][o].MoveTo(lerp(s.x-88,s.x+88,(o-0.5)/#s["options"])-1,135.5-2)
               s["options"][o].alpha = 1
               if hero_actions[i] == o and i == activehero then
                    s["options"][o]["select"].color = {1,1,0,1}
               else
                    s["options"][o]["select"].color = {1,1,0,0}
               end

               if not s["based"] then
                    s["options"][o].alpha = 0
                    s["options"][o]["select"].color = {1,1,0,0}
               end
          end
     end

     if activehero > 0 and activehero <= #heroes then
          for i = 1, #herohighlight.parts do
               local p = herohighlight.parts[i]
               p.color = heroes[activehero].herocolor
               p.MoveTo(UI.HeroUI[activehero].x+p["xoff"],UI.HeroUI[activehero].y+p["yoff"])
          end
     else
          for i = 1, #herohighlight.parts do
               local p = herohighlight.parts[i]
               p.MoveTo(-640,-480)
          end
     end

end

KROMER_LOG("Kromer UI Initialized", 3)

return UI
