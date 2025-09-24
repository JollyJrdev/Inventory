local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local InventoryService = require(script.Parent.InventoryService)
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local InteractFrame = Player.PlayerGui:WaitForChild("ScreenGui").InventoryFrame.InteractFrame
local UseButton = InteractFrame.UseButton
local CurrentSelected = nil
local UseItem = ReplicatedStorage.Remotes.UseItem

local Selected = nil

function onInteract(Item: GuiButton)
    CurrentSelected = Item
    InteractFrame.Visible = true
    InteractFrame.Position = UDim2.new(0, Mouse.X - InteractFrame.Parent.AbsolutePosition.X, 0, Mouse.Y - InteractFrame.Parent.AbsolutePosition.Y)
end 

UseButton.Activated:Connect(function()
    if not CurrentSelected then return end
    InventoryService.RemoveItem(CurrentSelected)
    UseItem:FireServer(CurrentSelected:GetAttribute("ID"))
    CurrentSelected = nil
end)

function InitListeners(UI: GuiButton)
    UI.MouseEnter:Connect(function()
        Selected = UI
        print(Selected)
    end)
    
    UI.MouseLeave:Connect(function()
        Selected = nil
        print(Selected)
    end)
end

for _,Button: GuiButton in pairs(CollectionService:GetTagged("Used")) do
    print(Button)
    InitListeners(Button)
end

local startPos
UIS.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    startPos = UIS:GetMouseLocation()
end)    


UIS.InputEnded:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not Selected then 
        InteractFrame.Visible = false
        return
    end
    local currentPos = UIS:GetMouseLocation()
    if (currentPos - startPos).Magnitude > 5 then return end
    onInteract(Selected)
end)    

CollectionService:GetInstanceAddedSignal("Used"):Connect(function(instance)
    InitListeners(instance)
end)