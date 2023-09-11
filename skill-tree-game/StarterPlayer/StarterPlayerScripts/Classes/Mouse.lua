--Client Mouse Controller
--Ashton
--3.31.23

--Objects--
local mouseController = {}
local userIS = game:GetService("UserInputService")
local repStorage = game:GetService("ReplicatedStorage")
local imageFolder = repStorage:WaitForChild("Images")
local componentsFolder = repStorage:WaitForChild("GUIComponents")
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local tweenService = game:GetService("TweenService")

--Variables--
local images = imageFolder:GetChildren()
local effects = componentsFolder:GetChildren()
local clickInfo = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local clickProp = {Size = UDim2.fromOffset(60, 60), ImageTransparency = 1}


--Map images--
local map = {} do 
	for _, image in pairs(images) do
		map[image.Name] = image
	end
	
	images = map
end

--Map effects--
local map = {} do
	for _, effect in pairs(effects) do
		map[effect.Name] = effect
	end
	
	effects = map
end

--Set Mouse Icon--
function mouseController.setIcon(icon)
	local toIcon = images[icon]
	if toIcon then
		userIS.MouseIcon = toIcon.Texture
	else
		userIS.MouseIcon = ""
	end
end

--Click Effect--
function mouseController.click(color)
	color = color or Color3.fromRGB(255,255,255)
	local mouse = player:GetMouse()
	local clickEffect = effects["ClickEffect"]:Clone()
	clickEffect.ImageColor3 = color
	clickEffect.Parent = gui
	clickEffect.Position = UDim2.fromOffset(mouse.X, mouse.Y)
	
	coroutine.wrap(function()
		local clickTween = tweenService:Create(clickEffect, clickInfo, clickProp)
		clickTween:Play()
		
		clickTween.Completed:Wait()
		clickEffect:Destroy()
	end)()
end

return mouseController