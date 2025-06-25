--[[
  UILib Modular para Delta Executor
  Modern UI inspirado en Synapse X / Rayfield / ShadCN
  Componentes: Window, Button, Toggle, Slider, Dropdown, TextBox
  Temas: Dark / Light
  Soporte PC y móvil
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Temas
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(102, 90, 255),
        Text = Color3.fromRGB(235, 235, 245),
        Secondary = Color3.fromRGB(40, 40, 55),
        Stroke = Color3.fromRGB(50, 50, 60),
        Placeholder = Color3.fromRGB(140, 140, 150),
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        Accent = Color3.fromRGB(102, 90, 255),
        Text = Color3.fromRGB(30, 30, 45),
        Secondary = Color3.fromRGB(230, 230, 245),
        Stroke = Color3.fromRGB(210, 210, 220),
        Placeholder = Color3.fromRGB(120, 120, 130),
    }
}

-- Utilidades
local function ApplyCorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = obj
end

local function ApplyStroke(obj, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
end

local function TweenObj(obj, props, dur)
    local tween = TweenService:Create(obj, TweenInfo.new(dur or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function MakeLabel(parent, text, theme, size, weight)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, size or 20)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
   ("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold) end)
    end
    return lbl
end

local function Cleanup(name)
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v.Name == name then v:Destroy() end
    end
end

-- Library principal
local UILib = {}
UILib.__index = UILib

function UILib:CreateWindow(opts)
    opts = opts or {}
    local theme = Themes[opts.Theme or "Dark"] or Themes.Dark
    local guiName = opts.Title or ("UILib_" .. tostring(math.random(10000,99999)))

    Cleanup(guiName) -- Evita duplicados

    -- ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = guiName
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui

    -- Main Window
    local main = Instance.new("Frame")
    main.Size = opts.Size or UDim2.new(0, 410, 0, 340)
    main.Position = UDim2.new(0.5, -205, 0.5, -170)
    main.BackgroundColor3 = theme.Background
    main.BorderSizePixel = 0
    main.ZIndex = 10
    main.Active = true
    main.Parent = gui

    ApplyCorner(main, 12)
    ApplyStroke(main, theme.Stroke, 2)

    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 38)
    header.BackgroundColor3 = theme.Secondary
    header.BorderSizePixel = 0
    header.ZIndex = 11
    header.Parent = main
    ApplyCorner(header, 12)
    ApplyStroke(header, theme.Stroke, 1)

    local title = MakeLabel(header, opts.Title or "UILib Window", theme, 22, "Bold")
    title.Position = UDim2.new(0, 16, 0, 0)
    title.Size = UDim2.new(1, -32, 1, 0)
    title.TextColor3 = theme.Accent

    -- Contenedor para componentes
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Position = UDim2.new(0, 0, 0, 38)
    container.Size = UDim2.new(1, 0, 1, -38)
    container.BackgroundTransparency = 1
    container.ZIndex = 11
    container.Parent = main

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container

    -- Draggable (PC y móvil)
    if opts.Draggable then
        local dragging, dragInput, dragStart, startPos
        local function update(input)
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                main.Position.X.Scale, startPos.X.Offset + delta.X,
                main.Position.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end

        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = main.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        header.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end

    -- API de la ventana
    local window = {}
    window._container = container
    window._theme = theme

    -- BUTTON
    function window:AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.92, 0, 0, 34)
        btn.BackgroundColor3 = theme.Accent
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Font = Enum.Font.Gotham
        btn.ZIndex = 12
        btn.Parent = container
        ApplyCorner(btn, 8)
        ApplyStroke(btn, theme.Stroke, 1.2)

        local lbl = MakeLabel(btn, text or "Botón", theme, 18, "Bold")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.TextColor3 = theme.Text

        btn.MouseEnter:Connect(function()
            TweenObj(btn, {BackgroundColor3 = theme.Secondary}, 0.17)
        end)
        btn.MouseLeave:Connect(function()
            TweenObj(btn, {BackgroundColor3 = theme.Accent}, 0.17)
        end)
        btn.MouseButton1Click:Connect(function()
            TweenObj(btn, {BackgroundTransparency = 0.18}, 0.08)
            task.wait(0.08)
            TweenObj(btn, {BackgroundTransparency = 0}, 0.1)
            if callback then callback() end
        end)
        return btn
    end

    -- TOGGLE
    function window:AddToggle(text, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.92, 0, 0, 32)
        frame.BackgroundTransparency = 1
        frame.ZIndex = 12
        frame.Parent = container

        local lbl = MakeLabel(frame, text or "Toggle", theme, 18)
        lbl.Size = UDim2.new(0.8, 0, 1, 0)

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 32, 0, 22)
        toggle.Position = UDim2.new(0.8, 0, 0.5, -11)
        toggle.BackgroundColor3 = default and theme.Accent or theme.Secondary
        toggle.AutoButtonColor = false
        toggle.Text = ""
        toggle.ZIndex = 13
        toggle.Parent = frame
        ApplyCorner(toggle, 11)
        ApplyStroke(toggle, theme.Stroke, 1)

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 16, 0, 16)
        circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        circle.BackgroundColor3 = theme.Background
        circle.ZIndex = 14
        circle.Parent = toggle
        ApplyCorner(circle, 8)

        local state = default or false

        local function setState(val)
            state = val
            TweenObj(toggle, {BackgroundColor3 = state and theme.Accent or theme.Secondary}, 0.17)
            TweenObj(circle, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.15)
            if callback then callback(state) end
        end

        toggle.MouseButton1Click:Connect(function()
            setState(not state)
        end)

        return {
            Set = setState,
            Get = function() return state end
        }
    end

    -- SLIDER
    function window:AddSlider(min, max, default, callback)
        min = min or 0
        max = max or 100
        default = default or min
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.92, 0, 0, 38)
        frame.BackgroundTransparency = 1
        frame.ZIndex = 12
        frame.Parent = container

        local lbl = MakeLabel(frame, tostring(default), theme, 16)
        lbl.Position = UDim2.new(0.85, 0, 0, 0)
        lbl.Size = UDim2.new(0.15, 0, 1, 0)
        lbl.TextXAlignment = Enum.TextXAlignment.Right

        local sliderBar = Instance.new("Frame")
        sliderBar.Size = UDim2.new(0.8, 0, 0, 10)
        sliderBar.Position = UDim2.new(0, 0, 0.5, -5)
        sliderBar.BackgroundColor3 = theme.Secondary
        sliderBar.ZIndex = 13
        sliderBar.Parent = frame
        ApplyCorner(sliderBar, 5)

        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        sliderFill.BackgroundColor3 = theme.Accent
        sliderFill.ZIndex = 14
        sliderFill.Parent = sliderBar
        ApplyCorner(sliderFill, 5)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = UDim2.new((default-min)/(max-min), -9, 0.5, -9)
        knob.BackgroundColor3 = theme.Accent
        knob.ZIndex = 15
        knob.Parent = sliderBar
        ApplyCorner(knob, 9)
        ApplyStroke(knob, theme.Stroke, 1)

        local dragging = false
        local value = default

        local function setValue(x)
            x = math.clamp(x, 0, 1)
            value = math.floor((min + (max-min)*x) + 0.5)
            TweenObj(sliderFill, {Size = UDim2.new(x, 0, 1, 0)}, 0.1)
            TweenObj(knob, {Position = UDim2.new(x, -9, 0.5, -9)}, 0.09)
            lbl.Text = tostring(value)
            if callback then callback(value) end
        end

        knob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            dragging = false
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local abs = sliderBar.AbsolutePosition
                local size = sliderBar.AbsoluteSize
                local x = (input.Position.X - abs.X) / size.X
                setValue(x)
            end
        end)
        setValue((default-min)/(max-min))
        return {
            Set = function(v) setValue((v-min)/(max-min)) end,
            Get = function() return value end
        }
    end

    -- DROPDOWN
    function window:AddDropdown(options, default, callback)
        options = options or {"Opción 1", "Opción 2"}
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.92, 0, 0, 36)
        frame.BackgroundTransparency = 1
        frame.ZIndex = 12
        frame.Parent = container

        local dropdownBtn = Instance.new("TextButton")
        dropdownBtn.Size = UDim2.new(1, 0, 1, 0)
        dropdownBtn.BackgroundColor3 = theme.Secondary
        dropdownBtn.Text = ""
        dropdownBtn.ZIndex = 13
        dropdownBtn.Parent = frame
        ApplyCorner(dropdownBtn, 7)
        ApplyStroke(dropdownBtn, theme.Stroke, 1)

        local lbl = MakeLabel(dropdownBtn, default or options[1], theme, 17)
        lbl.Size = UDim2.new(0.85, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0, 24, 0, 24)
        icon.Position = UDim2.new(1, -28, 0.5, -12)
        icon.BackgroundTransparency = 1
        icon.Text = "▼"
        icon.Font = Enum.Font.GothamBold
        icon.TextSize = 16
        icon.TextColor3 = theme.Placeholder
        icon.ZIndex = 14
        icon.Parent = dropdownBtn

        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Position = UDim2.new(0, 0, 1, 0)
        dropdownFrame.Size = UDim2.new(1, 0, 0, #options * 28)
        dropdownFrame.BackgroundColor3 = theme.Secondary
        dropdownFrame.Visible = false
        dropdownFrame.ClipsDescendants = true
        dropdownFrame.ZIndex = 15
        dropdownFrame.Parent = frame
        ApplyCorner(dropdownFrame, 7)
        ApplyStroke(dropdownFrame, theme.Stroke, 1)

        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 28)
            optBtn.Position = UDim2.new(0, 0, 0, (i-1)*28)
            optBtn.BackgroundTransparency = 1
            optBtn.Text = opt
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextColor3 = theme.Text
            optBtn.TextSize = 16
            optBtn.ZIndex = 16
            optBtn.Parent = dropdownFrame
            optBtn.MouseButton1Click:Connect(function()
                lbl.Text = opt
                dropdownFrame.Visible = false
                if callback then callback(opt) end
            end)
        end

        dropdownBtn.MouseButton1Click:Connect(function()
            dropdownFrame.Visible = not dropdownFrame.Visible
            TweenObj(icon, {Rotation = dropdownFrame.Visible and 180 or 0}, 0.12)
        end)

        UserInputService.InputBegan:Connect(function(input)
            if dropdownFrame.Visible and input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mouse = UserInputService:GetMouseLocation()
                if not (mouse.X > dropdownFrame.AbsolutePosition.X and mouse.X < dropdownFrame.AbsolutePosition.X + dropdownFrame.AbsoluteSize.X
                    and mouse.Y > dropdownFrame.AbsolutePosition.Y and mouse.Y < dropdownFrame.AbsolutePosition.Y + dropdownFrame.AbsoluteSize.Y) then
                    dropdownFrame.Visible = false
                    TweenObj(icon, {Rotation = 0}, 0.1)
                end
            end
        end)
        return {
            Set = function(val) lbl.Text = val end,
            Get = function() return lbl.Text end
        }
    end

    -- TEXTBOX
    function window:AddTextBox(placeholder, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.92, 0, 0, 36)
        frame.BackgroundTransparency = 1
        frame.ZIndex = 12
        frame.Parent = container

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, 0, 1, 0)
        box.BackgroundColor3 = theme.Secondary
        box.PlaceholderText = placeholder or "Escribe aquí..."
        box.PlaceholderColor3 = theme.Placeholder
        box.Text = ""
        box.TextColor3 = theme.Text
        box.TextSize = 16
        box.Font = Enum.Font.Gotham
        box.ClearTextOnFocus = false
        box.ZIndex = 13
        box.Parent = frame
        ApplyCorner(box, 7)
        ApplyStroke(box, theme.Stroke, 1)

        box.FocusLost:Connect(function(enter)
            if enter and callback then
                callback(box.Text)
            end
        end)
        return box
    end

    return window
end

return UILib
