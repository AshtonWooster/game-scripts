--Accessories Controller Server
--Ashton
--1.20.23 -- 1.29.23

--Modules--
local valueManip = require(script.Parent:WaitForChild("ValueManip"))

--Objects--
local accessoriesController = {}

--Weld Accessory--
function accessoriesController.WeldModel(weldGroup, toModel, parent)
	local newModel = valueManip.GetChildWithoutName(weldGroup, "ToPart")
	local attachPartName = weldGroup:FindFirstChild("ToPart").Value

	local attachPart = valueManip.GetChildrenOfName(toModel, attachPartName)[1]
	
	assert(attachPart and newModel, "Cannot weld")
	
	newModel = newModel:Clone()
	newModel.Parent = parent or attachPart.Parent
	local bodyAttach = newModel.PrimaryPart
	
	local newWeld = Instance.new("Motor6D")
	newWeld.Name = "BodyAttach"
	newWeld.Parent = attachPart
	newWeld.Part0 = attachPart
	newWeld.Part1 = bodyAttach
end

--Clear All Accessories--
function accessoriesController.RemoveAccessories(player)
	local accessories = {}
	local character = player.Character
	
	if not character then return end
	
	--Find accessories
	for _, obj in pairs(character:GetChildren()) do
		if obj:IsA("Part") then
			local a = obj:FindFirstChild("BodyAttach")
			while a do
				valueManip.RemoveChildOfName(character, a.Part1.Parent.Name)
				a:Destroy()
				
				a = obj:FindFirstChild("BodyAttach")
			end
		end
	end
end

return accessoriesController