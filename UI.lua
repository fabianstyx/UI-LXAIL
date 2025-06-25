--[[
    LXAIL- BETA (Rayfield API, Zygarde UI Style)
    github.com/SiriusSoftwareLtd/Rayfield adaptado - por fabianstyx
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Colores Zygarde/LXAIL
local PurpleMain = Color3.fromRGB(160, 30, 255)
local PurpleAccent = Color3.fromRGB(220, 40, 255)
local PurpleLight = Color3.fromRGB(250, 190, 255)
local PurpleDark = Color3.fromRGB(80, 0, 120)
local BlackGlass = Color3.fromRGB(5, 0, 10)
local BlackTab = Color3.fromRGB(18, 5, 30)
local Shadow = Color3.fromRGB(0,0,0)
local White = Color3.fromRGB(255,255,255)
local GreyNum = Color3.fromRGB(60,60,90)
local CartoonFont = Enum.Font.Cartoon

local defaultW, defaultH = 500, 400

local LXUILibrary = {}
LXUILibrary.__index = LXUILibrary

-- === COMPONENTS ===
local function CreateToggle(parent, label, default, callback)
    local holder = Instance.new("Frame", parent)
    holder.Size = UDim2.new(1,-32,0,44)
    holder.BackgroundTransparency = 1

    local txt = Instance.new("TextLabel", holder)
    txt.Text = label
    txt.Font = Enum.Font.GothamMedium
    txt.TextColor3 = PurpleMain
    txt.TextSize = 18
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0,0,0,0)
    txt.Size = UDim2.new(0.55,0,1,0)
    txt.TextXAlignment = Enum.TextXAlignment.Left

    local toggle = Instance.new("TextButton", holder)
    toggle.Size = UDim2.new(0,56,0,28)
    toggle.Position = UDim2.new(1,-60,0.5,-14)
    toggle.BackgroundTransparency = 0.18
    toggle.BackgroundColor3 = default and PurpleMain or PurpleLight
    toggle.Text = ""
    local round = Instance.new("UICorner", toggle)
    round.CornerRadius = UDim.new(1,0)
    toggle.AutoButtonColor = false

    local circle = Instance.new("Frame", toggle)
    circle.Size = UDim2.new(0,24,0,24)
    circle.Position = UDim2.new(default and 1 or 0, default and -26 or 2,0.5,-12)
    circle.BackgroundColor3 = White
    circle.BackgroundTransparency = default and 0.03 or 0.18
    circle.BorderSizePixel = 0
    local circCorner = Instance.new("UICorner", circle)
    circCorner.CornerRadius = UDim.new(1,0)
    local circStroke = Instance.new("UIStroke", circle)
    circStroke.Color = PurpleAccent
    circStroke.Thickness = 1.2

    local state = default
    local function update()
        if state then
            TweenService:Create(toggle, TweenInfo.new(0.13, Enum.EasingStyle.Quad), {BackgroundColor3 = PurpleMain}):Play()
            TweenService:Create(circle, TweenInfo.new(0.13, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1,-26,0.5,-12),
                BackgroundTransparency = 0.03
            }):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.13, Enum.EasingStyle.Quad), {BackgroundColor3 = PurpleLight}):Play()
            TweenService:Create(circle, TweenInfo.new(0.13, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0,2,0.5,-12),
                BackgroundTransparency = 0.18
            }):Play()
        end
    end
    toggle.MouseButton1Click:Connect(function()
        state = not state
        update()
        if callback then callback(state) end
    end)
    update()
    return holder
end

