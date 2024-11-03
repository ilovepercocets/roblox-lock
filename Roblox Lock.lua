local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local keybind = nil 

local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local textBox = Instance.new("TextBox")
local button = Instance.new("TextButton")

screenGui.Name = "LockOnGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

frame.Name = "MainFrame"
frame.Size = UDim2.new(0.4, 0, 0.3, 0)
frame.Position = UDim2.new(0.3, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Lock-On Keybind"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextScaled = true
titleLabel.Parent = frame

textBox.Name = "KeybindInput"
textBox.Size = UDim2.new(0.8, 0, 0.2, 0)
textBox.Position = UDim2.new(0.1, 0, 0.25, 0)
textBox.PlaceholderText = "Enter Keybind"
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.BorderSizePixel = 0
textBox.TextScaled = true
textBox.Parent = frame

button.Name = "SetKeybindButton"
button.Size = UDim2.new(0.4, 0, 0.2, 0)
button.Position = UDim2.new(0.3, 0, 0.55, 0)
button.Text = "Set Keybind"
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BorderSizePixel = 0
button.TextScaled = true
button.Parent = frame

local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (mouse.Hit.p - otherPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end

    return closestPlayer
end

local function lockOn()
    local targetPlayer = getClosestPlayer()
    if targetPlayer then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        player.Character.HumanoidRootPart.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position, targetPosition)
    end
end

local function onKeyPress(key)
    if keybind and key == keybind then
        lockOn()
    end
end

button.MouseButton1Click:Connect(function()
    local key = textBox.Text:upper()
    local keyCode = Enum.KeyCode[key]
    if keyCode then
        keybind = keyCode
        textBox.Text = ""
        print("Keybind set to: " .. key)
    else
        print("Invalid keybind")
    end
end)

UserInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed then
        onKeyPress(input.KeyCode)
    end
end)
