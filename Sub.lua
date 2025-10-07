local UserInputService = game:GetService("UserInputService")
local args = {...}

spawn(function()
	local TweenService = game:GetService("TweenService")
	local LocalPlayer = game:GetService("Players").LocalPlayer

	-- ฟังก์ชันโหลดโลโก้
	local getLogo = function()
		if getcustomasset and writefile then
			if isfile("NormalLogo.png") then
				delfile("NormalLogo.png")
			end
			writefile("NormalLogo.png", game:HttpGet("https://raw.githubusercontent.com/x2-Neptune/Image/main/Normal2.png"))
			return getcustomasset("NormalLogo.png")
		else
			return ""
		end
	end

	local function MakeDraggable(topbarobject, object)
		local Dragging, DragInput, DragStart, StartPosition = nil, nil, nil, nil

		local function Update(input)
			local Delta = input.Position - DragStart
			local pos = UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)
			TweenService:Create(object, TweenInfo.new(0.2), {Position = pos}):Play()
		end

		topbarobject.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPosition = object.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)

		topbarobject.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				DragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == DragInput and Dragging then
				Update(input)
			end
		end)
	end	

	local RoyXUi = args[1]
	if not RoyXUi then return end

	local CoreGui = game:GetService("CoreGui")
	if CoreGui:FindFirstChild("CloseUI") then
		CoreGui:FindFirstChild("CloseUI"):Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local ImageButton = Instance.new("ImageButton")

	ScreenGui.Name = "CloseUI"
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 1000

	Frame.Parent = ScreenGui
	Frame.Active = true
	Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0.08, 0, 0.08, 0)
	Frame.Size = UDim2.new(0, 55, 0, 55)
	Frame.ZIndex = 99999

	UICorner.CornerRadius = UDim.new(1, 0) -- ทำให้กลม
	UICorner.Parent = Frame

	ImageButton.Parent = Frame
	ImageButton.BackgroundTransparency = 1
	ImageButton.Size = UDim2.new(1, 0, 1, 0)
	ImageButton.Image = getLogo()
	ImageButton.ZIndex = 100000

	MakeDraggable(ImageButton, Frame)

	local focus = false

	local function SetUIVisibility(ui, visible)
		for _, v in pairs(ui:GetDescendants()) do
			if v:IsA("GuiObject") then
				v.Visible = visible
			end
		end
		ui.Visible = visible
	end

	ImageButton.MouseButton1Click:Connect(function()
		focus = not focus
		game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
		game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
		TweenService:Create(Frame, TweenInfo.new(0.2), {
			BackgroundColor3 = focus and Color3.fromRGB(200, 60, 60) or Color3.fromRGB(25, 25, 25)
		}):Play()
	end)
end)
