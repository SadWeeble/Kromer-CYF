if not isCYF or (CYFversion < "0.6.5" or CYFversion == "1.0") then
     error("<size=20>You need to be playing on <color=#ffff00><i>Create Your Frisk Version 0.6.5</i></color> or greater to use Kromer.</size>",-1)
end

if windows then Misc.WindowName = "KROMER" end

PACKAGE_ID = PACKAGE_ID or "NONE"

Kromer_StartTime = Time.time
Kromer_Version = "1.0.0"
Kromer_DebugLevel = Kromer_DebugLevel or 0
-- How much [debug] do you want in your kromer?
-- 0 for NONE
-- 1 for IMPORTANT WARNINGS
-- 2 for ALL WARNINGS
-- 3 for ALL DEBUG MESSAGES

CreateLayer("Background", "Top", true)
CreateLayer("Entity", "Background")
CreateLayer("LowerUI", "Entity")
CreateLayer("UpperUI", "LowerUI")
CreateLayer("Arena", "UpperUI")
CreateLayer("Bullet", "Arena")

-- States --
Kromer_State = "NONE"
Kromer_States = {
     "INTRO",
     "ACTIONSELECT",
     "ENEMYSELECT",
     "ALLYSELECT",
     "ENTITYSELECT",
     "MAGICMENU",
     "ITEMMENU",
     "ATTACKING",
     "DIALOGUE",
     "WAVE",
     "GAMEOVER",
     "OUTRO",
     "NONE"
     }
-- The default states of Kromer. Custom states can be added for
-- whatever reason.

function GetCurrentState()
     return Kromer_State
end

-- DO NOT CONFUSE THIS FOR EnteringState!!
function Kromer_EnteringState(newstate, oldstate)
end

-- Encounter Functions --
function RandomEncounterText()
     DEBUG("yeah")
end

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

--unescape = true

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
               text = text .. ">>>>>╔" .. topline .. "╗" .. "<<<<<\n>>>>>║ " .. line1 .. " ║ " .. line2 .. " ║ " .. line3 .. " ║<<<<<\n>>>>>╚" ..bottomline .. "╝<<<<<\n\n"
          end
     end
     local tb = Misc.OpenFile("traceback.txt","w")
     tb.Write(text,append)
end

local __e = error
function error(msg,chunk)
     KROMER_LOG("Threw Error",1)
     __e(msg,chunk)
end

require "Kromer/KrisGoPlayInTheSandboxWithYourBrother"
UI = require "Kromer/UI"

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

KROMER_LOG("Kromer Initialized",3)
