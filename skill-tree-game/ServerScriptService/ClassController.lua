--Class Controller Server
--Ashton
--1.20.23 -- 2.5.23

--Modules--
local valueManip = require(script.Parent:WaitForChild("ValueManip"))
local accessories = require(script.Parent:WaitForChild("Accessories"))

--Objects--
local players = game:GetService("Players")
local repStorage = game:GetService("ReplicatedStorage")
local classFolder = repStorage:WaitForChild("Classes")

--Variables--
local classes = valueManip.MapChildrenToHash(classFolder)

--Add Class Tag--
players.PlayerAdded:Connect(function(player)
	local newTag = Instance.new("StringValue")
	newTag.Name = "Class"
	newTag.Parent = player
	
	newTag.Changed:Connect(function(value)
		local character = player.Character
		if not character then return end
		
		accessories.RemoveAccessories(player)
		if not valueManip.StringEmpty(value) then
			for _, weldGroup in pairs(valueManip.GetChildrenOfName(classes[value], "WeldGroup")) do
				accessories.WeldModel(weldGroup, character)
			end
		end
	end)
end)