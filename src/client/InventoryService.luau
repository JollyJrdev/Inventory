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
    Slot.Name = index
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
		local Slot = ScrollingFrame:FindFirstChild(i)
        local isEmpty = Slot:HasTag("Empty")
        if isEmpty then
            return Slot, i
        end    
    end
    return false
end

function InventoryService.AddSlots(amount: number)
    MAX_SLOTS += amount
    for i = 1, amount do
        CreateSlot(MAX_SLOTS + i)
    end    
end   

function InventoryService.RemoveItem(item)
    local Slot = item.Parent
    if not Slot then return end
    Slot:AddTag("Empty")
    item:Destroy()
end    

function CreateUI(emptySlot, itemName, ID, amount)
    local Item = ItemTemplate:Clone()
    Item.Parent = emptySlot
    Item.Name = itemName
    Item.Text = itemName
    Item:SetAttribute("ID", ID)
    Item:SetAttribute("Amount", amount)
    Item:AddTag("Used")
    Item:AddTag("ItemUI")
end  

function InventoryService.AddItem(itemName, ID , amount: number, slot)
    local EmptySlot, index = nil
    
    if slot then
        EmptySlot = ScrollingFrame:FindFirstChild(slot)
        index = slot
    else
        EmptySlot, index = getEmptySlot()
    end
    if not EmptySlot then return false end
    EmptySlot:RemoveTag("Empty")

    CreateUI(EmptySlot, itemName, ID, amount)
    return true, index
end  

return InventoryService