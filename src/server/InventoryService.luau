local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Manager = require(script.Parent.Manager)

local InventoryService = {}

function InventoryService.AddItem(player: Player, item, slot: number)
    local Profile = Manager.GetProfile(player)
    if not Profile then return end
    print(Profile.Data)
    local emptySlots = Profile.Data.MaxSlots - Profile.Data.UsedSlots
    if emptySlots <= 0 then print(player, "Has no empty space") return end
    local itemInfo = {}
    itemInfo.Name = item.Name
    itemInfo.ID = item:GetAttribute("ID")
    itemInfo.Slot = slot
    table.insert(Profile.Data.Inventory, itemInfo)

    Profile.Data.UsedSlots += 1
    print(Profile.Data)
end

function InventoryService.RemoveItem(player, index)
    local Profile = Manager.GetProfile(player)
    if not Profile then return end

    Profile.Data.Inventory[index] = nil
    Profile.Data.UsedSlots -= 1
end

function InventoryService.UseItem(player: Player, ID: string)
    local Profile = Manager.GetProfile(player)
    if not Profile then return end

    for index, item in pairs(Profile.Data.Inventory) do
        print(index, item)
        if item.ID == ID then
            --Do something
            InventoryService.RemoveItem(player, index)
            return
        end   
    end    
    print("Couldnt find item:", ID)
end    

function InventoryService.SlotChanged(player: Player, ID: string, slot: number)
   local Profile = Manager.GetProfile(player)
   if not Profile then return end

   for _, item in pairs(Profile.Data.Inventory) do
        if item.ID ~= ID then continue end
        item.Slot = slot
   end
end    

return InventoryService