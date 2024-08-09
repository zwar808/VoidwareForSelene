repeat task.wait() until game:IsLoaded()
task.spawn(function()
    repeat task.wait() until warningNotification
    warningNotification("Voidware - Bedwarz", "Credits go to lwclowny#0 on discord!", 10)
end)
-- Initialize Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()  -- Ensure you have the correct URL for OrionLib

-- Create the window
local Window = OrionLib:MakeWindow({
    Name = "Trollage",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})

-- Create the main tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Create the misc tab
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Variables for cooldown
local cooldown = 0.1

-- Function to change walk speed
local function changeWalkSpeed(speed)
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
    end
end

-- Infinite jump function
local infiniteJumpEnabled = false
local UserInputService = game:GetService("UserInputService")
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and game:GetService("Players").LocalPlayer.Character then
        local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Break All Beds functionality
local breakAllBedsActive = false

local function breakAllBeds()
    spawn(function()
        while breakAllBedsActive do
            for _, bed in pairs(workspace.Map.Beds:GetChildren()) do
                local args = {
                    [1] = bed
                }
                game:GetService("ReplicatedStorage").Remotes.DestroyBed:FireServer(unpack(args))
                wait(0.1)
            end
            wait(0.1)
        end
    end)
end

MainTab:AddToggle({
    Name = "Break All Beds",
    Default = false,
    Callback = function(value)
        breakAllBedsActive = value
        if value then
            breakAllBeds()
        end
    end
})

local killAllPlayersActive = false

-- Function to apply CrossbowHit to a specific player
local function applyCrossbowHitToPlayer(player)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local args = {
            [1] = Vector3.new(0.06453713774681091, -0.03380536660552025, 0.997342586517334),
            [2] = player.Character,
            [3] = 400
        }
        game:GetService("ReplicatedStorage").Remotes.CrossbowHit:FireServer(unpack(args))
    end
end

-- Function to kill all players except the local player
local function killAllPlayers()
    spawn(function()
        while killAllPlayersActive do
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player ~= game:GetService("Players").LocalPlayer then
                    print("Killing player: " .. player.Name) -- Debugging line
                    applyCrossbowHitToPlayer(player)
                end
            end
            wait(0.1) -- Adjusted delay to reduce server strain
        end
    end)
end

-- Adding a toggle to the GUI to enable or disable the Kill All Players feature
MainTab:AddToggle({
    Name = "Kill All Players",
    Default = false,
    Callback = function(value)
        killAllPlayersActive = value
        if value then
            killAllPlayers()
        end
    end
})

-- Function to give resources
local function giveResource(resourceType, amount)
    local args = {
        [1] = resourceType,
        [2] = amount
    }
    game:GetService("ReplicatedStorage").Remotes.GetBlock:FireServer(unpack(args))
end

-- Variables to store amounts and active states
local emeraldAmount = 10000
local ironAmount = 10000
local diamondAmount = 10000
local customItemsAmount = 10000

-- Add textboxes and toggles for giving resources
MainTab:AddTextbox({
    Name = "Amount for Emerald",
    Default = "10000",
    TextDisappear = true,
    Callback = function(value)
        emeraldAmount = tonumber(value) or 10000
    end
})

local givingEmeralds = false
MainTab:AddToggle({
    Name = "Give Emerald",
    Default = false,
    Callback = function(value)
        givingEmeralds = value
        if value then
            spawn(function()
                while givingEmeralds do
                    giveResource("Emerald", emeraldAmount)
                    wait(cooldown)
                end
            end)
        end
    end
})

MainTab:AddTextbox({
    Name = "Amount for Iron",
    Default = "10000",
    TextDisappear = true,
    Callback = function(value)
        ironAmount = tonumber(value) or 10000
    end
})

local givingIron = false
MainTab:AddToggle({
    Name = "Give Iron",
    Default = false,
    Callback = function(value)
        givingIron = value
        if value then
            spawn(function()
                while givingIron do
                    giveResource("Iron", ironAmount)
                    wait(cooldown)
                end
            end)
        end
    end
})

MainTab:AddTextbox({
    Name = "Amount for Diamond",
    Default = "10000",
    TextDisappear = true,
    Callback = function(value)
        diamondAmount = tonumber(value) or 10000
    end
})

