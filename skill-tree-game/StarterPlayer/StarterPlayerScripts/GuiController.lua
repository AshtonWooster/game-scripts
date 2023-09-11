--Client Gui Controller
--Ashton
--9.18.22 -- 9.11.23

--Objects--
local repStorage = game:GetService("ReplicatedStorage")
local events = repStorage:WaitForChild("Events")
local joinEvent = events:WaitForChild("Join")
local adminEvent = events:WaitForChild("Admin")

--fire loaded event--
joinEvent:FireServer()

--Connect admin script--
adminEvent.OnClientEvent:Connect(function(perms)
	script.Parent:WaitForChild("AdminScript").Enabled = perms
end)