local function CreateSlider(parent, label, min, max, default, callback)
    local holder = Instance.new("Frame", parent)
    holder.Size = UDim2.new(1,-32,0,58)
    holder.BackgroundTransparency = 1

    local txt = Instance.new("TextLabel", holder)
    txt.Text = label
    txt.Font = Enum.Font.GothamMedium
    txt.TextColor3 = PurpleMain
    txt.TextSize = 17
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0,0,0,2)
    txt.Size = UDim2.new(0.5,0,0.45,0)
    txt.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBar = Instance.new("Frame", holder)
    sliderBar.Size = UDim2.new(0.63,0,0,8)
    sliderBar.Position = UDim2.new(0,0,1,-20)
    sliderBar.BackgroundColor3 = PurpleAccent
    sliderBar.BackgroundTransparency = 0.16
    sliderBar.BorderSizePixel = 0
    local sliderCorner = Instance.new("UICorner", sliderBar)
    sliderCorner.CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame", sliderBar)
    fill.BackgroundColor3 = PurpleMain
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BorderSizePixel = 0
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(1,0)

    local numBox = Instance.new("TextBox", holder)
    numBox.Position = UDim2.new(0.7,0,1,-32)
    numBox.Size = UDim2.new(0,60,0,28)
    numBox.Text = tostring(default)
    numBox.Font = Enum.Font.Code
    numBox.TextSize = 17
    numBox.BackgroundColor3 = PurpleLight
    numBox.BackgroundTransparency = 0.10
    numBox.TextColor3 = GreyNum
    local numCorner = Instance.new("UICorner", numBox)
    numCorner.CornerRadius = UDim.new(1,0)
    numBox.ClearTextOnFocus = false
    numBox.PlaceholderText = tostring(default)

    local dragging = false
    local val = default
    local function setSlider(x)
        local percent = math.clamp((x-sliderBar.AbsolutePosition.X)/sliderBar.AbsoluteSize.X,0,1)
        val = math.floor((min + (max-min)*percent) + 0.5)
        fill.Size = UDim2.new(percent,0,1,0)
        numBox.Text = tostring(val)
        if callback then callback(val) end
    end

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            setSlider(input.Position.X)
        end
    end)
    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            setSlider(input.Position.X)
        end
    end)

    numBox.FocusLost:Connect(function()
        local n = tonumber(numBox.Text)
        if n then
            n = math.clamp(n, min, max)
            val = n
            fill.Size = UDim2.new((val-min)/(max-min),0,1,0)
            numBox.Text = tostring(val)
            if callback then callback(val) end
        else
            numBox.Text = tostring(val)
        end
    end)

    return holder
end

local function CreateInputBox(parent, label, placeholder, callback)
    local holder = Instance.new("Frame", parent)
    holder.Size = UDim2.new(1,-32,0,48)
    holder.BackgroundTransparency = 1

    local txt = Instance.new("TextLabel", holder)
    txt.Text = label
    txt.Font = Enum.Font.GothamMedium
    txt.TextColor3 = PurpleMain
    txt.TextSize = 17
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0,0,0,4)
    txt.Size = UDim2.new(0.5,0,0.55,0)
    txt.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", holder)
    box.Size = UDim2.new(0.5,0,0,28)
    box.Position = UDim2.new(0.5,0,0.5,0)
    box.BackgroundColor3 = PurpleLight
    box.BackgroundTransparency = 0.10
    box.PlaceholderText = placeholder or ""
    box.TextColor3 = GreyNum
    box.Font = Enum.Font.Code
    box.TextSize = 16
    local boxCorner = Instance.new("UICorner", box)
    boxCorner.CornerRadius = UDim.new(1,0)
    box.ClearTextOnFocus = false

    box.FocusLost:Connect(function(enter)
        if enter and callback then
            callback(box.Text)
        end
    end)

    return holder
end

local function CreateKeybind(parent, label, defaultKey, callback)
    local holder = Instance.new("Frame", parent)
    holder.Size = UDim2.new(1,-32,0,48)
    holder.BackgroundTransparency = 1

    local txt = Instance.new("TextLabel", holder)
    txt.Text = label
    txt.Font = Enum.Font.GothamMedium
    txt.TextColor3 = PurpleMain
    txt.TextSize = 17
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0,0,0,4)
    txt.Size = UDim2.new(0.55,0,1,0)
    txt.TextXAlignment = Enum.TextXAlignment.Left

    local keyBtn = Instance.new("TextButton", holder)
    keyBtn.Size = UDim2.new(0,62,0,28)
    keyBtn.Position = UDim2.new(1,-66,0.5,-14)
    keyBtn.BackgroundColor3 = PurpleLight
    keyBtn.BackgroundTransparency = 0.13
    keyBtn.TextColor3 = PurpleMain
    keyBtn.Font = Enum.Font.Code
    keyBtn.TextSize = 16
    keyBtn.Text = defaultKey and tostring(defaultKey) or "None"
    local keyCorner = Instance.new("UICorner", keyBtn)
    keyCorner.CornerRadius = UDim.new(1,0)

    local capturing = false
    keyBtn.MouseButton1Click:Connect(function()
        keyBtn.Text = "..."
        capturing = true
    end)
    UserInputService.InputBegan:Connect(function(input,gpe)
        if capturing and not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
            keyBtn.Text = input.KeyCode.Name
            capturing = false
            if callback then callback(input.KeyCode) end
        end
    end)

    return holder