local givingDiamonds = false
MainTab:AddToggle({
    Name = "Give Diamond",
    Default = false,
    Callback = function(value)
        givingDiamonds = value
        if value then
            spawn(function()
                while givingDiamonds do
                    giveResource("Diamond", diamondAmount)
                    wait(cooldown)
                end
            end)
        end
    end
})

-- Function to get custom items
local customItemsActive = false

-- Variables for custom item type and amount
local customItemsType = "Wool"  -- Default item type
local customItemsAmount = 10000

-- Function to get custom items
local function getCustomItems()
    spawn(function()
        while customItemsActive do
            local args = {
                [1] = customItemsType,
                [2] = customItemsAmount
            }
            game:GetService("ReplicatedStorage").Remotes.GetBlock:FireServer(unpack(args))
            wait(cooldown)
        end
    end)
end

-- Add textboxes and toggles for custom items
MainTab:AddTextbox({
    Name = "Custom Item Type",
    Default = "Wool",  -- Default item type
    TextDisappear = true,
    Callback = function(value)
        customItemsType = value
    end
})

MainTab:AddTextbox({
    Name = "Amount for Custom Items",
    Default = "10000",
    TextDisappear = true,
    Callback = function(value)
        customItemsAmount = tonumber(value) or 10000
    end
})

MainTab:AddToggle({
    Name = "Get Custom Items in Shop",
    Default = false,
    Callback = function(value)
        customItemsActive = value
        if value then
            getCustomItems()
        end
    end
})

local giveItemActive = false
local numberOfExecutions = 1

-- Function to give the player 3rd inventory item
local function giveItem()
    spawn(function()
        while giveItemActive do
            for i = 1, numberOfExecutions do
                local args = {
                    [1] = "3",
                    [2] = "One"
                }
                game:GetService("ReplicatedStorage").Remotes.DropItem:FireServer(unpack(args))
                wait(0.0000001)  -- Cooldown of 0.0000001 seconds
            end
            wait(0.0000001)  -- Cooldown between executions
        end
    end)
end

-- Textbox to specify the number of executions
MainTab:AddTextbox({
    Name = "Numbers of drop items",
    Default = "1",
    TextDisappear = true,
    Callback = function(value)
        local num = tonumber(value)
        if num then
            numberOfExecutions = num
        else
            numberOfExecutions = 1
        end
    end
})

-- Toggle to activate/deactivate the function
MainTab:AddToggle({
    Name = "Give Player 3rd Inventory",
    Default = false,
    Callback = function(value)
        giveItemActive = value
        if value then
            giveItem()
        end
    end
})

-- Health giver function
local positiveHealthAmount = 0
local negativeHealthAmount = -0
local targetPlayerName = game:GetService("Players").LocalPlayer.Name
local healthGiverActive = false

-- Function to find the player by a partial name
local function findPlayerByPartialName(partialName)
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if string.find(string.lower(player.Name), string.lower(partialName)) then
            return player
        end
    end
    return nil
end

-- Function to give health
local function giveHealth()
    spawn(function()
        while healthGiverActive do
            local player = findPlayerByPartialName(targetPlayerName)
            if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                local args = {
                    [1] = player.Character:FindFirstChildOfClass("Humanoid"),
                    [2] = positiveHealthAmount,
                    [3] = negativeHealthAmount
                }
                game:GetService("ReplicatedStorage").Remotes.SetHealth:FireServer(unpack(args))
            end
            wait(cooldown)
        end
    end)
end

-- Textbox to specify the positive health amount
MainTab:AddTextbox({
    Name = "Positive Health Amount",
    Default = "0",
    TextDisappear = true,
    Callback = function(value)
        positiveHealthAmount = tonumber(value) or 0
    end
})

-- Textbox to specify the negative health amount
MainTab:AddTextbox({
    Name = "Negative Health Amount",
    Default = "0",
    TextDisappear = true,
    Callback = function(value)
        negativeHealthAmount = tonumber(value) or 0
    end
})

-- Textbox to specify the target player name
MainTab:AddTextbox({
    Name = "Target Player Name",
    Default = game:GetService("Players").LocalPlayer.Name,
    TextDisappear = true,
    Callback = function(value)
        targetPlayerName = value or game:GetService("Players").LocalPlayer.Name
    end
})

-- Toggle to activate/deactivate health giver function
MainTab:AddToggle({
    Name = "Give Health",
    Default = false,
    Callback = function(value)
        healthGiverActive = value
        if value then
            giveHealth()
        end
    end
})

-- Initialize the GUI
OrionLib:Init()