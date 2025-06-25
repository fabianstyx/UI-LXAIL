--[[
    UILib.lua
    UI Library moderna con soporte para tabs con imagen/texto, tema claro/oscuro y componentes customizables.
    Hecho por fabianstyx

    USO BÁSICO:

    local UILib = loadstring(game:HttpGet("TU_LINK_DEL_GIST_AQUI"))()
    local window = UILib:CreateWindow({
        Title = "Mi Panel Moderno",
        AccentColor = Color3.fromRGB(54, 114, 255), -- Header color
        Theme = "Light" -- o "Dark"
    })

    -- Agrega tabs con imagen y texto
    local tab1 = window:AddTab({
        Name = "Inicio",
        Icon = "rbxassetid://123456", -- o URL directa, o nombre de sprite
    })

    -- COMPONENTES:
    tab1:AddToggle({
        Name = "Activar modo pro",
        Default = false,
        Callback = function(state)
            print("Toggle:", state)
        end
    })

    tab1:AddSlider({
        Name = "Volumen",
        Min = 0,
        Max = 100,
        Default = 10,
        Callback = function(val)
            print("Slider:", val)
        end
    })

    tab1:AddDropdown({
        Name = "Colores",
        Options = {"Rojo", "Verde", "Azul"},
        Default = "Rojo",
        Callback = function(selected)
            print("Seleccionado:", selected)
        end
    })

    -- Cambiar tema en tiempo real:
    window:SetTheme("Dark") -- o "Light"
]]

local UILib = {}
UILib.__index = UILib

-- Tema base
local themes = {
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        Foreground = Color3.fromRGB(255,255,255),
        Text = Color3.fromRGB(30,30,40),
        Accent = Color3.fromRGB(54, 114, 255),
        Card = Color3.fromRGB(236,240,243)
    },
    Dark = {
        Background = Color3.fromRGB(26, 28, 34),
        Foreground = Color3.fromRGB(33,35,41),
        Text = Color3.fromRGB(235,235,245),
        Accent = Color3.fromRGB(54, 114, 255),
        Card = Color3.fromRGB(38,41,49)
    }
}