end

-- === LXUILibrary API ===
function LXUILibrary:CreateWindow(config)
    -- Main GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "LXAIL_BETA"
    gui.IgnoreGuiInset = true
    pcall(function() gui.Parent = game.CoreGui end)
    if not gui.Parent then
        gui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
    end

    -- Botón Toggle Flotante
    local floatToggle = Instance.new("Frame", gui)
    floatToggle.Size = UDim2.new(0, 46, 0, 46)
    floatToggle.Position = UDim2.new(0, 18, 0.5, -23)
    floatToggle.BackgroundColor3 = BlackGlass
    floatToggle.BackgroundTransparency = 0.13
    floatToggle.BorderSizePixel = 0
    floatToggle.AnchorPoint = Vector2.new(0,0.5)
    floatToggle.Visible = true
    floatToggle.ZIndex = 999
    local floatCorner = Instance.new("UICorner", floatToggle)
    floatCorner.CornerRadius = UDim.new(0, 15)
    local floatStroke = Instance.new("UIStroke", floatToggle)
    floatStroke.Color = PurpleAccent
    floatStroke.Thickness = 2
    floatStroke.Transparency = 0.12
    local toggleIcon = Instance.new("ImageLabel", floatToggle)
    toggleIcon.Image = "rbxassetid://7733964641"
    toggleIcon.Size = UDim2.new(0.6, 0, 0.6, 0)
    toggleIcon.Position = UDim2.new(0.2,0,0.2,0)
    toggleIcon.BackgroundTransparency = 1
    toggleIcon.ImageColor3 = PurpleAccent

    -- Toggle draggable
    do
        local dragging, dragInput, startPos, startMouse
        floatToggle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                startMouse = UserInputService:GetMouseLocation()
                startPos = floatToggle.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = UserInputService:GetMouseLocation() - startMouse
                floatToggle.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
            end
        end)
    end

    -- Sombra
    local shadow = Instance.new("Frame", gui)
    shadow.Size = UDim2.new(0, defaultW, 0, defaultH)
    shadow.Position = UDim2.new(0.5, -defaultW/2, 0.5, -defaultH/2)
    shadow.BackgroundColor3 = Shadow
    shadow.BackgroundTransparency = 0.80
    shadow.AnchorPoint = Vector2.new(0.5,0.5)
    shadow.ZIndex = 0
    shadow.BorderSizePixel = 0
    shadow.ClipsDescendants = true
    local shadowCorner = Instance.new("UICorner", shadow)
    shadowCorner.CornerRadius = UDim.new(0,30)

    -- Main panel
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, defaultW, 0, defaultH)
    main.Position = UDim2.new(0.5, -defaultW/2, 0.5, -defaultH/2)
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.BackgroundColor3 = BlackGlass
    main.BackgroundTransparency = 0.10
    main.BorderSizePixel = 0
    main.ZIndex = 1
    main.ClipsDescendants = true
    main.Active = true
    main.Draggable = true

    local mainCorner = Instance.new("UICorner", main)
    mainCorner.CornerRadius = UDim.new(0,24)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = PurpleAccent
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.10

    -- Overlay glass
    local glassOverlay = Instance.new("Frame", main)
    glassOverlay.BackgroundColor3 = PurpleMain
    glassOverlay.BackgroundTransparency = 0.90
    glassOverlay.Size = UDim2.new(1,0,1,0)
    glassOverlay.Position = UDim2.new(0,0,0,0)
    glassOverlay.ZIndex = 2
    glassOverlay.BorderSizePixel = 0
    local overlayCorner = Instance.new("UICorner", glassOverlay)
    overlayCorner.CornerRadius = UDim.new(0,24)

    -- HEADER
    local header = Instance.new("Frame", main)
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundTransparency = 0.02
    header.BackgroundColor3 = PurpleDark
    header.BorderSizePixel = 0
    header.ZIndex = 3
    local headerCorner = Instance.new("UICorner", header)
    headerCorner.CornerRadius = UDim.new(0,19)
    local headerStroke = Instance.new("UIStroke", header)
    headerStroke.Color = PurpleAccent
    headerStroke.Thickness = 1.2
    headerStroke.Transparency = 0.10

    local icon = Instance.new("ImageLabel", header)
    icon.Name = "DragonIcon"
    icon.Image = "rbxassetid://14772027246"
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0,36,0,36)
    icon.Position = UDim2.new(0,16,0.5,-18)
    icon.ZIndex = 4

    local title = Instance.new("TextLabel", header)
    title.Name = "Title"
    title.Text = config.Name or "LXAIL- BETA"
    title.Font = CartoonFont
    title.TextColor3 = PurpleLight
    title.TextStrokeTransparency = 0.5
    title.TextSize = 32
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0,62,0,0)
    title.Size = UDim2.new(0.7,0,1,0)
    title.ZIndex = 4
    title.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 23
    closeBtn.TextColor3 = PurpleLight
    closeBtn.BackgroundTransparency = 0.23
    closeBtn.BackgroundColor3 = PurpleAccent
    closeBtn.Size = UDim2.new(0,36,0,36)
    closeBtn.Position = UDim2.new(1,-44,0,12)
    closeBtn.ZIndex = 4
    local closeCorner = Instance.new("UICorner", closeBtn)
    closeCorner.CornerRadius = UDim.new(1,0)
    closeBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        shadow.Visible = false
        floatToggle.Visible = true
    end)

    local minBtn = Instance.new("TextButton", header)
    minBtn.Text = "—"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 25
    minBtn.TextColor3 = PurpleLight
    minBtn.BackgroundTransparency = 0.23
    minBtn.BackgroundColor3 = PurpleAccent
    minBtn.Size = UDim2.new(0,36,0,36)
    minBtn.Position = UDim2.new(1,-88,0,12)
    minBtn.ZIndex = 4
    local minCorner = Instance.new("UICorner", minBtn)
    minCorner.CornerRadius = UDim.new(1,0)
    minBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        shadow.Visible = false
        floatToggle.Visible = true
    end)

    floatToggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            main.Visible = true
            shadow.Visible = true
            floatToggle.Visible = false
        end
    end)

    gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        local w, h = main.Size.X.Offset, main.Size.Y.Offset
        main.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
        shadow.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
    end)

    -- Tabs columna izquierda
    local tabs = Instance.new("Frame", main)
    tabs.Name = "Tabs"
    tabs.BackgroundColor3 = BlackTab
    tabs.BackgroundTransparency = 0.22
    tabs.Position = UDim2.new(0,0,0,60)
    tabs.Size = UDim2.new(0,108,1,-60)
    tabs.BorderSizePixel = 0
    tabs.ZIndex = 3
    local tabsCorner = Instance.new("UICorner", tabs)
    tabsCorner.CornerRadius = UDim.new(0,18)
    local tabList = Instance.new("UIListLayout", tabs)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0,10)
    tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Contenedor de contenido derecho (glass)
    local content = Instance.new("Frame", main)
    content.Name = "Content"
    content.BackgroundColor3 = White
    content.BackgroundTransparency = 0.74
    content.Size = UDim2.new(1,-120,1,-78)
    content.Position = UDim2.new(0,112,0,68)
    content.ZIndex = 3
    content.BorderSizePixel = 0
    local contentCorner = Instance.new("UICorner", content)
    contentCorner.CornerRadius = UDim.new(0,16)
    local contentShadow = Instance.new("UIStroke", content)
    contentShadow.Color = PurpleAccent
    contentShadow.Thickness = 2
    contentShadow.Transparency = 0.63

    -- Tabs logic
    local tabPages, tabBtns = {}, {}
    local function selectTab(idx)
        for i,btn in ipairs(tabBtns) do
            btn.BackgroundColor3 = (i==idx) and PurpleMain or PurpleAccent
            btn.TextColor3 = (i==idx) and White or PurpleMain
            tabPages[i].Visible = (i==idx)
        end
    end

    -- Crear tabs desde config (Rayfield style)
    for i,tab in ipairs(config.Tabs or {}) do
        local btn = Instance.new("TextButton", tabs)
        btn.Text = tab.Name or ("Tab "..i)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 17
        btn.BackgroundTransparency = 0.17
        btn.BackgroundColor3 = i==1 and PurpleMain or PurpleAccent
        btn.TextColor3 = i==1 and White or PurpleMain
        btn.Size = UDim2.new(0.88,0,0,38)
        btn.ZIndex = 4
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(1,0)
        btn.AutoButtonColor = true
        tabBtns[i] = btn

        -- Contenido
        local page = Instance.new("Frame", content)
        page.Name = (tab.Name or "Tab").."Tab"
        page.Size = UDim2.new(1,0,1,0)
        page.BackgroundTransparency = 1
        page.Visible = i==1
        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0,17)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        tabPages[i] = page

        btn.MouseButton1Click:Connect(function()
            selectTab(i)
        end)

        -- Agregar elementos
        for _,elem in ipairs(tab.Elements or {}) do
            if elem.Type == "Toggle" then
                CreateToggle(page, elem.Name or "Toggle", elem.Default or false, elem.Callback)
            elseif elem.Type == "Slider" then
                CreateSlider(page, elem.Name or "Slider", elem.Min or 0, elem.Max or 100, elem.Default or 0, elem.Callback)
            elseif elem.Type == "Input" then
                CreateInputBox(page, elem.Name or "Input", elem.Placeholder or "", elem.Callback)
            elseif elem.Type == "Keybind" then
                CreateKeybind(page, elem.Name or "Keybind", elem.Default or Enum.KeyCode.F, elem.Callback)
            end
        end
    end
    selectTab(1)

    -- === NOTIFICACIONES ===
    local notificationHolder = Instance.new("Frame", gui)
    notificationHolder.Size = UDim2.new(0, 320, 1, -24)
    notificationHolder.Position = UDim2.new(1, -340, 0, 12)
    notificationHolder.BackgroundTransparency = 1
    notificationHolder.ZIndex = 1000

    local notifList = Instance.new("UIListLayout", notificationHolder)
    notifList.SortOrder = Enum.SortOrder.LayoutOrder
    notifList.Padding = UDim.new(0,8)

    local WindowAPI = {}
    function WindowAPI:Notify(title, message, time)
        local notif = Instance.new("Frame", notificationHolder)
        notif.Size = UDim2.new(1,0,0,64)
        notif.BackgroundColor3 = BlackGlass
        notif.BackgroundTransparency = 0.13
        notif.BorderSizePixel = 0
        notif.ZIndex = 1001
        local notifCorner = Instance.new("UICorner", notif)
        notifCorner.CornerRadius = UDim.new(0,15)
        local notifStroke = Instance.new("UIStroke", notif)
        notifStroke.Color = PurpleAccent
        notifStroke.Thickness = 1.2
        notifStroke.Transparency = 0.09

        local notifTitle = Instance.new("TextLabel", notif)
        notifTitle.Text = title or "Notificación"
        notifTitle.Font = Enum.Font.GothamBold
        notifTitle.TextSize = 18
        notifTitle.TextColor3 = PurpleMain
        notifTitle.BackgroundTransparency = 1
        notifTitle.Size = UDim2.new(1,-20,0,22)
        notifTitle.Position = UDim2.new(0,10,0,4)
        notifTitle.TextXAlignment = Enum.TextXAlignment.Left

        local notifMsg = Instance.new("TextLabel", notif)
        notifMsg.Text = message or ""
        notifMsg.Font = Enum.Font.Gotham
        notifMsg.TextSize = 15
        notifMsg.TextColor3 = White
        notifMsg.BackgroundTransparency = 1
        notifMsg.Size = UDim2.new(1,-20,1,-28)
        notifMsg.Position = UDim2.new(0,10,0,26)
        notifMsg.TextXAlignment = Enum.TextXAlignment.Left
        notifMsg.TextYAlignment = Enum.TextYAlignment.Top
        notifMsg.TextWrapped = true

        notif.Size = UDim2.new(1,0,0,0)
        TweenService:Create(notif, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Size = UDim2.new(1,0,0,64)}):Play()

        spawn(function()
            wait(time or 3)
            TweenService:Create(notif, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Size = UDim2.new(1,0,0,0)}):Play()
            wait(0.22)
            notif:Destroy()
        end)
    end

    return WindowAPI
end

-- Para usar: local Window = LXUILibrary:CreateWindow({ ... }) (ver ejemplo arriba)
_G.LXUILibrary = LXUILibrary -- Opcional para acceso global

return LXUILibrary
