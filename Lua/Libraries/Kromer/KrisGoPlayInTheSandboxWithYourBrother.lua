-- Create a basic environment so that user-made variables can't interfere with one another.
-- Depending on their intended usage, environments may get special variables from this function
function CreateBlankEnvironment(envtype)
     local t = {
          _VERSION = _G._VERSION,
          _MOONSHARP = _G.MOONSHARP,
          ipairs = _G.ipairs,
          pairs = _G.pairs,
          next = _G.next,
          type = _G.type,
          assert = _G.assert,
          collectgarbage = _G.collectgarbage,
          error = _G.error,
          tostring = _G.tostring,
          select = _G.select,
          tonumber = _G.tonumber,
          print = _G.print,
          setmetatable = _G.setmetatable,
          getmetatable = _G.getmetatable,
          rawget = _G.rawget,
          rawset = _G.rawset,
          rawequal = _G.rawequal,
          rawlen = _G.rawlen,
          string = _G.string,
          package = _G.package,
          load = _G.load,
          loadsafe = _G.loadsafe,
          loadfile = _G.loadfile,
          loadfilesafe = _G.loadfilesafe,
          dofile = _G.dofile,
          __require_clr_impl = _G.__require_clr_impl,
          require = _G.require,
          table = _G.table,
          unpack = _G.unpack,
          pack = _G.pack,
          pcall = _G.pcall,
          xpcall = _G.xpcall,
          math = _G.math,
          coroutine = _G.coroutine,
          bit32 = _G.bit32,
          dynamic = _G.dynamic,
          os = _G.os,
          debug = _G.debug,
          json = _G.json,
          SetGlobal = _G.SetGlobal,
          GetGlobal = _G.GetGlobal,
          SetRealGlobal = _G.SetRealGlobal,
          GetRealGlobal = _G.GetRealGlobal,
          SetAlMightyGlobal = _G.SetAlMightyGlobal,
          GetAlMightyGlobal = _G.GetAlMightyGlobal,
          isCYK = _G.isCYF,
          safe = _G.safe,
          windows = _G.windows,
          CYFversion = _G.CYFversion,
          CreateSprite = _G.CreateSprite,
          CreateLayer = _G.CreateLayer,
          --CreateProjectileLayer = _G.CreateProjectileLayer,
          SetPPCollision = _G.SetPPCollision,
          CreateText = _G.CreateText,
          GetCurrentState = _G.GetCurrentState,
          DEBUG = _G.DEBUG,
          EnableDebugger = _G.EnableDebugger,
          Audio = _G.Audio,
          NewAudio = _G.NewAudio,
          Input = _G.Input,
          Misc = _G.Misc,
          Time = _G.Time,
          Discord = _G.Discord,
          _getv = _G._getv,
          ModName = _G.ModName,
          Kromer_StartTime = _G.Kromer_StartTime,
          Kromer_Version = _G.Kromer_Version,
          Kromer_DebugLevel = _G.Kromer_DebugLevel,
          Kromer_LoadFile = _G.Kromer_LoadFile,
          Kromer_FindSprite = _G.Kromer_FindSprite,
          KROMER_LOG = _G.KROMER_LOG,
          --Kromer_State = _G.Kromer_State,
          GetModName = _G.GetModName,
          State = _G.State,
     }

     if envtype == "m" then -- Monster Entity
          t.commands = {}
          t.AddAct = function(name, desc, tp, pmr, pma)
               t.commands[#t.commands+1] = {name, desc, tp, pmr, pma}
          end
     end

     return t
end



-- A modified loadfile() that searches in...
-- 1) The associated package
-- 2) The actual folders
function Kromer_LoadFile(path,mode,environment)
     if Misc.FileExists(path) then
          return loadfile(ModName.."/"..path, mode, environment)
     elseif Misc.FileExists("Packages/"..PACKAGE_ID.."/"..path) then
          return loadfile(ModName.."Packages/"..PACKAGE_ID.."/"..path, mode, environment)
     else
          error("MISSING FILE!\nThese are the following places where Kromer searched:\n\n<color=#aaaaff>"..ModName.."/"..path.."\n\n"..ModName.."/Packages/"..PACKAGE_ID.."/"..path.."</color>", 0)
     end
end

-- Finds the given sprite in the usual places
function Kromer_FindSprite(path)
     local default_path = path
     local default_path_test = function()
          local p = CreateProjectile(default_path, 0, 0)
          p.Remove()
     end
     local package_path = "../Packages/"..PACKAGE_ID.."/"..path
     local package_path_test = function()
          local p = CreateProjectile(package_path, 0, 0)
          p.Remove()
     end

     local default_path_test = xpcall(default_path_test, debug.traceback)
     local package_path_test = xpcall(package_path_test, debug.traceback)

     --DEBUG(default_path.." . . . "..tostring(default_path_test))
     --DEBUG(package_path.." . . . "..tostring(package_path_test))
     if package_path_test then return package_path end
     if default_path_test then return default_path end
     return "missing_sprite_error"
end

-- Find the enemy "enemyname" and add it to the enemy list, or the given environment.
function AddEnemy(enemyname, environment)
     KROMER_LOG("Added Enemy \""..enemyname..".lua\"",3)

     if environment == nil then
          environment = {}
          enemies[#enemies+1] = CreateBlankEnvironment("m")
          enemies[#enemies]()
     else
          environment = CreateBlankEnvironment("m")
     end

     environment.__ID = enemyname
     local enemyfile = Kromer_LoadFile("Lua/Monsters/"..enemyname..".lua","t",environment)
     enemyfile()
     local enemyfile = Kromer_LoadFile("Lua/Libraries/Kromer/EnemyTemp.lua","t",environment)
     enemyfile()
     local enemyfile = Kromer_LoadFile("Lua/Libraries/Kromer/EntityTemp.lua","t",environment)
     enemyfile()
end

-- Find the hero "heroname" and add it to the hero list, or the given environment.
function AddHero(heroname,environment)
     KROMER_LOG("Added Hero \""..heroname..".lua\"",3)

     if environment == nil then
          environment = {}
          heroes[#heroes+1] = CreateBlankEnvironment("h")
          heroes[#heroes]()
     else
          environment = CreateBlankEnvironment("h")
     end

     environment.__ID = heroname
     local herofile = Kromer_LoadFile("Lua/Heroes/"..heroname..".lua","t",environment)
     herofile()
     local herofile = Kromer_LoadFile("Lua/Libraries/Kromer/HeroTemp.lua","t",environment)
     herofile()
     local herofile = Kromer_LoadFile("Lua/Libraries/Kromer/EntityTemp.lua","t",environment)
     herofile()
end

KROMER_LOG("Sandboxing Functions Created",3)
