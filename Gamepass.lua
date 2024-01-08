local button = script.Parent
local player = game.Players.LocalPlayer
local gamePassId = 669906250 

button.MouseButton1Click:Connect(function()
	if player then
		game:GetService("MarketplaceService"):PromptGamePassPurchase(player, gamePassId)
	end
end)
