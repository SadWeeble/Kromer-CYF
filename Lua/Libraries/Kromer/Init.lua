-- Initialize Kromer --
-- The actual behavior of Kromer can be found in EncounterPreload.lua --
-- However, some important functions are still held here --

if not isCYF or (CYFversion < "0.6.5" or CYFversion == "1.0") then
     error("<size=20>You need to be playing on <color=#ffff00><i>Create Your Frisk Version 0.6.5</i></color> or greater to use Kromer.</size>",-1)
end

if windows then Misc.WindowName = "KROMER" end

PACKAGE_ID = PACKAGE_ID or "NONE"

FRAME = 0

GetFrame = function() return FRAME end

Kromer_StartTime = Time.time
Kromer_Version = "1.0.0"
Kromer_DebugLevel = Kromer_DebugLevel or 0
-- How much [debug] do you want in your kromer?
-- 0 for NONE
-- 1 for IMPORTANT WARNINGS
-- 2 for ALL WARNINGS
-- 3 for ALL DEBUG MESSAGES

Kromer_Widescreen = Kromer_Widescreen or false
Kromer_30FPS = Kromer_30FPS or false

CreateLayer("Background", "Top", true)
CreateLayer("Entity", "Background")
CreateLayer("LowerUI", "Entity")
CreateLayer("UpperUI", "LowerUI")
CreateLayer("Arena", "UpperUI")
CreateLayer("Bullet", "Arena")
CreateLayer("HighestUI", "Bullet")

-- States --
Kromer_State = "NONE"
Kromer_States = {
     "INTRO",
     "ACTIONSELECT",
     "ENEMYSELECT",
     "HEROSELECT",
     "ENTITYSELECT",
     "ACTMENU",
     "MAGICMENU",
     "ITEMMENU",
     "ATTACKING",
     "DIALOGUE",
     "WAVE",
     "GAMEOVER",
     "OUTRO",
     "ENTITYSTATUS",
     "NONE"
     }
-- The default states of Kromer. Custom states can be added for
-- whatever reason.

function GetCurrentState()
     return Kromer_State
end

-- The actual Encounter Text Object
local EncounterText = nil

-- DO NOT CONFUSE THIS FOR EnteringState!!
function Kromer_EnteringState(newstate, oldstate)
     Kromer_StateAge = 0
     if oldstate == "ACTIONSELECT" then
          EncounterText.SkipLine()
     elseif oldstate == "ENTITYSELECT" or oldstate == "HEROSELECT" or oldstate == "ENEMYSELECT" then
          UI_Text.CleanUpChildren()
          UI.EntitySelectCover.yscale = 0
          uimenurefs = {}
     elseif oldstate == "ACTMENU" then
          UI_Text.CleanUpChildren()
          UI.ActMenuCover.yscale = 0
          uimenurefs = {}
     elseif oldstate == "MAGICMENU" then
          UI_Text.CleanUpChildren()
          UI.MagicMenuCover.yscale = 0
          uimenurefs = {}
     end

     if newstate == "INTRO" then
          Audio.PlaySound(introsound or "weaponpull")
          -- Play all heroes' intro animations
          -- Actually, play enemy animations too
          for i = 1, #heroes  do  heroes[i].SetAnimation("Intro") end
          for i = 1, #enemies do enemies[i].SetAnimation("Intro") end
     elseif newstate == "ACTIONSELECT" then
          -- Hide Various UI Menus
          TP.highlighted = 0
          UI.EntitySelectCover.yscale = 0
          -- Set Idle Animations
          if oldstate == "INTRO" then
               for i = 1, #heroes do
                    heroes[i].SetAnimation("Idle")
               end
               for i = 1, #enemies do
                    enemies[i].SetAnimation("Idle")
               end
               Audio.Unpause()
          end
          -- Encounter Text
          if EncounterText == nil and encountertext ~= nil then
               EncounterText = TextSystem.CreateText(encountertext,"BattleEncounterText",31,76)
          elseif encountertext == nil and EncounterText == nil then
               EncounterText = TextSystem.CreateText("","BattleEncounterText",31,76)
               KROMER_LOG("There is no Encounter Text!",1)
          end
     elseif newstate == "ENTITYSELECT" or newstate == "HEROSELECT" or newstate == "ENEMYSELECT" then
          -- Show Menu
          UI_Soul.SetParent(UI.EntitySelectCover)
          UI.EntitySelectCover.yscale = 115
     elseif newstate == "ACTMENU" then
          -- Show Menu
          UI_Soul.SetParent(UI.ActMenuCover)
          UI.ActMenuCover.yscale = 115
     elseif newstate == "MAGICMENU" then
          -- Show Menu
          UI_Soul.SetParent(UI.MagicMenuCover)
          UI.MagicMenuCover.yscale = 115
     elseif newstate == "DIALOGUE" then
          EncounterText.Remove()
          TextSystem.CharacterPortrait.Set("empty")

          if oldstate == "ACTIONSELECT" then
               local t = {}
               for i = 1, #heroes do
                    t[i] = heroes[i].name .. " done did "..hero_actions[i].action .. "!"
               end
               EncounterText = TextSystem.CreateText(t,"BattleEncounterText",31,76)
               EncounterText["progressmode"] = "manual"
          end

     end
