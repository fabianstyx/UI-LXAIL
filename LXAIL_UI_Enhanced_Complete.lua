--LXAIL UI 2.0 Enhanced - Compatible with Silent Aim
--Added: Connection Management, SafeCallback, and Crash Protection

-- === PROTECTION INITIALIZATION ===
if not game:IsLoaded() then 
    game.Loaded:Wait()
end

-- Protección para executors sin protectgui
if not syn or not protectgui then
    getgenv().protectgui = function() end
end

-- === ROBLOX SERVICES ===
local TweenService, UserInputService, RunService, HttpService, TextService, GuiService, Players, CoreGui, SoundService, player, playerGui

if game then
    -- Running in Roblox environment
    TweenService = game:GetService("TweenService")
    UserInputService = game:GetService("UserInputService")
    RunService = game:GetService("RunService")
    HttpService = game:GetService("HttpService")
    TextService = game:GetService("TextService")
    GuiService = game:GetService("GuiService")
    Players = game:GetService("Players")
    CoreGui = game:GetService("CoreGui")
    SoundService = game:GetService("SoundService")
    player = Players.LocalPlayer
    playerGui = player:WaitForChild("PlayerGui")
else
    -- Mock environment for local testing
    TweenService = {
        Create = function(obj, info, props) 
            return {
                Play = function() print("TweenService:Create() - Playing tween") end,
                Completed = {
                    Connect = function(self, func) print("TweenService - Tween completed") if func then func() end end
                }
            } 
        end
    }
    UserInputService = {
        InputBegan = {Connect = function(self, func) print("UserInputService.InputBegan connected") end},
        InputEnded = {Connect = function(self, func) print("UserInputService.InputEnded connected") end},
        TouchEnabled = true,
        KeyboardEnabled = true,
        MouseEnabled = true
    }
    RunService = {
        Heartbeat = {Connect = function(self, func) print("RunService.Heartbeat connected") end},
        Stepped = {Connect = function(self, func) print("RunService.Stepped connected") end}
    }
    HttpService = {
        JSONEncode = function(self, data) return "{\"mock\":\"data\"}" end,
        JSONDecode = function(self, json) return {mock = "data"} end
    }
    TextService = {
        GetTextSize = function(self, text, textSize, font, frameSize) 
            return Vector2.new(#text * textSize * 0.5, textSize)
        end
    }
    GuiService = {
        MenuOpened = {Connect = function(self, func) print("GuiService.MenuOpened connected") end}
    }
    Players = {
        LocalPlayer = {
            Name = "TestPlayer",
            UserId = 12345
        }
    }
    CoreGui = {}
    SoundService = {}
    player = Players.LocalPlayer
    playerGui = {
        Name = "PlayerGui",
        Parent = nil
    }
    
    -- Mock Roblox classes and functions
    Instance = {
        new = function(className)
            return {
                ClassName = className,
                Name = className,
                Parent = nil,
                Size = UDim2.new(0, 100, 0, 100),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 0,
                BorderSizePixel = 1,
                ZIndex = 1,
                Text = "",
                TextColor3 = Color3.new(0, 0, 0),
                TextSize = 14,
                Font = "Gotham",
                TextXAlignment = "Center",
                TextYAlignment = "Center",
                TextWrapped = false,
                Image = "",
                ImageTransparency = 0,
                ScaleType = "Stretch",
                SliceCenter = nil,
                SoundId = "",
                Volume = 0.5,
                ResetOnSpawn = false,
                MouseButton1Click = {Connect = function(self, func) print("MouseButton1Click connected") end},
                Changed = {Connect = function(self, func) print("Changed event connected") end},
                Ended = {Connect = function(self, func) print("Sound Ended event connected") end},
                Focused = {Connect = function(self, func) 
                    print("TextBox Focused event connected")
                    self._focusedCallback = func
                end},
                FocusLost = {Connect = function(self, func) 
                    print("TextBox FocusLost event connected")
                    self._focusLostCallback = func
                end},
                IsFocused = function(self) return self._isFocused or false end,
                ReleaseFocus = function(self) 
                    self._isFocused = false
                    if self._focusLostCallback then
                        self._focusLostCallback()
                    end
                end,
                Play = function(self) print("Playing sound:", self.SoundId) end,
                Stop = function(self) print("Stopping sound:", self.SoundId) end,
                Destroy = function(self) print("Destroying", self.ClassName) end
            }
        end
    }
    
    UDim2 = {
        new = function(xScale, xOffset, yScale, yOffset)
            local udim2 = {
                X = {Scale = xScale or 0, Offset = xOffset or 0},
                Y = {Scale = yScale or 0, Offset = yOffset or 0}
            }
            
            -- Add metamethod for addition
            local meta = {
                __add = function(a, b)
                    return UDim2.new(
                        a.X.Scale + b.X.Scale,
                        a.X.Offset + b.X.Offset,
                        a.Y.Scale + b.Y.Scale,
                        a.Y.Offset + b.Y.Offset
                    )
                end
            }
            setmetatable(udim2, meta)
            return udim2
        end
    }
    
    UDim = {
        new = function(scale, offset)
            return {Scale = scale or 0, Offset = offset or 0}
        end
    }
    
    Vector2 = {
        new = function(x, y)
            return {X = x or 0, Y = y or 0}
        end
    }
    
    Color3 = {
        new = function(r, g, b)
            return {R = r or 0, G = g or 0, B = b or 0}
        end,
        fromRGB = function(r, g, b)
            return {R = (r or 0)/255, G = (g or 0)/255, B = (b or 0)/255}
        end
    }
    
    ColorSequence = {
        new = function(colors)
            return {Colors = colors or {}}
        end
    }
    
    ColorSequenceKeypoint = {
        new = function(time, color)
            return {Time = time or 0, Value = color or Color3.new(1, 1, 1)}
        end
    }
    
    TweenInfo = {
        new = function(duration, style, direction, repeatCount, reverses, delayTime)
            return {
                Time = duration or 1,
                EasingStyle = style or "Quad",
                EasingDirection = direction or "Out",
                RepeatCount = repeatCount or 0,
                Reverses = reverses or false,
                DelayTime = delayTime or 0
            }
        end
    }
    
    Enum = {
        EasingStyle = {
            Quad = "Quad",
            Back = "Back",
            Bounce = "Bounce",
            Elastic = "Elastic"
        },
        EasingDirection = {
            In = "In",
            Out = "Out",
            InOut = "InOut"
        },
        Font = {
            Gotham = "Gotham",
            GothamBold = "GothamBold",
            SourceSans = "SourceSans"
        },
        TextXAlignment = {
            Left = "Left",
            Center = "Center",
            Right = "Right"
        },
        TextYAlignment = {
            Top = "Top",
            Center = "Center",
            Bottom = "Bottom"
        },
        ScaleType = {
            Stretch = "Stretch",
            Slice = "Slice",
            Tile = "Tile",
            Fit = "Fit"
        },
        SortOrder = {
            LayoutOrder = "LayoutOrder",
            Name = "Name"
        },
        ScrollingDirection = {
            X = "X",
            Y = "Y",
            XY = "XY"
        },
        AutomaticSize = {
            None = "None",
            X = "X",
            Y = "Y",
            XY = "XY"
        },
        HorizontalAlignment = {
            Left = "Left",
            Center = "Center",
            Right = "Right"
        }
    }
    
    Rect = {
        new = function(left, top, right, bottom)
            return {
                Left = left or 0,
                Top = top or 0,
                Right = right or 0,
                Bottom = bottom or 0
            }
        end
    }
    
    NumberSequence = {
        new = function(value)
            return {Value = value or 0}
        end
    }
    
    NumberSequenceKeypoint = {
        new = function(time, value)
            return {Time = time or 0, Value = value or 0}
        end
    }
    
    -- Mock global functions
    spawn = function(func)
        print("spawn() called with function")
        if func then func() end
    end
    
    wait = function(time)
        print("wait(" .. (time or 0) .. ") called")
    end
end

-- === LXAIL LIBRARY WITH ENHANCED PROTECTION ===
local LXAIL = {
    Version = "3.0.0",
    Flags = {},
    CurrentTheme = "Dark",
    Windows = {},
    Notifications = {},
    ConfigFolder = nil,
    DiscordInvite = nil,
    KeyValidated = false,
    
    -- === ENHANCED PROTECTION SYSTEM ===
    _connections = {}, -- Registro automático de conexiones
    _screenGuis = {}, -- Registro de ScreenGuis
    _drawingObjects = {}, -- Registro de Drawing objects
    _tweens = {}, -- Registro de tweens
    _isDestroyed = false, -- Estado de destrucción
    _validationCache = {} -- Cache de validación
}

-- === INTERNAL PROTECTION FUNCTIONS ===

-- SafeCallback: Protege callbacks con pcall
function LXAIL.SafeCallback(callback, ...)
    if not callback or type(callback) ~= "function" then
        return false, "Invalid callback"
    end
    
    if LXAIL._isDestroyed then
        return false, "Library destroyed"
    end
    
    local args = {...}
    local success, result = pcall(function()
        return callback(unpack(args))
    end)
    
    if not success then
        warn("[LXAIL] Callback error prevented crash: " .. tostring(result))
        return false, result
    end
    
    return true, result
end

-- Validación de instancias
local function ValidateInstance(instance)
    if not instance then
        return false, "Instance is nil"
    end
    
    local success, result = pcall(function()
        return instance.Parent ~= nil or instance.ClassName ~= nil
    end)
    
    return success and result, success and "Valid" or "Invalid or destroyed"
end

-- Registro seguro de conexiones
local function RegisterConnection(connection, name)
    if connection and typeof(connection) == "RBXScriptConnection" then
        table.insert(LXAIL._connections, {
            connection = connection,
            name = name or "Unknown",
            timestamp = tick()
        })
        return connection
    end
    return nil
end

-- Registro seguro de ScreenGuis
local function RegisterScreenGui(screenGui, name)
    if screenGui and screenGui.ClassName == "ScreenGui" then
        table.insert(LXAIL._screenGuis, {
            gui = screenGui,
            name = name or "Unknown",
            timestamp = tick()
        })
        
        -- Proteger GUI si está disponible
        if protectgui then
            pcall(function()
                protectgui(screenGui)
            end)
        end
        
        return screenGui
    end
    return nil
end

-- Establecer propiedades de forma segura
local function SafePropertySet(instance, property, value)
    local isValid, error = ValidateInstance(instance)
    if not isValid then
        warn("[LXAIL] Cannot set property on invalid instance: " .. tostring(error))
        return false
    end
    
    local success, error = pcall(function()
        instance[property] = value
    end)
    
    if not success then
        warn("[LXAIL] Failed to set property " .. tostring(property) .. ": " .. tostring(error))
        return false
    end
    
    return true
end

function LXAIL:Connect(event, func)
    if not (event and typeof(event) == "RBXScriptSignal" and func) then return end
    local connection = event:Connect(function(...)
        if self._isDestroyed then return end -- protección si UI ya destruida
        local ok, err = pcall(func, ...)
        if not ok then warn("[LXAIL:Connect] Callback error:", err) end
    end)
    -- REGISTRAR para limpieza
    table.insert(self._connections, {connection=connection, name="UserConnect", timestamp=tick()})
    return connection
end

-- === CLEANUP SYSTEM ===
function LXAIL:RegisterDrawing(obj)
    if not obj then return end
    table.insert(self._drawingObjects, obj)
    return obj
end

-- Función Unload completa
function LXAIL:Unload()
    if self._isDestroyed then
        warn("[LXAIL] Library already destroyed")
        return false
    end

    print("[LXAIL] Starting unload process...")
    self._isDestroyed = true

    -- Destruir todos los Drawing objects
    if self._drawingObjects then
        for i = #self._drawingObjects, 1, -1 do
            local obj = self._drawingObjects[i]
            if obj and typeof(obj.Remove) == "function" then
                pcall(function() obj:Remove() end)
            end
            table.remove(self._drawingObjects, i)
        end
        self._drawingObjects = {}
    end

    -- Desconectar todas las conexiones
    local disconnectedCount = 0
    for i = #self._connections, 1, -1 do
        local connectionInfo = self._connections[i]
        if connectionInfo and connectionInfo.connection then
            local success, error = pcall(function()
                if connectionInfo.connection.Connected then
                    connectionInfo.connection:Disconnect()
                    disconnectedCount = disconnectedCount + 1
                end
            end)
            if not success then
                warn("[LXAIL] Failed to disconnect connection: " .. tostring(error))
            end
        end
        table.remove(self._connections, i)
    end

    -- Destruir todos los ScreenGuis
    local destroyedCount = 0
    for i = #self._screenGuis, 1, -1 do
        local guiInfo = self._screenGuis[i]
        if guiInfo and guiInfo.gui then
            local success, error = pcall(function()
                if ValidateInstance and ValidateInstance(guiInfo.gui) then
                    guiInfo.gui:Destroy()
                    destroyedCount = destroyedCount + 1
                end
            end)
            if not success then
                warn("[LXAIL] Failed to destroy ScreenGui: " .. tostring(error))
            end
        end
        table.remove(self._screenGuis, i)
    end

    -- Cancelar todos los tweens
    local cancelledCount = 0
    for i = #self._tweens, 1, -1 do
        local tweenInfo = self._tweens[i]
        if tweenInfo and tweenInfo.tween then
            local success, error = pcall(function()
                tweenInfo.tween:Cancel()
                cancelledCount = cancelledCount + 1
            end)
            if not success then
                warn("[LXAIL] Failed to cancel tween: " .. tostring(error))
            end
        end
        table.remove(self._tweens, i)
    end

    -- Limpiar arrays
    self._connections = {}
    self._screenGuis = {}
    self._tweens = {}
    self._drawingObjects = {}
    self._validationCache = {}

    -- Limpiar configuración
    self.Flags = {}
    self.Windows = {}
    self.Notifications = {}

    print("[LXAIL] Unload complete. Cleaned: " .. disconnectedCount .. " connections, " ..
            destroyedCount .. " GUIs, " .. cancelledCount .. " tweens")
    return true
end


-- === ENHANCED UTILITY FUNCTIONS ===
local function playSound(soundId)
    local success, sound = pcall(function()
        return Instance.new("Sound")
    end)
    
    if not success then
        warn("[LXAIL] Failed to create sound")
        return nil
    end
    
    SafePropertySet(sound, "SoundId", soundId)
    SafePropertySet(sound, "Volume", 0.5)
    SafePropertySet(sound, "Parent", SoundService)
    
    local connection = RegisterConnection(sound.Ended:Connect(function()
        LXAIL.SafeCallback(function()
            if ValidateInstance(sound) then
                sound:Destroy()
            end
        end)
    end), "SoundEndedConnection")
    
    LXAIL.SafeCallback(function()
        sound:Play()
    end)
    
    return sound
end

local function tween(object, info, properties, callback)
    local isValid, error = ValidateInstance(object)
    if not isValid then
        warn("[LXAIL] Cannot tween invalid object: " .. tostring(error))
        return nil
    end
    
    local success, tweenObj = pcall(function()
        return TweenService:Create(object, info, properties)
    end)
    
    if not success then
        warn("[LXAIL] Failed to create tween: " .. tostring(tweenObj))
        return nil
    end
    
    table.insert(LXAIL._tweens, {
        tween = tweenObj,
        name = "GeneralTween",
        timestamp = tick()
    })
    
    if callback then
        local connection = RegisterConnection(tweenObj.Completed:Connect(function()
            LXAIL.SafeCallback(callback)
        end), "TweenCompletedConnection")
    end
    
    LXAIL.SafeCallback(function()
        tweenObj:Play()
    end)
    
    return tweenObj
end

local function addSectionShadow(section)
    local isValid, error = ValidateInstance(section)
    if not isValid then
        warn("[LXAIL] Cannot add shadow to invalid section: " .. tostring(error))
        return nil
    end
    
    local success, shadow = pcall(function()
        return Instance.new("ImageLabel")
    end)
    
    if not success then
        warn("[LXAIL] Failed to create shadow")
        return nil
    end
    
    SafePropertySet(shadow, "Name", "Shadow")
    SafePropertySet(shadow, "Image", "rbxassetid://1316045217")
    SafePropertySet(shadow, "Size", UDim2.new(1, 0, 1, 0))
    SafePropertySet(shadow, "Position", UDim2.new(0, 0, 0, 3))
    SafePropertySet(shadow, "BackgroundTransparency", 1)
    SafePropertySet(shadow, "ImageTransparency", 0.7)
    SafePropertySet(shadow, "ZIndex", section.ZIndex and section.ZIndex - 1 or 1)
    SafePropertySet(shadow, "ScaleType", Enum.ScaleType.Slice)
    SafePropertySet(shadow, "SliceCenter", Rect.new(10, 10, 118, 118))
    SafePropertySet(shadow, "Parent", section)
    
    return shadow
end

-- === CONFIGURATION MANAGEMENT ===
function LXAIL:SaveConfiguration()
    if not self.ConfigFolder then return end
    
    local configData = {}
    for flag, value in pairs(self.Flags) do
        configData[flag] = value
    end
    
    local success, result = pcall(function()
        return HttpService:JSONEncode(configData)
    end)
    
    if success then
        -- In a real implementation, you'd save to DataStore or external service
        print("Configuration saved:", self.ConfigFolder.FolderName .. "/" .. self.ConfigFolder.FileName)
        self:Notify({
            Title = "Configuration",
            Content = "Settings saved successfully",
            Duration = 2,
            Type = "Success"
        })
    else
        self:Notify({
            Title = "Error",
            Content = "Failed to save configuration",
            Duration = 3,
            Type = "Error"
        })
    end
end

function LXAIL:LoadConfiguration()
    if not self.ConfigFolder then return end
    
    -- In a real implementation, you'd load from DataStore or external service
    print("Loading configuration from:", self.ConfigFolder.FolderName .. "/" .. self.ConfigFolder.FileName)
    self:Notify({
        Title = "Configuration",
        Content = "Settings loaded successfully",
        Duration = 2,
        Type = "Success"
    })
end

function LXAIL:ResetConfiguration()
    self.Flags = {}
    self:Notify({
        Title = "Configuration",
        Content = "Settings reset to defaults",
        Duration = 3,
        Type = "Warning"
    })
end

-- === KEY SYSTEM ===
local function createKeySystem(options)
    local keySystemGui = Instance.new("ScreenGui")
    keySystemGui.Name = "LXAIL_KeySystem"
    keySystemGui.Parent = CoreGui
    keySystemGui.ResetOnSpawn = false
    keySystemGui.IgnoreGuiInset = true
    
    -- Background overlay
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.3
    overlay.BorderSizePixel = 0
    overlay.Parent = keySystemGui
    
    -- Key system window
    local keyWindow = Instance.new("Frame")
    keyWindow.Name = "KeyWindow"
    keyWindow.Size = UDim2.new(0, 400, 0, 300)
    keyWindow.Position = UDim2.new(0.5, -200, 0.5, -150)
    keyWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    keyWindow.BackgroundTransparency = 0.1
    keyWindow.BorderSizePixel = 0
    keyWindow.Parent = overlay
    
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 12)
    windowCorner.Parent = keyWindow
    
    addSectionShadow(keyWindow)
    
    -- Window gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    }
    gradient.Rotation = 90
    gradient.Parent = keyWindow
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = options.Title or "Key System"
    title.TextColor3 = Color3.fromRGB(230, 230, 230)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = keyWindow
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(1, -20, 0, 30)
    subtitle.Position = UDim2.new(0, 10, 0, 60)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = options.Subtitle or "Enter access key"
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    subtitle.TextSize = 16
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Center
    subtitle.Parent = keyWindow
    
    -- Note
    local note = Instance.new("TextLabel")
    note.Name = "Note"
    note.Size = UDim2.new(1, -20, 0, 50)
    note.Position = UDim2.new(0, 10, 0, 100)
    note.BackgroundTransparency = 1
    note.Text = options.Note or "Get your key from our website"
    note.TextColor3 = Color3.fromRGB(150, 150, 150)
    note.TextSize = 14
    note.Font = Enum.Font.Gotham
    note.TextXAlignment = Enum.TextXAlignment.Center
    note.TextWrapped = true
    note.Parent = keyWindow
    
    -- Key input
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Size = UDim2.new(1, -40, 0, 40)
    keyInput.Position = UDim2.new(0, 20, 0, 160)
    keyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    keyInput.BorderSizePixel = 0
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter your key here..."
    keyInput.TextColor3 = Color3.fromRGB(230, 230, 230)
    keyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    keyInput.TextSize = 16
    keyInput.Font = Enum.Font.Gotham
    keyInput.Parent = keyWindow
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = keyInput
    
    -- Key input border
    local keyInputBorder = Instance.new("Frame")
    keyInputBorder.Name = "Border"
    keyInputBorder.Size = UDim2.new(1, 2, 1, 2)
    keyInputBorder.Position = UDim2.new(0, -1, 0, -1)
    keyInputBorder.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    keyInputBorder.BackgroundTransparency = 0.8
    keyInputBorder.BorderSizePixel = 0
    keyInputBorder.ZIndex = keyInput.ZIndex - 1
    keyInputBorder.Parent = keyInput
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 6)
    borderCorner.Parent = keyInputBorder
    
    -- Validate button
    local validateButton = Instance.new("TextButton")
    validateButton.Name = "ValidateButton"
    validateButton.Size = UDim2.new(0, 120, 0, 40)
    validateButton.Position = UDim2.new(0.5, -60, 0, 220)
    validateButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    validateButton.BorderSizePixel = 0
    validateButton.Text = "Validate Key"
    validateButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    validateButton.TextSize = 16
    validateButton.Font = Enum.Font.GothamBold
    validateButton.Parent = keyWindow
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = validateButton
    
    -- Get key button (if URL provided)
    local getKeyButton
    if options.GrabKeyFromSite and options.KeySite then
        getKeyButton = Instance.new("TextButton")
        getKeyButton.Name = "GetKeyButton"
        getKeyButton.Size = UDim2.new(0, 100, 0, 30)
        getKeyButton.Position = UDim2.new(0.5, -50, 0, 270)
        getKeyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        getKeyButton.BorderSizePixel = 0
        getKeyButton.Text = "Get Key"
        getKeyButton.TextColor3 = Color3.fromRGB(230, 230, 230)
        getKeyButton.TextSize = 14
        getKeyButton.Font = Enum.Font.Gotham
        getKeyButton.Parent = keyWindow
        
        local getKeyCorner = Instance.new("UICorner")
        getKeyCorner.CornerRadius = UDim.new(0, 6)
        getKeyCorner.Parent = getKeyButton
        
        getKeyButton.MouseButton1Click:Connect(function()
            -- Open external URL for key
            if options.KeySite then
                pcall(function()
                    -- In a real implementation, this would open a browser or copy URL
                    print("Opening key site:", options.KeySite)
                    LXAIL:Notify({
                        Title = "Key Site",
                        Content = "Check console for key URL",
                        Duration = 3,
                        Type = "Info"
                    })
                end)
            end
        end)
    end
    
    -- Input focus effects
    keyInput.Focused:Connect(function()
        tween(keyInputBorder, TweenInfo.new(0.2), {BackgroundTransparency = 0.4})
    end)
    
    keyInput.FocusLost:Connect(function()
        tween(keyInputBorder, TweenInfo.new(0.2), {BackgroundTransparency = 0.8})
    end)
    
    -- Validation logic
    local function validateKey()
        local enteredKey = keyInput.Text
        local validKeys = options.Key or {"DefaultKey"}
        
        for _, validKey in ipairs(validKeys) do
            if enteredKey == validKey then
                -- Key is valid
                LXAIL.KeyValidated = true
                
                if options.SaveKey then
                    -- Save key for future sessions
                    print("Key saved for future use")
                end
                
                -- Close key system with animation
                tween(keyWindow, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)})
                tween(overlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}, function()
                    keySystemGui:Destroy()
                end)
                
                return true
            end
        end
        
        -- Invalid key
        keyInput.Text = ""
        keyInput.PlaceholderText = "Invalid key, try again..."
        keyInput.PlaceholderColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Shake animation
        local originalPos = keyInput.Position
        tween(keyInput, TweenInfo.new(0.1), {Position = originalPos + UDim2.new(0, 10, 0, 0)})
        wait(0.1)
        tween(keyInput, TweenInfo.new(0.1), {Position = originalPos - UDim2.new(0, 10, 0, 0)})
        wait(0.1)
        tween(keyInput, TweenInfo.new(0.1), {Position = originalPos})
        
        wait(2)
        keyInput.PlaceholderText = "Enter your key here..."
        keyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        
        return false
    end
    
    validateButton.MouseButton1Click:Connect(validateKey)
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            validateKey()
        end
    end)
    
    return keySystemGui
