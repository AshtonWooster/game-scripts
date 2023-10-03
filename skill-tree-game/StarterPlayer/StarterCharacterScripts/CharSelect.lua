--Client Character Select Script
--Ashton
--10.1.23

--Objects--
local repStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local clientMods = repStorage:WaitForChild("ClientModules")
local gui = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local charSelectFolder = gui:WaitForChild("CharacterSelect")
local charMenu = charSelectFolder:WaitForChild("SelectMenu")
local charMove = charMenu:WaitForChild("Move")
local charClose = charMenu:WaitForChild("Close")
local scrollFrame = charMenu:WaitForChild("Frame")
local templateImage = scrollFrame:WaitForChild("Template")
local gameState = player:WaitForChild("GameState")
local charOpen = charSelectFolder:WaitForChild("CharOpen")
local classesFolder = repStorage:WaitForChild("Classes")

--Modules--
local guiManip = require(clientMods:WaitForChild("GuiManip"))
local mouseController = require(clientMods:WaitForChild("Mouse"))

--Constants--
local NUM_CHAR_IN_ROW = 5

--Place all char Images--
local templateSize, xOffset, yOffset, offset do
	templateSize = templateImage.Size
	offset = (1 - templateSize.X.Scale * NUM_CHAR_IN_ROW) / (NUM_CHAR_IN_ROW + 1)
	xOffset = templateSize.X.Scale + offset
	yOffset = templateSize.Y.Scale + offset
	
	for i, char in pairs(classesFolder:GetChildren()) do
		local configFolder = char.Config
		local image = configFolder.Image.Value
		local newImage = templateImage:Clone()
		
		newImage.Parent = scrollFrame
		newImage.Image = image
		newImage.Name = tostring(i)
		newImage.Visible = true
		
		newImage.Position = UDim2.fromScale(xOffset * (i % (NUM_CHAR_IN_ROW + 1)), yOffset * math.ceil(i / NUM_CHAR_IN_ROW) - offset/2)
	end
end

--Hide/Show Char Select Menu--
gameState.Changed:Connect(function(value)
	if value == "Lobby" then
		charOpen.Visible = true
	else
		guiManip.HideAll(charSelectFolder)
	end
end)

--Close Menu--
charClose.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		charMenu.Visible = false
		mouseController.click()
	end
end)

--Open Menu--
charOpen.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		charMenu.Visible = not charMenu.Visible
		mouseController.click()
	end
end)

--Connect charMove--
guiManip.ConnectMove(charMove)