end

-- Encounter Functions --
function RandomEncounterText()
     DEBUG("yeah")
end

activehero     = 0       -- The currently selected hero
previoushero   = {}      -- If we press X, what hero do we go back to?
currentaction  = 1       -- The currently selected action
hero_actions   = {}      -- A more detailed table of hero actions
past_actions   = {}      -- A simple table containing the last-known actions of the heroes, for when they're selected again
linked_actions = {}      -- Has a hero's action "linked" to another's? If so, when their action is reset, reset the others'. (Ex: X-acts)
menucontext    = ""      -- Context for a menu, if required
UI_Positions   = {}      -- Deltarune remembers each hero's position in menus.

-- Remove obsolete things --
BeforeDeath = nil
SetFrameBasedMovement = nil
SetAction = nil
AllowPlayerDef = nil
BattleDialogue = nil
BattleDialog = nil
SetButtonLayer = nil
Inventory = nil
Player = nil

-- MISC --
KROMER_traceback = {}

local tb = Misc.OpenFile("traceback.txt","w")
tb.Write("",false)
tb = nil

-- Fancy DEBUG
-- Specific severity levels, Unity Rich Text, and automatic traceback printing.
function KROMER_LOG(message, severity)
     if severity <= Kromer_DebugLevel then
          local prefix = ""
          if severity == 3 then prefix = "<color=#00ff00><b>[KROMER]</b></color> <i><color=#ffffff>" end
          if severity == 2 then prefix = "<color=#ffff00><b>[KROMER WARN]</b></color> <i><color=#ffffff>" end
          if severity == 1 then prefix = "<color=#ff0000><b>[KROMER FATAL]</b></color> <i><color=#ffffff>" end
          DEBUG(prefix..message.."</color></i>")
          KROMER_traceback[#KROMER_traceback+1] = {math.floor(Time.time-Kromer_StartTime),severity,message}
          KROMER_PrintTraceback(true)
     end
end

-- Simpler than it looks
function KROMER_PrintTraceback(append)
     if not append then KROMER_LOG("Traceback Printed",3) end
     local text = ""
     local a = 1
     if append then a = #KROMER_traceback end
     for i = a, #KROMER_traceback do
          local t = "??????"
          if KROMER_traceback[i][2] == 3 then
               t = "[DEBUG MESSAGE]"
               local line1 = "Time: "..KROMER_traceback[i][1].." s"
               local line2 = "Message Type: "..t
               local line3 = "\""..KROMER_traceback[i][3].."\""
               local topline = string.rep("┈",1+string.len(line1)+1) .. "┳" .. string.rep("┈",1+string.len(line2)+1) .. "┳" .. string.rep("┈",1+string.len(line3)+1)
               local bottomline = string.rep("┈",1+string.len(line1)+1) .. "┻" .. string.rep("┈",1+string.len(line2)+1) .. "┻" .. string.rep("┈",1+string.len(line3)+1)
               text = text .. "╭" .. topline .. "╮" .. "\n┊ " .. line1 .. " ┊ " .. line2 .. " ┊ " .. line3 .. " ┊\n╰" ..bottomline .. "╯\n\n"
          end
          if KROMER_traceback[i][2] == 2 then
               t = "[WARNING]"
               local line1 = "Time: "..KROMER_traceback[i][1].." s"
               local line2 = "Message Type: "..t
               local line3 = "\""..KROMER_traceback[i][3].."\""
               local topline = string.rep("━",1+string.len(line1)+1) .. "┳" .. string.rep("━",1+string.len(line2)+1) .. "┳" .. string.rep("━",1+string.len(line3)+1)
               local bottomline = string.rep("━",1+string.len(line1)+1) .. "┻" .. string.rep("━",1+string.len(line2)+1) .. "┻" .. string.rep("━",1+string.len(line3)+1)
               text = text .. "┏" .. topline .. "┓" .. "\n┃ " .. line1 .. " ┃ " .. line2 .. " ┃ " .. line3 .. " ┃\n┗" ..bottomline .. "┛\n\n"
          end
          if KROMER_traceback[i][2] == 1 then
               t = "[SERIOUS ERROR]"
               local line1 = "Time: "..KROMER_traceback[i][1].." s"
               local line2 = "Message Type: "..t
               local line3 = "\""..KROMER_traceback[i][3].."\""
               local topline = string.rep("═",1+string.len(line1)+1) .. "╦" .. string.rep("═",1+string.len(line2)+1) .. "╦" .. string.rep("═",1+string.len(line3)+1)
               local bottomline = string.rep("═",1+string.len(line1)+1) .. "╩" .. string.rep("═",1+string.len(line2)+1) .. "╩" .. string.rep("═",1+string.len(line3)+1)
               text = text .. string.rep("!",string.len(topline)+2) .. "\n" .. "╔" .. topline .. "╗" .. "\n║ " .. line1 .. " ║ " .. line2 .. " ║ " .. line3 .. " ║\n╚" ..bottomline .. "╝\n" .. string.rep("!",string.len(bottomline)+2) .. "\n\n"
          end
     end
     local tb = Misc.OpenFile("traceback.txt","w")
     tb.Write(text,append)
     tb = nil
end

local __e = error
function error(msg,chunk)
     KROMER_LOG("Threw Error",1)
     __e(msg,chunk)
end

require "Kromer/KrisGoPlayInTheSandboxWithYourBrother"
TextSystem = require "TextSystem"
UI = require "Kromer/UI"
Interp = require "interpolation"
XmlParser = require "XmlParser"
TP = require "Kromer/TP"

-- Utility Code from CYK --

-- Takes a string and returns a table of strings between the characters we were searching for
-- Ex: string.split("test:testy", ":") --> { "test", "testy" }
-- Improved by WD200019
function string.split(inputstr, sep, isPattern)
    if sep == nil then
        sep = "%s"
    end
    local t = { }
    if isPattern then
        while string.find(inputstr, sep) ~= nil do
            local matchrange = { string.find(inputstr, sep) }
            local preceding = string.sub(inputstr, 0, matchrange[1] - 1)
            table.insert(t, preceding ~= "" and preceding or nil)
            inputstr = string.sub(inputstr, matchrange[2] + 1)
        end
        table.insert(t, inputstr)
    else
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
        end
    end
    return t
end

-- Returns the name of the mod
-- Credits to WD for this handy function!
function GetModName()
    local testError = function()
        CreateProjectile("asdbfiosdjfaosdijcfiosdjsdo", 0, 0)
    end

    local _, output = xpcall(testError, debug.traceback)

    -- Find the position of "Sprites/asdbfiosdjfaosdijcfiosdjsdo"
    local SpritesFolderPos = output:find("asdbfiosdjfaosdijcfiosdjsdo") - 10
    output = output:sub(1, SpritesFolderPos)

    local paths = string.split(output, "Attempted to load ", true)
    return paths[#paths]
end

-- Copies a table
function table.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.copy(orig_key)] = table.copy(orig_value)
        end
        setmetatable(copy, table.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- Parses a base 10 number into a base 16 number (unsigned)
function NumberToHex(number)
    number = math.abs(number)
    local startNumber = number
    local hex = ""
    if type(number) == "number" then
        repeat
            local tempHex = number % 16
            number = math.floor(number / 16)
            hex = (tempHex < 10 and tostring(tempHex) or tostring(string.char(string.byte('a') + tempHex - 10))) .. hex
        until number == 0
    else
        error("NumberToHex() needs a number variable.")
    end

    if string.len(hex) == 1 then hex = 0 .. hex end

    return hex
end


-- Other functions

function lerp(a,b,t)
     return a+(b-a)*t
end

function map(a1,a2,b1,b2,s)
    return b1+(s-a1)*(b2-b1)/(a2-a1)
end

KROMER_LOG("Kromer Initialized",3)
