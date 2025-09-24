local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local InventoryService = require(script.Parent.InventoryService)
local Remotes = ReplicatedStorage.Remotes
local PickUpItem = Remotes.PickUpItem
local UseItem = Remotes.UseItem
local SlotChanged = Remotes.SlotChanged

local Debounce = {}

function AddID(object)
    local uniqueId = HttpService:GenerateGUID(false)
    object:SetAttribute("ID", uniqueId)
end

CollectionService:GetInstanceAddedSignal("PickUp"):Connect(function(instance)
    AddID(instance)
end)

for i,v in pairs(CollectionService:GetTagged("PickUp")) do
    AddID(v)
end

PickUpItem.OnServerEvent:Connect(function(player: Player, object, slot)
    if Debounce[player.UserId] then return end
    Debounce[player.UserId] = true
    if not object then return end
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