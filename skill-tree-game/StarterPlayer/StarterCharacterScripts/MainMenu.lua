--Client Main Menu Controller
--Ashton
--9.11.23 -- 9.12.23

--Modules--
local cameraManip = require(script.Parent:WaitForChild("Classes"):WaitForChild("Camera"))

--Objects--
local player = game.Players.LocalPlayer
local gameState = player:WaitForChild("GameState")
local gui = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local menu = gui:WaitForChild("Menu")
local joinButton = menu:WaitForChild("Join")
local repStorage = game:GetService("ReplicatedStorage")
local events = repStorage:WaitForChild("Events")
local menuEvent = events:WaitForChild("Menu")
local menuPositions = workspace:WaitForChild("MenuPositions")
local cameraStartPositions = menuPositions:WaitForChild("StartPos"):GetChildren()
local cameraLookPositions = menuPositions:WaitForChild("LookPos")

--Variables--
local cameraPoints = {}

--Set Up CameraPoints--
for _, part in pairs(cameraStartPositions) do
	local i = tonumber(part.Name)
	local startPos = part.Position
	local lookPos = cameraLookPositions:WaitForChild(part.Name).Position
	
	cameraPoints[i] = CFrame.new(startPos, lookPos)
end

--Start Camera Manipulator--
if gameState.Value == "Menu" then
	cameraManip.Float(cameraPoints)

	joinButton.Visible = true
else
	joinButton.Visible = false
end

--Spawn when join button hit--
joinButton.Activated:Connect(function()
	menuEvent:FireServer()
	cameraManip.StopFloat()
	joinButton.Visible = false
end)