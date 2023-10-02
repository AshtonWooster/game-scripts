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
local gameState = player:WaitForChild("GameState")
local charOpen = charSelectFolder:WaitForChild("CharOpen")

--Modules--
local guiManip = require(clientMods:WaitForChild("GuiManip"))
local mouseController = require(clientMods:WaitForChild("Mouse"))

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