end

-- === NOTIFICATION SYSTEM ===
function LXAIL:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or "No content provided"
    local duration = options.Duration or 3
    local notificationType = options.Type or "Info"
    
    playSound("rbxassetid://131961136")
    
    -- CRITICAL FIX: Create notification container if it doesn't exist (PROTECTED)
    local notificationContainer = nil
    if game then
        -- Create notification container in Roblox environment
        local existingContainer = CoreGui:FindFirstChild("LXAIL_Notifications")
        if not existingContainer then
            local success, gui = pcall(function()
                return Instance.new("ScreenGui")
            end)
            
            if success then
                SafePropertySet(gui, "Name", "LXAIL_Notifications")
                SafePropertySet(gui, "ResetOnSpawn", false)
                SafePropertySet(gui, "IgnoreGuiInset", true)
                SafePropertySet(gui, "Parent", CoreGui)
                notificationContainer = gui
                RegisterScreenGui(gui, "NotificationContainer")
            else
                warn("[LXAIL] Failed to create notification container")
                return
            end
        else
            notificationContainer = existingContainer
        end
    else
        notificationContainer = CoreGui
    end
    
    -- Create notification (extra small size)
    local notification = Instance.new("Frame")
    notification.Name = "LXAILNotification"
    notification.Size = UDim2.new(0, 250, 0, 55)
    notification.Position = UDim2.new(1, -270, 0, 20 + (#self.Notifications * 65))
    notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notification.BorderSizePixel = 0
    notification.Parent = notificationContainer
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notification
    
    addSectionShadow(notification)
    
    -- Gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    }
    gradient.Rotation = 90
    gradient.Parent = notification
    
    -- Type border
    local typeBorder = Instance.new("Frame")
    typeBorder.Name = "TypeBorder"
    typeBorder.Size = UDim2.new(0, 6, 1, 0)
    typeBorder.Position = UDim2.new(0, 0, 0, 0)
    typeBorder.BorderSizePixel = 0
    typeBorder.Parent = notification
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 12)
    borderCorner.Parent = typeBorder
    
    -- Set border color based on type
    local typeColors = {
        Success = Color3.fromRGB(60, 180, 60),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(255, 60, 60),
        Info = Color3.fromRGB(100, 150, 255)
    }
    typeBorder.BackgroundColor3 = typeColors[notificationType] or typeColors.Info
    
    -- Icon (extra small)
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.Position = UDim2.new(0, 10, 0, 13)
    icon.BackgroundTransparency = 1
    icon.TextColor3 = typeBorder.BackgroundColor3
    icon.TextSize = 16
    icon.Font = Enum.Font.GothamBold
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.TextYAlignment = Enum.TextYAlignment.Center
    icon.Parent = notification
    
    -- Set icon based on type
    local typeIcons = {
        Success = "✓",
        Warning = "⚠",
        Error = "✕",
        Info = "ℹ"
    }
    icon.Text = typeIcons[notificationType] or typeIcons.Info
    
    -- Title (extra small)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -50, 0, 16)
    titleLabel.Position = UDim2.new(0, 45, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    titleLabel.Parent = notification
    
    -- Content (extra small)
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "Content"
    contentLabel.Size = UDim2.new(1, -50, 0, 30)
    contentLabel.Position = UDim2.new(0, 45, 0, 22)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    contentLabel.TextSize = 11
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.TextWrapped = true
    contentLabel.Parent = notification
    
    -- Close button (smaller)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 18, 0, 18)
    closeButton.Position = UDim2.new(1, -22, 0, 4)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = notification
    
    -- Animations (adjusted for extra small size)
    notification.Position = UDim2.new(1, 0, 0, 20 + (#self.Notifications * 65))
    tween(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, -270, 0, 20 + (#self.Notifications * 65))
    })
    
    -- Add to notifications list
    table.insert(self.Notifications, notification)
    
    -- Close functionality
    local function closeNotification()
        tween(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 0, 0, notification.Position.Y.Offset)
        }, function()
            notification:Destroy()
            -- Remove from list and reposition others
            for i, notif in ipairs(self.Notifications) do
                if notif == notification then
                    table.remove(self.Notifications, i)
                    break
                end
            end
            
            -- Reposition remaining notifications (adjusted for extra small size)
            for i, notif in ipairs(self.Notifications) do
                tween(notif, TweenInfo.new(0.3), {
                    Position = UDim2.new(1, -270, 0, 20 + ((i-1) * 65))
                })
            end
        end)
    end
    
    closeButton.MouseButton1Click:Connect(closeNotification)
    
    -- Auto-remove after duration
    spawn(function()
        wait(duration)
        if notification.Parent then
            closeNotification()
        end
    end)
