local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventoryService = require(script.Parent.InventoryService)
local Remotes = ReplicatedStorage.Remotes
local PickUpItem = Remotes.PickUpItem
local UseItem = Remotes.UseItem
local SlotChanged = Remotes.SlotChanged

local Debounce = {}

PickUpItem.OnServerEvent:Connect(function(player: Player, object, slot)
    if Debounce[player.UserId] then return end
    Debounce[player.UserId] = true
    if not object then return end
    print(object)
    InventoryService.AddItem(player, object, slot)
    object:Destroy()
    Debounce[player.UserId] = nil
end)

UseItem.OnServerEvent:Connect(function(player: Player, ID: string)
    InventoryService.UseItem(player, ID)
end)

SlotChanged.OnServerEvent:Connect(function(player: Player, ID: string, slot: number)
    InventoryService.SlotChanged(player, ID, slot)
end)