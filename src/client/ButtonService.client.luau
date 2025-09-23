local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ScreenGUI = Player.PlayerGui:WaitForChild("ScreenGui")
local InventoryButton = ScreenGUI.InventoryButton
local InventoryFrame = ScreenGUI.InventoryFrame
local Open = false

InventoryButton.Activated:Connect(function()
    if Open then
        Open = false
    else
        Open = true
    end
    InventoryFrame.Visible = Open        
end)    