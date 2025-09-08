local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local SlotTemplate = ReplicatedStorage.SlotTemplate
local ItemTemplate = ReplicatedStorage.ItemTemplate

local Player = Players.LocalPlayer
local ScrollingFrame = Player.PlayerGui:WaitForChild("ScreenGui").InventoryFrame.ScrollingFrame
local MAX_SLOTS = ReplicatedStorage.Slots.Value

local InventoryService = {}

function CreateSlot(index: number)
    local Slot = SlotTemplate:Clone()
    Slot.Parent = ScrollingFrame
    Slot.Name = "Slot"..index
    Slot.LayoutOrder = index
    Slot:AddTag("Empty")
end

function InventoryService.LoadSlots()
    for i = 1, MAX_SLOTS do
        CreateSlot(i)
    end    
end    

function getEmptySlot()
	for i = 1, MAX_SLOTS do
		local Slot = ScrollingFrame:FindFirstChild("Slot"..i)
        local isEmpty = Slot:HasTag("Empty")
        if isEmpty then
            return Slot
        end    
    end
    return false
end

function InventoryService.AddItem(name: string, amount: number)
    local EmptySlot = getEmptySlot()
    if not EmptySlot then return end
    EmptySlot:RemoveTag("Empty")

    local Item = ItemTemplate:Clone()
    Item.Parent = EmptySlot
    Item.Name = name
    Item.Text = name
    Item:SetAttribute("Amount", amount)
    Item:AddTag("Used")

end

return InventoryService