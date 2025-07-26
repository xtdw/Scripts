local plrs = game.Players
local plr = plrs.LocalPlayer
local char = plr.Character
local drilling = false 
local selling = false
local collecting = false
local storage = false
local rebirthing = false
local selectedDrill = nil
local selectedHandDrill = nil
local selectedPlayer = nil

local function drill()
    if char:FindFirstChildOfClass("Tool") and string.match(char:FindFirstChildOfClass("Tool").Name, "Hand") then
        game:GetService("ReplicatedStorage").Packages.Knit.Services.OreService.RE.RequestRandomOre:FireServer()
    else
        for _,v in ipairs(plr.Backpack:GetChildren()) do
            if string.match(v.Name, "Hand") then
                char.Humanoid:EquipTool(v)
                game:GetService("ReplicatedStorage").Packages.Knit.Services.OreService.RE.RequestRandomOre:FireServer()
                break
            end
        end
    end
end

local function sell()
    for _,v in next, plr.Backpack:GetChildren() do
        if not string.match(v.Name, "Drill") then
            if v:IsA("Tool") and v:FindFirstChild("Handle") then
                local old = char:GetPivot()
                char:PivotTo(workspace["Sell Shop"]:GetPivot())
                task.wait(0.1)
                game:GetService("ReplicatedStorage").Packages.Knit.Services.OreService.RE.SellAll:FireServer()
                task.wait(0.1)
                char:PivotTo(old)
            end
        end
    end
end

local function getPlot()
    for _,v in next, workspace.Plots:GetChildren() do
        if v:FindFirstChild("Owner") and v:FindFirstChild("Owner").Value == plr then
            return v
        end
    end
end

local function collectDrills()
    for _,v in next, getPlot():FindFirstChild("Drills"):GetChildren() do
        if v:FindFirstChild("Ores") and v:FindFirstChild("Ores"):FindFirstChild("TotalQuantity") and v:FindFirstChild("Ores"):FindFirstChild("TotalQuantity").Value > 0 then
            game:GetService("ReplicatedStorage").Packages.Knit.Services.PlotService.RE.CollectDrill:FireServer(v)
        end
    end
end

local function collectStorage()
    for _,v in next, getPlot():FindFirstChild("Storage"):GetChildren() do
        if v:FindFirstChild("Ores") and v:FindFirstChild("Ores"):FindFirstChild("TotalQuantity") and v:FindFirstChild("Ores"):FindFirstChild("TotalQuantity").Value > 0 then
            game:GetService("ReplicatedStorage").Packages.Knit.Services.PlotService.RE.CollectDrill:FireServer(v)
        end
    end
end


local function rebirth()
    local reb = plr.PlayerGui.Menu.CanvasGroup.Rebirth.Background
    local progress = reb.Progress.Checkmark.Image == "rbxassetid://131015443699741"
    local ores = reb.RequiredOres:GetChildren()
    
    if #ores >= 2 then
        local ore1 = ores[1]:FindFirstChild("Checkmark")
        local ore2 = ores[2]:FindFirstChild("Checkmark")

        if progress
        and ore1 and ore1.Image == "rbxassetid://131015443699741"
        and ore2 and ore2.Image == "rbxassetid://131015443699741" then
            game:GetService("ReplicatedStorage").Packages.Knit.Services.RebirthService.RE.RebirthRequest:FireServer()
        end
    end
end

local function formatPrice(num)
    local formatted = tostring(num)
    local k
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return "$" .. formatted
end

local function getDrillsSortedByPrice()
    local drills = {}

    for _, frame in pairs(plr.PlayerGui.Menu.CanvasGroup.Buy.Background.DrillList:GetChildren()) do
        if frame:IsA("Frame") then
            local priceLabel = frame:FindFirstChild("Buy")
                and frame.Buy:FindFirstChild("TextLabel")
            local titleLabel = frame:FindFirstChild("Title")

            if priceLabel and titleLabel then
                local priceText = priceLabel.Text

                local cleanPriceText = priceText:gsub("[%$,]", "")
                local price = tonumber(cleanPriceText)

                if price then
                    table.insert(drills, {
                        name = titleLabel.Text,
                        price = price,
                        frame = frame
                    })
                end
            end
        end
    end

    table.sort(drills, function(a, b)
        return a.price < b.price
    end)

    return drills
end

local sortedDrills = getDrillsSortedByPrice()

local drillNames = {}
for _, drill in ipairs(sortedDrills) do
    table.insert(drillNames, drill.name)
end


local function getHandDrillsSortedByPrice()
    local drills = {}

    for _, frame in pairs(plr.PlayerGui.Menu.CanvasGroup.HandDrills.Background.HandDrillList:GetChildren()) do
        if frame:IsA("Frame") then
            local priceLabel = frame:FindFirstChild("Buy")
                and frame.Buy:FindFirstChild("TextLabel")
            local titleLabel = frame:FindFirstChild("Title")

            if priceLabel and titleLabel then
                local priceText = priceLabel.Text

                local cleanPriceText = priceText:gsub("[%$,]", "")
                local price = tonumber(cleanPriceText)

                if price then
                    table.insert(drills, {
                        name = titleLabel.Text,
                        price = price,
                        frame = frame
                    })
                end
            end
        end
    end

    table.sort(drills, function(a, b)
        return a.price < b.price
    end)

    return drills
