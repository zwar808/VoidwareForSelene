repeat task.wait() until game:IsLoaded()
repeat task.wait() until shared.GuiLibrary
repeat task.wait() until shared.VapeUniversalLoaded

local GuiLibrary = shared.GuiLibrary
local entityLibrary = shared.vapeentity

local colors = {
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(0, 0, 0),
    Red = Color3.fromRGB(255, 0, 0),
    Green = Color3.fromRGB(0, 255, 0),
    Blue = Color3.fromRGB(0, 0, 255),
    Yellow = Color3.fromRGB(255, 255, 0),
    Cyan = Color3.fromRGB(0, 255, 255),
    Magenta = Color3.fromRGB(255, 0, 255),
    Gray = Color3.fromRGB(128, 128, 128),
    DarkGray = Color3.fromRGB(64, 64, 64),
    LightGray = Color3.fromRGB(192, 192, 192),
    Orange = Color3.fromRGB(255, 165, 0),
    Pink = Color3.fromRGB(255, 192, 203),
    Purple = Color3.fromRGB(128, 0, 128),
    Brown = Color3.fromRGB(139, 69, 19),
    LimeGreen = Color3.fromRGB(50, 205, 50),
    NavyBlue = Color3.fromRGB(0, 0, 128),
    Olive = Color3.fromRGB(128, 128, 0),
    Teal = Color3.fromRGB(0, 128, 128),
    Maroon = Color3.fromRGB(128, 0, 0),
    Gold = Color3.fromRGB(255, 215, 0),
    Silver = Color3.fromRGB(192, 192, 192),
    SkyBlue = Color3.fromRGB(135, 206, 235),
    Violet = Color3.fromRGB(238, 130, 238)
}
getgenv().ColorTable = colors

local lplr = game:GetService("Players").LocalPlayer
local lightingService = game:GetService("Lighting")
local core
pcall(function() core = game:GetService('CoreGui') end)
warn(tostring(core))

local function warningNotification(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title, text, delay, "assets/InfoNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
    warn(title..": "..text)
	return (suc and res)
end

local function InfoNotification(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title or "Voidware", text or "Successfully called function", delay or 7, "assets/InfoNotification.png")
		return frame
	end)
    warn(title..": "..text)
	return (suc and res)
end

local function errorNotification(title, text, delay)
    local suc, res = pcall(function()
        local frame = GuiLibrary.CreateNotification(title, text, delay, "assets/InfoNotification.png")
        frame.Frame.Frame.ImageColor3 = Color3.fromRGB(220, 0, 0)
        return frame
    end)
    warn(title..": "..text)
    return (suc and res)
end

local newcolor = function() return {Hue = 0, Sat = 0, Value = 0} end

local textlabel = Instance.new("TextLabel")
textlabel.Size = UDim2.new(1, 0, 0, 36)
textlabel.Text = "discord.gg/voidware"
textlabel.BackgroundTransparency = 1
textlabel.ZIndex = 10
textlabel.TextStrokeTransparency = 0
textlabel.TextScaled = true
textlabel.Font = Enum.Font.SourceSans
textlabel.TextColor3 = Color3.new(1, 1, 1)
textlabel.Position = UDim2.new(0, 200, 1, 200)
textlabel.Parent = GuiLibrary.MainGui.ScaledGui.ClickGui

