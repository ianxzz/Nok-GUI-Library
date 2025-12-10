local lib = {}

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function dragify(frame, dragArea)
    local dragging, dragInput, startPos, startInputPos
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startInputPos = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - startInputPos
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function createDropdown(Items, Main, ScreenGui, opts, updateSize)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 215, 0, 32)
    container.BackgroundTransparency = 1
    container.Parent = Items

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.LuckiestGuy
    label.TextSize = 17
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Text = opts.Text or "Dropdown"
    label.TextXAlignment = Enum.TextXAlignment.Left

    local selectedIndex = 1
    local options = opts.Options or {}

    local currentOption = Instance.new("TextButton", container)
    currentOption.Size = UDim2.new(0, 130, 1, 0)
    currentOption.Position = UDim2.new(1, -140, 0, 0)
    currentOption.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    currentOption.BorderSizePixel = 0
    currentOption.TextColor3 = Color3.fromRGB(220, 220, 220)
    currentOption.Font = Enum.Font.LuckiestGuy
    currentOption.TextSize = 17
    currentOption.Text = options[selectedIndex] or ""
    currentOption.ClipsDescendants = true
    Instance.new("UICorner", currentOption).CornerRadius = UDim.new(0, 7)

    local arrow = Instance.new("TextLabel", currentOption)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(220, 220, 220)
    arrow.Font = Enum.Font.LuckiestGuy
    arrow.TextSize = 14

    local listContainer = Instance.new("Frame")
    listContainer.Size = UDim2.new(0, 130, 0, 0)
    listContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    listContainer.BorderSizePixel = 0
    listContainer.ClipsDescendants = true
    Instance.new("UICorner", listContainer).CornerRadius = UDim.new(0, 7)
    listContainer.Parent = ScreenGui

    local uiList = Instance.new("UIListLayout", listContainer)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder

    local open = false

    local function positionList()
        local mp = Main.AbsolutePosition
        local ms = Main.AbsoluteSize
        local dp = currentOption.AbsolutePosition
        listContainer.Position = UDim2.new(0, mp.X + ms.X + 5, 0, dp.Y)
    end

    local function toggleList()
        open = not open
        if open then
            positionList()
            TweenService:Create(listContainer, TweenInfo.new(0.2), {Size = UDim2.new(0, 130, 0, #options * 30)}):Play()
        else
            TweenService:Create(listContainer, TweenInfo.new(0.2), {Size = UDim2.new(0, 130, 0, 0)}):Play()
        end
    end

    UIS.InputBegan:Connect(function(input)
        if open and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local m = input.Position
            local lp = listContainer.AbsolutePosition
            local ls = listContainer.AbsoluteSize
            local dp = currentOption.AbsolutePosition
            local ds = currentOption.AbsoluteSize

            local function inside(p, pos, size)
                return p.X >= pos.X and p.X <= pos.X + size.X and p.Y >= pos.Y and p.Y <= pos.Y + size.Y
            end

            if not (inside(m, lp, ls) or inside(m, dp, ds)) then
                toggleList()
            end
        end
    end)

    currentOption.MouseButton1Click:Connect(toggleList)

    for i, option in ipairs(options) do
        local optLabel = Instance.new("TextButton", listContainer)
        optLabel.Size = UDim2.new(1, 0, 0, 30)
        optLabel.BackgroundTransparency = 1
        optLabel.Text = option
        optLabel.Font = Enum.Font.LuckiestGuy
        optLabel.TextSize = 17
        optLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        optLabel.TextXAlignment = Enum.TextXAlignment.Left

        optLabel.MouseButton1Click:Connect(function()
            selectedIndex = i
            currentOption.Text = option
            toggleList()
            if opts.Callback then pcall(opts.Callback, option) end
        end)
    end

    updateSize()
end

function lib:Window(opts)
    local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 250, 0, 200)
    Main.Position = UDim2.new(0, 50, 0, 50)
    Main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 7)

    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 7)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = opts.Text or "Window"
    Title.Font = Enum.Font.LuckiestGuy
    Title.TextSize = 17
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Items = Instance.new("Frame", Main)
    Items.Size = UDim2.new(1, 0, 1, -45)
    Items.Position = UDim2.new(0, 0, 0, 45)
    Items.BackgroundTransparency = 1

    local UIList = Instance.new("UIListLayout", Items)
    UIList.Padding = UDim.new(0, 8)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local MAX_HEIGHT = 350
    local MIN_HEIGHT = 120

    local windowAPI = {}

    local function updateSize()
        local c = UIList.AbsoluteContentSize.Y
        local h = math.clamp(c + 80, MIN_HEIGHT, MAX_HEIGHT)
        Main:TweenSize(UDim2.new(0, 250, 0, h), "Out", "Quad", 0.15)
    end

    UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

    dragify(Main, TopBar)

    windowAPI._Items = Items
    windowAPI._Main = Main
    windowAPI._Gui = ScreenGui
    windowAPI._update = updateSize

    function windowAPI:Dropdown(o)
        createDropdown(Items, Main, ScreenGui, o, updateSize)
    end

    function windowAPI:Button(opts)
        local BtnFrame = Instance.new("Frame", Items)
        BtnFrame.Size = UDim2.new(0, 215, 0, 32)
        BtnFrame.BackgroundTransparency = 1

        local Btn = Instance.new("TextButton", BtnFrame)
        Btn.Size = UDim2.new(1, 0, 1, 0)
        Btn.BackgroundTransparency = 1
        Btn.Text = opts.Text or "Button"
        Btn.Font = Enum.Font.LuckiestGuy
        Btn.TextSize = 17
        Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.Position = UDim2.new(0, 12, 0, 0)
        Btn.AutoButtonColor = false

        Btn.MouseEnter:Connect(function()
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        Btn.MouseLeave:Connect(function()
            Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        end)

        Btn.MouseButton1Click:Connect(function()
            Btn.TextColor3 = Color3.fromRGB(100, 200, 255)
            task.delay(0.15, function()
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                task.delay(0.15, function()
                    Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
                end)
            end)
            if opts.Callback then pcall(opts.Callback) end
        end)

        updateSize()
    end

    function windowAPI:Toggle(opts)
        local Container = Instance.new("Frame", Items)
        Container.Size = UDim2.new(0, 215, 0, 32)
        Container.BackgroundTransparency = 1

        local Label = Instance.new("TextLabel", Container)
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.LuckiestGuy
        Label.TextSize = 17
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.Text = opts.Text or "Toggle"
        Label.TextXAlignment = Enum.TextXAlignment.Left

        local Switch = Instance.new("Frame", Container)
        Switch.Size = UDim2.new(0, 40, 0, 18)
        Switch.Position = UDim2.new(1, -50, 0.5, -9)
        Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Switch.BorderSizePixel = 0
        Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

        local Dot = Instance.new("Frame", Switch)
        Dot.Size = UDim2.new(0, 16, 0, 16)
        Dot.Position = UDim2.new(0, 2, 0.5, -8)
        Dot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

        local Click = Instance.new("TextButton", Container)
        Click.Size = UDim2.new(1, 0, 1, 0)
        Click.BackgroundTransparency = 1
        Click.Text = ""
        Click.AutoButtonColor = false

        local state = false

        local function setState(v)
            state = v
            if v then
                Switch.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                Dot:TweenPosition(UDim2.new(1, -18, 0.5, -8), "Out", "Quad", 0.12)
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                Dot:TweenPosition(UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.12)
                Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            end
            if opts.Callback then pcall(opts.Callback, state) end
        end

        Click.MouseButton1Click:Connect(function()
            Label.TextColor3 = Color3.fromRGB(100, 200, 255)
            task.delay(0.15, function()
                Label.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 220, 220)
            end)
            setState(not state)
        end)

        updateSize()
    end

    function windowAPI:Label(opts)
        local Frame = Instance.new("Frame", Items)
        Frame.Size = UDim2.new(0, 215, 0, 24)
        Frame.BackgroundTransparency = 1

        local Label = Instance.new("TextLabel", Frame)
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.LuckiestGuy
        Label.TextSize = 17
        Label.TextColor3 = opts.Color or Color3.fromRGB(220, 220, 220)
        Label.Text = opts.Text or "Label"
        Label.TextXAlignment = Enum.TextXAlignment.Left

        updateSize()

        return {
            Set = function(_, props)
                for k, v in pairs(props) do
                    Label[k] = v
                end
            end
        }
    end

    function windowAPI:Slider(opts)
        local Container = Instance.new("Frame", Items)
        Container.Size = UDim2.new(0, 215, 0, 50)
        Container.BackgroundTransparency = 1

        local Label = Instance.new("TextLabel", Container)
        Label.Size = UDim2.new(1, -20, 0, 24)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.LuckiestGuy
        Label.TextSize = 17
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.Text = opts.Text or "Slider"
        Label.TextXAlignment = Enum.TextXAlignment.Left

        local Bar = Instance.new("Frame", Container)
        Bar.Size = UDim2.new(0, 215, 0, 18)
        Bar.Position = UDim2.new(0, 0, 0, 26)
        Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Bar.BorderSizePixel = 0
        Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 7)

        local Fill = Instance.new("Frame", Bar)
        Fill.Size = UDim2.new(0, 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        Fill.BorderSizePixel = 0
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 7)

        local Value = Instance.new("TextLabel", Container)
        Value.Size = UDim2.new(0, 50, 0, 20)
        Value.Position = UDim2.new(1, -55, 0, 26)
        Value.BackgroundTransparency = 1
        Value.Font = Enum.Font.LuckiestGuy
        Value.TextSize = 17
        Value.TextColor3 = Color3.fromRGB(220, 220, 220)
        Value.TextXAlignment = Enum.TextXAlignment.Center

        local min = opts.Min or 0
        local max = opts.Max or 100
        local step = opts.Step or 1
        local val = opts.Default or min
        Value.Text = tostring(val)

        local function update(x)
            local r = math.clamp(x - Bar.AbsolutePosition.X, 0, Bar.AbsoluteSize.X)
            local pct = r / Bar.AbsoluteSize.X
            local v = min + math.floor((max - min) * pct / step + 0.5) * step
            v = math.clamp(v, min, max)
            val = v
            Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
            Value.Text = tostring(val)
            if opts.Callback then pcall(opts.Callback, val) end
        end

        local dragging = false

        Bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                update(i.Position.X)
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        Bar.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                update(i.Position.X)
            end
        end)

        updateSize()
    end

    return windowAPI
end

return lib