end

-- === DISCORD PROMPT SYSTEM ===
function LXAIL:Prompt(options)
    options = options or {}
    local title = options.Title or "Discord Invitation"
    local subTitle = options.SubTitle or "Join our server"
    local content = options.Content or "Join our Discord server for support and updates"
    local actions = options.Actions or {}
    
    local promptGui = Instance.new("ScreenGui")
    promptGui.Name = "LXAILPrompt"
    promptGui.Parent = CoreGui
    promptGui.ResetOnSpawn = false
    
    -- Background overlay
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel = 0
    overlay.Parent = promptGui
    
    -- Prompt window
    local promptWindow = Instance.new("Frame")
    promptWindow.Size = UDim2.new(0, 500, 0, 350)
    promptWindow.Position = UDim2.new(0.5, -250, 0.5, -175)
    promptWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    promptWindow.BorderSizePixel = 0
    promptWindow.Parent = overlay
    
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 12)
    windowCorner.Parent = promptWindow
    
    addSectionShadow(promptWindow)
    
    -- Window gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    }
    gradient.Rotation = 90
    gradient.Parent = promptWindow
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = promptWindow
    
    -- Subtitle
    local subTitleLabel = Instance.new("TextLabel")
    subTitleLabel.Size = UDim2.new(1, -20, 0, 30)
    subTitleLabel.Position = UDim2.new(0, 10, 0, 70)
    subTitleLabel.BackgroundTransparency = 1
    subTitleLabel.Text = subTitle
    subTitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    subTitleLabel.TextSize = 18
    subTitleLabel.Font = Enum.Font.Gotham
    subTitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    subTitleLabel.Parent = promptWindow
    
    -- Content
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -40, 0, 100)
    contentLabel.Position = UDim2.new(0, 20, 0, 120)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    contentLabel.TextSize = 16
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextXAlignment = Enum.TextXAlignment.Center
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.TextWrapped = true
    contentLabel.Parent = promptWindow
    
    -- Action buttons
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -40, 0, 60)
    buttonContainer.Position = UDim2.new(0, 20, 1, -80)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = promptWindow
    
    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    buttonLayout.Padding = UDim.new(0, 20)
    buttonLayout.Parent = buttonContainer
    
    -- Accept button
    if actions.Accept then
        local acceptButton = Instance.new("TextButton")
        acceptButton.Size = UDim2.new(0, 150, 0, 40)
        acceptButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        acceptButton.BorderSizePixel = 0
        acceptButton.Text = actions.Accept.Name or "Accept"
        acceptButton.TextColor3 = Color3.fromRGB(230, 230, 230)
        acceptButton.TextSize = 16
        acceptButton.Font = Enum.Font.GothamBold
        acceptButton.Parent = buttonContainer
        
        local acceptCorner = Instance.new("UICorner")
        acceptCorner.CornerRadius = UDim.new(0, 6)
        acceptCorner.Parent = acceptButton
        
        acceptButton.MouseButton1Click:Connect(function()
            promptGui:Destroy()
            if actions.Accept.Callback then
                actions.Accept.Callback()
            end
        end)
    end
    
    -- Ignore button  
    if actions.Ignore then
        local ignoreButton = Instance.new("TextButton")
        ignoreButton.Size = UDim2.new(0, 150, 0, 40)
        ignoreButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        ignoreButton.BorderSizePixel = 0
        ignoreButton.Text = actions.Ignore.Name or "Ignore"
        ignoreButton.TextColor3 = Color3.fromRGB(230, 230, 230)
        ignoreButton.TextSize = 16
        ignoreButton.Font = Enum.Font.Gotham
        ignoreButton.Parent = buttonContainer
        
        local ignoreCorner = Instance.new("UICorner")
        ignoreCorner.CornerRadius = UDim.new(0, 6)
        ignoreCorner.Parent = ignoreButton
        
        ignoreButton.MouseButton1Click:Connect(function()
            promptGui:Destroy()
            if actions.Ignore.Callback then
                actions.Ignore.Callback()
            end
        end)
    end
    
    -- Animate in
    promptWindow.Size = UDim2.new(0, 0, 0, 0)
    tween(promptWindow, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 500, 0, 350)
    })
