_G.unrender = true

local rs = game:GetService("RunService")
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local rebirth = game.ReplicatedStorage:WaitForChild("RebirthEvent")
local cp = workspace:WaitForChild("Checkpoints")
local stats = plr:WaitForChild("leaderstats")
local stage = stats:WaitForChild("Stage")

if _G.unrender == true then 
	rs:Set3dRenderingEnabled(false) 
end

local function touchCheckpoints()
	for i = 1, 45 do
		if stage.Value >= 45 then
			break
		end
		local chk = cp:FindFirstChild(tostring(i))
		if chk then
			firetouchinterest(chk, hrp, 0)
		end
	end
end

rs.Heartbeat:Connect(function()
	if stage.Value >= 45 then
		rebirth:FireServer()
	else
		touchCheckpoints()
	end
end)
