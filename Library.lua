local lib = {}

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local subHolder = false -- ajustar conforme desejar para textSize

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
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local screenGui = PlayerGui:FindFirstChild("NotificationGui")
if not screenGui then
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NotificationGui"
    screenGui.Parent = PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
end

local notificationsFolder = screenGui:FindFirstChild("NotificationsFolder")
if not notificationsFolder then
    notificationsFolder = Instance.new("Folder")
    notificationsFolder.Name = "NotificationsFolder"
    notificationsFolder.Parent = screenGui
end

local function createNotification(text, duration)
    duration = duration or 3

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 300, 0, 60)  -- Aumentado tamanho
    notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notifFrame.BorderSizePixel = 0
    notifFrame.AnchorPoint = Vector2.new(1, 1)
    notifFrame.Position = UDim2.new(1, -70, 1, -120)
    notifFrame.BackgroundTransparency = 1
    notifFrame.Parent = notificationsFolder
    notifFrame.ClipsDescendants = true
    notifFrame.ZIndex = 10
    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 8)

    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Position = UDim2.new(0, 10, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.TextColor3 = Color3.fromRGB(220, 220, 220)
    notifText.Font = Enum.Font.LuckiestGuy
    notifText.TextSize = 22  -- Texto maior para combinar
    notifText.Text = text or "Notificação"
    notifText.TextWrapped = true
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.Parent = notifFrame

    TweenService:Create(notifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

    delay(duration, function()
        local tween = TweenService:Create(notifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Wait()
        notifFrame:Destroy()
    end)
end

-- Exemplo:
createNotification("Notificação maior e mais visível!", 4)

function lib:Window(opts)
    local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.Size = UDim2.new(0, 250, 0, 200)
    Main.Position = UDim2.new(0.5, -125, 0.5, -100)
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
function windowAPI:Dropdown(opts)
    local Container = Instance.new("Frame", Items)
    Container.Size = UDim2.new(0, 215, 0, 32)
    Container.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Container)
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.LuckiestGuy
    Label.TextSize = subHolder and 16 or 17
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Text = opts.Text or "Dropdown"
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextStrokeTransparency = 1

    local Arrow = Instance.new("TextLabel", Container)
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -30, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.Font = Enum.Font.LuckiestGuy
    Arrow.TextSize = subHolder and 16 or 17
    Arrow.TextColor3 = Color3.fromRGB(220, 220, 220)

    local dropdownOpen = false

    local dropdownFrame = Instance.new("Frame", ScreenGui)
    dropdownFrame.Size = UDim2.new(0, 150, 0, 0)
    dropdownFrame.Position = Container.AbsolutePosition + Vector2.new(Container.AbsoluteSize.X + 5, 0)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.ClipsDescendants = true
    Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 7)
    dropdownFrame.Visible = false
    dropdownFrame.ZIndex = 20

    local UIList = Instance.new("UIListLayout", dropdownFrame)
    UIList.Padding = UDim.new(0, 4)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder

    local function closeDropdown()
        dropdownOpen = false
        dropdownFrame.Visible = false
        dropdownFrame:TweenSize(UDim2.new(0, 150, 0, 0), "Out", "Quad", 0.2, true)
        Arrow.Text = "▼"
    end

    local function openDropdown()
        dropdownOpen = true
        dropdownFrame.Visible = true
        dropdownFrame:TweenSize(UDim2.new(0, 150, 0, #opts.Options * 28 + 8), "Out", "Quad", 0.2, true)
        Arrow.Text = "▲"
    end

    Container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dropdownOpen then
                closeDropdown()
            else
                openDropdown()
            end
        end
    end)

    local currentValue = opts.Default or opts.Options[1]
    Label.Text = opts.Text .. ": " .. currentValue

    for i, option in ipairs(opts.Options) do
        local optionBtn = Instance.new("TextButton", dropdownFrame)
        optionBtn.Size = UDim2.new(1, -10, 0, 28)
        optionBtn.Position = UDim2.new(0, 5, 0, (i - 1) * 28 + 4)
        optionBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        optionBtn.BorderSizePixel = 0
        optionBtn.AutoButtonColor = false
        optionBtn.Font = Enum.Font.LuckiestGuy
        optionBtn.TextSize = subHolder and 16 or 17
        optionBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        optionBtn.Text = option
        Instance.new("UICorner", optionBtn).CornerRadius = UDim.new(0, 5)

        optionBtn.MouseEnter:Connect(function()
            optionBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end)
        optionBtn.MouseLeave:Connect(function()
            optionBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)

        optionBtn.MouseButton1Click:Connect(function()
            currentValue = option
            Label.Text = opts.Text .. ": " .. currentValue
            if opts.Callback then
                pcall(opts.Callback, currentValue)
            end
            closeDropdown()
        end)
    end

    updateSize()
end

function windowAPI:Slider(opts)
    local Container = Instance.new("Frame", Items)
    Container.Size = UDim2.new(0, 215, 0, 50)
    Container.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Container)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.LuckiestGuy
    Label.TextSize = subHolder and 16 or 17
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Text = opts.Text or "Slider"
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextStrokeTransparency = 1

    local SliderBar = Instance.new("Frame", Container)
    SliderBar.Size = UDim2.new(1, -24, 0, 12)
    SliderBar.Position = UDim2.new(0, 12, 0, 30)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBar.BorderSizePixel = 0
    SliderBar.ClipsDescendants = true
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(0, 6)

    local Fill = Instance.new("Frame", SliderBar)
    Fill.Size = UDim2.new((opts.Default or 0) / (opts.Max or 100), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.BorderSizePixel = 0
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 6)

    local dragging = false

    local function updateValue(x)
        local relativeX = math.clamp(x - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
        local percent = relativeX / SliderBar.AbsoluteSize.X
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        local value = math.floor((opts.Max or 100) * percent)
        Label.Text = opts.Text .. ": " .. tostring(value)
        if opts.Callback then
            pcall(opts.Callback, value)
        end
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateValue(input.Position.X)
        end
    end)
    SliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    SliderBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input.Position.X)
        end
    end)

    updateSize()
end

    return windowAPI
end

return lib