-- Oh dear fuck this is spaghetti as hell --
-- Oh well, it works. --
-- Needs a major rework though --

-- Anyway, this handles the text --

local self = {}

-- The big important character portrait
-- Want more than one? Too bad.
self.CharacterPortrait = CreateSprite("empty","UpperUI")
self.CharacterPortrait.Scale(2,2)
self.CharacterPortrait.xpivot = 0
self.CharacterPortrait["prefix"] = ""

self.TextObjects = {}    -- All text objects
self.EntityText  = {}    -- All text objects spoken by entities (Sort of a category of text objects)

-- Replaces a text tag with something else based on its arguments
self.ParseCustomTextTag = function(object, string, tagname, replacement)
     local i = 0
     while true do
          local tagbegin = string.find(string, "[[]", i+1)
          local tagend = string.find(string, "]", i+1)
          if tagbegin == nil or tagend == nil then break end
          --KROMER_LOG(i,3)

          local tag = string.sub(string,tagbegin+1,tagend-1)
          local tn = nil
          local args = false
          if string.find(tag,":") then
               tn = string.sub(tag,1,string.find(tag,":")-1)
               args = string.split(string.sub(tag,string.len(tn)+2,-1), ",")


          else
               tn = string.sub(tag,1,-1)
          end

          if tn == tagname then
               local rep = replacement
               if type(replacement) == "string" then
                    if args then
                         for i = 1, #args do
                              rep = string.gsub(rep,"ARG_"..i,args[i])
                         end
                    end
                    string = string.sub(string,1,tagbegin-1) .. rep .. string.sub(string,tagend+1,-1)
               elseif type(replacement) == "function" then
                    if args then
                         for i = 1, #args do
                              -- Workaround, because I can't workthrough
                              args[i] = string.gsub(args[i],"{_COMMA_}",",")
                         end
                    end
                    replacement(args,object)
                    string = string.sub(string,1,tagbegin-1) .. string.sub(string,tagend+1,-1)
               end
          end
          i = i + 1 -- Not efficient but whatever
     end
     return string
end

-- Formats a string based on the type of text object (Adding stars and stuff)
self.formatstring = function(object,string,type)
     if type == "BattleEncounterText" then
          string = string.gsub(string, "\n", "\n[letters:3]* ")
          string = string.gsub(string, "\r", "\n[letters:3]  ")

          string = self.ParseCustomTextTag(object, string, "character", function(args) self.CharacterPortrait["prefix"] = args[1] end)
          string = self.ParseCustomTextTag(object, string, "expression",
          function(args)
               self.CharacterPortrait.Set(self.CharacterPortrait["prefix"]..args[1])
          end)

          string = self.ParseCustomTextTag(object, string, "highlight", "[font:vertgradienttrim][color:ARG_1]")
          string = self.ParseCustomTextTag(object, string, "endhighlight", "[font:uidialog2][color:ffffff]")

          -- Face, text, position, start position (x and y)
          string = self.ParseCustomTextTag(object, string, "smallface", function(args,object)
               local icon = CreateSprite(args[1],"UpperUI")
               icon["xoff"] = 0
               icon["yoff"] = 0
               icon["textfin"] = false
               icon["slide"] = {args[4],args[5]}
               icon["UNIQUEID"] = Time.time*math.random(Time.time)
               icon["smallface"] = true
               local text = CreateText("[font:uidialog][instant]"..args[2],{320,240},9999,"UpperUI",-1)
               text.HideBubble()
               text.progressmode = "none"
               text.Scale(0.5,0.5)
               text.MoveTo(text.x+icon.width*0.75,text.y+0)
               text.SetParent(icon)
               icon.alpha = 0
               text.alpha = 0
               icon["text"] = text
               if args[3] == "bottomleft" then
                    icon["xoff"] = 0
                    icon["yoff"] = -50
               elseif args[3] == "bottom" then
                    icon["xoff"] = 250
                    icon["yoff"] = -50
               elseif args[3] == "bottomright" then
                    icon["xoff"] = 425
                    icon["yoff"] = -50
               end
               table.insert(object["children"],icon)
          end)
     elseif type == "BattleEnemyText" or type == "BattleHeroText" then
          string = self.ParseCustomTextTag(object, string, "bubble", function(args, object)
               object["bubble"] = args[1]
          end)
     elseif type == "BattleUIText" then
          string = self.ParseCustomTextTag(object, string, "icon", function(args, object)
               local path = Kromer_FindSprite(args[1])
               local s = CreateSprite(path,"HighestUI")
               s.MoveTo(object.x+tonumber(args[2]),object.y+tonumber(args[3]))
               if args[4] ~= nil then s.SetParent(UI[args[4]]) end
               s["xoff"] = tonumber(args[2])
               s["yoff"] = tonumber(args[3])
               table.insert(object["children"],s)
          end)
     end


     return string
