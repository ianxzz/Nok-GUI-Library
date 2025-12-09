local lib = {}

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local subHolder = false

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

    setItemsVisible(true)

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            setItemsVisible(false)
            TweenService:Create(Main, TweenInfo.new(0.2), {Size = UDim2.new(0, 250, 0, 40)}):Play()
            TweenService:Create(Items, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            MinBtn.Text = "+"
        else
            setItemsVisible(true)
            TweenService:Create(Main, TweenInfo.new(0.2), {Size = UDim2.new(0, 250, 0, fullHeight)}):Play()
            TweenService:Create(Items, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 1, -45)}):Play()
            MinBtn.Text = "-"
        end
    end)

    enableDrag(Main, TopBar)

    local api = {}

    function api:Button(opts)
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
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.AutoButtonColor = false
        Btn.Position = UDim2.new(0, 12, 0, 0)

        Btn.MouseButton1Click:Connect(function()
            Btn.TextColor3 = Color3.fromRGB(100, 200, 255)
            task.delay(0.15, function()
                Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            end)
            if opts.Callback then pcall(opts.Callback) end
        end)

        updateSize()
    end

    function api:Toggle(opts)
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

        local state = false
        local function setState(on)
            state = on
            if on then
                Switch.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                Dot:TweenPosition(UDim2.new(1, -18, 0.5, -8))
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                Dot:TweenPosition(UDim2.new(0, 2, 0.5, -8))
                Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            end
            if opts.Callback then pcall(opts.Callback, state) end
        end

        Click.MouseButton1Click:Connect(function()
            setState(not state)
        end)

        updateSize()
    end

    return api
end

function lib.Notify(text, duration)
    duration = duration or 3
    local PlayerGui = Player:WaitForChild("PlayerGui")

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 250, 0, 50)
    notifFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notifFrame.BackgroundTransparency = 0.5
    notifFrame.Parent = PlayerGui
    notifFrame.AnchorPoint = Vector2.new(1, 1)
    notifFrame.Position = UDim2.new(1, -20, 1, -80)
    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", notifFrame)
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.LuckiestGuy
    label.TextSize = 18
    label.Text = text
    label.TextWrapped = true

    notifFrame.BackgroundTransparency = 1
    label.TextTransparency = 1

    TweenService:Create(notifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    task.delay(duration, function()
        TweenService:Create(notifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.3)
        notifFrame:Destroy()
    end)
end

return function()
    return lib
end