end



-- === SCROLL DETECTION HELPER ===
-- Helper function to check if an interaction should be ignored due to scrolling
local function isScrollingInteraction(scrollDetection, minDistance)
    minDistance = minDistance or 5
    
    if scrollDetection.isScrolling then
        return true
    end
    
    if scrollDetection.startPosition and scrollDetection.scrollStartPosition then
        local currentPos = scrollDetection.scrollStartPosition
        local distance = math.abs(currentPos.Y - scrollDetection.scrollStartPosition.Y)
        return distance > minDistance
    end
    
    return false
end

-- Handle mock environment gracefully if `task` is not available
if not task then
    task = {
        delay = function(time, func)
            spawn(function()
                wait(time)
                func()
            end)
            return {}
        end,
        cancel = function(id)
            -- Mock cancel - no operation needed
        end
    }
end

-- === MAIN WINDOW CREATION ===
function LXAIL:CreateWindow(options)
    options = options or {}
    local windowName = options.Name or "LXAIL Window"
    
    -- Handle KeySystem first
    if options.KeySystem and options.KeySystem.Enabled and not self.KeyValidated then
        local keySystemGui = createKeySystem(options.KeySystem)
        
        -- Wait for key validation
        repeat wait(0.1) until self.KeyValidated or not keySystemGui.Parent
        
        if not self.KeyValidated then
            return nil -- Key system was closed without validation
        end
    end
    
    -- Handle configuration saving
    if options.ConfigurationSaving and options.ConfigurationSaving.Enabled then
        self.ConfigFolder = {
            FolderName = options.ConfigurationSaving.FolderName or "LXAIL_Configs",
            FileName = options.ConfigurationSaving.FileName or "config"
        }
    end
    
    -- Handle Discord integration
    if options.Discord and options.Discord.Enabled then
        self.DiscordInvite = options.Discord.Invite
        if options.Discord.RememberJoins then
            -- Check if user has already joined (would be stored in DataStore)
            local hasJoined = false -- In real implementation, check DataStore
            if not hasJoined then
                -- Show Discord prompt after a delay
                spawn(function()
                    wait(2)
                    self:Prompt({
                        Title = "Join our Discord!",
                        SubTitle = "Get support and updates",
                        Content = "Join our Discord server to get help, report bugs, and stay updated with the latest features.",
                        Actions = {
                            Accept = {
                                Name = "Join Discord",
                                Callback = function()
                                    print("Opening Discord invite:", self.DiscordInvite)
                                    self:Notify({
                                        Title = "Discord",
                                        Content = "Opening Discord invitation...",
                                        Duration = 3,
                                        Type = "Info"
                                    })
                                end
                            },
                            Ignore = {
                                Name = "Maybe Later",
                                Callback = function()
                                    print("Discord invitation declined")
                                end
                            }
                        }
                    })
                end)
            end
        end
    end
    
    -- UI Principal (toggleable) - PROTECTED
    local success, mainGui = pcall(function()
        return Instance.new("ScreenGui")
    end)
    
    if not success then
        warn("[LXAIL] Failed to create main GUI")
        return nil
    end
    
    SafePropertySet(mainGui, "Name", "LXAILUI")
    SafePropertySet(mainGui, "Parent", CoreGui)
    SafePropertySet(mainGui, "IgnoreGuiInset", true)
    SafePropertySet(mainGui, "ResetOnSpawn", false)
    SafePropertySet(mainGui, "Enabled", true)
    
    RegisterScreenGui(mainGui, "MainWindow")
    
    -- Background frame
    local bg = Instance.new("Frame")
    bg.Name = "MainContainer"
    bg.Size = UDim2.new(0.6, 0, 0.7, 0)
    bg.Position = UDim2.new(0.2, 0, 0.15, 0)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    bg.BackgroundTransparency = 0.3
    bg.AnchorPoint = Vector2.new(0, 0)
    bg.BorderSizePixel = 0
    bg.Parent = mainGui
    
    -- bg Complements
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 12)
    bgCorner.Parent = bg
    
    local bgShadow = Instance.new("ImageLabel")
    bgShadow.Image = "rbxassetid://1316045217"
    bgShadow.Size = UDim2.new(1, 10, 1, 10)
    bgShadow.Position = UDim2.new(0, -5, 0, -5)
    bgShadow.BackgroundTransparency = 1
    bgShadow.ImageTransparency = 0.85
    bgShadow.ZIndex = 0
    bgShadow.ScaleType = Enum.ScaleType.Slice
    bgShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    bgShadow.Parent = bg
    
    -- bg gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    }
    gradient.Rotation = 90
    gradient.Transparency = NumberSequence.new(0.2)
    gradient.Parent = bg
    
    -- Drag bar
    local dragBar = Instance.new("Frame")
    dragBar.BackgroundTransparency = 1
    dragBar.Size = UDim2.new(1, 0, 0, 50)
    dragBar.Position = UDim2.new(0, 0, 0, 0)
    dragBar.ZIndex = 10
    dragBar.Parent = bg
    
    -- Animated title
    local titleText = windowName or "LXAIL - BETA"
    local startPosTitle = UDim2.new(0, 60, 0, 10)
    local letterSpacing = 22
    local letters = {}
    
    for i = 1, #titleText do
        local char = titleText:sub(i, i)
        local letterLabel = Instance.new("TextLabel")
        letterLabel.Parent = bg
        letterLabel.BackgroundTransparency = 1
        letterLabel.Text = char
        letterLabel.Font = Enum.Font.GothamBlack
        letterLabel.TextSize = 32
        letterLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
        letterLabel.Size = UDim2.new(0, 20, 0, 40)
        letterLabel.Position = startPosTitle + UDim2.new(0, (i-1)*letterSpacing, 0, 0)
        letterLabel.TextXAlignment = Enum.TextXAlignment.Center
        letterLabel.TextYAlignment = Enum.TextYAlignment.Center
        letterLabel.TextTransparency = 1
        letters[#letters+1] = letterLabel
    end
    
    local function animateLetters()
        local fadeInInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local fadeOutInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        while true do
            for _, letter in ipairs(letters) do
                TweenService:Create(letter, fadeInInfo, {TextTransparency = 0}):Play()
                wait(0.1)
            end
            wait(0.6)
            for _, letter in ipairs(letters) do
                TweenService:Create(letter, fadeOutInfo, {TextTransparency = 1}):Play()
                wait(0.1)
            end
            wait(0.6)
        end
    end

    coroutine.wrap(animateLetters)()
    
    -- Close button
    local close = Instance.new("TextButton")
    close.Text = "✕"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 32
    close.TextColor3 = Color3.fromRGB(230, 230, 230)
    close.BackgroundTransparency = 1
    close.Position = UDim2.new(1, -45, 0, 10)
    close.Size = UDim2.new(0, 35, 0, 35)
    close.ZIndex = 2
    close.AutoButtonColor = false
    close.Parent = bg
    
    -- Mouse events (only if available)
    if close.MouseEnter then
        close.MouseEnter:Connect(function()
            tween(close, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 100, 100)})
        end)
    end
    if close.MouseLeave then
        close.MouseLeave:Connect(function()
            tween(close, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(230, 230, 230)})
        end)
    end
    
    -- ScreenGui separado para el botón flotante (siempre visible) - PROTECTED
    local success, buttonGui = pcall(function()
        return Instance.new("ScreenGui")
    end)
    
    if not success then
        warn("[LXAIL] Failed to create toggle button GUI")
        return nil
    end
    
    SafePropertySet(buttonGui, "Name", "ToggleButtonGui")
    SafePropertySet(buttonGui, "Parent", CoreGui)
    SafePropertySet(buttonGui, "IgnoreGuiInset", true)
    SafePropertySet(buttonGui, "ResetOnSpawn", false)
    
    RegisterScreenGui(buttonGui, "ToggleButton")

    local draggableButton = Instance.new("ImageButton")
    draggableButton.Name = "ToggleButton"
    draggableButton.Image = "rbxassetid://100710776166961"
    draggableButton.Size = UDim2.new(0, 40, 0, 40)
    draggableButton.Position = UDim2.new(0, 20, 0, 200)
    draggableButton.BackgroundTransparency = 1
    draggableButton.AnchorPoint = Vector2.new(0, 0)
    draggableButton.ZIndex = 1000
    draggableButton.Parent = buttonGui

    -- Variables para drag y click
    local dragging = false
    local dragStart, startPos
    local dragMoved = false
    
    -- Toggle UI state
    local visible = true

    -- Drag functionality (only if available) - PROTECTED
    if draggableButton.InputBegan then
        local dragConnection = RegisterConnection(draggableButton.InputBegan:Connect(function(input)
            LXAIL.SafeCallback(function()
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragMoved = false
                    dragStart = input.Position
                    startPos = draggableButton.Position
                end
            end)
        end), "DragBeginConnection")
    end

    -- Input handling (only if UserInputService is available) - PROTECTED
    if UserInputService and UserInputService.InputChanged then
        local dragMoveConnection = RegisterConnection(UserInputService.InputChanged:Connect(function(input)
            LXAIL.SafeCallback(function()
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragStart
                    local distance = math.sqrt(delta.X^2 + delta.Y^2)
                    
                    if distance > 5 then
                        dragMoved = true
                        SafePropertySet(draggableButton, "Position", UDim2.new(
                            startPos.X.Scale, startPos.X.Offset + delta.X,
                            startPos.Y.Scale, startPos.Y.Offset + delta.Y
                        ))
                    end
                end
            end)
        end), "DragMoveConnection")
    end

    if UserInputService and UserInputService.InputEnded then
        local dragEndConnection = RegisterConnection(UserInputService.InputEnded:Connect(function(input)
            LXAIL.SafeCallback(function()
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if dragging and not dragMoved then
                        -- Solo fue un click, no drag - hacer toggle
                        spawn(function()
                            LXAIL.SafeCallback(function()
                                -- Animación de click
                                tween(draggableButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 30, 0, 30)})
                                wait(0.1)
                                tween(draggableButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 40, 0, 40)})
                                
                                -- Toggle UI
                                visible = not visible
                                SafePropertySet(mainGui, "Enabled", visible)
                            end)
                        end)
                    end
                    dragging = false
                    dragMoved = false
                end
            end)
        end), "DragEndConnection")
    end
    
    -- Fallback: Use MouseButton1Click if InputBegan is not available
    if not draggableButton.InputBegan and draggableButton.MouseButton1Click then
        draggableButton.MouseButton1Click:Connect(function()
            spawn(function()
                -- Animación de click
                tween(draggableButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 30, 0, 30)})
                wait(0.1)
                tween(draggableButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 40, 0, 40)})
                
                -- Toggle UI
                visible = not visible
                mainGui.Enabled = visible
            end)
        end)
    end

    -- Botón cerrar actualizado - PROTECTED
    local closeConnection = RegisterConnection(close.MouseButton1Click:Connect(function()
        LXAIL.SafeCallback(function()
            SafePropertySet(mainGui, "Enabled", false)
            visible = false
        end)
    end), "CloseButtonConnection")
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    sidebar.BackgroundTransparency = 0.25
    sidebar.Size = UDim2.new(0, 180, 1, -50)
    sidebar.Position = UDim2.new(0, 0, 0, 43)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = bg
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 10)
    sidebarCorner.Parent = sidebar
    
    -- Create scrolling container for tabs
    local tabScrollFrame = Instance.new("ScrollingFrame")
    tabScrollFrame.Size = UDim2.new(1, 0, 1, -70) -- Leave space for profile (60px + 10px padding)
    tabScrollFrame.Position = UDim2.new(0, 0, 0, 0)
    tabScrollFrame.BackgroundTransparency = 1
    tabScrollFrame.BorderSizePixel = 0
    tabScrollFrame.ScrollBarThickness = 4
    tabScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    tabScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    tabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated dynamically
    tabScrollFrame.Parent = sidebar
    
    -- Tab ScrollFrame click/scroll detection
    local tabScrollDetection = {
        isScrolling = false,
        startPosition = nil,
        scrollStartPosition = nil,
        timeoutId = nil
    }
    
    -- Monitor scroll changes for tab scroll frame
    tabScrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if not tabScrollDetection.isScrolling then
            tabScrollDetection.isScrolling = true
            tabScrollDetection.scrollStartPosition = tabScrollFrame.CanvasPosition
            
            -- Reset scrolling flag after a short delay
            if tabScrollDetection.timeoutId then
                task.cancel(tabScrollDetection.timeoutId)
            end
            tabScrollDetection.timeoutId = task.delay(0.1, function()
                tabScrollDetection.isScrolling = false
                tabScrollDetection.scrollStartPosition = nil
            end)
        end
    end)
    
    -- Input handling for tab scroll frame
    if tabScrollFrame.InputBegan then
        tabScrollFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                tabScrollDetection.startPosition = input.Position
                tabScrollDetection.isScrolling = false
            end
        end)
    end
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.Parent = tabScrollFrame
    
    -- Update canvas size when tabs are added
    sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Content panel
    local content = Instance.new("Frame")
    content.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    content.BackgroundTransparency = 0.3
    content.Size = UDim2.new(1, -190, 1, -60)
    content.Position = UDim2.new(0, 190, 0, 55)
    content.BorderSizePixel = 0
    content.Parent = bg
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = content
    
    -- Profile section - positioned at bottom of sidebar
    local profile = Instance.new("Frame")
    profile.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    profile.BackgroundTransparency = 0.25
    profile.Size = UDim2.new(1, 0, 0, 60)
    profile.Position = UDim2.new(0, 0, 1, -60) -- Always at bottom
    profile.BorderSizePixel = 0
    profile.Parent = sidebar
    
    local profileCorner = Instance.new("UICorner")
    profileCorner.CornerRadius = UDim.new(0, 10)
    profileCorner.Parent = profile
    
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 40, 0, 40)
    avatar.Position = UDim2.new(0, 5, 0, 4)
    avatar.BackgroundTransparency = 1
    avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png"
    avatar.Parent = profile
    
    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatar
    
    local pname = Instance.new("TextLabel")
    pname.Text = player.DisplayName
    pname.Font = Enum.Font.GothamBold
    pname.TextSize = 16
    pname.TextColor3 = Color3.fromRGB(230, 230, 230)
    pname.BackgroundTransparency = 1
    pname.Position = UDim2.new(0, 50, 0, 20)
    pname.Size = UDim2.new(1, -55, 0, 20)
    pname.TextXAlignment = Enum.TextXAlignment.Left
    pname.Parent = profile
    
    -- Drag functionality
    local draggingBg = false
    local dragInputBg, dragStartBg, startPosBg
    
    -- Drag functionality for window (only if available)
    if dragBar.InputBegan then
        dragBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingBg = true
                dragStartBg = input.Position
                startPosBg = bg.Position
            end
        end)
    end
    
    -- Window drag handlers (only if UserInputService is available)
    if UserInputService and UserInputService.InputChanged then
        UserInputService.InputChanged:Connect(function(input)
            if draggingBg and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStartBg
                bg.Position = UDim2.new(startPosBg.X.Scale, startPosBg.X.Offset + delta.X, startPosBg.Y.Scale, startPosBg.Y.Offset + delta.Y)
            end
        end)
    end
    
    if UserInputService and UserInputService.InputEnded then
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingBg = false
            end
        end)
    end
    
    -- Window object
    local window = {
        Name = windowName,
        GUI = mainGui,
        MainFrame = bg,
        Sidebar = sidebar,
        TabScrollFrame = tabScrollFrame,
        Content = content,
        Tabs = {},
        TabFrames = {},
        CurrentTab = nil,
        Visible = true
    }
    
    -- Add window to LXAIL
    table.insert(self.Windows, window)
    
    -- Toggle function
    function window:Toggle()
        visible = not visible
        self.GUI.Enabled = visible
        self.Visible = visible
    end
    
    -- CreateTab function
    function window:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or "Tab"
        local tabIcon = tabOptions.Icon
        local visible = tabOptions.Visible ~= false
        
        -- Create tab button
        local tabShadow = Instance.new("Frame")
        tabShadow.Size = UDim2.new(1, 0, 0, 50)
        tabShadow.BackgroundTransparency = 1
        tabShadow.LayoutOrder = #self.Tabs + 1
        tabShadow.Parent = tabScrollFrame
        
        local tab = Instance.new("TextButton")
        tab.Name = "Tab"
        tab.Text = tabName
        tab.Font = Enum.Font.GothamBold
        tab.TextSize = 20
        tab.TextColor3 = Color3.fromRGB(230, 230, 230)
        tab.BackgroundColor3 = (#self.Tabs == 0) and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(35, 35, 35)
        tab.BackgroundTransparency = 0
        tab.Size = UDim2.new(1, -10, 1, -10)
        tab.Position = UDim2.new(0, 5, 0, 5)
        tab.BorderSizePixel = 0
        tab.AutoButtonColor = false
        tab.Parent = tabShadow
        
        local shadow = Instance.new("ImageLabel")
        shadow.Image = "rbxassetid://1316045217"
        shadow.Size = UDim2.new(1, 0, 1, 0)
        shadow.Position = UDim2.new(0, 0, 0, 3)
        shadow.BackgroundTransparency = 1
        shadow.ImageTransparency = 0.7
        shadow.ZIndex = 0
        shadow.Parent = tabShadow
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tab
        
        -- Create tab content frame
        local frame = Instance.new("ScrollingFrame")
        frame.Name = tabName .. "Scroll"
        frame.BackgroundTransparency = 1
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.Visible = (#self.Tabs == 0)
        frame.BorderSizePixel = 0
        frame.ScrollBarThickness = 6
        frame.ScrollingDirection = Enum.ScrollingDirection.Y
        frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        frame.CanvasSize = UDim2.new(0, 0, 0, 0)
        frame.ClipsDescendants = true
        frame.Parent = content
        
        -- Content ScrollFrame click/scroll detection
        local contentScrollDetection = {
            isScrolling = false,
            startPosition = nil,
            scrollStartPosition = nil,
            timeoutId = nil
        }
        
        -- Monitor scroll changes for content scroll frame
        frame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            if not contentScrollDetection.isScrolling then
                contentScrollDetection.isScrolling = true
                contentScrollDetection.scrollStartPosition = frame.CanvasPosition
                
                -- Reset scrolling flag after a short delay
                if contentScrollDetection.timeoutId then
                    task.cancel(contentScrollDetection.timeoutId)
                end
                contentScrollDetection.timeoutId = task.delay(0.1, function()
                    contentScrollDetection.isScrolling = false
                    contentScrollDetection.scrollStartPosition = nil
                end)
            end
        end)
        
        -- Input handling for content scroll frame
        if frame.InputBegan then
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    contentScrollDetection.startPosition = input.Position
                    contentScrollDetection.isScrolling = false
                end
            end)
        end
        
        local list = Instance.new("UIListLayout")
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 10)
        list.HorizontalAlignment = Enum.HorizontalAlignment.Center
        list.Parent = frame
        
        -- Tab object
        local tabObj = {
            Name = tabName,
            Icon = tabIcon,
            Visible = visible,
            Window = window,
            Frame = frame,
            Button = tab,
            Components = {}
        }
        
        -- Add tab to window
        table.insert(self.Tabs, tabObj)
        self.TabFrames[tabName] = frame
        
        if #self.Tabs == 1 then
            self.CurrentTab = tabObj
        end
        
        -- Tab switching with glitch animation (with scroll detection)
        tab.MouseButton1Click:Connect(function()
            -- Check if we're in the middle of scrolling
            if tabScrollDetection.isScrolling then
                return -- Don't switch tabs if we're scrolling
            end
            
            -- Update tab colors
            for _, tabData in pairs(self.Tabs) do
                tabData.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end
            tab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            
            local newTab = frame
            local currentTab = nil
            for _, f in pairs(self.TabFrames) do
                if f.Visible then
                    currentTab = f
                    break
                end
            end
            
            if currentTab and currentTab ~= newTab then
                -- Glitch animation for current tab
                local glitchTween1 = TweenService:Create(currentTab, TweenInfo.new(0.05), {
                    Position = currentTab.Position + UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 0.5,
                    Size = currentTab.Size + UDim2.new(0, 5, 0, 5)
                })
                local glitchTween2 = TweenService:Create(currentTab, TweenInfo.new(0.05), {
                    Position = currentTab.Position + UDim2.new(0, -5, 0, 5),
                    BackgroundTransparency = 0.7,
                    Size = currentTab.Size - UDim2.new(0, 5, 0, 5)
                })
                local glitchTween3 = TweenService:Create(currentTab, TweenInfo.new(0.05), {
                    Position = currentTab.Position,
                    BackgroundTransparency = 1,
                    Size = currentTab.Size
                })
                
                glitchTween1:Play()
                glitchTween1.Completed:Wait()
                glitchTween2:Play()
                glitchTween2.Completed:Wait()
                glitchTween3:Play()
                glitchTween3.Completed:Wait()
                
                currentTab.Visible = false
                currentTab.BackgroundTransparency = 0
                currentTab.Size = UDim2.new(1, 0, 1, 0)
                currentTab.Position = UDim2.new(0, 0, 0, 0)
            end
            
            -- Show new tab with glitch animation
            newTab.Visible = true
            newTab.BackgroundTransparency = 1
            newTab.Size = UDim2.new(1, 0, 1, 0)
            newTab.Position = UDim2.new(0, 0, 0, 0)
            
            local glitchIn1 = TweenService:Create(newTab, TweenInfo.new(0.05), {
                Position = newTab.Position + UDim2.new(0, 5, 0, 0),
                BackgroundTransparency = 0.5,
                Size = newTab.Size + UDim2.new(0, 5, 0, 5)
            })
            local glitchIn2 = TweenService:Create(newTab, TweenInfo.new(0.05), {
                Position = newTab.Position + UDim2.new(0, -5, 0, 5),
                BackgroundTransparency = 0.7,
                Size = newTab.Size - UDim2.new(0, 5, 0, 5)
            })
            local glitchIn3 = TweenService:Create(newTab, TweenInfo.new(0.05), {
                Position = newTab.Position,
                BackgroundTransparency = 0,
                Size = newTab.Size
            })
            
            glitchIn1:Play()
            glitchIn1.Completed:Wait()
            glitchIn2:Play()
            glitchIn2.Completed:Wait()
            glitchIn3:Play()
            
            self.CurrentTab = tabObj
        end)
        
        -- === COMPONENT CREATION FUNCTIONS ===
        
        function tabObj:CreateLabel(options)
            options = options or {}
            local text = options.Text or "Label"
            
            local section = Instance.new("Frame")
            section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            section.BackgroundTransparency = 0.3
            section.Size = UDim2.new(0.95, 0, 0, 40)
            section.BorderSizePixel = 0
            section.LayoutOrder = #self.Components + 1
            section.Parent = frame
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 8)
            sectionCorner.Parent = section
            
            local label = Instance.new("TextLabel")
            label.Text = text
            label.Font = Enum.Font.GothamBold
            label.TextSize = 18
            label.TextColor3 = Color3.fromRGB(240, 240, 240)
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 15, 0, 0)
            label.Size = UDim2.new(1, -30, 1, 0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextYAlignment = Enum.TextYAlignment.Center
            label.Parent = section
            
            local labelObj = {
                Type = "Label",
                Text = text,
                Element = section
            }
            
            table.insert(self.Components, labelObj)
            return labelObj
        end
        
        function tabObj:CreateToggle(options)
            options = options or {}
            local name = options.Name or "Toggle"
            local currentValue = options.CurrentValue or false
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local section = Instance.new("Frame")
            section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            section.BackgroundTransparency = 0.3
            section.Size = UDim2.new(0.95, 0, 0, 40)
            section.BorderSizePixel = 0
            section.LayoutOrder = #self.Components + 1
            section.Parent = frame
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 8)
            sectionCorner.Parent = section
            
            local padding = Instance.new("UIPadding")
            padding.PaddingLeft = UDim.new(0, 10)
            padding.PaddingRight = UDim.new(0, 10)
            padding.Parent = section
            
            local layout = Instance.new("UIListLayout")
            layout.FillDirection = Enum.FillDirection.Horizontal
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 6)
            layout.Parent = section
            
            local label = Instance.new("TextLabel")
            label.Text = name
            label.Font = Enum.Font.GothamBold
            label.TextSize = 18
            label.TextColor3 = Color3.fromRGB(240, 240, 240)
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, -56, 1, 0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.LayoutOrder = 1
            label.Parent = section
            
            local toggle = Instance.new("TextButton")
            toggle.Text = ""
            toggle.Size = UDim2.new(0, 46, 0, 24)
            toggle.BackgroundColor3 = currentValue and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(150, 40, 40)
            toggle.BorderSizePixel = 0
            toggle.AutoButtonColor = false
            toggle.LayoutOrder = 2
            toggle.ClipsDescendants = true
            toggle.Parent = section
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 12)
            toggleCorner.Parent = toggle
            
            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 20, 0, 20)
            circle.Position = currentValue and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
            circle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
            circle.BorderSizePixel = 0
            circle.Name = "Circle"
            circle.Parent = toggle
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = circle
            
            local icon = Instance.new("TextLabel")
            icon.Size = UDim2.new(1, 0, 1, 0)
            icon.BackgroundTransparency = 1
            icon.Text = currentValue and "✔" or ""
            icon.TextColor3 = Color3.fromRGB(60, 180, 60)
            icon.Font = Enum.Font.GothamBold
            icon.TextSize = 14
            icon.Parent = circle
            
            local toggled = currentValue
            
            local function updateToggle()
                local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                if toggled then
                    tween(circle, tweenInfo, {Position = UDim2.new(1, -22, 0, 2)})
                    tween(toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 180, 60)})
                    icon.Text = "✔"
                else
                    tween(circle, tweenInfo, {Position = UDim2.new(0, 2, 0, 2)})
                    tween(toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(150, 40, 40)})
                    icon.Text = ""
                end
                
                if flag then
                    LXAIL.Flags[flag] = toggled
                end
                
                callback(toggled)
            end
            
            toggle.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)
            
            -- Set initial flag value
            if flag then
                LXAIL.Flags[flag] = currentValue
            end
            
            local toggleObj = {
                Type = "Toggle",
                Name = name,
                Value = currentValue,
                Flag = flag,
                Callback = callback,
                Element = section
            }
            
            function toggleObj:Set(value)
                toggled = value
                self.Value = value
                updateToggle()
            end
            
            table.insert(self.Components, toggleObj)
            return toggleObj
        end
        
        function tabObj:CreateSlider(options)
            options = options or {}
            local name = options.Name or "Slider"
            local range = options.Range or {0, 100}
            local increment = options.Increment or 1
            local suffix = options.Suffix or ""
            local currentValue = options.CurrentValue or range[1]
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local section = Instance.new("Frame")
            section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            section.BackgroundTransparency = 0.3
            section.Size = UDim2.new(0.95, 0, 0, 40)
            section.BorderSizePixel = 0
            section.LayoutOrder = #self.Components + 1
            section.Parent = frame
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 8)
            sectionCorner.Parent = section
            
            local padding = Instance.new("UIPadding")
            padding.PaddingLeft = UDim.new(0, 10)
            padding.PaddingRight = UDim.new(0, 10)
            padding.Parent = section
            
            local layout = Instance.new("UIListLayout")
            layout.FillDirection = Enum.FillDirection.Horizontal
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 6)
            layout.Parent = section
            
            local label = Instance.new("TextLabel")
            label.Text = name
            label.Font = Enum.Font.GothamBold
            label.TextSize = 18
            label.TextColor3 = Color3.fromRGB(240, 240, 240)
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(0.45, 0, 1, 0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.LayoutOrder = 1
            label.Parent = section
            
            local sliderBG = Instance.new("Frame")
            sliderBG.Size = UDim2.new(0.4, 0, 0, 6)
            sliderBG.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            sliderBG.BorderSizePixel = 0
            sliderBG.LayoutOrder = 2
            sliderBG.AnchorPoint = Vector2.new(0, 0.5)
            sliderBG.Position = UDim2.new(0, 0, 0.5, 0)
            sliderBG.ClipsDescendants = true
            sliderBG.Parent = section
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 4)
            sliderCorner.Parent = sliderBG
            
            local sliderFG = Instance.new("Frame")
            sliderFG.Size = UDim2.new(0, 0, 1, 0)
            sliderFG.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
            sliderFG.BorderSizePixel = 0
            sliderFG.Parent = sliderBG
            
            local sliderFGCorner = Instance.new("UICorner")
            sliderFGCorner.CornerRadius = UDim.new(0, 4)
            sliderFGCorner.Parent = sliderFG
            
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 14, 0, 14)
            knob.Position = UDim2.new(0, -7, 0.5, 0)
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
            knob.BorderSizePixel = 0
            knob.Parent = sliderBG
            
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = knob
            
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(0.15, 0, 1, -8)
            box.Font = Enum.Font.GothamBold
            box.TextSize = 16
            box.TextColor3 = Color3.fromRGB(230, 230, 230)
            box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            box.BorderSizePixel = 0
            box.Text = tostring(currentValue) .. suffix
            box.LayoutOrder = 3
            box.Parent = section
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 4)
            boxCorner.Parent = box
            
            local draggingSlider = false
            local sliderValue = currentValue
            
            local function setSlider(value)
                value = math.clamp(value, range[1], range[2])
                value = math.round(value / increment) * increment
                sliderValue = value
                
                local percentage = (value - range[1]) / (range[2] - range[1])
                local px = percentage * sliderBG.AbsoluteSize.X
                
                tween(sliderFG, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Size = UDim2.new(0, px, 1, 0)})
                tween(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = UDim2.new(0, px, 0.5, 0)})
                
                box.Text = tostring(value) .. suffix
                
                if flag then
                    LXAIL.Flags[flag] = value
                end
                
                callback(value)
            end
            
            local function updateSlider(input)
                local rel = math.clamp(input.Position.X - sliderBG.AbsolutePosition.X, 0, sliderBG.AbsoluteSize.X)
                local percentage = rel / sliderBG.AbsoluteSize.X
                local value = range[1] + percentage * (range[2] - range[1])
                setSlider(value)
            end
            
            knob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    draggingSlider = false
                end
            end)
            
            sliderBG.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    updateSlider(input)
                end
            end)
            
            -- Handle text input to update slider
            box.FocusLost:Connect(function()
                local text = box.Text
                -- Remove suffix if present
                if suffix ~= "" and text:sub(-#suffix) == suffix then
                    text = text:sub(1, -#suffix-1)
                end
                local val = tonumber(text)
                if val then
                    setSlider(val)
                else
                    box.Text = tostring(sliderValue) .. suffix
                end
            end)
            
            -- Optional: Update while typing (on Enter key)
            box.Focused:Connect(function()
                -- Allow immediate update when Enter is pressed
            end)
            
            -- Handle Enter key press for immediate update
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
                    if box:IsFocused() then
                        local text = box.Text
                        -- Remove suffix if present
                        if suffix ~= "" and text:sub(-#suffix) == suffix then
                            text = text:sub(1, -#suffix-1)
                        end
                        local val = tonumber(text)
                        if val then
                            setSlider(val)
                            box:ReleaseFocus()
                        end
                    end
                end
            end)
            
            -- Set initial value
            setSlider(currentValue)
            
            local sliderObj = {
                Type = "Slider",
                Name = name,
                Range = range,
                Increment = increment,
                Suffix = suffix,
                Value = currentValue,
                Flag = flag,
                Callback = callback,
                Element = section
            }
            
            function sliderObj:Set(value)
                setSlider(value)
                self.Value = value
            end
            
            table.insert(self.Components, sliderObj)
            return sliderObj
        end
        
        function tabObj:CreateButton(options)
            options = options or {}
            local name = options.Name or "Button"
            local callback = options.Callback or function() end
            
            local section = Instance.new("Frame")
            section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            section.BackgroundTransparency = 0.3
            section.Size = UDim2.new(0.95, 0, 0, 50)
            section.BorderSizePixel = 0
            section.LayoutOrder = #self.Components + 1
            section.Parent = frame
            
            addSectionShadow(section)
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 8)
            sectionCorner.Parent = section
            
            local label = Instance.new("TextLabel")
            label.Text = name
            label.Font = Enum.Font.GothamBold
            label.TextSize = 20
            label.TextColor3 = Color3.fromRGB(240, 240, 240)
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 15, 0, 0)
            label.Size = UDim2.new(0.7, -15, 1, 0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextYAlignment = Enum.TextYAlignment.Center
            label.Parent = section
            
            local btn = Instance.new("TextButton")
            btn.Text = "Execute"
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 18
            btn.TextColor3 = Color3.fromRGB(60, 180, 60)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.Size = UDim2.new(0, 80, 0, 35)
            btn.Position = UDim2.new(1, -90, 0.5, -17)
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = true
            btn.Parent = section
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            btn.MouseEnter:Connect(function()
                tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 220, 60)})
            end)
            btn.MouseLeave:Connect(function()
                tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
            end)
            btn.MouseButton1Click:Connect(function()
                btn.Text = "Done!"
                callback()
                spawn(function()
                    wait(0.5)
                    btn.Text = "Execute"
                end)
            end)
            
            local buttonObj = {
                Type = "Button",
                Name = name,
                Callback = callback,
                Element = section
            }
            
            table.insert(self.Components, buttonObj)
            return buttonObj
        end
        
        function tabObj:CreateInput(options)
            options = options or {}
            local name = options.Name or "Input"
            local placeholderText = options.PlaceholderText or "Enter text..."
            local removeTextAfterFocusLost = options.RemoveTextAfterFocusLost or false
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local section = Instance.new("Frame")
            section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            section.BackgroundTransparency = 0.3
            section.Size = UDim2.new(0.95, 0, 0, 50)
            section.BorderSizePixel = 0
            section.LayoutOrder = #self.Components + 1
            section.Parent = frame
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 8)
            sectionCorner.Parent = section
            
            local label = Instance.new("TextLabel")
            label.Text = name
            label.Font = Enum.Font.GothamBold
            label.TextSize = 18
            label.TextColor3 = Color3.fromRGB(240, 240, 240)
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 15, 0, 5)
            label.Size = UDim2.new(1, -30, 0, 20)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = section
            
            local inputBox = Instance.new("TextBox")
            inputBox.Size = UDim2.new(1, -30, 0, 20)
            inputBox.Position = UDim2.new(0, 15, 0, 25)
            inputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            inputBox.BorderSizePixel = 0
            inputBox.Text = ""
            inputBox.PlaceholderText = placeholderText
            inputBox.TextColor3 = Color3.fromRGB(230, 230, 230)
            inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
            inputBox.TextSize = 16
            inputBox.Font = Enum.Font.Gotham
            inputBox.TextXAlignment = Enum.TextXAlignment.Left
            inputBox.Parent = section
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 4)
            inputCorner.Parent = inputBox
            
            inputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed or not removeTextAfterFocusLost then
                    local text = inputBox.Text
                    
                    if flag then
                        LXAIL.Flags[flag] = text
                    end
                    
                    callback(text)
                    
                    if removeTextAfterFocusLost then
                        inputBox.Text = ""
                    end
                end
            end)
            
            local inputObj = {
                Type = "Input",
                Name = name,
                PlaceholderText = placeholderText,
                RemoveTextAfterFocusLost = removeTextAfterFocusLost,
                Value = "",
                Flag = flag,
                Callback = callback,
                Element = section
            }
            
            function inputObj:Set(value)
                inputBox.Text = tostring(value)
                self.Value = tostring(value)
                if self.Flag then
                    LXAIL.Flags[self.Flag] = self.Value
                end
                self.Callback(self.Value)
            end
            
            table.insert(self.Components, inputObj)
            return inputObj
        end
        
    function tabObj:CreateDropdown(options)
    options = options or {}
    local name = options.Name or "Dropdown"
    local optionsList = options.Options or {"Option 1", "Option 2"}
    local multipleOptions = options.MultipleOptions or false
    local flag = options.Flag
    local callback = options.Callback or function() end

    -- Proper initialization for single vs multiple
    local currentValue
    if multipleOptions then
        currentValue = options.CurrentOption or {}
        if type(currentValue) ~= "table" then
            currentValue = currentValue and {currentValue} or {}
        end
    else
        currentValue = options.CurrentOption or optionsList[1] or "Select..."
    end

    local section = Instance.new("Frame")
    section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    section.BackgroundTransparency = 0.3
    section.Size = UDim2.new(0.95, 0, 0, 50)
    section.BorderSizePixel = 0
    section.LayoutOrder = #self.Components + 1
    section.ClipsDescendants = false -- Allow dropdown to show outside bounds
    section.Parent = frame
    
    -- Expand section size when dropdown is open
    local originalSize = section.Size
    local function expandSection()
        local maxVisibleOptions = 6
        local optionHeight = 34
        local totalHeight = math.min(#optionsList * optionHeight, maxVisibleOptions * optionHeight)
        section.Size = UDim2.new(0.95, 0, 0, 50 + totalHeight + 5)
    end
    
    local function collapseSection()
        section.Size = originalSize
    end

    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 15, 0, 5)
    label.Size = UDim2.new(0.6, -15, 0, 20)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section

    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(0.4, -15, 0, 25)
    dropdownButton.Position = UDim2.new(0.6, 0, 0, 20)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Text = "Select..."
    dropdownButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    dropdownButton.TextSize = 16
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.AutoButtonColor = false
    dropdownButton.Parent = section

    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 4)
    dropdownCorner.Parent = dropdownButton

    local dropdownArrow = Instance.new("TextLabel")
    dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
    dropdownArrow.Position = UDim2.new(1, -20, 0, 0)
    dropdownArrow.BackgroundTransparency = 1
    dropdownArrow.Text = "▼"
    dropdownArrow.TextColor3 = Color3.fromRGB(150, 150, 150)
    dropdownArrow.TextSize = 12
    dropdownArrow.Font = Enum.Font.Gotham
    dropdownArrow.TextXAlignment = Enum.TextXAlignment.Center
    dropdownArrow.Parent = dropdownButton

    local dropdownOpen = false
    local optionsFrame = nil

    local function updateDisplay()
        if multipleOptions then
            if #currentValue > 0 then
                dropdownButton.Text = table.concat(currentValue, ", ")
            else
                dropdownButton.Text = "Select..."
            end
            if flag then LXAIL.Flags[flag] = currentValue end
            callback(currentValue)
        else
            dropdownButton.Text = tostring(currentValue)
            if flag then LXAIL.Flags[flag] = currentValue end
            callback(currentValue)
        end
    end

    local function closeDropdown()
        if optionsFrame then 
            optionsFrame:Destroy() 
            optionsFrame = nil 
        end
        dropdownOpen = false
        tween(dropdownArrow, TweenInfo.new(0.2), {Rotation = 0})
        collapseSection()
    end

    local function createOptionsFrame()
    if optionsFrame then optionsFrame:Destroy() end

    -- Calculate dynamic height based on number of options
    local maxVisibleOptions = 6
    local optionHeight = 34
    local totalHeight = math.min(#optionsList * optionHeight, maxVisibleOptions * optionHeight)
    
    optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "LXAILDropdownOptions"
    optionsFrame.Size = UDim2.new(0, dropdownButton.AbsoluteSize.X, 0, totalHeight)
    
    -- Position relative to the dropdown button within the same parent
    optionsFrame.Position = UDim2.new(0, dropdownButton.Position.X.Offset, 0, dropdownButton.Position.Y.Offset + dropdownButton.Size.Y.Offset + 2)
    optionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    optionsFrame.BorderSizePixel = 1
    optionsFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    optionsFrame.ZIndex = 10000
    optionsFrame.ClipsDescendants = false
    optionsFrame.Parent = section

    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 4)
    optionsCorner.Parent = optionsFrame

    -- Always use ScrollingFrame for consistent behavior
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = (#optionsList > maxVisibleOptions) and 6 or 0
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #optionsList * optionHeight)
    scrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    scrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    scrollingFrame.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    scrollingFrame.Parent = optionsFrame

    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scrollLayout.Padding = UDim.new(0, 1)
    scrollLayout.Parent = scrollingFrame

    for i, option in ipairs(optionsList) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. tostring(i)
        optionButton.Size = UDim2.new(1, (#optionsList > maxVisibleOptions) and -6 or 0, 0, optionHeight - 1)
        optionButton.Position = UDim2.new(0, 0, 0, 0)
        optionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        optionButton.BorderSizePixel = 0
        optionButton.Text = tostring(option)
        optionButton.TextColor3 = Color3.fromRGB(230, 230, 230)
        optionButton.TextSize = 14
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.AutoButtonColor = false
        optionButton.LayoutOrder = i
        optionButton.ZIndex = 1001
        optionButton.Parent = scrollingFrame

        -- Add padding for text
        local textPadding = Instance.new("UIPadding")
        textPadding.PaddingLeft = UDim.new(0, 8)
        textPadding.PaddingRight = UDim.new(0, 8)
        textPadding.Parent = optionButton

        local isSelected = multipleOptions and table.find(currentValue, option) or (currentValue == option)
        if isSelected then
            optionButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        end

        optionButton.MouseEnter:Connect(function()
            local stillSelected = multipleOptions and table.find(currentValue, option) or (currentValue == option)
            if not stillSelected then
                optionButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            end
        end)

        optionButton.MouseLeave:Connect(function()
            local stillSelected = multipleOptions and table.find(currentValue, option) or (currentValue == option)
            optionButton.BackgroundColor3 = stillSelected and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(45, 45, 45)
        end)

        optionButton.MouseButton1Click:Connect(function()
            if multipleOptions then
                local idx = table.find(currentValue, option)
                if idx then
                    table.remove(currentValue, idx)
                else
                    table.insert(currentValue, option)
                end
                updateDisplay()
                -- Update all option buttons in this dropdown
                for _, btn in ipairs(scrollingFrame:GetChildren()) do
                    if btn:IsA("TextButton") and btn.Name:match("Option_") then
                        local sel = table.find(currentValue, btn.Text)
                        btn.BackgroundColor3 = sel and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(45, 45, 45)
                    end
                end
            else
                currentValue = option
                updateDisplay()
                closeDropdown()
            end
        end)
    end
end

    dropdownButton.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        if dropdownOpen then
            expandSection()
            createOptionsFrame()
            tween(dropdownArrow, TweenInfo.new(0.2), {Rotation = 180})
        else
            closeDropdown()
        end
    end)
    
    -- Close dropdown when clicking outside
    if UserInputService and UserInputService.InputBegan then
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dropdownOpen and optionsFrame then
                    -- Check if click is outside the dropdown and dropdown button
                    local mouse = UserInputService:GetMouseLocation()
                    local framePos = optionsFrame.AbsolutePosition
                    local frameSize = optionsFrame.AbsoluteSize
                    local buttonPos = dropdownButton.AbsolutePosition
                    local buttonSize = dropdownButton.AbsoluteSize
                    
                    local outsideDropdown = mouse.X < framePos.X or mouse.X > framePos.X + frameSize.X or 
                                           mouse.Y < framePos.Y or mouse.Y > framePos.Y + frameSize.Y
                    local outsideButton = mouse.X < buttonPos.X or mouse.X > buttonPos.X + buttonSize.X or 
                                         mouse.Y < buttonPos.Y or mouse.Y > buttonPos.Y + buttonSize.Y
                    
                    if outsideDropdown and outsideButton then
                        closeDropdown()
                    end
                end
            end
        end)
    end

    -- Set initial flag value
    if flag then LXAIL.Flags[flag] = currentValue end

    local dropdownObj = {
        Type = "Dropdown",
        Name = name,
        Options = optionsList,
        CurrentOption = currentValue,
        MultipleOptions = multipleOptions,
        Flag = flag,
        Callback = callback,
        Element = section
    }

    function dropdownObj:Set(opt)
        if multipleOptions then
            currentValue = type(opt) == "table" and opt or {opt}
        else
            currentValue = opt
        end
        self.CurrentOption = currentValue
        updateDisplay()
    end

    table.insert(self.Components, dropdownObj)
    updateDisplay()
    return dropdownObj
end
        
        function tabObj:CreateColorPicker(options)
            options = options or {}
            local name = options.Name or "ColorPicker"
            local color = options.Color or Color3.fromRGB(255, 255, 255)
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local section = Instance.new("Frame")
            section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            section.BackgroundTransparency = 0.3
            section.Size = UDim2.new(0.95, 0, 0, 50)
            section.BorderSizePixel = 0
            section.LayoutOrder = #self.Components + 1
            section.Parent = frame
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 8)
            sectionCorner.Parent = section
            
            local label = Instance.new("TextLabel")
            label.Text = name
            label.Font = Enum.Font.GothamBold
            label.TextSize = 18
            label.TextColor3 = Color3.fromRGB(240, 240, 240)
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 15, 0, 5)
            label.Size = UDim2.new(0.7, -15, 0, 20)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = section
            
            local colorButton = Instance.new("TextButton")
            colorButton.Size = UDim2.new(0, 100, 0, 25)
            colorButton.Position = UDim2.new(1, -115, 0, 20)
            colorButton.BackgroundColor3 = color
            colorButton.BorderSizePixel = 0
            colorButton.Text = ""
            colorButton.AutoButtonColor = false
            colorButton.Parent = section
            
            local colorCorner = Instance.new("UICorner")
            colorCorner.CornerRadius = UDim.new(0, 4)
            colorCorner.Parent = colorButton
            
            local colorText = Instance.new("TextLabel")
            colorText.Size = UDim2.new(1, 0, 1, 0)
            colorText.BackgroundTransparency = 1
            colorText.Text = string.format("RGB(%d, %d, %d)", 
                math.floor(color.R * 255), 
                math.floor(color.G * 255), 
                math.floor(color.B * 255))
            colorText.TextColor3 = Color3.fromRGB(230, 230, 230)
            colorText.TextSize = 12
            colorText.Font = Enum.Font.Gotham
            colorText.Parent = colorButton
            
            local currentColor = color
            
            local function updateColor(newColor)
                currentColor = newColor
                colorButton.BackgroundColor3 = newColor
                colorText.Text = string.format("RGB(%d, %d, %d)", 
                    math.floor(newColor.R * 255), 
                    math.floor(newColor.G * 255), 
                    math.floor(newColor.B * 255))
                
                if flag then
                    LXAIL.Flags[flag] = newColor
                end
                
                callback(newColor)
            end
            
            colorButton.MouseButton1Click:Connect(function()
                -- Simple color picker - cycle through preset colors
                local presetColors = {
                    Color3.fromRGB(255, 100, 100),
                    Color3.fromRGB(100, 255, 100),
                    Color3.fromRGB(100, 100, 255),
                    Color3.fromRGB(255, 255, 100),
                    Color3.fromRGB(255, 100, 255),
                    Color3.fromRGB(100, 255, 255),
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(200, 200, 200),
                    Color3.fromRGB(100, 100, 100),
                    Color3.fromRGB(50, 50, 50)
                }
                
                local currentIndex = 1
                for i, presetColor in ipairs(presetColors) do
                    if math.abs(currentColor.R - presetColor.R) < 0.01 and 
                       math.abs(currentColor.G - presetColor.G) < 0.01 and 
                       math.abs(currentColor.B - presetColor.B) < 0.01 then
                        currentIndex = i
                        break
                    end
                end
                
                local nextIndex = (currentIndex % #presetColors) + 1
                updateColor(presetColors[nextIndex])
            end)
            
            -- Set initial flag value
            if flag then
                LXAIL.Flags[flag] = color
            end
            
            local colorPickerObj = {
                Type = "ColorPicker",
                Name = name,
                Color = color,
                Flag = flag,
                Callback = callback,
                Element = section
            }
            
            function colorPickerObj:Set(newColor)
                updateColor(newColor)
                self.Color = newColor
            end
            
            table.insert(self.Components, colorPickerObj)
            return colorPickerObj
        end
        
        function tabObj:CreateKeybind(options)
            options = options or {}
            local name = options.Name or "Keybind"
            local currentKeybind = options.CurrentKeybind or "F"
            local holdToInteract = options.HoldToInteract or false
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local section = Instance.new("Frame")
            section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            section.BackgroundTransparency = 0.3
            section.Size = UDim2.new(0.95, 0, 0, 50)
            section.BorderSizePixel = 0
            section.LayoutOrder = #self.Components + 1
            section.Parent = frame
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 8)
            sectionCorner.Parent = section
            
            local label = Instance.new("TextLabel")
            label.Text = name
            label.Font = Enum.Font.GothamBold
            label.TextSize = 18
            label.TextColor3 = Color3.fromRGB(240, 240, 240)
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 15, 0, 5)
            label.Size = UDim2.new(0.6, -15, 0, 20)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = section
            
            local keybindButton = Instance.new("TextButton")
            keybindButton.Size = UDim2.new(0, 100, 0, 25)
            keybindButton.Position = UDim2.new(1, -115, 0, 20)
            keybindButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            keybindButton.BorderSizePixel = 0
            keybindButton.Text = currentKeybind .. (holdToInteract and " (Hold)" or "")
            keybindButton.TextColor3 = Color3.fromRGB(230, 230, 230)
            keybindButton.TextSize = 14
            keybindButton.Font = Enum.Font.Gotham
            keybindButton.AutoButtonColor = false
            keybindButton.Parent = section
            
            local keybindCorner = Instance.new("UICorner")
            keybindCorner.CornerRadius = UDim.new(0, 4)
            keybindCorner.Parent = keybindButton
            
            local listeningForKey = false
            local currentKey = currentKeybind
            
            local function updateKeybind(newKey)
                currentKey = newKey
                keybindButton.Text = newKey .. (holdToInteract and " (Hold)" or "")
                
                if flag then
                    LXAIL.Flags[flag] = newKey
                end
                
                -- Don't call the callback when setting the key, only when the key is pressed
                print("Keybind updated: " .. name .. " -> " .. newKey)
            end
            
            keybindButton.MouseButton1Click:Connect(function()
                if not listeningForKey then
                    listeningForKey = true
                    keybindButton.Text = "Press a key..."
                    keybindButton.TextColor3 = Color3.fromRGB(255, 255, 100)
                end
            end)
            
            -- Key listening for setting new keybind
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listeningForKey and not gameProcessed then
                    local keyName = input.KeyCode.Name
                    if keyName ~= "Unknown" then
                        updateKeybind(keyName)
                        listeningForKey = false
                        keybindButton.TextColor3 = Color3.fromRGB(230, 230, 230)
                    end
                end
            end)
            
            -- Key detection for executing callback when assigned key is pressed
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not listeningForKey and not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                    local keyName = input.KeyCode.Name
                    if keyName == currentKey then
                        if not holdToInteract then
                            -- Execute callback immediately for non-hold keys
                            callback()
                        end
                    end
                end
            end)
            
            -- Handle hold-to-interact functionality
            if holdToInteract then
                UserInputService.InputEnded:Connect(function(input, gameProcessed)
                    if not listeningForKey and not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                        local keyName = input.KeyCode.Name
                        if keyName == currentKey then
                            -- Execute callback on key release for hold keys
                            callback()
                        end
                    end
                end)
            end
            
            -- Set initial flag value
            if flag then
                LXAIL.Flags[flag] = currentKeybind
            end
            
            local keybindObj = {
                Type = "Keybind",
                Name = name,
                CurrentKeybind = currentKeybind,
                HoldToInteract = holdToInteract,
                Flag = flag,
                Callback = callback,
                Element = section
            }
            
            function keybindObj:Set(newKey)
                updateKeybind(newKey)
                self.CurrentKeybind = newKey
            end
            
            table.insert(self.Components, keybindObj)
            return keybindObj
        end
        
        function tabObj:CreateParagraph(options)
            options = options or {}
            local title = options.Title or "Paragraph"
            local content = options.Content or "No content provided"
            
            local section = Instance.new("Frame")
            section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            section.BackgroundTransparency = 0.3
            section.Size = UDim2.new(0.95, 0, 0, 80)
            section.BorderSizePixel = 0
            section.LayoutOrder = #self.Components + 1
            section.Parent = frame
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 8)
            sectionCorner.Parent = section
            
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Text = title
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextSize = 18
            titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Position = UDim2.new(0, 15, 0, 5)
            titleLabel.Size = UDim2.new(1, -30, 0, 25)
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = section
            
            local contentLabel = Instance.new("TextLabel")
            contentLabel.Text = content
            contentLabel.Font = Enum.Font.Gotham
            contentLabel.TextSize = 16
            contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            contentLabel.BackgroundTransparency = 1
            contentLabel.Position = UDim2.new(0, 15, 0, 30)
            contentLabel.Size = UDim2.new(1, -30, 0, 45)
            contentLabel.TextXAlignment = Enum.TextXAlignment.Left
            contentLabel.TextYAlignment = Enum.TextYAlignment.Top
            contentLabel.TextWrapped = true
            contentLabel.Parent = section
            
            local paragraphObj = {
                Type = "Paragraph",
                Title = title,
                Content = content,
                Element = section
            }
            
            table.insert(self.Components, paragraphObj)
            return paragraphObj
        end
        
        function tabObj:CreateDivider()
            local section = Instance.new("Frame")
            section.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            section.BackgroundTransparency = 0.5
            section.Size = UDim2.new(0.95, 0, 0, 2)
            section.BorderSizePixel = 0
            section.LayoutOrder = #self.Components + 1
            section.Parent = frame
            
            local dividerObj = {
                Type = "Divider",
                Element = section
            }
            
            table.insert(self.Components, dividerObj)
            return dividerObj
        end
        
        return tabObj
    end
    
    return window