-- Crea la ventana principal
function UILib:CreateWindow(opts)
    local self = setmetatable({}, UILib)
    self.ThemeName = opts.Theme or "Light"
    self.Theme = themes[self.ThemeName]
    self.AccentColor = opts.AccentColor or self.Theme.Accent
    self.Tabs = {}
    self.ActiveTab = nil

    -- [INICIA UI]
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILib"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 480, 0, 420)
    Main.Position = UDim2.new(0.5, -240, 0.5, -210)
    Main.BackgroundColor3 = self.Theme.Background
    Main.BorderSizePixel = 0
    Main.AnchorPoint = Vector2.new(0.5,0.5)
    Main.Name = "Main"
    Main.Parent = ScreenGui

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1,0,0,56)
    Header.BackgroundColor3 = self.AccentColor
    Header.BorderSizePixel = 0
    Header.Name = "Header"
    Header.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Text = opts.Title or "Panel"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0,20,0,12)
    Title.Size = UDim2.new(1,-40,0,32)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Tabs Container
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "Tabs"
    TabsContainer.Size = UDim2.new(0, 120, 1, -56)
    TabsContainer.Position = UDim2.new(0,0,0,56)
    TabsContainer.BackgroundColor3 = self.Theme.Foreground
    TabsContainer.BorderSizePixel = 0
    TabsContainer.Parent = Main

    local TabsList = Instance.new("UIListLayout")
    TabsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabsList.Padding = UDim.new(0,2)
    TabsList.Parent = TabsContainer

    -- Tab Content Container
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1,-120,1,-56)
    Content.Position = UDim2.new(0,120,0,56)
    Content.BackgroundColor3 = self.Theme.Card
    Content.BorderSizePixel = 0
    Content.Parent = Main

    self.GuiRefs = {
        ScreenGui=ScreenGui,
        Main=Main,
        Header=Header,
        Content=Content,
        TabsContainer=TabsContainer
    }
    -- API:
    function self:AddTab(tabinfo)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabinfo.Name or "Tab"
        tabBtn.Size = UDim2.new(1,0,0,48)
        tabBtn.BackgroundColor3 = self.Theme.Foreground
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = TabsContainer

        -- Imagen
        local Icon = Instance.new("ImageLabel")
        Icon.Name = "Icon"
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.new(0,10,0,8)
        Icon.Size = UDim2.new(0,32,0,32)
        Icon.Image = tabinfo.Icon or ""
        Icon.Parent = tabBtn

        -- Texto
        local Txt = Instance.new("TextLabel")
        Txt.Name = "TabText"
        Txt.Text = tabinfo.Name or ""
        Txt.Font = Enum.Font.Gotham
        Txt.TextSize = 16
        Txt.BackgroundTransparency = 1
        Txt.Position = UDim2.new(0,48,0,0)
        Txt.Size = UDim2.new(1,-54,1,0)
        Txt.TextColor3 = self.Theme.Text
        Txt.TextXAlignment = Enum.TextXAlignment.Left
        Txt.Parent = tabBtn

        -- Tab Content
        local tabFrame = Instance.new("Frame")
        tabFrame.Name = "Tab_"..tabinfo.Name
        tabFrame.Size = UDim2.new(1,0,1,0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.Parent = Content

        local elementsList = Instance.new("UIListLayout")
        elementsList.SortOrder = Enum.SortOrder.LayoutOrder
        elementsList.Padding = UDim.new(0,8)
        elementsList.Parent = tabFrame

        -- Cambiar tab
        tabBtn.MouseButton1Click:Connect(function()
            for _, tb in pairs(self.Tabs) do
                tb.Frame.Visible = false
                tb.Button.BackgroundColor3 = self.Theme.Foreground
            end
            tabFrame.Visible = true
            tabBtn.BackgroundColor3 = self.Theme.Card
            self.ActiveTab = tabFrame
        end)
        -- Primera pestaña autoactiva
        if #self.Tabs == 0 then
            tabFrame.Visible = true
            tabBtn.BackgroundColor3 = self.Theme.Card
        end

        -- API para componentes
        local tabapi = {}
        function tabapi:AddToggle(opts)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1,-24,0,40)
            holder.BackgroundTransparency = 1
            holder.Parent = tabFrame

            local txt = Instance.new("TextLabel")
            txt.Text = opts.Name or "Toggle"
            txt.Font = Enum.Font.Gotham
            txt.TextSize = 15
            txt.BackgroundTransparency = 1
            txt.Size = UDim2.new(1,-50,1,0)
            txt.TextColor3 = self.Theme.Text
            txt.TextXAlignment = Enum.TextXAlignment.Left
            txt.Parent = holder

            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0,40,0,22)
            toggleBtn.Position = UDim2.new(1,-50,0.5,-11)
            toggleBtn.BackgroundColor3 = self.Theme.Background
            toggleBtn.BorderSizePixel = 0
            toggleBtn.Text = ""
            toggleBtn.Parent = holder

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0,18,0,18)
            circle.Position = UDim2.new(0,2,0.5,-9)
            circle.BackgroundColor3 = self.Theme.Card
            circle.BorderSizePixel = 0
            circle.Parent = toggleBtn

            local state = opts.Default or false
            local function update()
                if state then
                    toggleBtn.BackgroundColor3 = self.AccentColor
                    circle.Position = UDim2.new(1,-20,0.5,-9)
                else
                    toggleBtn.BackgroundColor3 = self.Theme.Background
                    circle.Position = UDim2.new(0,2,0.5,-9)
                end
            end
            update()
            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                update()
                if opts.Callback then opts.Callback(state) end
            end)
        end

        function tabapi:AddSlider(opts)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1,-24,0,48)
            holder.BackgroundTransparency = 1
            holder.Parent = tabFrame

            local txt = Instance.new("TextLabel")
            txt.Text = opts.Name or "Slider"
            txt.Font = Enum.Font.Gotham
            txt.TextSize = 15
            txt.BackgroundTransparency = 1
            txt.Size = UDim2.new(1,0,0,18)
            txt.TextColor3 = self.Theme.Text
            txt.TextXAlignment = Enum.TextXAlignment.Left
            txt.Parent = holder

            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(1,0,0,8)
            sliderBar.Position = UDim2.new(0,0,0,28)
            sliderBar.BackgroundColor3 = self.Theme.Card
            sliderBar.BorderSizePixel = 0
            sliderBar.Parent = holder

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0,0,1,0)
            fill.BackgroundColor3 = self.AccentColor
            fill.BorderSizePixel = 0
            fill.Parent = sliderBar

            local min = opts.Min or 0
            local max = opts.Max or 100
            local val = opts.Default or min

            local drag = false
            local function setSlider(x)
                local percent = math.clamp((x-sliderBar.AbsolutePosition.X)/sliderBar.AbsoluteSize.X,0,1)
                val = math.floor((min + (max-min)*percent)+0.5)
                fill.Size = UDim2.new(percent,0,1,0)
                if opts.Callback then opts.Callback(val) end
            end

            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    drag = true
                    setSlider(input.Position.X)
                end
            end)
            sliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    drag = false
                end
            end)
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
                    setSlider(input.Position.X)
                end
            end)

            -- Inicial
            fill.Size = UDim2.new((val-min)/(max-min),0,1,0)
        end

        function tabapi:AddDropdown(opts)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1,-24,0,40)
            holder.BackgroundTransparency = 1
            holder.Parent = tabFrame

            local txt = Instance.new("TextLabel")
            txt.Text = opts.Name or "Dropdown"
            txt.Font = Enum.Font.Gotham
            txt.TextSize = 15
            txt.BackgroundTransparency = 1
            txt.Size = UDim2.new(0.7,0,1,0)
            txt.TextColor3 = self.Theme.Text
            txt.TextXAlignment = Enum.TextXAlignment.Left
            txt.Parent = holder

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.3,0,1,0)
            btn.Position = UDim2.new(0.7,4,0,0)
            btn.BackgroundColor3 = self.Theme.Card
            btn.BorderSizePixel = 0
            btn.Text = opts.Default or opts.Options[1]
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.TextColor3 = self.Theme.Text
            btn.Parent = holder

            local open = false
            local optsFrame = Instance.new("Frame")
            optsFrame.Visible = false
            optsFrame.Size = UDim2.new(0,120,0,#opts.Options*28)
            optsFrame.Position = UDim2.new(0, btn.AbsolutePosition.X, 1, 0)
            optsFrame.BackgroundColor3 = self.Theme.Card
            optsFrame.BorderSizePixel = 0
            optsFrame.ZIndex = 10
            optsFrame.Parent = btn

            btn.MouseButton1Click:Connect(function()
                open = not open
                optsFrame.Visible = open
            end)
            for i,opt in ipairs(opts.Options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1,0,0,28)
                optBtn.Position = UDim2.new(0,0,0,(i-1)*28)
                optBtn.BackgroundColor3 = self.Theme.Card
                optBtn.BorderSizePixel = 0
                optBtn.Text = opt
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 14
                optBtn.TextColor3 = self.Theme.Text
                optBtn.Parent = optsFrame
                optBtn.MouseButton1Click:Connect(function()
                    btn.Text = opt
                    optsFrame.Visible = false
                    open = false
                    if opts.Callback then opts.Callback(opt) end
                end)
            end
        end
        table.insert(self.Tabs, {Button=tabBtn, Frame=tabFrame, Api=tabapi})
        return tabapi
    end

    function self:SetTheme(theme)
        assert(themes[theme], "Tema no soportado")
        self.ThemeName = theme
        self.Theme = themes[theme]
        -- Actualiza colores
        self.GuiRefs.Main.BackgroundColor3 = self.Theme.Background
        self.GuiRefs.Header.BackgroundColor3 = self.AccentColor
        self.GuiRefs.TabsContainer.BackgroundColor3 = self.Theme.Foreground
        self.GuiRefs.Content.BackgroundColor3 = self.Theme.Card
        -- Y todo lo demás (tabs, componentes, etc.) si quieres profundizar, puedes recorrer y actualizar
    end

    return self
end

return UILib