end

-- Update Text Objects
self.Update = function()
     for _,t in pairs(self.TextObjects) do
          if t["text"].isactive then
               for _,c in pairs(t["children"]) do

                    if c["smallface"] == true then
                         if t["text"].lineComplete and not c["textfin"] then
                              c["textfin"] = true
                              local distance = math.sqrt(c["slide"][1]^2 + c["slide"][2]^2)
                              local speed = 5
                              Interp.SetValue(c["UNIQUEID"].."SlideX",c["slide"][1],0,distance/speed,"linear",false)
                              Interp.SetValue(c["UNIQUEID"].."SlideY",c["slide"][2],0,distance/speed,"linear",false)
                         elseif c["textfin"] and c.alpha < 1 then
                              local xs = Interp.GetItem(c["UNIQUEID"].."SlideX") or {ct = 1, t = 1}
                              c.alpha = xs.ct / xs.t
                              c["text"].alpha = c.alpha
                              c["slide"][1] = Interp.GetValue(c["UNIQUEID"].."SlideX") or 0
                              c["slide"][2] = Interp.GetValue(c["UNIQUEID"].."SlideY") or 0
                         end

                         c.x = t.x + c["xoff"] + c["slide"][1]
                         c.y = t.y + c["yoff"] + c["slide"][2]
                    else
                         c.absx = t["text"].absx + c["xoff"]
                         c.absy = t["text"].absy + c["yoff"]
                    end
               end

               if t["progressmode"] == "manual" then
                    if t["text"].allLinesComplete and t["backlight"].allLinesComplete and Input.Confirm == 1 then
                         t.Remove()
                    elseif t["text"].lineComplete and t["backlight"].lineComplete and Input.Confirm == 1 then
                         t["text"].NextLine()
                         t["backlight"].NextLine()
                    end
               end
          end
     end

     local pass = true
     if Input.Confirm == 1 then
          for _,t in pairs(self.EntityText) do
               DEBUG(_)
               if not t["text"].lineComplete then
                    pass = false
                    break
               end
          end
          if pass then
               for _,tt in pairs(self.EntityText) do
                    if tt["text"].allLinesComplete then
                         tt["text"].NextLine()
                         if tt["bubble"] == "automatic" then
                              tt["bubble1"].Remove()
                              tt["bubble2"].Remove()
                              tt["bubbletail"].Remove()
                         else
                              for i in ipairs(tt["sprites"]) do
                                   tt["sprites"][i].Remove()
                              end
                         end
                         self.EntityText[_] = nil
                    else
                         tt["text"].NextLine()
                         local w = tt["text"].GetTextWidth()
                         local h = tt["text"].GetTextHeight()
                         if tt["bubble"] == "automatic" then
                              tt["bubble1"].Scale(w+5+10,h+5)
                              tt["bubble2"].Scale(w+5,h+5+10)
                              if tt["type"] == "BattleHeroText" then
                                   tt["bubbletail"].xpivot = 1
                                   tt["bubbletail"].MoveTo(tt.x,tt.y)
                                   tt["bubble1"].MoveTo(tt.x+w/2+15+10,tt.y)
                                   tt["bubble2"].MoveTo(tt.x+w/2+15+10,tt.y)
                                   tt["text"].MoveTo(tt.x+15+10,tt.y+h/2-12)
                                   tt["bubbletail"].Scale(-1,1)
                              elseif tt["type"] == "BattleEnemyText" then
                                   tt["bubbletail"].xpivot = 1
                                   tt["bubbletail"].MoveTo(tt.x,tt.y)
                                   tt["bubble1"].MoveTo(tt.x-w/2-15-10,tt.y)
                                   tt["bubble2"].MoveTo(tt.x-w/2-15-10,tt.y)
                                   tt["text"].MoveTo(tt.x-w-15-10,tt.y+h/2-12)
                                   tt["bubbletail"].Scale(1,1)
                              end
                         end
                    end
               end
          end
     end
