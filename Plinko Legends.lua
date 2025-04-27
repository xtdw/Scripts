local config = {
    time = 0.1,
    amount = 1,
    price = 500,
    drop = true
}

function dropBalls()
    game:GetService("Players").LocalPlayer.PlinkoEvent:FireServer(config.price, config.amount)
end

local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

local Window = MacLib:Window({
    Title = "Script",
    Subtitle = "bakaaa",
    Size = UDim2.fromOffset(868, 650),
    DragStyle = 2,
    DisabledWindowControls = {},
    ShowUserInfo = true,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = true,
})

local globalSettings = {
    UIBlurToggle = Window:GlobalSetting({
        Name = "UI Blur",
        Default = Window:GetAcrylicBlurState(),
        Callback = function(bool)
            Window:SetAcrylicBlurState(bool)
            Window:Notify({
                Title = Window.Settings.Title,
                Description = (bool and "Enabled" or "Disabled") .. " UI Blur",
                Lifetime = 5
            })
        end,
    }),
    NotificationToggler = Window:GlobalSetting({
        Name = "Notifications",
        Default = Window:GetNotificationsState(),
        Callback = function(bool)
            Window:SetNotificationsState(bool)
            Window:Notify({
                Title = Window.Settings.Title,
                Description = (bool and "Enabled" or "Disabled") .. " Notifications",
                Lifetime = 5
            })
        end,
    }),
    ShowUserInfo = Window:GlobalSetting({
        Name = "Show User Info",
        Default = Window:GetUserInfoState(),
        Callback = function(bool)
            Window:SetUserInfoState(bool)
            Window:Notify({
                Title = Window.Settings.Title,
                Description = (bool and "Showing" or "Redacted") .. " User Info",
                Lifetime = 5
            })
        end,
    })
}

local tabGroups = {
    TabGroup1 = Window:TabGroup()
}

local tabs = {
    Main = tabGroups.TabGroup1:Tab({ Name = "Main", Image = "rbxassetid://18821914323" }),
    Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" })
}

local sections = {
    MainSection1 = tabs.Main:Section({ Side = "Left" }),
}

sections.MainSection1:Input({
    Name = "Amount Of Money Per Drop",
    Placeholder = "500",
    AcceptedCharacters = "Numeric",
    Callback = function(input)
        config.price = tonumber(input)
        Window:Notify({
            Title = Window.Settings.Title,
            Description = "Successfully set money per drop to " .. input .. " dollars"
        })
    end,
}, "Input")

sections.MainSection1:Slider({
    Name = "Amount Of Balls Per Drop",
    Default = 1,
    Minimum = 1,
    Maximum = 10,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(Value)
        config.amount = Value
    end
}, "Slider")

sections.MainSection1:Input({
    Name = "Time between drops",
    Placeholder = "0.1",
    AcceptedCharacters = "All",
    Callback = function(input)
        config.time = tonumber(input)
        Window:Notify({
            Title = Window.Settings.Title,
            Description = "Successfully set time between drops to " .. input .. " seconds"
        })
    end,
}, "Input")

sections.MainSection1:Toggle({
    Name = "Auto drop balls :3",
    Default = false,
    Callback = function(value)
        config.drop = value
        if value then
            coroutine.wrap(function()
                while config.drop do
                    dropBalls()
                    wait(config.time)
                end
            end)()
        end
    end,
}, "Toggle")

MacLib:SetFolder("Maclib")
tabs.Settings:InsertConfigSection("Left")

tabs.Main:Select()
MacLib:LoadAutoLoadConfig()