end

local sortedHandDrills = getHandDrillsSortedByPrice()

local handDrillNames = {}
for _, drill in ipairs(sortedHandDrills) do
    table.insert(handDrillNames, drill.name)
end

local function getDrillPrice()
    if not selectedDrill then return end
    for _,v in next, plr.PlayerGui.Menu.CanvasGroup.Buy.Background.DrillList:GetDescendants() do
        if v:IsA("TextLabel") and v.Name == "Title" and v.Text == selectedDrill then
            return v.Parent:FindFirstChild("Buy").TextLabel.Text
        end
    end
end

local function getHandDrillPrice()
    if not selectedHandDrill then return end
    for _,v in next, plr.PlayerGui.Menu.CanvasGroup.HandDrills.Background.HandDrillList:GetDescendants() do
        if v:IsA("TextLabel") and v.Name == "Title" and v.Text == selectedHandDrill then
            return v.Parent:FindFirstChild("Buy").TextLabel.Text
        end
    end
end

local function get()
	local t = {}
	for _, p in ipairs(plrs:GetPlayers()) do
        if p == plr then continue end
		t[#t + 1] = p.Name
	end
	return t
end



local ui = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local win = ui:CreateWindow({
    Title = "Untitled Drill Game",
    Icon = "terminal",
    Folder = nil,
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    Background = "",
})

local tab = win:Tab({
    Title = "Main",
    Icon = "pickaxe",
})

tab:Section({
    Title = "Farming",
    TextXAlignment = "Left",
    TextSize = 17,
})

tab:Toggle({
    Title = "Drill Ores",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        drilling = state
        if drilling then
            task.spawn(function()
                while drilling do
                    drill()
                    task.wait()
                end
            end)
        end
    end
})

tab:Toggle({
    Title = "Sell Ores",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        selling = state
        if selling then
            task.spawn(function()
                while selling do
                    sell()
                    task.wait()
                end
            end)
        end
    end
})

tab:Toggle({
    Title = "Collect Ores From Drills",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        collecting = state
        if collecting then
            task.spawn(function()
                while collecting do
                    collectDrills()
                    task.wait()
                end
            end)
        end
    end
})

tab:Toggle({
    Title = "Collect Ores From Storage",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        storage = state
        if storage then
            task.spawn(function()
                while storage do
                    collectStorage()
                    task.wait()
                end
            end)
        end
    end
})

tab:Toggle({
    Title = "Rebirth",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        rebirthing = state
        if rebirthing then
            task.spawn(function()
                while rebirthing do
                    rebirth()
                    task.wait(1)
                end
            end)
        end
    end
})

tab:Section({
    Title = "Buying",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Paragraph = tab:Paragraph({
    Title = "Selected Drill Price: N/A",
    Locked = false,
})

local Dropdown = tab:Dropdown({
    Title = "Drill List",
    Values = drillNames,
    Value = nil,
    Callback = function(option)
        selectedDrill = option
        local price = getDrillPrice() or "N/A"
        Paragraph:SetTitle("Selected Drill Price: " .. price)
    end
})


tab:Button({
    Title = "Buy Drill",
    Locked = false,
    Callback = function()
        if selectedDrill then
            game:GetService("ReplicatedStorage").Packages.Knit.Services.OreService.RE.BuyDrill:FireServer(selectedDrill)
        end
    end
})

local Paragraph2 = tab:Paragraph({
    Title = "Selected Hand Drill Price: N/A",
    Locked = false,
})

local Dropdown = tab:Dropdown({
    Title = "Hand Drill List",
    Values = handDrillNames,
    Value = nil,
    Callback = function(option)
        selectedHandDrill = option
        local price = getHandDrillPrice() or "N/A"
        Paragraph2:SetTitle("Selected Hand Drill Price: " .. price)
    end
})


tab:Button({
    Title = "Buy Hand Drill",
    Locked = false,
    Callback = function()
        if selectedHandDrill then
            game:GetService("ReplicatedStorage").Packages.Knit.Services.OreService.RE.BuyHandDrill:FireServer(selectedHandDrill)
        end
    end
})


local tab = win:Tab({
    Title = "Miscellaneous",
    Icon = "person-standing",
})

tab:Section({
    Title = "Player",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Slider = tab:Slider({
    Title = "WalkSpeed",
    Step = 1,
    Value = {
        Min = 0,
        Max = 500,
        Default = plr.Character.Humanoid.WalkSpeed,
    },
    Callback = function(value)
        plr.Character.Humanoid.WalkSpeed = value
    end
})

local Slider = tab:Slider({
    Title = "JumpPower",
    Step = 1,
    Value = {
        Min = 0,
        Max = 500,
        Default = plr.Character.Humanoid.JumpPower,
    },
    Callback = function(value)
        plr.Character.Humanoid.JumpPower = value
    end
})

local Dropdown = tab:Dropdown({
    Title = "Select Player",
    Values = get(),
    Value = nil,
    Callback = function(option)
        selectedPlayer = option
    end
})

plrs.PlayerAdded:Connect(function()
    Dropdown:Refresh(get())
end)

local Button = tab:Button({
    Title = "Teleport To Player",
    Locked = false,
    Callback = function()
        char:PivotTo(plrs[selectedPlayer].Character:GetPivot())
    end
})
