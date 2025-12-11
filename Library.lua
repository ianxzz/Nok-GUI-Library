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
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
	Main.Position = UDim2.new(0, 64, 0, 40)
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

	local MinBtn = Instance.new("TextButton", TopBar)
	MinBtn.Size = UDim2.new(0, 40, 1, 0)
	MinBtn.Position = UDim2.new(1, -40, 0, 0)
	MinBtn.BackgroundTransparency = 1
	MinBtn.Text = "-"
	MinBtn.Font = Enum.Font.LuckiestGuy
	MinBtn.TextSize = subHolder and 16 or 17
	MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
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

		Btn.MouseEnter:Connect(function() Btn.TextColor3 = Color3.fromRGB(255, 255, 255) end)
		Btn.MouseLeave:Connect(function() Btn.TextColor3 = Color3.fromRGB(220, 220, 220) end)

		Btn.MouseButton1Click:Connect(function()
			Btn.TextColor3 = Color3.fromRGB(100, 200, 255)
			task.delay(0.15, function()
				Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				task.delay(0.15, function() Btn.TextColor3 = Color3.fromRGB(220, 220, 220) end)
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

		local state = opts.Default or false
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
		setState(state)
		Click.MouseButton1Click:Connect(function() setState(not state) end)

		updateSize()
		return { Set = setState, Get = function() return state end }
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

		updateSize()
		return { Set = function(self, p) for i,v in pairs(p) do Label[i] = v end end }
	end

	function windowAPI:Dropdown(opts)
		local container = Instance.new("Frame")
		container.Size = UDim2.new(0, 215, 0, 32)
		container.BackgroundTransparency = 1
		container.Parent = Items

		local label = Instance.new("TextLabel", container)
		label.Size = UDim2.new(1, -12, 1, 0)
		label.Position = UDim2.new(0, 12, 0, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.LuckiestGuy
		label.TextSize = subHolder and 16 or 17
		label.TextColor3 = Color3.fromRGB(220, 220, 220)
		label.Text = opts.Text or "Dropdown"
		label.TextXAlignment = Enum.TextXAlignment.Left

		local selectedIndex = 1
		local options = opts.Options or {}
		local dropdownBtn = Instance.new("TextButton", container)
		dropdownBtn.Size = UDim2.new(0, 215, 0, 32)
		dropdownBtn.Position = UDim2.new(0, 0, 0, 32)
		dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		dropdownBtn.BorderSizePixel = 0
		dropdownBtn.Text = options[1] or "Select"
		dropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
		dropdownBtn.Font = Enum.Font.LuckiestGuy
		dropdownBtn.TextSize = subHolder and 16 or 17
		Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0, 7)

		local arrow = Instance.new("TextLabel", dropdownBtn)
		arrow.Size = UDim2.new(0, 30, 1, 0)
		arrow.Position = UDim2.new(1, -35, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = "Down Arrow"
		arrow.TextColor3 = Color3.fromRGB(220, 220, 220)
		arrow.Font = Enum.Font.LuckiestGuy
		arrow.TextSize = 18

		local listContainer = Instance.new("Frame")
		listContainer.Size = UDim2.new(0, 215, 0, 0)
		listContainer.Position = UDim2.new(0, 0, 1, 2)
		listContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		listContainer.BorderSizePixel = 0
		listContainer.ClipsDescendants = true
		listContainer.Visible = false
		Instance.new("UICorner", listContainer).CornerRadius = UDim.new(0, 7)
		listContainer.Parent = dropdownBtn

		local uiList = Instance.new("UIListLayout", listContainer)
		uiList.Padding = UDim.new(0, 2)

		local open = false

		local function toggle()
			open = not open
			listContainer.Visible = open
			TweenService:Create(listContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
				Size = open and UDim2.new(0, 215, 0, math.min(#options * 34, 150)) or UDim2.new(0, 215, 0, 0)
			}):Play()
			arrow.Text = open and "Up Arrow" or "Down Arrow"
		end

		dropdownBtn.MouseButton1Click:Connect(toggle)

		UIS.InputBegan:Connect(function(input)
			if open and input.UserInputType == Enum.UserInputType.MouseButton1 then
				local pos = input.Position
				if not (pos.Y >= listContainer.AbsolutePosition.Y and pos.Y <= listContainer.AbsolutePosition.Y + listContainer.AbsoluteSize.Y and
				        pos.X >= listContainer.AbsolutePosition.X and pos.X <= listContainer.AbsolutePosition.X + listContainer.AbsoluteSize.X) then
					toggle()
				end
			end
		end)

		for i, option in ipairs(options) do
			local btn = Instance.new("TextButton", listContainer)
			btn.Size = UDim2.new(1, -8, 0, 32)
			btn.BackgroundTransparency = 1
			btn.Text = "  " .. option
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.Font = Enum.Font.LuckiestGuy
			btn.TextSize = subHolder and 16 or 17
			btn.TextColor3 = Color3.fromRGB(220, 220, 220)

			btn.MouseEnter:Connect(function() btn.BackgroundTransparency = 0.5 btn.BackgroundColor3 = Color3.fromRGB(70,70,70) end)
			btn.MouseLeave:Connect(function() btn.BackgroundTransparency = 1 end)

			btn.MouseButton1Click:Connect(function()
				selectedIndex = i
				dropdownBtn.Text = option
				toggle()
				if opts.Callback then pcall(opts.Callback, option) end
			end)
		end

		updateSize()

		return {
			Get = function() return options[selectedIndex] end,
			Set = function(val)
				for i,v in ipairs(options) do
					if v == val then
						selectedIndex = i
						dropdownBtn.Text = v
						break
					end
				end
			end
		}
	end

	function windowAPI:Slider(opts)
		local container = Instance.new("Frame")
		container.Size = UDim2.new(0, 215, 0, 50)
		container.BackgroundTransparency = 1
		container.Parent = Items

		local label = Instance.new("TextLabel", container)
		label.Size = UDim2.new(1, -20, 0, 24)
		label.Position = UDim2.new(0, 12, 0, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.LuckiestGuy
		label.TextSize = subHolder and 16 or 17
		label.TextColor3 = Color3.fromRGB(220, 220, 220)
		label.Text = opts.Text or "Slider"
		label.TextXAlignment = Enum.TextXAlignment.Left

		local sliderBar = Instance.new("Frame", container)
		sliderBar.Size = UDim2.new(0, 215, 0, 18)
		sliderBar.Position = UDim2.new(0, 0, 0, 26)
		sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		sliderBar.BorderSizePixel = 0
		Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0, 7)

		local fill = Instance.new("Frame", sliderBar)
		fill.Size = UDim2.new(0, 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		fill.BorderSizePixel = 0
		Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 7)

		local valueLabel = Instance.new("TextLabel", container)
		valueLabel.Size = UDim2.new(0, 50, 0, 20)
		valueLabel.Position = UDim2.new(1, -55, 0, 26)
		valueLabel.BackgroundTransparency = 1
		valueLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
		valueLabel.Font = Enum.Font.LuckiestGuy
		valueLabel.TextSize = subHolder and 16 or 17
		valueLabel.TextXAlignment = Enum.TextXAlignment.Center
		valueLabel.Text = tostring(opts.Default or opts.Min or 0)

		local minValue = opts.Min or 0
		local maxValue = opts.Max or 100
		local step = opts.Step or 1
		local currentValue = opts.Default or minValue

		local dragging = false

		local function updateSlider(x)
			local percent = math.clamp((x - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
			currentValue = minValue + math.floor((maxValue - minValue) * percent / step + 0.5) * step
			currentValue = math.clamp(currentValue, minValue, maxValue)
			fill.Size = UDim2.new(percent, 0, 1, 0)
			valueLabel.Text = tostring(currentValue)
			if opts.Callback then pcall(opts.Callback, currentValue) end
		end

		sliderBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				updateSlider(input.Position.X)
			end
		end)

		sliderBar.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				updateSlider(input.Position.X)
			end
		end)

		UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		fill.Size = UDim2.new((currentValue - minValue)/(maxValue - minValue), 0, 1, 0)
		valueLabel.Text = tostring(currentValue)

		updateSize()

		return {
			Get = function() return currentValue end,
			Set = function(val)
				currentValue = math.clamp(val, minValue, maxValue)
				fill.Size = UDim2.new((currentValue - minValue)/(maxValue - minValue), 0, 1, 0)
				valueLabel.Text = tostring(currentValue)
				if opts.Callback then pcall(opts.Callback, currentValue) end
			end
		}
	end

	return windowAPI
end

return lib