end

-- Create Text Object
self.CreateText = function(text,_type,x,y,layer)

     layer = layer or "UpperUI"

     local prefix = ""
     local len = 99999

     if _type == "BattleHeroText" or _type == "BattleEnemyText" then
          len = 99999
     elseif _type == "BattleEncounterText" then
          len = 99999
          prefix = "[font:uidialog2]* "
     elseif _type == "BattleUIText" then
          len = 99999
          prefix = "[font:uidialog]"
     else
          KROMER_LOG("Text is missing type!", 1)
     end

     local t = {}
     t.x = x
     t.y = y
     t["children"] = {}
     t["type"] = _type
     t["bubble"] = "automatic"

     if type(text) == "string" then
          text = prefix .. text
          text = self.formatstring(t,text,_type)
     elseif type(text) == "table" then
          for i = 1, #text do
               text[i] = prefix .. text[i]
               text[i] = self.formatstring(t,text[i],_type)
          end
     else
          KROMER_LOG("Text is missing text!", 1)
     end

     t.SkipLine = function()
          t["text"].SkipLine()
          if t["backlight"] ~= nil then t["backlight"].SkipLine() end
     end

     t.Remove = function()
          t["text"].Remove()
          if t["backlight"] ~= nil then t["backlight"].Remove() end

          t.CleanUpChildren()

          for a,b in pairs(t) do
               b = nil
          end

          t = nil
     end

     t.CleanUpChildren = function()
          for a,b in pairs(t["children"]) do
               b.Remove()
               b = nil
          end
          t["children"] = {}
     end

     if _type == "BattleHeroText" or _type == "BattleEnemyText" then
     elseif _type == "BattleEncounterText" then
          self.CharacterPortrait.MoveTo(x-17,y-27)
          x = x + self.CharacterPortrait.width * 2
     end

     t.x = x
     t.y = y

     if _type == "BattleEncounterText" then
          local t2 = text
          if type(t2) == "string" then
               t2 = self.ParseCustomTextTag(t,t2,"font","[font:uidialogtrimless]")
               t2 = self.ParseCustomTextTag(t,t2,"color","[color:ffffff]")
               t2 = self.ParseCustomTextTag(t,t2,"func","")
          elseif type(t2) == "table" then
               t2 = table.copy(text)
               for i = 1, #t2 do
                    t2[i] = self.ParseCustomTextTag(t,t2[i],"font","[font:uidialogtrimless]")
                    t2[i] = self.ParseCustomTextTag(t,t2[i],"color","[color:ffffff]")
                    t2[i] = self.ParseCustomTextTag(t,t2[i],"func","")
               end
          end
          t["backlight"] = CreateText(t2,{x,y},len,"UpperUI",-1)
     end
     t["text"] = CreateText(text,{x,y},len,layer,-1)

     if _type == "BattleHeroText" or _type == "BattleEnemyText" then
          local path = ""
          local xml = {}
          if t["bubble"] ~= "automatic" then
               t["textoffset"] = {0,0}
               t["sprites"] = {}
               t["width"] = 9999
               path = Kromer_FindSprite("UI/SpeechBubbles/"..t["bubble"])
               if Misc.FileExists("Sprites/"..path..".xml") then
                    -- I'm not commenting on this.
                    local file = Misc.OpenFile("Sprites/"..path..".xml")
                    local text = ""
                    for i = 1, #file.readLines() do
                         text = text .. file.readLines()[i]
                    end
                    xml = XmlParser:ParseXmlText(text)

                    t["width"] = xml.Attributes.width or 9999
                    if autolinebreak then t["text"].textMaxWidth = tonumber(t["width"]) end

                    for _,sprite in ipairs(xml.ChildNodes[1].ChildNodes) do
                         local s = CreateSprite("missing_sprite_error","LowerUI")
                         s.setPivot(0,1)
                         for _,attribute in pairs(sprite.Attributes) do
                              if _ == "name" then
                                   s.Set(Kromer_FindSprite("UI/SpeechBubbles/"..attribute))
                              end
                         end
                         for _,child in pairs(sprite.ChildNodes) do
                              if child.Name == "origin" then
                                   s.MoveTo(t.x-child.Attributes.x,t.y+child.Attributes.y)

                                   --t["textoffset"][1] = t["textoffset"][1] - child.Attributes.x
                                   --t["textoffset"][2] = t["textoffset"][2] + child.Attributes.y
                              end
                         end
                         table.insert(t["sprites"],s)
                    end

                    for _,child in ipairs(xml.ChildNodes) do
                         if child.Name == "origin" then
                              t["textoffset"][1] = t["textoffset"][1] - child.Attributes.x
                              t["textoffset"][2] = t["textoffset"][2] + child.Attributes.y
                         elseif child.Name == "border" then
                              t["textoffset"][1] = t["textoffset"][1] + child.Attributes.x
                              t["textoffset"][2] = t["textoffset"][2] - child.Attributes.y
                         end
                    end
                    file = nil
               else
                    KROMER_LOG("Speech Bubble \""..path.."\" is Missing .xml File!",1)
                    t["bubble"] = "automatic"
               end
          end

          if t["bubble"] == "automatic" then
               local w = t["text"].GetTextWidth()
               local h = t["text"].GetTextHeight()
               t["bubble1"] = CreateSprite("px","LowerUI")
               t["bubble1"].Scale(w+5+10,h+5)
               t["bubble2"] = CreateSprite("px","LowerUI")
               t["bubble2"].Scale(w+5,h+5+10)
               t["bubbletail"] = CreateSprite("UI/tail","LowerUI")
               if _type == "BattleHeroText" then
                    t["bubbletail"].xpivot = 1
                    t["bubbletail"].MoveTo(t.x,t.y)
                    t["bubble1"].MoveTo(t.x+w/2+15+10,t.y)
                    t["bubble2"].MoveTo(t.x+w/2+15+10,t.y)
                    t["text"].MoveTo(t.x+15+10,t.y+h/2-12)
                    t["bubbletail"].Scale(-1,1)
               elseif _type == "BattleEnemyText" then
                    t["bubbletail"].xpivot = 1
                    t["bubbletail"].MoveTo(t.x,t.y)
                    t["bubble1"].MoveTo(t.x-w/2-15-10,t.y)
                    t["bubble2"].MoveTo(t.x-w/2-15-10,t.y)
                    t["text"].MoveTo(t.x-w-15-10,t.y+h/2-12)
                    t["bubbletail"].Scale(1,1)
               end
          else
               t["text"].MoveTo(t.x+t["textoffset"][1],t.y+t["textoffset"][2])
          end
          t["text"].HideBubble()
          t["text"].progressmode = "none"
          table.insert(self.EntityText,t)
     elseif _type == "BattleEncounterText" then
          t["backlight"].HideBubble()
          t["backlight"].progressmode = "none"

          t["text"].HideBubble()
          t["text"].progressmode = "none"
     elseif _type == "BattleUIText" then
          t["text"].HideBubble()
          t["text"].progressmode = "none"
     end

     table.insert(self.TextObjects,t)
     return t
end

KROMER_LOG("Text System Initialized",3)
return self
