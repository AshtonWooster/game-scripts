--Client Camera Manipulator Module
--Ashton
--9.12.23

--Objects--
local camera = {}
local tweenService = game:GetService("TweenService")

--Variables--
local floatTween = nil
local runFloat = true

--Constants--
local FLOAT_INFO = TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

--Freeze camera--
function camera.FreezeCamera(pos, lookPos) 
	local plrCamera = workspace.CurrentCamera
	plrCamera.CameraType = Enum.CameraType.Scriptable

	pos = pos or plrCamera.Position
	if lookPos then
		plrCamera.CFrame = CFrame.new(pos, lookPos)
	else
		plrCamera.CFrame = CFrame.new(pos)
	end
end

--Tween Camera between a list of given CFrame points--
function camera.Float(points, tweenInfo)
	tweenInfo = tweenInfo or FLOAT_INFO
	local plrCamera = workspace.CurrentCamera
	plrCamera.CameraType = Enum.CameraType.Scriptable
	
	plrCamera.CFrame = points[#points]
	coroutine.wrap(function()
		while runFloat and plrCamera.Parent do
			for i, point in pairs(points) do
				if runFloat == false or not plrCamera.Parent then break end
				
				local tweenProps = {CFrame = point}
				floatTween = tweenService:Create(plrCamera, tweenInfo, tweenProps)
				floatTween:Play()
				floatTween.Completed:Wait()
			end
		end
	end)()
end

--Stop Float--
function camera.StopFloat()
	runFloat = false

	local plrCamera = workspace.CurrentCamera
	plrCamera.CameraType = Enum.CameraType.Custom
	if floatTween then
		floatTween:Cancel()
		floatTween:Destroy()
	end
end

return camera