--Client Main Menu Controller
--Ashton
--9.11.23

--Objects--
local player = game.Players.LocalPlayer
local gameState = player:WaitForChild("GameState")
local gui = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local menu = gui:WaitForChild("Menu")
local joinButton = menu:WaitForChild("Join")
local repStorage = game:GetService("ReplicatedStorage")
local events = repStorage:WaitForChild("Events")
local menuEvent = events:WaitForChild("Menu")

--If loaded, hide join button
joinButton.Visible = gameState.Value == "Menu"

--Spawn when join button hit--
joinButton.Activated:Connect(function()
	menuEvent:FireServer()
	joinButton.Visible = false
end)