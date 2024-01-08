local switch = false

t = game.StarterGui["LOBBY SCREEN"]["PROFILE FRAME"].TextBox:WaitForChild("TextButton")

script.Parent.MouseButton1Click:Connect(function()
	if switch then
		script.Parent.Text = "On"
		script.Parent.TextColor3 = Color3.new(0, 0.666667, 0)
		switch = false
	else
		script.Parent.Text = "Off"
		script.Parent.TextColor3 = Color3.new(170, 0, 0)
		switch = true
	end
end)
