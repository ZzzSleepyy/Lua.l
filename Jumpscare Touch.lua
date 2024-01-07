local TweenService = game:GetService("TweenService")
local Lighting = game.Lighting

local debounce = false
local sound = script.Parent.Sound:Clone()
local sound1 = script.Parent.Sound1:Clone()
local TweenService = game:GetService("TweenService")


local rollingGiant = workspace:WaitForChild("THE ROLLING GIANT JUMPSACRE")


local primaryPart = rollingGiant.PrimaryPart -- REMEMBER THIS


local tweenInfo1 = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local targetPosition = Vector3.new(-41.007, 306.248, -8.812)

local tween = TweenService:Create(primaryPart, tweenInfo1, {Position = targetPosition})


local function playBlurEffect()
	local blur = Lighting:FindFirstChild("Blur") or Instance.new("BlurEffect")
	local s = game.Lighting:FindFirstChild("ColorCorrection")
	blur.Name = "Blur"
	blur.Parent = Lighting

	sound1:Play()
	wait(3)
	
	local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local targetSize = 17 
	local reverseSize = 7
	local sizeTween = TweenService:Create(blur, tweenInfo, { Size = targetSize })
	local sizeTweenReverse = TweenService:Create(blur, tweenInfo, {Size = reverseSize})
	sizeTween:Play()
	tween:Play()
	s.Enabled = true
	sound:Play()
	wait(3)
	sizeTweenReverse:Play()
	s.Enabled = false
	sound:Destroy()
	rollingGiant:Destroy()
	
end

script.Parent.Touched:Connect(function(hit)
	if not debounce then
		debounce = true
		if hit.Parent:FindFirstChild("Humanoid") then
			local player = game.Players:GetPlayerFromCharacter(hit.Parent)
			sound.Parent = player.PlayerGui
			sound1.Parent = player.PlayerGui
			playBlurEffect()
		end
		debounce = false
	end
end)
