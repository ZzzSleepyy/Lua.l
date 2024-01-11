local Player = game.Players.LocalPlayer
local Char = Player.Character

local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)



local function playJoinSound()
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://15546405086"
	sound.Parent = game:GetService("SoundService")
	sound:Play()
end


Char:WaitForChild("Humanoid").Died:Connect(function()
	playJoinSound()
	script.Parent.Enabled = true
end)
