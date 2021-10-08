local self = {}

self.TextObjects = {}

self.CreateText = function(text,type,x,y)

     local prefix = ""

     if type == "BattleEntityText" then
     else
          KROMER_LOG("Text is missing type!", 1)
     end

     if type(text) == "string" then
          text = prefix .. text
     elseif type(text) == "table" then
          for i = 1, #text do
               text[i] = prefix .. text[i]
          end
     else
          KROMER_LOG("Text is missing text!", 1)
     end

     local t = CreateText(text,{x,y},len,"UpperUI",-1)

     table.insert(self.TextObjects,t)
     return t
end

KROMER_LOG("Text System Initialized",3)
return self