end

-- === GLOBAL TOGGLE FUNCTION ===
function LXAIL:Toggle()
    for _, window in ipairs(self.Windows) do
        if window.Toggle then
            window:Toggle()
        end
    end
end

-- === SET THEME FUNCTION ===
function LXAIL:SetTheme(themeName)
    self.CurrentTheme = themeName or "Dark"
    print("Theme set to:", self.CurrentTheme)
end

-- === GLOBAL KEYBIND FOR UI TOGGLE ===
local globalToggleConnection = RegisterConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    LXAIL.SafeCallback(function()
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.G then
            LXAIL:Toggle()
        end
    end)
end), "GlobalToggleConnection")

-- === AUTO-CLEANUP ON GAME CLOSE ===
local Players = game:GetService("Players")
local player = Players.LocalPlayer

player.AncestryChanged:Connect(function(_, parent)
    if not parent then
        -- jugador salió, aquí limpia tu UI o desconecta eventos
        LXAIL:Unload()
    end
end)

local TweenService = game:GetService("TweenService")
function tween(instance, ti, props)
    TweenService:Create(instance, ti, props):Play()
end

-- === INITIALIZATION ===
print("[LXAIL Enhanced] UI Library v" .. LXAIL.Version .. " loaded successfully")
print("[LXAIL Enhanced] Connection management and crash protection enabled")
print("[LXAIL Enhanced] Compatible with Silent Aim and other script hooks")
print("[LXAIL Enhanced] Use LXAIL:Unload() to cleanup when script ends")

return LXAIL