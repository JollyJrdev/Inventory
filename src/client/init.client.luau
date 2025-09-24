local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventoryService = require(script.InventoryService)
local ItemsTable = require(script.ItemsTable)
local Remotes = ReplicatedStorage.Remotes
local SendData = Remotes.SendData

InventoryService.LoadSlots()


SendData.OnClientEvent:Connect(function(data)
    for _, itemInfo in pairs(data.Inventory) do
        local Info = ItemsTable[itemInfo.Name]
        if not Info then continue end
        InventoryService.AddItem(itemInfo.Name, itemInfo.ID, 1, itemInfo.Slot)
    end    
end)  