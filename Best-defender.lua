local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- 1. YOUR ORIGINAL LOGIC & CONFIG
local active = false
local locked = false
local triggerText = "stealing"
local Commands = {";jail ", ";rocket ", ";ragdoll ", ";jumpscare ", ";morph ", ";balloon ", ";inverse ", ";tiny "}

-- 2. MINI UI SETUP (3x Smaller)
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "AidensDefender_MiniUI"
sg.ResetOnSpawn = false
sg.DisplayOrder = 999

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 140, 0, 160)
mainFrame.Position = UDim2.new(1, -150, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.6 
mainFrame.Active = true
Instance.new("UICorner", mainFrame)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(0.65, 0, 0.1, 0)
title.Position = UDim2.new(0.05, 0, 0.02, 0)
title.Text = "AIDEN'S DEFENDER"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

local lockBtn = Instance.new("TextButton", mainFrame)
lockBtn.Size = UDim2.new(0, 40, 0, 15)
lockBtn.Position = UDim2.new(1, -45, 0.02, 0)
lockBtn.Text = "UNLOCK"
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 8
lockBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
lockBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", lockBtn)

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(0.9, 0, 0, 25)
toggleBtn.Position = UDim2.new(0.05, 0, 0.14, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleBtn.Text = "AUTO-DEFENDER: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true
Instance.new("UICorner", toggleBtn)

local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Size = UDim2.new(0.9, 0, 0, 15)
statusLabel.Position = UDim2.new(0.05, 0, 0.32, 0)
statusLabel.Text = "STATUS: IDLE"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.BackgroundTransparency = 1
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham

local listFrame = Instance.new("ScrollingFrame", mainFrame)
listFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
listFrame.Position = UDim2.new(0.05, 0, 0.43, 0)
listFrame.BackgroundTransparency = 1
listFrame.ScrollBarThickness = 1
local layout = Instance.new("UIListLayout", listFrame)
layout.Padding = UDim.new(0, 3)

local resizer = Instance.new("TextButton", mainFrame)
resizer.Name = "Handle"
resizer.Size = UDim2.new(0, 120, 0, 120)
resizer.Position = UDim2.new(1, -120, 1, -120)
resizer.BackgroundTransparency = 1
resizer.Text = ""
resizer.ZIndex = 1001

-- 3. YOUR ORIGINAL FUNCTIONS (UNTOUCHED)
local function findAPTextBox()
    for _, v in pairs(PlayerGui:GetDescendants()) do
        if v:IsA("TextBox") and (v.PlaceholderText:lower():find("command") or v.Name:lower():find("admin")) then
            return v
        end
    end
    return nil
end

local function executeViaPanel(fullCmd)
    local textBox = findAPTextBox()
    if textBox then
        textBox.Text = fullCmd
        for _, connection in pairs(getconnections(textBox.FocusLost)) do
            connection:Fire(true)
        end
    end
end

local function runAttack(targetName)
    statusLabel.Text = "DEFENDING: " .. targetName
    statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    for _, cmd in ipairs(Commands) do
        executeViaPanel(cmd .. targetName)
        task.wait(0.03)
    end
    statusLabel.Text = active and "STATUS: SCANNING..." or "STATUS: IDLE"
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
end

local function attackAllEnemies()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            task.spawn(function() runAttack(p.Name) end)
        end
    end
end

-- 4. PLAYER LIST WITH PROFILES
local function updateList()
    for _, c in pairs(listFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local b = Instance.new("TextButton", listFrame)
            b.Size = UDim2.new(1, -2, 0, 20)
            b.BackgroundTransparency = 0.8
            b.BackgroundColor3 = Color3.new(1,1,1)
            b.Text = ""
            Instance.new("UICorner", b)

            local pfp = Instance.new("ImageLabel", b)
            pfp.Size = UDim2.new(0, 16, 0, 16)
            pfp.Position = UDim2.new(0, 2, 0.5, -8)
            pfp.BackgroundTransparency = 1
            pfp.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            Instance.new("UICorner", pfp).CornerRadius = UDim.new(1, 0)

            local nl = Instance.new("TextLabel", b)
            nl.Size = UDim2.new(1, -22, 1, 0)
            nl.Position = UDim2.new(0, 22, 0, 0)
            nl.Text = p.Name
            nl.TextColor3 = Color3.new(1, 1, 1)
            nl.Font = Enum.Font.Gotham
            nl.TextScaled = true
            nl.TextXAlignment = Enum.TextXAlignment.Left
            nl.BackgroundTransparency = 1

            b.MouseButton1Click:Connect(function() task.spawn(function() runAttack(p.Name) end) end)
        end
    end
end

-- 5. YOUR ORIGINAL TOGGLE & MONITORING (UNTOUCHED)
toggleBtn.MouseButton1Click:Connect(function()
    active = not active
    toggleBtn.Text = active and "AUTO-DEFENDER: ON" or "AUTO-DEFENDER: OFF"
    toggleBtn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

local function checkText(obj)
    if (obj:IsA("TextLabel") or obj:IsA("TextBox")) then
        if active and obj.Text:lower():find(triggerText) then
            attackAllEnemies()
        end
        obj:GetPropertyChangedSignal("Text"):Connect(function()
            if active and obj.Text:lower():find(triggerText) then
                attackAllEnemies()
            end
        end)
    end
end

-- 6. DRAG & RESIZE ENGINE
local dragging, resizing, dragStart, startPos, startSize
resizer.MouseButton1Down:Connect(function()
    if not locked then
        resizing = true
        dragStart = UserInputService:GetMouseLocation()
        startSize = mainFrame.Size
    end
end)
mainFrame.InputBegan:Connect(function(input)
    if not locked and not resizing and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not locked then
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        elseif resizing then
            local mousePos = UserInputService:GetMouseLocation()
            local delta = mousePos - dragStart
            mainFrame.Size = UDim2.new(0, math.max(120, startSize.X.Offset + delta.X), 0, math.max(100, startSize.Y.Offset + delta.Y))
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, resizing = false, false
    end
end)
lockBtn.MouseButton1Click:Connect(function()
    locked = not locked
    lockBtn.Text = locked and "LOCK" or "UNLOCK"
    resizer.Visible = not locked
end)

for _, d in pairs(PlayerGui:GetDescendants()) do checkText(d) end
PlayerGui.DescendantAdded:Connect(checkText)
Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)
updateList()
