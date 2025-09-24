local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MAX_SLOTS = ReplicatedStorage.Slots.Value

function CreateInventoryData(data)
    if data.Inventory then return end
    data.Inventory = {}
    for i = 1, MAX_SLOTS do
        data.Inventory[i] = false
    end    
end

return CreateInventoryData