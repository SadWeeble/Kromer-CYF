local self = {}

self.ItemDefinitions = {}
self.Inventory       = {Items = {}, ItemCount = 0, Size = 16, NoDelete = false}
self.Weapons         = {Items = {}, ItemCount = 0, Size = 48}
self.Armors          = {Items = {}, ItemCount = 0, Size = 48}
self.Storage         = {Items = {}, ItemCount = 0, Size = 16, NoDelete = false}

--------------- GENERAL ---------------

-- Completely different from CYF. Pay attention!
function self.AddCustomItem(args)
     local _set = function(item,msg,def,lvl)
          if args[item] == nil then
               args[item] = def
               KROMER_LOG(msg,lvl)
          end
     end
     if args.ID == nil then error("Item "..(args.name or "Unknown").." has no ID!",2) end
     _set("name", "Item "..(args.ID).." has no name!","Invalid",1)
     _set("battleDesc", "Item "..(args.ID).." has no battleDesc!","",2)
     _set("overworldDesc", "Item "..(args.ID).." has no overworldDesc!","",2)
     _set("targettype", "Item "..(args.ID).." has no targettype!","Hero",1)
     self.ItemDefinitions[args.ID] = {name = name, battleDesc = battleDesc, overworldDesc = overworldDesc, targettype = targetype}
end

function self.AddItem(name, index)
     if true then -- CONSUMABLE
          if #self.Inventory.Items == self.Inventory.Size then
               if #self.Storage.Items == self.Storage.Size then
                    return false
               else
                    index = math.min(index,#self.Storage.Items) or #self.Storage.Items
                    table.insert(self.Storage.Items,index,name)
                    self.Storage.ItemCount = #self.Storage.Items
                    return true
               end
          else
               index = math.min(index,#self.Inventory.Items) or #self.Inventory.Items
               table.insert(self.Inventory.Items,index,name)
               self.Inventory.ItemCount = #self.Inventory.Items
               return true
          end
     end
end

function self.AddDefaultItems()
     self.AddCustomItem({
          ID = "Dark Candy",
          name = "Dark Candy",
          battleDesc = "Heals\n40 HP",
          overworldDesc = "Heals 40 HP. A red-and-black star that tastes like marshmellows.",
          targettype = "Hero"
     })
end

---------------------------------------

-------------- INVENTORY --------------

function self.Inventory.AddItem(name, index)
     if #self.Inventory.Items == self.Inventory.Size then
          return false
     else
          index = math.min(index,#self.Inventory.Items) or #self.Inventory.Items
          table.insert(self.Inventory.Items,index,name)
          self.Inventory.ItemCount = #self.Inventory.Items
          return true
     end
end

function self.Inventory.RemoveItem(index)
     table.remove(self.Inventory.Items,index)
     self.Inventory.ItemCount = #self.Inventory.Items
end

function self.Inventory.GetItem(index)
     return self.Inventory.Items[index]
end

function self.Inventory.SetItem(index, name)
     self.Inventory.Items[index] = name
end

function self.Inventory.SetInventory(names)
     self.Inventory.Items = names
     self.Inventory.ItemCount = #self.Inventory.Items
end

---------------------------------------

--------------- STORAGE ---------------

function self.Storage.AddItem(name, index)
     if #self.Storage.Items == self.Storage.Size then
          return false
     else
          index = math.min(index,#self.Storage.Items) or #self.Storage.Items
          table.insert(self.Storage.Items,index,name)
          self.Storage.ItemCount = #self.Storage.Items
          return true
     end
end

function self.Storage.RemoveItem(index)
     table.remove(self.Storage.Items,index)
     self.Storage.ItemCount = #self.Storage.Items
end

function self.Storage.GetItem(index)
     return self.Storage.Items[index]
end

function self.Storage.SetItem(index, name)
     self.Storage.Items[index] = name
end

function self.Storage.SetInventory(names)
     self.Storage.Items = names
     self.Storage.ItemCount = #self.Storage.Items
end

---------------------------------------


Inventory = self.Inventory
Storage   = self.Storage

return self
