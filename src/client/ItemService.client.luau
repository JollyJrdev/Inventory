local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventoryService = require(script.Parent.InventoryService)
local Remotes = ReplicatedStorage.Remotes
local PickUpItem = Remotes.PickUpItem

function CreatePrompt(object: Model)
    local Prompt = Instance.new("ProximityPrompt", object)
    Prompt.Name = "PickUpPrompt"
    Prompt.ActionText = "PickUp"
    return Prompt
end    

function onPickUp(object)
    local isSpace, index = InventoryService.AddItem(object.Name, object:GetAttribute("ID"), 1)
    if not isSpace then print("Not enough Space") return end
    PickUpItem:FireServer(object, index)
end

function InitItem(object)
    local Prompt = CreatePrompt(object)
    Prompt.Triggered:Connect(function()
        onPickUp(object)
    end)
end   

wait()
for _, object in pairs(CollectionService:GetTagged("PickUp")) do
    print("get tagged", object)
    InitItem(object)
end    

CollectionService:GetInstanceAddedSignal("PickUp"):Connect(function(object)
    InitItem(object)
end)    