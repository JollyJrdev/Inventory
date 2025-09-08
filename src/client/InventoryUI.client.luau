local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local InteractFrame = Player.PlayerGui:WaitForChild("ScreenGui").InventoryFrame.InteractFrame
local UseButton = InteractFrame.UseButton
local CurrentSelected = nil

function onInteract(Item: GuiButton)
    print("Bang", InteractFrame)
    CurrentSelected = Item
    InteractFrame.Visible = true
    InteractFrame.Position = UDim2.new(0, Mouse.X - InteractFrame.Parent.AbsolutePosition.X, 0, Mouse.Y - InteractFrame.Parent.AbsolutePosition.Y)
end 

UseButton.Activated:Connect(function()

end    

for _,Button: GuiButton in pairs(CollectionService:GetTagged("Used")) do
    print(Button)
	Button.Activated:Connect(function()
		onInteract(Button)
	end)
end

CollectionService:GetInstanceAddedSignal("Used"):Connect(function(instance)
    print(instance)
	instance.Activated:Connect(function()
		onInteract(instance)
	end)
end)