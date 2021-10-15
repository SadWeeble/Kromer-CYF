local self = {}

self.CharacterPortrait = CreateSprite("empty","UpperUI")
self.CharacterPortrait.Scale(2,2)
self.CharacterPortrait.xpivot = 0
self.CharacterPortrait["prefix"] = ""

self.TextObjects = {}

self.ParseCustomTextTag = function(string, tagname, replacement)
     local i = 0
     while true do
          local tagbegin = string.find(string, "[[]", i+1)
          local tagend = string.find(string, "]", i+1)
          i = tagend
          if tagbegin == nil or tagend == nil then break end

          local tag = string.sub(string,tagbegin+1,tagend-1)
          local tn = nil
          local args = false
          if string.find(tag,":") then
               tn = string.sub(tag,1,string.find(tag,":")-1)
               args = string.split(string.sub(tag,string.len(tn)+2,-1), ",")

               --for i = 1, #args do
               --     DEBUG(tn.." arg #"..i.." = "..args[i])
               --end

          else
               tn = string.sub(tag,1,-1)
          end

          if tn == tagname then
               if type(replacement) == "string" then
                    if args then
                         for i = 1, #args do
                              replacement = string.gsub(replacement,"ARG_"..i,args[i])
                         end
                    end
                    string = string.sub(string,1,tagbegin-1) .. replacement .. string.sub(string,tagend+1,-1)
               elseif type(replacement) == "function" then
                    replacement(args)
                    string = string.sub(string,1,tagbegin-1) .. string.sub(string,tagend+1,-1)
               end
          end
     end
     return string
end

self.formatstring = function(string,type)
     if type == "BattleEncounterText" then
          string = string.gsub(string, "\n", "\n[letters:3]* ")
          string = string.gsub(string, "\r", "\n[letters:3]  ")
     end
     string = self.ParseCustomTextTag(string, "character", function(args) self.CharacterPortrait["prefix"] = args[1] end)
     string = self.ParseCustomTextTag(string, "expression",
     function(args)
          self.CharacterPortrait.Set(self.CharacterPortrait["prefix"]..args[1])
     end)
     string = self.ParseCustomTextTag(string, "highlight", "[font:vertgradient][color:ARG_1]")
     string = self.ParseCustomTextTag(string, "endhighlight", "[font:uidialog2][color:ffffff]")


     return string
end

self.CreateText = function(text,_type,x,y)

     local prefix = ""
     local len = 99999

     if _type == "BattleEntityText" then
     elseif _type == "BattleEncounterText" then
          self.CharacterPortrait.MoveTo(x-17,y-27)
          x = x + 116
          len = 99999
          prefix = "[font:uidialog2]* "
     else
          KROMER_LOG("Text is missing type!", 1)
     end

     local t = {}

     if type(text) == "string" then
          text = prefix .. text
          text = self.formatstring(text,_type)
     elseif type(text) == "table" then
          for i = 1, #text do
               text[i] = prefix .. text[i]
               text[i] = self.formatstring(text[i],_type)
          end
     else
          KROMER_LOG("Text is missing text!", 1)
     end

     t["text"] = CreateText(text,{x,y},len,"UpperUI",-1)

     if _type == "BattleEntityText" then
     elseif _type == "BattleEncounterText" then
          t["text"].HideBubble()
          t["text"].progressmode = "none"
     end

     table.insert(self.TextObjects,t)
     return t
end

KROMER_LOG("Text System Initialized",3)
return self
