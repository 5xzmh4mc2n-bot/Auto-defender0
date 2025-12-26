-- MAIN UI SETUP
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Cleanup old UI if it exists
if CoreGui:FindFirstChild("AidenDefenderUI") then
    CoreGui.AidenDefenderUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "AidenDefenderUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 180, 0, 260) 
MainFrame.Position = UDim2.new(0.5, -90, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "AIDEN'S AUTO\nDEFENDER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 30)
ToggleBtn.Position = UDim2.new(0.075, 0, 0, 70)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
ToggleBtn.Text = "AUTO: OFF"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

-- THE PLAYER LIST (Buttons)
local PlayerList = Instance.new("ScrollingFrame", MainFrame)
PlayerList.Size = UDim2.new(0.9, 0, 0, 100)
PlayerList.Position = UDim2.new(0.05, 0, 0, 110)
PlayerList.BackgroundTransparency = 1
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0) 
PlayerList.ScrollBarThickness = 2
local UIListLayout = Instance.new("UIListLayout", PlayerList)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 1, -40)
StatusLabel.Text = "READY"
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.BackgroundTransparency = 1

-- COMMAND LOGIC
local isEnabled = false

local function runCommands(targetName)
    if not isEnabled then return end
    
    local ChatService = game:GetService("TextChatService")
    if ChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = ChatService.TextChannels.RBXGeneral
        channel:SendAsync(";block " .. targetName)
    else
        local sayMessage = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(";block " .. targetName, "All")
        end
    end
    
    StatusLabel.Text = "DEFENDING VS: " .. targetName
end

-- Update Player List
local function updateList()
    for _, child in pairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local pBtn = Instance.new("TextButton", PlayerList)
            pBtn.Size = UDim2.new(1, 0, 0, 25)
            pBtn.Text = player.Name
            pBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            pBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            pBtn.BorderSizePixel = 0
            pBtn.Font = Enum.Font.Gotham
            pBtn.TextSize = 14
            
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)

            pBtn.MouseButton1Click:Connect(function()
                runCommands(player.Name)
            end)
        end
    end
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)
updateList()

-- Toggle Logic
ToggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    ToggleBtn.Text = isEnabled and "AUTO: ON" or "AUTO: OFF"
    ToggleBtn.BackgroundColor3 = isEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(180, 0, 0)
    StatusLabel.Text = isEnabled and "SELECT TARGET" or "READY"
end)
