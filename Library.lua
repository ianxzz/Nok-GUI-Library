local lib = {}

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local subHolder = false -- ajusta tamanho do texto

local function enableDrag(frame, dragArea)
    local dragging, dragInput, startPos, startInputPos
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
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
    opts = opts or {}
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = opts.Name or "CustomUI"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
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
    Title.Text = opts.Title or "Minha UI"
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
        opts = opts or {}
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
        opts = opts or {}
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

    return windowAPI
end

return lib