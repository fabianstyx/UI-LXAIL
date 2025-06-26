-- ZygardeUILib.lua
local ZygardeUILib = {}

-- Utilidades internas
local function roundify(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

local function outline(instance, color)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 2
    stroke.Parent = instance
end

local function createGlass()
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 20
    blurEffect.Parent = game:GetService("Lighting") -- Esto aplica el efecto global de Glass
end

local function getAvatarImg(userId)
    return ("https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=100&height=100&format=png")
end

local function getSaved(key, default)
    if writefile then
        local success, result = pcall(readfile, key)
        if success then
            return result
        end
    end
    return default
end

local function setSaved(key, value)
    if writefile then
        pcall(writefile, key, value)
    end
end

-- Crea la ventana principal
function ZygardeUILib.CreateWindow(options)
    local gui = Instance.new("ScreenGui")
    gui.Name = "ZygardeUI"
    gui.Parent = (gethui and gethui()) or game.CoreGui

    local window = Instance.new("Frame")
    window.Size = options.Size or UDim2.new(0, 620, 0, 540)
    window.Position = UDim2.new(0.5, -310, 0.5, -270)
    window.AnchorPoint = Vector2.new(0.5, 0.5)
    window.BackgroundColor3 = Color3.fromRGB(155, 255, 110) -- GlassLime
    window.BackgroundTransparency = 0.5
    roundify(window, 24)
    outline(window, Color3.fromRGB(85, 175, 86)) -- GlassLimeDark
    window.Parent = gui

    createGlass() -- Efecto de blur global

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(200, 255, 180) -- GlassLimeLight
    titleBar.BackgroundTransparency = 0.5
    roundify(titleBar, 16)
    outline(titleBar, Color3.fromRGB(85, 175, 86)) -- GlassLimeDark
    titleBar.Parent = window

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.Text = options.Title or "Zygarde UI"
    titleLabel.Font = Enum.Font.Cartoon
    titleLabel.TextSize = 28
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.TextStrokeTransparency = 0
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Botones de minimizar y cerrar
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0.5, -15)
    closeButton.Text = "❌"
    closeButton.Font = Enum.Font.Cartoon
    closeButton.TextSize = 24
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 255, 180) -- GlassLimeLight
    closeButton.BackgroundTransparency = 0.5
    roundify(closeButton, 16)
    outline(closeButton, Color3.fromRGB(85, 175, 86)) -- GlassLimeDark
    closeButton.Parent = titleBar

    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    return {
        CreateTab = function(tabName)
            local tabButton = Instance.new("TextButton")
            tabButton.Size = UDim2.new(1, -20, 0, 40)
            tabButton.Position = UDim2.new(0, 10, 0, 60)
            tabButton.Text = tabName or "Tab"
            tabButton.Font = Enum.Font.Cartoon
            tabButton.TextSize = 24
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabButton.BackgroundColor3 = Color3.fromRGB(155, 255, 110) -- GlassLime
            tabButton.BackgroundTransparency = 0.5
            roundify(tabButton, 16)
            outline(tabButton, Color3.fromRGB(85, 175, 86)) -- GlassLimeDark
            tabButton.Parent = window

            return tabButton
        end,
    }
end

return ZygardeUILib
