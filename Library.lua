local lib = {}

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local subHolder = false -- para ajustar TextSize, se quiser

local function enableDrag(frame, dragArea)
    local dragging, dragInput, startPos, startInputPos
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - startInputPos
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function lib:Window(opts)
    local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.Size = UDim2.new(0, 250, 0, 200)
    Main.Position = opts.Position or UDim2.new(0, 64, 0, 40) -- posição customizável
    Main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 7)

    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    TopBar.BorderSizePixel = 0
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 7)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = opts.Text or "Window"
    Title.Font = Enum.Font.LuckiestGuy
    Title.TextSize = subHolder and 16 or 17
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextStrokeTransparency = 1

    local MinBtn = Instance.new("TextButton", TopBar)
    MinBtn.Size = UDim2.new(0, 40, 1, 0)
    MinBtn.Position = UDim2.new(1, -40, 0, 0)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "-"
    MinBtn.Font = Enum.Font.LuckiestGuy
    MinBtn.TextSize = subHolder and 16 or 17
    MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinBtn.TextStrokeTransparency = 1
    MinBtn.AutoButtonColor = false

    local minimized = false
    local fullHeight = 200

    local Items = Instance.new("Frame", Main)
    Items.BackgroundTransparency = 1
    Items.Position = UDim2.new(0, 0, 0, 45)
    Items.Size = UDim2.new(1, 0, 1, -45)

    local UIList = Instance.new("UIListLayout", Items)
    UIList.Padding = UDim.new(0, 8)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local MAX_HEIGHT = 350
    local MIN_HEIGHT = 120

    local function updateSize()
        local contentHeight = UIList.AbsoluteContentSize.Y
        local newHeight = math.clamp(contentHeight + 80, MIN_HEIGHT, MAX_HEIGHT)
        if not minimized then
            Main:TweenSize(UDim2.new(0, 250, 0, newHeight), "Out", "Quad", 0.15, true)
            fullHeight = newHeight
        end
    end

    UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

    local function setItemsVisible(visible)
        for _, child in ipairs(Items:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = visible
                for _, sub in ipairs(child:GetChildren()) do
                    if sub:IsA("GuiButton") or sub:IsA("TextLabel") then
                        sub.Visible = visible
                        if sub:IsA("GuiButton") then
                            sub.Active = visible
                        end
                    end
                end
            end
        end
    end

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            setItemsVisible(false)
            TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 250, 0, 40)}):Play()
            TweenService:Create(Items, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            MinBtn.Text = "+"
        else
            setItemsVisible(true)
            TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 250, 0, fullHeight)}):Play()
            TweenService:Create(Items, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 1, -45)}):Play()
            MinBtn.Text = "-"
        end
    end)

    enableDrag(Main, TopBar)

    local windowAPI = {}

    -- Botão
    function windowAPI:Button(opts)
        local BtnFrame = Instance.new("Frame", Items)
        BtnFrame.Size = UDim2.new(0, 215, 0, 32)
        BtnFrame.BackgroundTransparency = 1

        local Btn = Instance.new("TextButton", BtnFrame)
        Btn.Size = UDim2.new(1, 0, 1, 0)
        Btn.BackgroundTransparency = 1
        Btn.Text = opts.Text or "Button"
        Btn.Font = Enum.Font.LuckiestGuy
        Btn.TextSize = subHolder and 16 or 17
        Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        Btn.AutoButtonColor = false
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.Position = UDim2.new(0, 12, 0, 0)

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

    -- Toggle
    function windowAPI:Toggle(opts)
        local Container = Instance.new("Frame", Items)
        Container.Size = UDim2.new(0, 215, 0, 32)
        Container.BackgroundTransparency = 1

        local Label = Instance.new("TextLabel", Container)
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.LuckiestGuy
        Label.TextSize = subHolder and 16 or 17
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.Text = opts.Text or "Toggle"
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextStrokeTransparency = 1

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
        local function setState(on)
            state = on
            if on then
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

    -- Label
    function windowAPI:Label(opts)
        local LabelFrame = Instance.new("Frame", Items)
        LabelFrame.Size = UDim2.new(0, 215, 0, 24)
        LabelFrame.BackgroundTransparency = 1

        local Label = Instance.new("TextLabel", LabelFrame)
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.LuckiestGuy
        Label.TextSize = subHolder and 16 or 17
        Label.TextColor3 = opts.Color or Color3.fromRGB(220, 220, 220)
        Label.Text = opts.Text or "Label"
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextStrokeTransparency = 1

        updateSize()

        return {
            Set = function(self, properties)
                for prop, val in pairs(properties) do
                    Label[prop] = val
                end
            end
        }
    end

    -- Dropdown
    function windowAPI:Dropdown(opts)
        local container = Instance.new("Frame", Items)
        container.Size = UDim2.new(0, 215, 0, 32)
        container.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.LuckiestGuy
        label.TextSize = 17
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.Text = opts.Text or "Dropdown"
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextStrokeTransparency = 1

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
        currentOption.TextXAlignment = Enum.TextXAlignment.Center
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
            local mainPos = Main.AbsolutePosition
            local mainSize = Main.AbsoluteSize
            local dropdownPos = currentOption.AbsolutePosition
            local dropdownSize = currentOption.AbsoluteSize

            listContainer.Position = UDim2.new(0, mainPos.X + mainSize.X + 5, 0, dropdownPos.Y)
        end

        local function toggleList()
            open = not open
            if open then
                positionList()
                local targetHeight = #options * 30
                TweenService:Create(listContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 130, 0, targetHeight)}):Play()
            else
                TweenService:Create(listContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 130, 0, 0)}):Play()
            end
        end

        UIS.InputBegan:Connect(function(input)
            if open and input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mousePos = input.Position
                local listAbsPos = listContainer.AbsolutePosition
                local listAbsSize = listContainer.AbsoluteSize
                local dropdownAbsPos = currentOption.AbsolutePosition
                local dropdownAbsSize = currentOption.AbsoluteSize

                local function inside(pos, absPos, absSize)
                    return pos.X >= absPos.X and pos.X <= absPos.X + absSize.X and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y
                end

                if not (inside(mousePos, listAbsPos, listAbsSize) or inside(mousePos, dropdownAbsPos, dropdownAbsSize)) then
                    open = false
                    TweenService:Create(listContainer, TweenInfo.new(0.2), {Size = UDim2.new(0, 130, 0, 0)}):Play()
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
            optLabel.Position = UDim2.new(0, 12, 0, 0)

            optLabel.MouseEnter:Connect(function()
                optLabel.BackgroundTransparency = 0.5
                optLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            end)
            optLabel.MouseLeave:Connect(function()
                optLabel.BackgroundTransparency = 1
            end)

            optLabel.MouseButton1Click:Connect(function()
                selectedIndex = i
                currentOption.Text = option
                toggleList()
                if opts.Callback then
                    pcall(opts.Callback, option)
                    if opts.Callback then
                    pcall(opts.Callback, option)
                end
            end
        end)

        updateSize()
    end

    -- Slider
    function windowAPI:Slider(opts)
        local container = Instance.new("Frame", Items)
        container.Size = UDim2.new(0, 215, 0, 40)
        container.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(1, -60, 0, 20)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.LuckiestGuy
        label.TextSize = 17
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.Text = opts.Text or "Slider"
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextStrokeTransparency = 1

        local sliderFrame = Instance.new("Frame", container)
        sliderFrame.Size = UDim2.new(1, -24, 0, 10)
        sliderFrame.Position = UDim2.new(0, 12, 0, 28)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        sliderFrame.BorderSizePixel = 0
        Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 5)

        local fill = Instance.new("Frame", sliderFrame)
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 5)

        local valueLabel = Instance.new("TextLabel", container)
        valueLabel.Size = UDim2.new(0, 40, 0, 20)
        valueLabel.Position = UDim2.new(1, -48, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = Enum.Font.LuckiestGuy
        valueLabel.TextSize = 17
        valueLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        valueLabel.Text = tostring(opts.Default or 0)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.TextStrokeTransparency = 1

        local dragging = false
        local min = opts.Min or 0
        local max = opts.Max or 100
        local step = opts.Step or 1
        local value = opts.Default or min

        local function updateValue(x)
            local relativeX = math.clamp(x - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
            local percent = relativeX / sliderFrame.AbsoluteSize.X
            local newValue = math.floor((min + (max - min) * percent) / step + 0.5) * step
            newValue = math.clamp(newValue, min, max)
            value = newValue
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            valueLabel.Text = tostring(value)
            if opts.Callback then
                pcall(opts.Callback, value)
            end
        end

        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateValue(input.Position.X)
            end
        end)

        sliderFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateValue(input.Position.X)
            end
        end)

        updateSize()
    end

    return windowAPI
end

return lib 
end