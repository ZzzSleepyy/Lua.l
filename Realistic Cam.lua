
local CanToggleMouse = { allowed = true, activationkey = Enum.KeyCode.F }
local CanViewBody = true
local Sensitivity = 0.2
local Smoothness = 0.05
local FieldOfView = 90


local Camera = game.Workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
Mouse.Icon = "http://www.roblox.com/asset/?id=569021388"

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Head = Character:WaitForChild("Head")


local CamPos, TargetCamPos = Camera.CoordinateFrame.p, Camera.CoordinateFrame.p
local AngleX, TargetAngleX = 0, 0
local AngleY, TargetAngleY = 0, 0
local Running = true
local FreeMouse = false


local modelName = "Blackhole"
local model = game.Workspace:FindFirstChild(modelName)

local idleSway = true
local idleSwayIntensity = 3 
local idleSwaySpeed = 0.2 
local idleSwayTimerX = 0
local idleSwayTimerY = 0




function UpdateCharacter()
	for _, v in pairs(Character:GetChildren()) do
		if CanViewBody then
			if v.Name == 'Head' then
				v.LocalTransparencyModifier = 1
				v.CanCollide = false
			end
		else
			if v:IsA('Part') or v:IsA('UnionOperation') or v:IsA('MeshPart') then
				v.LocalTransparencyModifier = 1
				v.CanCollide = false
			end
		end
		if v:IsA('Accessory') or v:IsA('Hat') then
			local handle = v:FindFirstChild('Handle')
			if handle then
				handle.LocalTransparencyModifier = 1
				handle.CanCollide = false
			end
		end
	end
end

function lerp(a, b, c)
	return a + (b - a) * c
end


local func1, func2, func3, func4 = 0, 0, 0, 0
local val, val2, int, int2 = 0, 0, 5, 5
local vect3 = Vector3.new()
local smoothTurnSpeed = 0.1
local bobbing = nil

function onRenderStepped(deltaTime)
	deltaTime = deltaTime * 30
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid or Humanoid.Health <= 0 then
		bobbing:Disconnect()
		return
	end

	local rootMagnitude = HumanoidRootPart.Velocity.magnitude
	local calcRootMagnitude = math.min(rootMagnitude, 25)

	-- Idle sway
	if idleSway then
		idleSwayTimerX = idleSwayTimerX + deltaTime * idleSwaySpeed
		idleSwayTimerY = idleSwayTimerY + deltaTime * idleSwaySpeed * 0.5
		local swayX = math.sin(idleSwayTimerX) * idleSwayIntensity
		local swayY = math.cos(idleSwayTimerY) * idleSwayIntensity
		func1 = lerp(func1, math.rad(swayX), 0.05 * deltaTime)
		func2 = lerp(func2, math.rad(swayY), 0.05 * deltaTime)
	else
		idleSwayTimerX = 0
		idleSwayTimerY = 0
	end

	if deltaTime > 1.5 then
		func3, func4 = 0, 0
	else
		func3 = lerp(func3, math.cos(tick() * 0.5 * math.random(5, 7.5)) * (math.random(2.5, 10) / 100) * deltaTime, 0.05 * deltaTime)
		func4 = lerp(func4, math.cos(tick() * 0.5 * math.random(2.5, 5)) * (math.random(1, 5) / 100) * deltaTime, 0.05 * deltaTime)
	end

	Camera.CFrame = Camera.CFrame * (
		CFrame.fromEulerAnglesXYZ(0, 0, math.rad(func3)) *
			CFrame.fromEulerAnglesXYZ(math.rad(func4 * deltaTime), math.rad(val * deltaTime), val2) *
			CFrame.Angles(0, 0, math.rad(func4 * deltaTime * (calcRootMagnitude / 5))) *
			CFrame.fromEulerAnglesXYZ(math.rad(func1), math.rad(func2), math.rad(func2 * 10))
	)

	val2 = math.clamp(lerp(val2, -Camera.CFrame:VectorToObjectSpace(HumanoidRootPart.Velocity / math.max(Humanoid.WalkSpeed, 0.01)).X * 0.04, 0.1 * deltaTime), -0.12, 0.1)
	func3 = lerp(func3, math.clamp(Mouse.delta.x, -2.5, 2.5), 0.25 * deltaTime)
	func4 = lerp(func4, math.sin(tick() * int) / 5 * math.min(1, int2 / 10), 0.25 * deltaTime)

	if rootMagnitude > 1 then
		val = lerp(val, math.cos(tick() * 0.5 * int) * (int / 200), 0.25 * deltaTime)
	else
		val = lerp(val, 0, 0.05 * deltaTime)
	end

	if rootMagnitude > 6 then
		int, int2 = 18, 20
	elseif rootMagnitude > 0.1 then
		int, int2 = 15, 20
	else
		int2 = 0
	end

	LocalPlayer.CameraMaxZoomDistance = 128
	LocalPlayer.CameraMinZoomDistance = 0.5
	vect3 = lerp(vect3, Camera.CFrame.LookVector, 0.125 * deltaTime)
end


bobbing = game:GetService("RunService").RenderStepped:Connect(onRenderStepped)


local UserInputService = game:GetService("UserInputService")

UserInputService.InputChanged:Connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = Vector2.new(inputObject.Delta.x / Sensitivity, inputObject.Delta.y / Sensitivity) * Smoothness
		local X = TargetAngleX - delta.y
		TargetAngleX = (X >= 80 and 80) or (X <= -80 and -80) or X
		TargetAngleY = (TargetAngleY - delta.x) % 360
	end
end)

UserInputService.InputBegan:Connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.Keyboard then
		if inputObject.KeyCode == CanToggleMouse.activationkey then
			if CanToggleMouse.allowed and FreeMouse == false then
				FreeMouse = false
			else
				FreeMouse = false
			end
		end
	end
end)


local RunService = game:GetService("RunService")

RunService.RenderStepped:Connect(function()
	if Running then
		UpdateCharacter()

		CamPos = CamPos + (TargetCamPos - CamPos) * 0.28
		AngleX = AngleX + (TargetAngleX - AngleX) * 0.35
		local dist = TargetAngleY - AngleY
		dist = math.abs(dist) > 180 and dist - (dist / math.abs(dist)) * 360 or dist
		AngleY = (AngleY + dist * 0.35) % 360
		Camera.CameraType = Enum.CameraType.Scriptable

		Camera.CoordinateFrame = CFrame.new(Head.Position) * CFrame.Angles(0, math.rad(AngleY), 0) * CFrame.Angles(math.rad(AngleX), 0, 0) * CFrame.new(0, 0.8, 0)
		HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position) * CFrame.Angles(0, math.rad(AngleY), 0)
		Character.Humanoid.AutoRotate = false
	else
		game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
		Character.Humanoid.AutoRotate = true
	end

	if (Camera.Focus.p - Camera.CoordinateFrame.p).magnitude < 1 then
		Running = false
	else
		Running = true
		if FreeMouse == true then
			game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
		else
			game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter
		end
	end

	if not CanToggleMouse.allowed then
		FreeMouse = false
	end

	Camera.FieldOfView = FieldOfView
end)
