local lib = {}

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function enableDrag(frame, dragArea)
	local dragging, dragInput, startPos, startInputPos
	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startInputPos = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
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
			frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
		end
	end)
end

function lib:Window(opts)
	local ScreenGui = Instance.new("ScreenGui",Player:WaitForChild("PlayerGui"))
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	local Main = Instance.new("Frame")
	Main.Parent = ScreenGui
	Main.Size = UDim2.new(0,250,0,200)
	Main.Position = UDim2.new(0.5,-125,0.5,-100)
	Main.BackgroundColor3 = Color3.fromRGB(22,22,22)
	Main.BorderSizePixel = 0
	Instance.new("UICorner",Main).CornerRadius = UDim.new(0,7)

	local TopBar = Instance.new("Frame",Main)
	TopBar.Size = UDim2.new(1,0,0,40)
	TopBar.BackgroundColor3 = Color3.fromRGB(28,28,28)
	TopBar.BorderSizePixel = 0
	Instance.new("UICorner",TopBar).CornerRadius = UDim.new(0,7)

	local Title = Instance.new("TextLabel",TopBar)
	Title.Text = opts.Text or "Window"
	Title.Font = Enum.Font.LuckiestGuy
	Title.TextSize = 17
	Title.TextColor3 = Color3.fromRGB(255,255,255)
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0,12,0,0)
	Title.Size = UDim2.new(1,-50,1,0)
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local MinBtn = Instance.new("TextButton",TopBar)
	MinBtn.Size = UDim2.new(0,40,1,0)
	MinBtn.Position = UDim2.new(1,-40,0,0)
	MinBtn.BackgroundTransparency = 1
	MinBtn.Text = "-"
	MinBtn.Font = Enum.Font.LuckiestGuy
	MinBtn.TextSize = 17
	MinBtn.TextColor3 = Color3.fromRGB(200,200,200)
	MinBtn.AutoButtonColor = false

	local minimized = false
	local fullHeight = 200

	local Items = Instance.new("Frame",Main)
	Items.BackgroundTransparency = 1
	Items.Position = UDim2.new(0,0,0,45)
	Items.Size = UDim2.new(1,0,1,-45)

	local UIList = Instance.new("UIListLayout",Items)
	UIList.Padding = UDim.new(0,8)
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local function updateSize()
		local newHeight = math.clamp(UIList.AbsoluteContentSize.Y + 80,120,350)
		if not minimized then
			Main:TweenSize(UDim2.new(0,250,0,newHeight),"Out","Quad",0.15,true)
			fullHeight = newHeight
		end
	end
	UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

	local function setItemsVisible(v)
		for _,c in Items:GetChildren() do
			if c:IsA("Frame") then
				c.Visible = v
				for _,s in c:GetChildren() do
					if s:IsA("GuiButton") or s:IsA("TextLabel") then
						s.Visible = v
						if s:IsA("GuiButton") then s.Active = v end
					end
				end
			end
		end
	end

	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			setItemsVisible(false)
			TweenService:Create(Main,TweenInfo.new(0.2),{Size=UDim2.new(0,250,0,40)}):Play()
			TweenService:Create(Items,TweenInfo.new(0.15),{Size=UDim2.new(1,0,0,0)}):Play()
			MinBtn.Text = "+"
		else
			setItemsVisible(true)
			TweenService:Create(Main,TweenInfo.new(0.2),{Size=UDim2.new(0,250,0,fullHeight)}):Play()
			TweenService:Create(Items,TweenInfo.new(0.15),{Size=UDim2.new(1,0,1,-45)}):Play()
			MinBtn.Text = "-"
		end
	end)

	enableDrag(Main,TopBar)

	local api = {}

	function api:Button(opts)
		local f = Instance.new("Frame",Items)
		f.Size = UDim2.new(0,215,0,32)
		f.BackgroundTransparency = 1
		local b = Instance.new("TextButton",f)
		b.Size = UDim2.new(1,0,1,0)
		b.BackgroundTransparency = 1
		b.Text = opts.Text or "Button"
		b.Font = Enum.Font.LuckiestGuy
		b.TextSize = 17
		b.TextColor3 = Color3.fromRGB(220,220,220)
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.Position = UDim2.new(0,12,0,0)
		b.MouseEnter:Connect(function()b.TextColor3=Color3.fromRGB(255,255,255)end)
		b.MouseLeave:Connect(function()b.TextColor3=Color3.fromRGB(220,220,220)end)
		b.MouseButton1Click:Connect(function()
			b.TextColor3 = Color3.fromRGB(100,200,255)
			task.delay(0.15,function()b.TextColor3=Color3.fromRGB(255,255,255)task.delay(0.15,function()b.TextColor3=Color3.fromRGB(220,220,220)end)end)
			if opts.Callback then pcall(opts.Callback) end
		end)
		updateSize()
	end

	function api:Toggle(opts)
		local c = Instance.new("Frame",Items)
		c.Size = UDim2.new(0,215,0,32)
		c.BackgroundTransparency = 1
		local l = Instance.new("TextLabel",c)
		l.Size = UDim2.new(1,-60,1,0)
		l.Position = UDim2.new(0,12,0,0)
		l.BackgroundTransparency = 1
		l.Font = Enum.Font.LuckiestGuy
		l.TextSize = 17
		l.TextColor3 = Color3.fromRGB(220,220,220)
		l.Text = opts.Text or "Toggle"
		l.TextXAlignment = Enum.TextXAlignment.Left
		local s = Instance.new("Frame",c)
		s.Size = UDim2.new(0,40,0,18)
		s.Position = UDim2.new(1,-50,0.5,-9)
		s.BackgroundColor3 = Color3.fromRGB(60,60,60)
		Instance.new("UICorner",s).CornerRadius = UDim.new(1,0)
		local d = Instance.new("Frame",s)
		d.Size = UDim2.new(0,16,0,16)
		d.Position = UDim2.new(0,2,0.5,-8)
		d.BackgroundColor3 = Color3.fromRGB(200,200,200)
		Instance.new("UICorner",d).CornerRadius = UDim.new(1,0)
		local cl = Instance.new("TextButton",c)
		cl.Size = UDim2.new(1,0,1,0)
		cl.BackgroundTransparency = 1
		cl.Text = ""
		local state = opts.Default or false
		local function set(v)
			state = v
			if v then
				s.BackgroundColor3 = Color3.fromRGB(0,170,255)
				d:TweenPosition(UDim2.new(1,-18,0.5,-8),"Out","Quad",0.12)
				l.TextColor3 = Color3.fromRGB(255,255,255)
			else
				s.BackgroundColor3 = Color3.fromRGB(60,60,60)
				d:TweenPosition(UDim2.new(0,2,0.5,-8),"Out","Quad",0.12)
				l.TextColor3 = Color3.fromRGB(220,220,220)
			end
			if opts.Callback then pcall(opts.Callback,state) end
		end
		set(state)
		cl.MouseButton1Click:Connect(function()set(not state)end)
		updateSize()
		return {Set=set,Get=function()return state end}
	end

	function api:Label(opts)
		local f = Instance.new("Frame",Items)
		f.Size = UDim2.new(0,215,0,24)
		f.BackgroundTransparency = 1
		local l = Instance.new("TextLabel",f)
		l.Size = UDim2.new(1,0,1,0)
		l.BackgroundTransparency = 1
		l.Font = Enum.Font.LuckiestGuy
		l.TextSize = 17
		l.TextColor3 = opts.Color or Color3.fromRGB(220,220,220)
		l.Text = opts.Text or "Label"
		l.TextXAlignment = Enum.TextXAlignment.Left
		updateSize()
		return {Set=function(p)for i,v in pairs(p)do l[i]=v end end}
	end

	function api:Dropdown(opts)
		local container = Instance.new("Frame")
		container.Size = UDim2.new(0,215,0,56)
		container.BackgroundTransparency = 1
		container.Parent = Items

		local label = Instance.new("TextLabel",container)
		label.Size = UDim2.new(1,-20,0,24)
		label.Position = UDim2.new(0,12,0,0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.LuckiestGuy
		label.TextSize = 17
		label.TextColor3 = Color3.fromRGB(220,220,220)
		label.Text = opts.Text or "Dropdown"
		label.TextXAlignment = Enum.TextXAlignment.Left

		local btn = Instance.new("TextButton",container)
		btn.Size = UDim2.new(0,215,0,32)
		btn.Position = UDim2.new(0,0,0,26)
		btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
		btn.Text = opts.Options and opts.Options[1] or "Select"
		btn.TextColor3 = Color3.fromRGB(220,220,220)
		btn.Font = Enum.Font.LuckiestGuy
		btn.TextSize = 17
		Instance.new("UICorner",btn).CornerRadius = UDim.new(0,7)

		local arrow = Instance.new("TextLabel",btn)
		arrow.Size = UDim2.new(0,30,1,0)
		arrow.Position = UDim2.new(1,-35,0,0)
		arrow.BackgroundTransparency = 1
		arrow.Text = "Down Arrow"
		arrow.TextColor3 = Color3.fromRGB(220,220,220)
		arrow.Font = Enum.Font.LuckiestGuy
		arrow.TextSize = 18

		local listHolder = Instance.new("Frame")
		listHolder.Size = UDim2.new(0,140,0,150)
		listHolder.BackgroundColor3 = Color3.fromRGB(40,40,40)
		listHolder.ClipsDescendants = true
		listHolder.Visible = false
		Instance.new("UICorner",listHolder).CornerRadius = UDim.new(0,7)
		listHolder.Parent = ScreenGui

		local scrolling = Instance.new("ScrollingFrame",listHolder)
		scrolling.Size = UDim2.new(1,0,1,0)
		scrolling.BackgroundTransparency = 1
		scrolling.BorderSizePixel = 0
		scrolling.ScrollBarThickness = 6
		scrolling.ScrollBarImageColor3 = Color3.fromRGB(100,100,100)

		local layout = Instance.new("UIListLayout",scrolling)
		layout.Padding = UDim.new(0,2)

		local open = false
		local selected = 1
		local options = opts.Options or {}

		local function reposition()
			local mainPos = Main.AbsolutePosition
			local mainSize = Main.AbsoluteSize
			local btnPos = btn.AbsolutePosition
			listHolder.Position = UDim2.new(0,mainPos.X + mainSize.X + 5,0,btnPos.Y)
		end

		local function toggle()
			open = not open
			listHolder.Visible = open
			if open then
				reposition()
				scrolling.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
			end
			arrow.Text = open and "Up Arrow" or "Down Arrow"
		end

		btn.MouseButton1Click:Connect(toggle)

		UIS.InputBegan:Connect(function(i)
			if open and i.UserInputType == Enum.UserInputType.MouseButton1 then
				local p = i.Position
				local la = listHolder.AbsolutePosition
				local ls = listHolder.AbsoluteSize
				local ba = btn.AbsolutePosition
				local bs = btn.AbsoluteSize
				if not (p.X >= la.X and p.X <= la.X+ls.X and p.Y >= la.Y and p.Y <= la.Y+ls.Y or
				        p.X >= ba.X and p.X <= ba.X+bs.X and p.Y >= ba.Y and p.Y <= ba.Y+bs.Y) then
					toggle()
				end
			end
		end)

		Main:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			if open then reposition() end
		end)

		for i,opt in ipairs(options) do
			local b = Instance.new("TextButton",scrolling)
			b.Size = UDim2.new(1,-8,0,32)
			b.BackgroundTransparency = 1
			b.Text = "  "..opt
			b.TextXAlignment = Enum.TextXAlignment.Left
			b.Font = Enum.Font.LuckiestGuy
			b.TextSize = 17
			b.TextColor3 = Color3.fromRGB(220,220,220)
			b.MouseEnter:Connect(function()b.BackgroundTransparency=0.5 b.BackgroundColor3=Color3.fromRGB(70,70,70)end)
			b.MouseLeave:Connect(function()b.BackgroundTransparency=1 end)
			b.MouseButton1Click:Connect(function()
				selected = i
				btn.Text = opt
				toggle()
				if opts.Callback then pcall(opts.Callback,opt) end
			end)
		end

		updateSize()

		return {
			Get = function() return options[selected] end,
			Set = function(v)
				for i,o in ipairs(options) do
					if o == v then selected = i btn.Text = v break end
				end
			end
		}
	end

	function api:Slider(opts)
		local container = Instance.new("Frame")
		container.Size = UDim2.new(0,215,0,50)
		container.BackgroundTransparency = 1
		container.Parent = Items

		local label = Instance.new("TextLabel",container)
		label.Size = UDim2.new(1,-20,0,24)
		label.Position = UDim2.new(0,12,0,0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.LuckiestGuy
		label.TextSize = 17
		label.TextColor3 = Color3.fromRGB(220,220,220)
		label.Text = opts.Text or "Slider"
		label.TextXAlignment = Enum.TextXAlignment.Left

		local bar = Instance.new("Frame",container)
		bar.Size = UDim2.new(0,215,0,18)
		bar.Position = UDim2.new(0,0,0,26)
		bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
		Instance.new("UICorner",bar).CornerRadius = UDim.new(0,7)

		local fill = Instance.new("Frame",bar)
		fill.Size = UDim2.new(0,0,1,0)
		fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
		Instance.new("UICorner",fill).CornerRadius = UDim.new(0,7)

		local valLabel = Instance.new("TextLabel",container)
		valLabel.Size = UDim2.new(0,50,0,20)
		valLabel.Position = UDim2.new(1,-55,0,26)
		valLabel.BackgroundTransparency = 1
		valLabel.TextColor3 = Color3.fromRGB(220,220,220)
		valLabel.Font = Enum.Font.LuckiestGuy
		valLabel.TextSize = 17
		valLabel.TextXAlignment = Enum.TextXAlignment.Center
		valLabel.Text = tostring(opts.Default or opts.Min or 0)

		local minV = opts.Min or 0
		local maxV = opts.Max or 100
		local step = opts.Step or 1
		local cur = opts.Default or minV

		local dragging = false
		local function update(x)
			local pct = math.clamp((x - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
			cur = minV + math.floor((maxV-minV)*pct/step + 0.5)*step
			cur = math.clamp(cur,minV,maxV)
			fill.Size = UDim2.new(pct,0,1,0)
			valLabel.Text = tostring(cur)
			if opts.Callback then pcall(opts.Callback,cur) end
		end

		bar.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				update(i.Position.X)
			end
		end)
		bar.InputChanged:Connect(function(i)
			if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				update(i.Position.X)
			end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		fill.Size = UDim2.new((cur-minV)/(maxV-minV),0,1,0)
		valLabel.Text = tostring(cur)
		updateSize()

		return {
			Get = function() return cur end,
			Set = function(v)
				cur = math.clamp(v,minV,maxV)
				fill.Size = UDim2.new((cur-minV)/(maxV-minV),0,1,0)
				valLabel.Text = tostring(cur)
				if opts.Callback then pcall(opts.Callback,cur) end
			end
		}
	end

	return api
end

return lib