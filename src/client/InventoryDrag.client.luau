local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local DraggerService = game:GetService("DraggerService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local ScrollingFrame = Player.PlayerGui:WaitForChild("ScreenGui").InventoryFrame.ScrollingFrame
local insetOffset = game:GetService("GuiService"):GetGuiInset().Y
local Remotes = ReplicatedStorage.Remotes
local SlotChanged = Remotes.SlotChanged

local Selected = nil
local lastSlot = nil
local DragCon = nil
local selectedSlot = nil

function getNearestSlot()
    local mousePos = UIS:GetMouseLocation()
    local nearestPos 
    local nearestSlot
    for _, slot in pairs(ScrollingFrame:GetChildren()) do
        if not slot:IsA("ImageButton") then continue end
        local slotPos = Vector2.new(slot.AbsolutePosition.X + slot.AbsoluteSize.X/2, slot.AbsolutePosition.Y + slot.AbsoluteSize.Y/2 + insetOffset)
        local Distance = (mousePos - slotPos).Magnitude
        warn(insetOffset)
        print(slot.Name, Distance, slotPos)
        print(slot.AbsolutePosition)
        print(mousePos)
        if not nearestPos then
            nearestPos = Distance
            nearestSlot = slot
            continue
        end    
        if Distance < nearestPos then
            nearestPos = Distance
            nearestSlot = slot
        end    
    end
    return nearestSlot
end    

function DragUpdate(itemUI, offset)
    local mousePos = UIS:GetMouseLocation()
    local newPos = UIS:GetMouseLocation() - offset
    itemUI.Position = UDim2.new(0, mousePos.X - itemUI.Size.X.Offset/2,0, mousePos.Y - itemUI.Size.Y.Offset/2)
    local nearestSlot = getNearestSlot()
    if not nearestSlot then return end
    selectedSlot = nearestSlot
    print(nearestSlot)
end    

UIS.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not Selected then return end
    lastSlot = Selected.Parent
    local Dragging = Selected
    Dragging.Size = UDim2.new(0,100,0,100)
    
    local Offset = UIS:GetMouseLocation() - Dragging.AbsolutePosition

    Selected.Parent = ScrollingFrame.Parent.Parent
    DragUpdate(Dragging, Offset)
    DragCon = Mouse.Move:Connect(function()
        DragUpdate(Dragging, Offset)
    end)   
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not DragCon then return end   
    DragCon:Disconnect()
    Selected.Parent = selectedSlot
    Selected.Position = UDim2.new(0,0,0,0)
    Selected.Size = UDim2.new(1,0,1,0)

    if lastSlot ~= selectedSlot then 
        SlotChanged:FireServer(Selected:GetAttribute("ID"), tonumber(selectedSlot.Name))
    end
end)

function InitListeners(UI: GuiButton)
    print("Initated listerns")
    UI.MouseEnter:Connect(function()
        Selected = UI
        print(Selected)
    end)
    
    UI.MouseLeave:Connect(function()
        Selected = nil
        print(Selected)
    end)
end

for _, UI in pairs(CollectionService:GetTagged("ItemUI")) do
    InitListeners(UI)
end    

CollectionService:GetInstanceAddedSignal("ItemUI"):Connect(function(UI)
    InitListeners(UI)
end)    