run(function() 
    local Search = {Enabled = false}
	local SearchTextList = {RefreshValues = function() end, ObjectList = {}}
	local SearchColor = {Value = 0.44}
	local SearchFolder = Instance.new("Folder")
	SearchFolder.Name = "SearchFolder"
	SearchFolder.Parent = GuiLibrary.MainGui
	local function searchFindBoxHandle(part)
		for i,v in pairs(SearchFolder:GetChildren()) do
			if v.Adornee == part then
				return v
			end
		end
		return nil
	end
	local searchRefresh = function()
		SearchFolder:ClearAllChildren()
		if Search.Enabled then
			for i,v in pairs(workspace:GetDescendants()) do
				if (v:IsA("BasePart") or v:IsA("Model")) and table.find(SearchTextList.ObjectList, v.Name) and searchFindBoxHandle(v) == nil then
					local highlight = Instance.new("Highlight")
					highlight.Name = v.Name
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.FillColor = Color3.fromHSV(SearchColor.Hue, SearchColor.Sat, SearchColor.Value)
					highlight.Adornee = v
					highlight.Parent = SearchFolder
				end
			end
		end
	end
	Search = GuiLibrary.ObjectsThatCanBeSaved.CustomisationWindow.Api.CreateOptionsButton({
		Name = "PartESP",
		Function = function(callback)
			if callback then
				searchRefresh()
				table.insert(Search.Connections, workspace.DescendantAdded:Connect(function(v)
					if (v:IsA("BasePart") or v:IsA("Model")) and table.find(SearchTextList.ObjectList, v.Name) and searchFindBoxHandle(v) == nil then
						local highlight = Instance.new("Highlight")
						highlight.Name = v.Name
						highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						highlight.FillColor = Color3.fromHSV(SearchColor.Hue, SearchColor.Sat, SearchColor.Value)
						highlight.Adornee = v
						highlight.Parent = SearchFolder
					end 
				end))
				table.insert(Search.Connections, workspace.DescendantRemoving:Connect(function(v)
					if v:IsA("BasePart") or v:IsA("Model") then
						local boxhandle = searchFindBoxHandle(v)
						if boxhandle then
							boxhandle:Remove()
						end
					end
				end))
			else
				SearchFolder:ClearAllChildren()
			end
		end,
		HoverText = "Draws a box around selected parts\nAdd parts in Search frame"
	})
	SearchColor = Search.CreateColorSlider({
		Name = "new part color",
		Function = function(hue, sat, val)
			for i,v in pairs(SearchFolder:GetChildren()) do
				v.FillColor = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	SearchTextList = Search.CreateTextList({
		Name = "SearchList",
		TempText = "part name",
		AddFunction = function(user)
			searchRefresh()
		end,
		RemoveFunction = function(num)
			searchRefresh()
		end
	})
end)

run(function() 
    local function setIconID(iconId)
        local lplr = game:GetService("Players").LocalPlayer
        local playerlist = game:GetService("CoreGui"):FindFirstChild("PlayerList")
        if playerlist then
            pcall(function()
                local playerlistplayers = playerlist.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame
                local targetedplr = playerlistplayers:FindFirstChild("p_" .. lplr.UserId)
                if targetedplr then
                    targetedplr.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerIcon.Image = iconId
                    warningNotification("PlayerListIcon", "Succesfully set the icon!", 3)
                end
            end)
        end
    end
    local CustomIcon = {}
    local IconID = {Value = ""}
    local defaultID = "rbxassetid://18518244636"
    CustomIcon = GuiLibrary.ObjectsThatCanBeSaved.CustomisationWindow.Api.CreateOptionsButton({
        Name = 'CustomPlayerListIcon',
        Function = function(calling)
            if calling then 
                --CustomIcon["ToggleButton"](false) 
                if string.find(IconID.Value, "rbxassetid://") then
                    setIconID(iconId)
				elseif IconID.Value == "" then
                    setIconID(defaultID)
                    --warningNotification("PlayerListIcon", "Please specify valid ID! Example: rbxassetid://18518244636", 5)
                else
					setIconID("rbxassetid://"..IconID.Value)
				end
            end
        end
    }) 
    IconID = CustomIcon.CreateTextBox({
        Name = "IconID",
        TempText = "Type here the iconID",
        Function = function()
			if string.find(IconID.Value, "rbxassetid://") then
				setIconID(iconId)
			elseif IconID.Value == "" then
				setIconID(defaultID)
				--warningNotification("PlayerListIcon", "Please specify valid ID! Example: rbxassetid://18518244636", 5)
			else
				setIconID("rbxassetid://"..IconID.Value)
			end
		end
    })
end)

run(function() local Shader = {Enabled = false}
	local ShaderColor = {Hue = 0, Sat = 0, Value = 0}
	local ShaderTintSlider
	local ShaderBlur
	local ShaderTint
	local oldlightingsettings = {
		Brightness = lightingService.Brightness,
		ColorShift_Top = lightingService.ColorShift_Top,
		ColorShift_Bottom = lightingService.ColorShift_Bottom,
		OutdoorAmbient = lightingService.OutdoorAmbient,
		ClockTime = lightingService.ClockTime,
		ExposureCompensation = lightingService.ExposureCompensation,
		ShadowSoftness = lightingService.ShadowSoftness,
		Ambient = lightingService.Ambient
	}
	Shader = GuiLibrary.ObjectsThatCanBeSaved.CustomisationWindow.Api.CreateOptionsButton({
		Name = "RichShader",
		HoverText = "pro shader",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					pcall(function()
					ShaderBlur = Instance.new("BlurEffect")
					ShaderBlur.Parent = lightingService
					ShaderBlur.Size = 4 end)
					pcall(function()
						ShaderTint = Instance.new("ColorCorrectionEffect")
						ShaderTint.Parent = lightingService
						ShaderTint.Saturation = -0.2
						ShaderTint.TintColor = Color3.fromRGB(255, 224, 219)
					end)
					pcall(function()
						lightingService.ColorShift_Bottom = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
						lightingService.ColorShift_Top = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
						lightingService.OutdoorAmbient = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
						lightingService.ClockTime = 8.7
						lightingService.FogColor = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
						lightingService.FogEnd = 1000
						lightingService.FogStart = 0
						lightingService.ExposureCompensation = 0.24
						lightingService.ShadowSoftness = 0
						lightingService.Ambient = Color3.fromRGB(59, 33, 27)
					end)
				end)
			else
				pcall(function() ShaderBlur:Destroy() end)
				pcall(function() ShaderTint:Destroy() end)
				pcall(function()
				    lightingService.Brightness = oldlightingsettings.Brightness
				    lightingService.ColorShift_Top = oldlightingsettings.ColorShift_Top
				    lightingService.ColorShift_Bottom = oldlightingsettings.ColorShift_Bottom
				    lightingService.OutdoorAmbient = oldlightingsettings.OutdoorAmbient
				    lightingService.ClockTime = oldlightingsettings.ClockTime
				    lightingService.ExposureCompensation = oldlightingsettings.ExposureCompensation
				    lightingService.ShadowSoftness = oldlightingsettings.ShadowSoftnesss
				    lightingService.Ambient = oldlightingsettings.Ambient
				    lightingService.FogColor = oldthemesettings.FogColor
				    lightingService.FogStart = oldthemesettings.FogStart
				    ightingService.FogEnd = oldthemesettings.FogEnd
				end)
			end
		end
	})	
	ShaderColor = Shader.CreateColorSlider({
		Name = "Main Color",
		Function = function(h, s, v)
			if Shader.Enabled then 
				pcall(function()
					lightingService.ColorShift_Bottom = Color3.fromHSV(h, s, v)
					lightingService.ColorShift_Top = Color3.fromHSV(h, s, v)
					lightingService.OutdoorAmbient = Color3.fromHSV(h, s, v)
					lightingService.FogColor = Color3.fromHSV(h, s, v)
				end)
			end
		end
	})
end)

run(function() local CustomChatTag = {}
	local TagText = {Value = "VOIDWARE USER"}
	local TagColor = {Value = "Red"}
	local oldchanneltab
	local oldchannelfunc
	local oldchanneltabs = {}
	local whitelist = shared.vapewhitelist

	CustomChatTag = GuiLibrary.ObjectsThatCanBeSaved.CustomisationWindow.Api.CreateOptionsButton({
		Name = 'ChatTag',
		Function = function(calling)
			if calling then 
				task.spawn(function()
					repeat task.wait() until shared.vapewhitelist.loaded 
					if shared.vapewhitelist:get(lplr) ~= 0 then 
						warningNotification("ChatTag", "Whitelisted users cannot use this module! Sorry", 3)
						CustomChatTag["ToggleButton"](false) 
					end
					if TagText.Value then
						local suc, err = pcall(function()
							local Players = game:GetService("Players")
							local ReplicatedStorage = game:GetService("ReplicatedStorage")
							local yes = Players.LocalPlayer.Name
							local ChatTag = {}
							ChatTag[yes] =
								{
									TagText = TagText.Value,
									TagColor = ColorTable[TagColor.Value],
								}
							local oldchanneltab
							local oldchannelfunc
							local oldchanneltabs = {}
							for i, v in pairs(getconnections(ReplicatedStorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
								if
									v.Function
									and #debug.getupvalues(v.Function) > 0
									and type(debug.getupvalues(v.Function)[1]) == "table"
									and getmetatable(debug.getupvalues(v.Function)[1])
									and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
								then
									oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
									oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
									getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
										local tab = oldchannelfunc(Self, Name)
										if tab and tab.AddMessageToChannel then
											local addmessage = tab.AddMessageToChannel
											if oldchanneltabs[tab] == nil then
												oldchanneltabs[tab] = tab.AddMessageToChannel
											end
											tab.AddMessageToChannel = function(Self2, MessageData)
												if MessageData.FromSpeaker and Players[MessageData.FromSpeaker] then
													if ChatTag[Players[MessageData.FromSpeaker].Name] then
														MessageData.ExtraData = {
															NameColor = Players[MessageData.FromSpeaker].Team == nil and Color3.new(128,0,128)
																or Players[MessageData.FromSpeaker].TeamColor.Color,
															Tags = {
																table.unpack(MessageData.ExtraData.Tags),
																{
																	TagColor = ChatTag[Players[MessageData.FromSpeaker].Name].TagColor,
																	TagText = ChatTag[Players[MessageData.FromSpeaker].Name].TagText,
																},
															},
														}
													end
												end
												return addmessage(Self2, MessageData)
											end
										end
										return tab
									end
								end
							end 
						end)
						if err then 
							warningNotification("ChatTag", "Error making tag! Error: "..tostring(err), 3)
							warn("[ChatTag_ErrorReport] Error making tag! Error: "..tostring(err))
							CustomChatTag["ToggleButton"](false) 
						end
					else
						warningNotification("ChatTag", "Please specify the chat tag name!", 3)
						CustomChatTag["ToggleButton"](false) 
					end
				end)
			else
				warningNotification("ChatTag", "Will apply new changes in the next game!", 3)
			end
		end,
		HoverText = "Gives you custom chat tag which only you can see"
	})

	TagText = CustomChatTag.CreateTextBox({
		Name = "Your tag's text",
		TempText = "Type here what you want your tag to be",
		Default = "VOIDWARE USER",
		Function = function() end
	})

	local color_table = {}
	for i,v in pairs(colors) do table.insert(color_table, i) end

	TagColor = CustomChatTag.CreateDropdown({
		Name = "TagColor",
		List = color_table,
		Default = "Red",
		Function = function() end
	})
end)
task.spawn(function()
	pcall(function()
		repeat task.wait() until shared.VapeFullyLoaded
		if shared.GuiLibrary.ObjectsThatCanBeSaved["ChatTagOptionsButton"].Api.Enabled then
		else
			repeat task.wait() until shared.vapewhitelist.loaded 
			if shared.vapewhitelist:get(lplr) ~= 0 then 
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local yes = Players.LocalPlayer.Name
				local ChatTag = {}
				ChatTag[yes] =
					{
						TagText = "VOIDWARE USER",
						TagColor = Color3.fromRGB(255, 0, 0),
					}
				local oldchanneltab
				local oldchannelfunc
				local oldchanneltabs = {}
				for i, v in pairs(getconnections(ReplicatedStorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
					if
						v.Function
						and #debug.getupvalues(v.Function) > 0
						and type(debug.getupvalues(v.Function)[1]) == "table"
						and getmetatable(debug.getupvalues(v.Function)[1])
						and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
					then
						oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
						oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
						getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
							local tab = oldchannelfunc(Self, Name)
							if tab and tab.AddMessageToChannel then
								local addmessage = tab.AddMessageToChannel
								if oldchanneltabs[tab] == nil then
									oldchanneltabs[tab] = tab.AddMessageToChannel
								end
								tab.AddMessageToChannel = function(Self2, MessageData)
									if MessageData.FromSpeaker and Players[MessageData.FromSpeaker] then
										if ChatTag[Players[MessageData.FromSpeaker].Name] then
											MessageData.ExtraData = {
												NameColor = Players[MessageData.FromSpeaker].Team == nil and Color3.new(128,0,128)
													or Players[MessageData.FromSpeaker].TeamColor.Color,
												Tags = {
													table.unpack(MessageData.ExtraData.Tags),
													{
														TagColor = ChatTag[Players[MessageData.FromSpeaker].Name].TagColor,
														TagText = ChatTag[Players[MessageData.FromSpeaker].Name].TagText,
													},
												},
											}
										end
									end
									return addmessage(Self2, MessageData)
								end
							end
							return tab
						end
					end
				end	
			end
		end
	end)
end)

run(function() local chatDisable = {Enabled = false}
	local chatVersion = function()
		if game.Chat:GetChildren()[1] then return true else return false end
	end
	chatDisable = GuiLibrary["ObjectsThatCanBeSaved"]["CustomisationWindow"]["Api"]["CreateOptionsButton"]({
		Name = "ChatDisable",
		HoverText = "Disables the chat",
		Function = function(callback)
			if callback then
				if chatVersion() then
					lplr.PlayerGui.Chat.Enabled = false
					game:GetService("CoreGui").TopBarApp.TopBarFrame.LeftFrame.ChatIcon.Visible = false
				elseif (not chatVersion()) then
					game.CoreGui.ExperienceChat.Enabled = false
					game:GetService("CoreGui").TopBarApp.TopBarFrame.LeftFrame.ChatIcon.Visible = false
					textChatService.ChatInputBarConfiguration.Enabled = false
					textChatService.BubbleChatConfiguration.Enabled = false
				end
			else
				if chatVersion() then
					lplr.PlayerGui.Chat.Enabled = true
					core.TopBarApp.TopBarFrame.LeftFrame.ChatIcon.Visible = true
				else
					gcore.ExperienceChat.Enabled = true
					core.TopBarApp.TopBarFrame.LeftFrame.ChatIcon.Visible = true
					textChatService.ChatInputBarConfiguration.Enabled = true
					textChatService.BubbleChatConfiguration.Enabled = true
				end
			end
		end
	})
	local Credits
	Credits = chatDisable.CreateCredits({
        Name = 'CreditsButtonInstance',
        Credits = 'Render'
    }) 
end)

run(function() local CharacterOutline = {}
	local CharacterOutlineColor = newcolor()
	local outline = Instance.new('Highlight', GuiLibrary.MainGui)
	CharacterOutline = GuiLibrary.ObjectsThatCanBeSaved.CustomisationWindow.Api.CreateOptionsButton({
		Name = 'CharacterOutline',
		HoverText = 'adds a cool outline to your character.',
		Function = function(calling)
			if calling then 
				task.spawn(function()
					repeat task.wait() until (lplr.Character or not CharacterOutline.Enabled)
					if CharacterOutline.Enabled then 
						local oldhighlight = lplr.Character:FindFirstChildWhichIsA('Highlight')
						if oldhighlight then 
							oldhighlight.Adornee = nil 
						end
						outline.FillTransparency = 1
						outline.Adornee = lplr.Character
						table.insert(CharacterOutline.Connections, lplr.Character.DescendantAdded:Connect(function(instance)
							if instance:IsA('Highlight') then 
								instance.Adornee = nil
							end 
						end))
						table.insert(CharacterOutline.Connections, runService.Heartbeat:Connect(function()
							outline.Adornee = (CharacterOutline.Enabled and lplr.Character or outline.Adornee)
						end))
						table.insert(CharacterOutline.Connections, lplr.CharacterAdded:Connect(function()
							CharacterOutline.ToggleButton()
							CharacterOutline.ToggleButton()
						end))
					end
				end)
			else
				outline.Adornee = nil
			end
		end
	})
	
	CharacterOutlineColor = CharacterOutline.CreateColorSlider({
		Name = 'Color',
		Function = function()
			pcall(function() outline.OutlineColor = Color3.fromHSV(CharacterOutlineColor.Hue, CharacterOutlineColor.Sat, CharacterOutlineColor.Value) end)
		end
	})
	local Credits
	Credits = CharacterOutline.CreateCredits({
        Name = 'CreditsButtonInstance',
        Credits = 'Render'
    })
end)

run(function() local CloudMods = {}
	local CloudNeon = {}
	local clouds = {}
	local CloudColor = newcolor()
	local cloudFunction = function(cloud)
		pcall(function()
			cloud.Color = Color3.fromHSV(CloudColor.Hue, CloudColor.Sat, CloudColor.Value)
			cloud.Material = (CloudNeon.Enabled and Enum.Material.Neon or Enum.Material.SmoothPlastic) 
		end)
	end
	CloudMods = GuiLibrary.ObjectsThatCanBeSaved.CustomisationWindow.Api.CreateOptionsButton({
		Name = 'CloudMods',
		HoverText = 'Recolorizes the clouds to your liking.',
		Function = function(calling)
			if calling then 
				clouds = workspace:WaitForChild('Clouds'):GetChildren()
				if not CloudMods.Enabled then 
					return 
				end
				for i,v in next, clouds do 
					cloudFunction(v)
				end
				table.insert(CloudMods.Connections, workspace.Clouds.ChildAdded:Connect(function(cloud)
					cloudFunction(cloud)
					table.insert(clouds, cloud)
				end))
			else 
				for i,v in next, clouds do 
					pcall(function() 
						v.Color = Color3.fromRGB(255, 255, 255)
						v.Material = Enum.Material.SmoothPlastic
					end) 
				end
			end
		end
	})
	CloudColor = CloudMods.CreateColorSlider({
		Name = 'Color',
		Function = function()
			for i,v in next, clouds do 
				cloudFunction(v)
			end
		end
	})
	CloudNeon = CloudMods.CreateToggle({
		Name = 'Neon',
		Function = function() 
			for i,v in next, clouds do 
				cloudFunction(v)
			end
		end
	})
	local Credits
	Credits = CloudMods.CreateCredits({
        Name = 'CreditsButtonInstance',
        Credits = 'Render'
    })
end)

run(function() local RestartVoidware = {}
	RestartVoidware = GuiLibrary.ObjectsThatCanBeSaved.HotWindow.Api.CreateOptionsButton({
		Name = 'Restart',
		Function = function(calling)
			if calling then 
				RestartVoidware["ToggleButton"](false) 
				wait(0.1)
				GuiLibrary.Restart()
			end
		end
	}) 
end)

run(function() local ReinstallProfiles = {}
	ReinstallProfiles = GuiLibrary.ObjectsThatCanBeSaved.VoidwareWindow.Api.CreateOptionsButton({
		Name = 'ReinstallProfiles',
		Function = function(calling)
			if calling then 
				ReinstallProfiles["ToggleButton"](false) 
				GuiLibrary.SelfDestruct()
				delfolder('vape/Profiles')
				delfolder('vape/ClosetProfiles')
				pload('NewMainScript.lua', true)
			end
		end
	}) 
end)
local vec3 = function(a, b, c) return Vector3.new(a, b, c) end
run(function() 
	local CustomJump = {Enabled = false}
	local CustomJumpMode = {Value = "Normal"}
	local CustomJumpVelocity = {Value = 50}
	CustomJump = GuiLibrary["ObjectsThatCanBeSaved"]["HotWindow"]["Api"]["CreateOptionsButton"]({
		Name = "InfJUmp",
        HoverText = "Customizes your jumping ability",
		Function = function(callback)
			if callback then
				game:GetService("UserInputService").JumpRequest:Connect(function()
					if CustomJumpMode.Value == "Normal" then
						entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					elseif CustomJumpMode.Value == "Velocity" then
						entityLibrary.character.HumanoidRootPart.Velocity += vec3(0,CustomJumpVelocity.Value,0)
					end 
				end)
			end
		end,
		ExtraText = function()
			return CustomJumpMode.Value
		end
	})
	CustomJumpMode = CustomJump.CreateDropdown({
		Name = "Mode",
		List = {
			"Normal",
			"Velocity"
		},
		Function = function() end,
	})
	CustomJumpVelocity = CustomJump.CreateSlider({
		Name = "Velocity",
		Min = 1,
		Max = 100,
		Function = function() end,
		Default = 50
	})
end)

run(function()
	local AnimationChanger = {Enabled = false}
	local AnimFreeze = {Enabled = false}
	local AnimRun = {Value = "Robot"}
	local AnimWalk = {Value = "Robot"}
	local AnimJump = {Value = "Robot"}
	local AnimFall = {Value = "Robot"}
    local AnimClimb = {Value = "Robot"}
	local AnimIdle = {Value = "Robot"}
	local AnimIdleB = {Value = "Robot"}
	local Animate
	local oldanimations = {}
	local RunAnimations = {}
	local WalkAnimations = {}
	local FallAnimations = {}
	local JumpAnimations = {}
    local ClimbAnimations = {}
	local IdleAnimations = {}
	local IdleAnimationsB = {}
	local AnimList = {
		RunAnim = {
		    ["Cartoony"] = "http://www.roblox.com/asset/?id=10921082452",
		    ["Levitation"] = "http://www.roblox.com/asset/?id=10921135644",
		    ["Robot"] = "http://www.roblox.com/asset/?id=10921250460",
		    ["Stylish"] = "http://www.roblox.com/asset/?id=10921276116",
		    ["Superhero"] = "http://www.roblox.com/asset/?id=10921291831",
		    ["Zombie"] = "http://www.roblox.com/asset/?id=616163682",
		    ["Ninja"] = "http://www.roblox.com/asset/?id=10921157929",
		    ["Knight"] = "http://www.roblox.com/asset/?id=10921121197",
		    ["Mage"] = "http://www.roblox.com/asset/?id=10921148209",
		    ["Pirate"] = "http://www.roblox.com/asset/?id=750783738",
		    ["Elder"] = "http://www.roblox.com/asset/?id=10921104374",
		    ["Toy"] = "http://www.roblox.com/asset/?id=10921306285",
	    	["Bubbly"] = "http://www.roblox.com/asset/?id=10921057244",
	    	["Astronaut"] = "http://www.roblox.com/asset/?id=10921039308",
	    	["Vampire"] = "http://www.roblox.com/asset/?id=10921320299",
	    	["Werewolf"] = "http://www.roblox.com/asset/?id=10921336997",
	    	["Rthro"] = "http://www.roblox.com/asset/?id=10921261968",
	    	["Oldschool"] = "http://www.roblox.com/asset/?id=10921240218",
	    	["Toilet"] = "http://www.roblox.com/asset/?id=4417979645",
		    ["Rthro Heavy Run"] = "http://www.roblox.com/asset/?id=3236836670",
            ["Tryhard"] = "http://www.roblox.com/asset/?id=10921157929",
            ["Goofy"] = "http://www.roblox.com/asset/?id=4417979645",
            ["Tamar"] = "http://www.roblox.com/asset/?id=10921306285"
	    },
	    WalkAnim = {
	    	["Cartoony"] = "http://www.roblox.com/asset/?id=10921082452",
    		["Levitation"] = "http://www.roblox.com/asset/?id=10921140719",
		    ["Robot"] = "http://www.roblox.com/asset/?id=10921255446",
		    ["Stylish"] = "http://www.roblox.com/asset/?id=10921283326",
		    ["Superhero"] = "http://www.roblox.com/asset/?id=10921298616",
		    ["Zombie"] = "http://www.roblox.com/asset/?id=10921355261",
		    ["Ninja"] = "http://www.roblox.com/asset/?id=10921162768",
		    ["Knight"] = "http://www.roblox.com/asset/?id=10921127095",
		    ["Mage"] = "http://www.roblox.com/asset/?id=10921152678",
		    ["Pirate"] = "http://www.roblox.com/asset/?id=750785693",
            ["Elder"] = "http://www.roblox.com/asset/?id=10921111375",
    		["Toy"] = "http://www.roblox.com/asset/?id=10921312010",
    		["Bubbly"] = "http://www.roblox.com/asset/?id=10980888364",
    		["Astronaut"] = "http://www.roblox.com/asset/?id=10921046031",
    		["Vampire"] = "http://www.roblox.com/asset/?id=10921326949",
    	  	["Werewolf"] = "http://www.roblox.com/asset/?id=10921342074",
    		["Rthro"] = "http://www.roblox.com/asset/?id=10921269718",
    		["Oldschool"] = "http://www.roblox.com/asset/?id=10921244891",
		    ["Ud'zal"] = "http://www.roblox.com/asset/?id=3303162967",
            ["Tryhard"] = "http://www.roblox.com/asset/?id=10921162768",
            ["Goofy"] = "http://www.roblox.com/asset/?id=10921162768",
            ["Tamar"] = "http://www.roblox.com/asset/?id=10921312010"
	    },
        FallAnim = {
            ["Cartoony"] = "http://www.roblox.com/asset/?id=10921077030",
            ["Levitation"] = "http://www.roblox.com/asset/?id=10921136539",
            ["Robot"] = "http://www.roblox.com/asset/?id=10921251156",
            ["Stylish"] = "http://www.roblox.com/asset/?id=10921278648",
            ["Superhero"] = "http://www.roblox.com/asset/?id=10921293373",
            ["Zombie"] = "http://www.roblox.com/asset/?id=10921350320",
            ["Ninja"] = "http://www.roblox.com/asset/?id=10921159222",
            ["Knight"] = "http://www.roblox.com/asset/?id=10921122579",
            ["Mage"] = "http://www.roblox.com/asset/?id=10921148939",
            ["Pirate"] = "http://www.roblox.com/asset/?id=750780242",
            ["Elder"] = "http://www.roblox.com/asset/?id=10921105765",
            ["Toy"] = "http://www.roblox.com/asset/?id=10921307241",
            ["Bubbly"] = "http://www.roblox.com/asset/?id=10921061530",
            ["Astronaut"] = "http://www.roblox.com/asset/?id=10921040576",
            ["Vampire"] = "http://www.roblox.com/asset/?id=10921321317",
            ["Werewolf"] = "http://www.roblox.com/asset/?id=10921337907",
            ["Rthro"] = "http://www.roblox.com/asset/?id=10921262864",
            ["Oldschool"] = "http://www.roblox.com/asset/?id=10921241244",
            ["Tryhard"] = "http://www.roblox.com/asset/?id=10921136539",
            ["Goofy"] = "http://www.roblox.com/asset/?id=10921136539",
            ["Tamar"] = "http://www.roblox.com/asset/?id=10921136539"
        },
        JumpAnim = {
            ["Cartoony"] = "http://www.roblox.com/asset/?id=10921078135",
            ["Levitation"] = "http://www.roblox.com/asset/?id=10921137402",
            ["Robot"] = "http://www.roblox.com/asset/?id=10921252123",
            ["Stylish"] = "http://www.roblox.com/asset/?id=10921279832",
            ["Superhero"] = "http://www.roblox.com/asset/?id=10921294559",
            ["Zombie"] = "http://www.roblox.com/asset/?id=10921351278",
            ["Ninja"] = "http://www.roblox.com/asset/?id=10921160088",
            ["Knight"] = "http://www.roblox.com/asset/?id=10921123517",
            ["Mage"] = "http://www.roblox.com/asset/?id=10921149743",
            ["Pirate"] = "http://www.roblox.com/asset/?id=750782230",
            ["Elder"] = "http://www.roblox.com/asset/?id=10921107367",
            ["Toy"] = "http://www.roblox.com/asset/?id=10921308158",
            ["Bubbly"] = "http://www.roblox.com/asset/?id=10921062673",
            ["Astronaut"] = "http://www.roblox.com/asset/?id=10921042494",
            ["Vampire"] = "http://www.roblox.com/asset/?id=10921322186",
            ["Werewolf"] = "http://www.roblox.com/asset/?id=1083218792",
            ["Rthro"] = "http://www.roblox.com/asset/?id=10921263860",
            ["Oldschool"] = "http://www.roblox.com/asset/?id=10921242013",
            ["Tryhard"] = "http://www.roblox.com/asset/?id=10921137402",
            ["Goofy"] = "http://www.roblox.com/asset/?id=10921137402",
            ["Tamar"] = "http://www.roblox.com/asset/?id=10921242013"
        },
        ClimbAnim = {
            ["Cartoony"] = "http://www.roblox.com/asset/?id=10921070953",
            ["Levitation"] = "http://www.roblox.com/asset/?id=10921132092",
            ["Robot"] = "http://www.roblox.com/asset/?id=10921245669",
            ["Stylish"] = "http://www.roblox.com/asset/?id=10921525854",
            ["Superhero"] = "http://www.roblox.com/asset/?id=10921346417",
            ["Zombie"] = "http://www.roblox.com/asset/?id=10921469135",
            ["Ninja"] = "http://www.roblox.com/asset/?id=10920908048",
            ["Knight"] = "http://www.roblox.com/asset/?id=10921116196",
            ["Mage"] = "http://www.roblox.com/asset/?id=10921143404",
            ["Pirate"] = "http://www.roblox.com/asset/?id=750779899",
            ["Elder"] = "http://www.roblox.com/asset/?id=10921100400",
            ["Toy"] = "http://www.roblox.com/asset/?id=10921300839",
            ["Bubbly"] = "http://www.roblox.com/asset/?id=10921053544",
            ["Astronaut"] = "http://www.roblox.com/asset/?id=10921032124",
            ["Vampire"] = "http://www.roblox.com/asset/?id=10921314188",
            ["Werewolf"] = "http://www.roblox.com/asset/?id=10921329322",
            ["Rthro"] = "http://www.roblox.com/asset/?id=10921257536",
            ["Oldschool"] = "http://www.roblox.com/asset/?id=10921229866"
        },
        Animation1 = {
            ["Cartoony"] = "http://www.roblox.com/asset/?id=10921071918",
            ["Levitation"] = "http://www.roblox.com/asset/?id=10921132962",
            ["Robot"] = "http://www.roblox.com/asset/?id=10921248039",
            ["Stylish"] = "http://www.roblox.com/asset/?id=10921272275",
            ["Superhero"] = "http://www.roblox.com/asset/?id=10921288909",
            ["Zombie"] = "http://www.roblox.com/asset/?id=10921344533",
            ["Ninja"] = "http://www.roblox.com/asset/?id=10921155160",
            ["Knight"] = "http://www.roblox.com/asset/?id=10921117521",
            ["Mage"] = "http://www.roblox.com/asset/?id=10921144709",
            ["Pirate"] = "http://www.roblox.com/asset/?id=750781874",
            ["Elder"] = "http://www.roblox.com/asset/?id=10921101664",
            ["Toy"] = "http://www.roblox.com/asset/?id=10921301576",
            ["Bubbly"] = "http://www.roblox.com/asset/?id=10921054344",
            ["Astronaut"] = "http://www.roblox.com/asset/?id=10921034824",
            ["Vampire"] = "http://www.roblox.com/asset/?id=10921315373",
            ["Werewolf"] = "http://www.roblox.com/asset/?id=10921330408",
            ["Rthro"] = "http://www.roblox.com/asset/?id=10921258489",
            ["Oldschool"] = "http://www.roblox.com/asset/?id=10921230744",
            ["Toilet"] = "http://www.roblox.com/asset/?id=4417977954",
            ["Ud'zal"] = "http://www.roblox.com/asset/?id=3303162274",
            ["Tryhard"] = "http://www.roblox.com/asset/?id=10921301576",
            ["Goofy"] = "http://www.roblox.com/asset/?id=4417977954",
            ["Tamar"] = "http://www.roblox.com/asset/?id=10921034824"
        },
        Animation2 = {
            ["Cartoony"] = "http://www.roblox.com/asset/?id=10921072875",
            ["Levitation"] = "http://www.roblox.com/asset/?id=10921133721",
            ["Robot"] = "http://www.roblox.com/asset/?id=10921248831",
            ["Stylish"] = "http://www.roblox.com/asset/?id=10921273958",
            ["Superhero"] = "http://www.roblox.com/asset/?id=10921290167",
            ["Zombie"] = "http://www.roblox.com/asset/?id=10921345304",
            ["Ninja"] = "http://www.roblox.com/asset/?id=10921155867",
            ["Knight"] = "http://www.roblox.com/asset/?id=10921118894",
            ["Mage"] = "http://www.roblox.com/asset/?id=10921145797",
            ["Pirate"] = "http://www.roblox.com/asset/?id=750782770",
            ["Elder"] = "http://www.roblox.com/asset/?id=10921102574",
            ["Toy"] = "http://www.roblox.com/asset/?id=10921302207",
            ["Bubbly"] = "http://www.roblox.com/asset/?id=10921055107",
            ["Astronaut"] = "http://www.roblox.com/asset/?id=10921036806",
            ["Vampire"] = "http://www.roblox.com/asset/?id=10921316709",
            ["Werewolf"] = "http://www.roblox.com/asset/?id=10921333667",
            ["Rthro"] = "http://www.roblox.com/asset/?id=10921259953",
            ["Oldschool"] = "http://www.roblox.com/asset/?id=10921232093",
            ["Toilet"] = "http://www.roblox.com/asset/?id=4417978624",
            ["Ud'zal"] = "http://www.roblox.com/asset/?id=3303162549",
            ["Tryhard"] = "http://www.roblox.com/asset/?id=10921302207",
            ["Goofy"] = "http://www.roblox.com/asset/?id=4417978624",
            ["Tamar"] = "http://www.roblox.com/asset/?id=10921036806"
        }
    }
    local function AnimateCharacter()
        local animate = lplr.Character:FindFirstChild("Animate") 
        if AnimFreeze.Enabled then
            animate.Enabled = false
        end
        animate.run.RunAnim.AnimationId = AnimList.RunAnim[AnimRun.Value]
        task.wait(4.5)
        animate.walk.WalkAnim.AnimationId = AnimList.WalkAnim[AnimWalk.Value]
        task.wait(4.5)
        animate.fall.FallAnim.AnimationId = AnimList.FallAnim[AnimFall.Value]
        task.wait(4.5)
        animate.jump.JumpAnim.AnimationId = AnimList.JumpAnim[AnimJump.Value]
        task.wait(4.5)
        animate.climb.ClimbAnim.AnimationId = AnimList.Animation1[AnimClimb.Value]
        task.wait(4.5)
        animate.idle.Animation1.AnimationId = AnimList.Animation1[AnimIdle.Value]
        task.wait(4.5)
        animate.idle.Animation2.AnimationId = AnimList.Animation2[AnimIdleB.Value]
        task.wait(4.5)
    end
	AnimationChanger = GuiLibrary.ObjectsThatCanBeSaved.CustomisationWindow.Api.CreateOptionsButton({
		Name = "AnimationChanger",
		Function = function(callback)
			if callback then
                RunLoops:BindToHeartbeat('AnimationChanger', function()
					pcall(function()
				        task.spawn(function()
					        if not entityLibrary.isAlive then repeat task.wait(10) until entityLibrary.isAlive end
					        table.insert(AnimationChanger.Connections, lplr.CharacterAdded:Connect(function()
					        if not entityLibrary.isAlive then repeat task.wait(10) until entityLibrary.isAlive end
					            pcall(AnimateCharacter)
					        end))                        
					        pcall(AnimateCharacter)
                        end)
                    end)
				end)
			else
				pcall(function() Animate.Enabled = true end)
				Animate = nil
			end
		end,
		HoverText = "customize your animations freely."
	})
	for i,v in pairs(AnimList.RunAnim) do table.insert(RunAnimations, i) end
	for i,v in pairs(AnimList.WalkAnim) do table.insert(WalkAnimations, i) end
	for i,v in pairs(AnimList.FallAnim) do table.insert(FallAnimations, i) end
	for i,v in pairs(AnimList.JumpAnim) do table.insert(JumpAnimations, i) end
	for i,v in pairs(AnimList.ClimbAnim) do table.insert(ClimbAnimations, i) end
	for i,v in pairs(AnimList.Animation1) do table.insert(IdleAnimations, i) end
	for i,v in pairs(AnimList.Animation2) do table.insert(IdleAnimationsB, i) end
	AnimRun = AnimationChanger.CreateDropdown({
		Name = "Run",
		List = RunAnimations,
		Function = function() 
			if AnimationChanger.Enabled then
				AnimationChanger.ToggleButton(false)
				AnimationChanger.ToggleButton(false)
			end
		end
	})
	AnimWalk = AnimationChanger.CreateDropdown({
		Name = "Walk",
		List = WalkAnimations,
		Function = function() 
			if AnimationChanger.Enabled then
				AnimationChanger.ToggleButton(false)
				AnimationChanger.ToggleButton(false)
			end
		end
	})
	AnimFall = AnimationChanger.CreateDropdown({
		Name = "Fall",
		List = FallAnimations,
		Function = function() 
			if AnimationChanger.Enabled then
				AnimationChanger.ToggleButton(false)
				AnimationChanger.ToggleButton(false)
			end
		end
	})
	AnimJump = AnimationChanger.CreateDropdown({
		Name = "Jump",
		List = JumpAnimations,
		Function = function() 
			if AnimationChanger.Enabled then
				AnimationChanger.ToggleButton(false)
				AnimationChanger.ToggleButton(false)
			end
		end
	})
	AnimIdle = AnimationChanger.CreateDropdown({
		Name = "Idle",
		List = IdleAnimations,
		Function = function() 
			if AnimationChanger.Enabled then
				AnimationChanger.ToggleButton(false)
				AnimationChanger.ToggleButton(false)
			end
		end
	})
	AnimIdleB = AnimationChanger.CreateDropdown({
		Name = "Idle 2",
		List = IdleAnimationsB,
		Function = function() 
			if AnimationChanger.Enabled then
				AnimationChanger.ToggleButton(false)
				AnimationChanger.ToggleButton(false)
			end
		end
	})
	AnimFreeze = AnimationChanger.CreateToggle({
		Name = "Freeze",
		HoverText = "Freezes all your animations",
		Function = function(callback)
			if AnimationChanger.Enabled then
				AnimationChanger.ToggleButton(false)
				AnimationChanger.ToggleButton(false)
			end
		end
	})
end)

run(function() local VapePrivateDetector = {Enabled = false}
	local VPLeave = {Enabled = false}
	local alreadydetected = {}
	VapePrivateDetector = GuiLibrary.ObjectsThatCanBeSaved.VoidwareWindow.Api.CreateOptionsButton({
		Name = "VapePrivateDetector",
		Function = function(callback)
			if callback then
				task.spawn(function()
					if not shared.vapewhitelist.loaded then 
						repeat task.wait() until shared.vapewhitelist.loaded or not VapePrivateDetector.Enabled
					end
					if not VapePrivateDetector.Enabled then 
						return 
					end
					for i,v in pairs(playersService:GetPlayers()) do
						if v ~= lplr then
							local rank = shared.vapewhitelist:get(v)
							if rank > 0 and not table.find(alreadydetected, v) then
								local rankstring = rank == 1 and "Private Member" or rank > 1 and "Owner"
								warningNotification("VapePrivateDetector", "Vape "..rankstring.." Detected! | "..v.DisplayName, 120)
								table.insert(alreadydetected, v)
								if VPLeave.Enabled then
									local newserver = nil
									repeat newserver = findnewserver() until newserver 
									game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, newserver, lplr)
								end
							end
						end
					end
					table.insert(VapePrivateDetector.Connections, playersService.PlayerAdded:Connect(function(v)
						local rank = shared.vapewhitelist:get(v)
						if rank > 0 and not table.find(alreadydetected, v) then
						local rankstring = rank == 1 and "Private Member" or rank > 1 and "Owner"
						warningNotification("VapePrivateDetector", "Vape "..rankstring.." Detected! | "..v.DisplayName, 120)
						table.insert(alreadydetected, v)
						if VPLeave.Enabled then
							local newserver = nil
							repeat newserver = findnewserver() until newserver 
							game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, newserver, lplr)
						end
						end 
					end))
				end)
			end
		end
	})
	VPLeave = VapePrivateDetector.CreateToggle({
		Name = "ServerHop",
		HoverText = "switches servers on detection.",
		Function = function() end
	})
	--[[task.spawn(function()
		repeat task.wait() until shared.vapewhitelist.loaded 
		if shared.vapewhitelist:get(lplr) ~= 0 then 
			pcall(GuiLibrary.RemoveObject, "VapePrivateDetectorOptionsButton")
		end
	end)--]]
end)

run(function() local InfiniteYield = {Enabled = false}
	InfiniteYield = GuiLibrary.ObjectsThatCanBeSaved.VoidwareWindow.Api.CreateOptionsButton({
		Name = "InfiniteYield",
		HoverText = "Loads the Infinite Yield script.",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() 
				end)
			end
		end
	})
end)

run(function() local Dex = {Enabled = false}
	Dex = GuiLibrary.ObjectsThatCanBeSaved.VoidwareWindow.Api.CreateOptionsButton({
		Name = "Dex",
		HoverText = "Loads Dex",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
				end)
				Dex.ToggleButton()
			end
		end
	})
end)

task.spawn(function()
	repeat task.wait() until shared.GuiLibrary.ObjectsThatCanBeSaved["StreamerModeToggle"].Api.Enabled
	local suc, err = pcall(function()
		while game:IsLoaded() == false do wait() end
		local fakeplr = {["Name"] = "7GrandDad", ["UserId"] = "239702688"}
		local otherfakeplayers = {["Name"] = "ROBLOX", ["UserId"] = "1"}
		local lplr = game:GetService("Players").LocalPlayer
		
		local function plrthing(obj, property)
			for i,v in pairs(game:GetService("Players"):GetChildren()) do
				if v ~= lplr then
					obj[property] = obj[property]:gsub(v.Name, otherfakeplayers["Name"])
					obj[property] = obj[property]:gsub(v.DisplayName, otherfakeplayers["Name"])
					obj[property] = obj[property]:gsub(v.UserId, otherfakeplayers["UserId"])
				else
					obj[property] = obj[property]:gsub(v.Name, fakeplr["Name"])
					obj[property] = obj[property]:gsub(v.DisplayName, fakeplr["Name"])
					obj[property] = obj[property]:gsub(v.UserId, fakeplr["UserId"])
				end
			end
		end
		
		local function newobj(v)
			if v:IsA("TextLabel") or v:IsA("TextButton") then
				plrthing(v, "Text")
				v:GetPropertyChangedSignal("Text"):connect(function()
					plrthing(v, "Text")
				end)
			end
			if v:IsA("ImageLabel") then
				plrthing(v, "Image")
				v:GetPropertyChangedSignal("Image"):connect(function()
					plrthing(v, "Image")
				end)
			end
		end
		
		for i,v in pairs(game:GetDescendants()) do
			newobj(v)
		end
		game.DescendantAdded:connect(newobj)
	end)
end)

--[[task.spawn(function()
	repeat task.wait() until shared.VapeFullyLoaded
	pcall(function()
		if shared.GuiLibrary.ObjectsThatCanBeSaved["ChatTagOptionsButton"].Api.Enabled then
		else
			repeat task.wait() until shared.vapewhitelist.loaded 
			local lplr = game:GetService("Players").LocalPlayer
			if shared.vapewhitelist:get(lplr) == 0 then 
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local yes = Players.LocalPlayer.Name
				local ChatTag = {}
				ChatTag[yes] =
					{
						TagText = "VOIDWARE USER",
						TagColor = Color3.fromRGB(255, 0, 0),
					}
				local oldchanneltab
				local oldchannelfunc
				local oldchanneltabs = {}
				for i, v in pairs(getconnections(ReplicatedStorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
					if
						v.Function
						and #debug.getupvalues(v.Function) > 0
						and type(debug.getupvalues(v.Function)[1]) == "table"
						and getmetatable(debug.getupvalues(v.Function)[1])
						and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
					then
						oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
						oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
						getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
							local tab = oldchannelfunc(Self, Name)
							if tab and tab.AddMessageToChannel then
								local addmessage = tab.AddMessageToChannel
								if oldchanneltabs[tab] == nil then
									oldchanneltabs[tab] = tab.AddMessageToChannel
								end
								tab.AddMessageToChannel = function(Self2, MessageData)
									if MessageData.FromSpeaker and Players[MessageData.FromSpeaker] then
										if ChatTag[Players[MessageData.FromSpeaker].Name] then
											MessageData.ExtraData = {
												NameColor = Players[MessageData.FromSpeaker].Team == nil and Color3.new(128,0,128)
													or Players[MessageData.FromSpeaker].TeamColor.Color,
												Tags = {
													table.unpack(MessageData.ExtraData.Tags),
													{
														TagColor = ChatTag[Players[MessageData.FromSpeaker].Name].TagColor,
														TagText = ChatTag[Players[MessageData.FromSpeaker].Name].TagText,
													},
												},
											}
										end
									end
									return addmessage(Self2, MessageData)
								end
							end
							return tab
						end
					end
				end	
			end
		end
	end)
end)--]]

local cooldown = 0
run(function() 
	local function setCooldown()
		cooldown = 5
		task.spawn(function()
			repeat cooldown = cooldown - 1 task.wait(1) until cooldown < 1
			cooldown = 0
		end)
	end
	local EditWL = {}
	local API_KEY = {Value = ""}
	local Tag_Text = {Value = ""}
	local Tag_Color = {Value = ""}
	local Custom_Tag_Color = {Value = ""}
	local Custom_Tag_Color_Toggle = {Enabled = false}
	local Roblox_Username = {Value = game:GetService("Players").LocalPlayer.Name}
	local Custom_Roblox_Username = {Value = ""}
	local Custom_Roblox_Username_Toggle = {Enabled = false}
	local Color_Table = {
		{name = "Black", hex = "#000000"},
		{name = "White", hex = "#FFFFFF"},
		{name = "Red", hex = "#FF0000"},
		{name = "Green", hex = "#00FF00"},
		{name = "Blue", hex = "#0000FF"},
		{name = "Yellow", hex = "#FFFF00"},
		{name = "Cyan", hex = "#00FFFF"},
		{name = "Magenta", hex = "#FF00FF"},
		{name = "Gray", hex = "#808080"},
		{name = "Orange", hex = "#FFA500"}
	}
	local function checkAPIKey()
		if API_KEY.Value ~= "" then
			return true, API_KEY.Value
		else
			return false, nil
		end
	end
	local function checkTagText()
		if Tag_Text.Value ~= "" then
			return true, Tag_Text.Value
		else
			return false, nil
		end
	end
	local function checkTagColor()
		if Custom_Tag_Color_Toggle.Enabled then
			if Custom_Tag_Color.Value ~= "" then
				return true, Custom_Tag_Color.Value, true
			else
				return false, nil, true
			end
		else
			if Tag_Color.Value ~= "" then 
				local color
				for i,v in pairs(Color_Table) do
					if Color_Table[i]["name"] == Tag_Color.Value then color = Color_Table[i]["hex"] break end
				end
				return true, color, false
			else
				return false, nil, false
			end
		end
	end
	local function checkRblxUsername()
		if Custom_Roblox_Username_Toggle.Enabled then
			if Custom_Roblox_Username.Value ~= "" then
				return true, Custom_Roblox_Username.Value, true
			else
				return false, nil, true
			end
		else
			if Roblox_Username.Value ~= "" then
				return true, Roblox_Username.Value, false
			else
				return false, nil, false
			end
		end
	end
	EditWL = GuiLibrary.ObjectsThatCanBeSaved.VoidwareWindow.Api.CreateOptionsButton({
		Name = 'EditWL',
		HoverText = "Use this to edit your whitelist data (whitelisted users only!)",
		Function = function(calling)
			if calling then 
				EditWL["ToggleButton"](false) 
				if cooldown ~= 0 then
					errorNotification("EditWL-Cooldown", "Please wait "..tostring(cooldown).." seconds.", cooldown)
					return
				end
				local suc1, apiKey = checkAPIKey()
				local suc2, tagText = checkTagText()
				local suc3, tagColor, isCustom = checkTagColor()
				local suc4, user, isCustom = checkRblxUsername()
				if not suc1 then errorNotification("EditWL-API_KEY", "Please specify your WL API Key in the textbox! \n More information in discord.gg/voidware \n (whitelisted users only)", 7) end
				if suc1 and (suc2 or suc3 or suc4) then
					local ArgTable = {}
					ArgTable["api_key"] = apiKey
					if suc2 then ArgTable["TagText"] = tagText end
					if suc3 then ArgTable["TagColor"] = tagColor end
					if suc4 then ArgTable["RobloxUsername"] = user end
					InfoNotification("EditWL", "Sent request to the Voidware API! Waiting for response...", 7)
					if not shared.VoidwareFunctions then errorNotification("EditWL-API_HANDLER", "Critical file not found!", 3) end
					local VoidwareFunctions = shared.VoidwareFunctions
					local response = VoidwareFunctions.EditWL(ArgTable)
					task.spawn(function()
						repeat task.wait() until response
						if type(response) == "string" then 
							errorNotification("EditWL-Response_Handler", "Failure! Error: "..tostring(response), 5) 
						elseif type(response) == "table" then
							if response["StatusCode"] then
								if response["StatusCode"] == 200 then
									InfoNotification("EditWL-Response_Handler", "Successfully edited your WL Data!", 3)
								else
									errorNotification("EditWL-Reponse_Handler", "Error! Error data has been sent in the console \n type /console in the roblox chat", 5)
									local function printError(text)
										print("[EditWL-Response_Handler Error]: "..text)
									end
									printError("StatusCode = "..tostring(response["StatusCode"]))
									printError("Body = "..tostring(game:GetService("HttpService"):JSONDecode(response["Body"])))
								end
							end
						else
							errorNotification("EditWL-Response_Handler", "Error! Unknown error", 5)
						end
					end)
 				else
					errorNotification("EditWL-TAG_ARGS", "Please specify at least one of the following: tag's text, tag's color \n in the textbox", 7)
				end
			end
		end
	}) 
	API_KEY = EditWL.CreateTextBox({
		Name = "WL-API-Key",
		TempText = "Type here your whitelist api-key",
		Function = function() end
	})
	Tag_Text = EditWL.CreateTextBox({
		Name = "Tag-Text",
		TempText = "Type here your tag's new text",
		Function = function() end
	})
	Custom_Roblox_Username = EditWL.CreateTextBox({
		Name = "New username",
		TempText = "Type here a username",
		Function = function() end
	})
	Custom_Roblox_Username.Object.Visible = false
	Custom_Roblox_Username_Toggle = EditWL.CreateToggle({
		Name = "Other Username",
		Function = function(calling)
			if calling then
				Custom_Roblox_Username.Object.Visible = true
			else
				Custom_Roblox_Username.Object.Visible = false
			end
		end
	})
	local simplified_color_table = {""}
	for i,v in pairs(Color_Table) do
		table.insert(simplified_color_table, Color_Table[i]["name"])
	end
	Tag_Color = EditWL.CreateDropdown({
		Name = "Tag-Color",
		Function = function() end,
		List = simplified_color_table
	})
	Custom_Tag_Color = EditWL.CreateTextBox({
		Name = "TagColor",
		TempText = "Type here your tag's new color \n (HEX)",
		Function = function() end
	})
	Custom_Tag_Color.Object.Visible = false
	Custom_Tag_Color_Toggle = EditWL.CreateToggle({
		Name = "Custom HEX color",
		Function = function(calling)
			if calling then
				Custom_Tag_Color.Object.Visible = true
				Tag_Color.Object.Visible = false
			else
				Custom_Tag_Color.Object.Visible = false
				Tag_Color.Object.Visible = true
			end
		end
	})
end)

task.spawn(function()
	local suc, err = pcall(function()
		local topbarappgui = lplr.PlayerGui:WaitForChild("TopBarAppGui")
		local topbarapp = topbarappgui:WaitForChild("TopBarApp")
		if topbarapp:FindFirstChild("3") then
			local thing_to_clone
			for i,v in pairs(topbarapp:GetChildren()) do
				if topbarapp:GetChildren()[i].ClassName == "Frame" then
					if topbarapp:GetChildren()[i]:FindFirstChild("2"):FindFirstChild("3") and topbarapp:GetChildren()[i]:FindFirstChild("2"):FindFirstChild("3").ClassName == "ImageLabel" then
						if topbarapp:GetChildren()[i]:FindFirstChild("2"):FindFirstChild("3").Image == "rbxassetid://8531706273" then
							thing_to_clone = topbarapp:GetChildren()[i]
							break
						end
					end
				end
			end
			local clone
			if thing_to_clone then
				clone = thing_to_clone:Clone() 
				local coreGui
				local suc, err = pcall(function()
					coreGui = game:GetService("CoreGui")
				end)
				if err then 
					clone.Parent = topbarappgui
					GuiLibrary.SelfDestructEvent.Event:Connect(function()
						clone:Destroy()
					end)
				else
					local frame = Instance.new("Frame")
					frame.Parent = coreGui:FindFirstChild("TopBarApp"):FindFirstChild("TopBarFrame"):FindFirstChild("LeftFrame")
					clone.Parent = frame
					GuiLibrary.SelfDestructEvent.Event:Connect(function()
						frame:Destroy()
					end)
				end
				print(tostring(clone.Parent))
				clone.Position = UDim2.new(0, 100, 0, 5)
				clone:WaitForChild("2"):WaitForChild("3").Image = "rbxassetid://18518244636"
				print(tostring(clone:WaitForChild("2"):WaitForChild("3").ClassName))
				table.insert(vapeConnections, clone:WaitForChild("2").MouseButton1Click:Connect(function()
					shared.GUIKeybindFunction() 
				end))
			end
		end
	end)
	if err then
		warn("Error making mobile button! Error: "..tostring(err))
	end
end)

local Customisation = GuiLibrary.ObjectsThatCanBeSaved.CustomisationWindow.Api
run(function()
	local UIS = game:GetService('UserInputService')
	local mouseMod = {Enabled = false}
	local mouseDropdown = {Value = 'Arrow'}
	local mouseIcons = {
		['CS:GO'] = 'rbxassetid://14789879068',
		['Old Roblox Mouse'] = 'rbxassetid://13546344315',
		['dx9ware'] = 'rbxassetid://12233942144',
		['Aimbot'] = 'rbxassetid://8680062686',
		['Triangle'] = 'rbxassetid://14790304072',
		['Arrow'] = 'rbxassetid://14790316561'
	}
	local customMouseIcon = {Enabled = false}
	local customIcon = {Value = ''}
	mouseMod = Customisation.CreateOptionsButton({
		Name = 'MouseMod',
		HoverText = 'Modifies your cursor\'s image.',
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait()
						if customMouseIcon.Enabled then
							UIS.MouseIcon = 'rbxassetid://' .. customIcon.Value
						else
							UIS.MouseIcon = mouseIcons[mouseDropdown.Value]
						end
					until not mouseMod.Enabled
				end)
			else
				UIS.MouseIcon = ''
				task.wait()
				UIS.MouseIcon = ''
			end
		end
	})
	mouseDropdown = mouseMod.CreateDropdown({
		Name = 'Mouse Icon',
		List = {
			'CS:GO',
			'Old Roblox Mouse',
			'dx9ware',
			'Aimbot',
			'Triangle',
			'Arrow'
		},
		Function = function() end
	})
	customMouseIcon = mouseMod.CreateToggle({
		Name = 'Custom Icon',
		Function = function(callback) end
	})
	customIcon = mouseMod.CreateTextBox({
		Name = 'Custom Mouse Icon',
		TempText = 'Image ID (not decal)',
		FocusLost = function(enter) 
			if mouseMod.Enabled then 
				mouseMod.ToggleButton(false)
				mouseMod.ToggleButton(false)
			end
		end
	})
end)

run(function()
	local CustomNotification = {Enabled = false}
	local CustomNotificationMode = {Value = 'Absolute'}
	local CustomNotificationColor = {
		Hue = 1,
		Sat = 1,
		Value = 0.50
	}
	local CustomNotificationPath = {Value = 'assets/InfoNotification.png'}
	CustomNotification = Customisation.CreateOptionsButton({
		Name = 'CustomNotification',
        HoverText = 'Customizes vape\'s notification',
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait()
						if CustomNotificationMode.Value == 'Color' then
							shared.NotifyColor = Color3.fromHSV(CustomNotificationColor.Hue, CustomNotificationColor.Sat, CustomNotificationColor.Value)
							shared.NotifyIcon = 'assets/WarningNotification.png'
						elseif CustomNotificationMode.Value == 'Icon' then
							shared.NotifyColor = Color3.fromRGB(236, 129, 44)
							shared.NotifyIcon = CustomNotificationPath.Value
						elseif CustomNotificationMode.Value == 'Absolute' then
							shared.NotifyColor = Color3.fromHSV(CustomNotificationColor.Hue, CustomNotificationColor.Sat, CustomNotificationColor.Value)
							shared.NotifyIcon = CustomNotificationPath.Value
						end
					until not CustomNotification.Enabled
				end)
			else
				shared.NotifyColor = Color3.fromRGB(236, 129, 44)
				shared.NotifyIcon = 'assets/WarningNotification.png'
			end
		end,
		ExtraText = function()
			return CustomNotificationMode.Value
		end
	})
	CustomNotificationMode = CustomNotification.CreateDropdown({
		Name = 'Mode',
		List = {
			'Color',
			'Icon',
			'Absolute'
		},
		HoverText = 'Notifcation Mode',
		Function = function() end,
	})
	CustomNotificationColor = CustomNotification.CreateColorSlider({
		Name = 'Color',
		HoverText = 'Notification Color',
		Function = function() end,
	})
	CustomNotificationPath = CustomNotification.CreateTextBox({
		Name = 'IconPath',
		TempText = 'Icon Path',
		HoverText = 'Notificatiion Icon Path',
		FocusLost = function(enter) 
			if CustomNotification.Enabled then 
				CustomNotification.ToggleButton(false)
				CustomNotification.ToggleButton(false)
			end
		end
	})
end)