require("ui.uieditor.widgets.GameSettings.GameSettings_Background")
require("ui.uieditor.widgets.Lobby.Common.FE_TabBar")
require("ui.uieditor.widgets.Lobby.Common.FE_Menu_LeftGraphics")
require("ui.uieditor.widgets.Scrollbars.verticalCounter")
require("ui.uieditor.widgets.CharacterCustomization.list1ButtonNewStyle")
require("ui.uieditor.widgets.BackgroundFrames.GenericMenuFrame")
require("ui.uieditor.widgets.Lobby.Common.FE_TitleLineSingle")

local UpdateDvarSetting = function ( self, element, controller, dvar, menu )
	local dvarSetting = dvar
	local f1_local1 = Engine.DvarInt( nil, dvarSetting )
	local f1_local2 = element.value
	UpdateInfoModels( element )
	if f1_local2 == f1_local1 then
		return 
	end
	print( "Setting Dvar: " .. dvarSetting .. " to: " .. f1_local2 )
	Engine.SetDvar( dvarSetting, f1_local2 )
	if CoDShared.IsGametypeTeamBased() then
		local f1_local3 = Engine.DvarInt( nil, "bot_maxAllies" )
		local f1_local4 = Engine.DvarInt( nil, "bot_maxAxis" )
		local f1_local5 = CoD.GameSettingsUtility.GetMaxBotsCount()
		if f1_local5 < f1_local3 + f1_local4 then
			local f1_local6 = 0
			if dvarSetting == "bot_maxAllies" and f1_local3 > 0 then
				f1_local6 = f1_local5 - f1_local3 + 1
			else
				f1_local6 = f1_local5 - f1_local4 + 1
			end
			if f1_local6 > 0 then
				if dvarSetting == "bot_maxAllies" then
					Engine.SetDvar( "bot_maxAxis", f1_local6 - 1 )
				else
					Engine.SetDvar( "bot_maxAllies", f1_local6 - 1 )
				end
			end
		end
	end
	Engine.ForceNotifyModelSubscriptions( Engine.CreateModel( Engine.CreateModel( Engine.GetGlobalModel(), "GametypeSettings" ), "Update" ) )
end

local UpdateGameModeSetting = function ( self, element, controller, dvar, menu )
	local function strTok( str_word, token )
		local index = 1
		local elements = {}
		for word in string.gmatch( str_word, '([^' .. token .. ']+)' ) do
			elements[ index ] = word
			index = index + 1
		end
		return elements
	end
	local dvarSetting = dvar
	local f1_local1 = Engine.DvarString( nil, dvarSetting )
	local f1_local2 = element.value
	local gamemodeandareaarray = strTok( f1_local2, "_" )
	UpdateInfoModels( element )
	if gamemodeandareaarray then
		element.gametype = gamemodeandareaarray[ 1 ]
		if not element.gametype then
			element.gametype = "znml"
		end

		local area = gamemodeandareaarray[ 2 ]
		if not area then
			area = "area1"
		end
		SetCurrentUIGameType(element, controller)
		GameModeSelected(element, controller)
		print( "Setting Dvar: " .. "ui_location" .. " to: " .. area )
		Engine.SetDvar( "ui_location", area )
		print( "Setting Dvar: " .. dvarSetting .. " to: " .. f1_local2 )
		Engine.SetDvar( dvarSetting, f1_local2 )
		Engine.ForceNotifyModelSubscriptions( Engine.CreateModel( Engine.CreateModel( Engine.GetGlobalModel(), "GametypeSettings" ), "Update" ) )
	end
end

local f0_local1, f0_local2 = nil
DataSources.MJGameTabs = DataSourceHelpers.ListSetup("MJGameTabs", function (f7_arg0, f7_arg1, f7_arg2, f7_arg3, f7_arg4)
	local categories = {}
	table.insert(categories, {models = {tabIcon = CoD.buttonStrings.shoulderl},properties = {m_mouseDisabled = true}})
	table.insert(categories, {models = {tabName = "GLOBAL", tabIcon = ""},properties = {tabId = "MJGameTabsGlobalSettings", dataSourceName = "MJGameTabsGlobalSettings", title = ""}})
	table.insert(categories, {models = {tabIcon = CoD.buttonStrings.shoulderr},properties = {m_mouseDisabled = true}})
	return categories
end)

f0_local1, f0_local2 = nil
DataSources.MJGameTabsGlobalSettings = DataSourceHelpers.ListSetup("MJGameTabsGlobalSettings", function (menu, controller, f10_arg2, f10_arg3, f10_arg4)
	local GlobalOptions = {}
	local PointOptions = {}
	local PerkLimitOptions = {}
	if not CoD.GameOptions.GameModeAndArea then
		CreateMapOptions( nil, controller, nil )
	end
	table.insert(GlobalOptions, CoD.OptionsUtility.CreateNamedSettings(
																		menu, 
																		"Difficulty",
																		"ZMUI_DIFFICULTY_DESC", 
																		"mutatorOption_difficulty", 
																		"zmDifficulty", 
																		{
																			{
																				option = "Easy", 
																				value = 0
																			},
																			{
																				option = "Normal",
																				value = 1,
																				default = true
																			} 
																		} 
																		) )
	table.insert( GlobalOptions, CoD.OptionsUtility.CreateDvarSettings( 
																		menu, 
																		"Game mode and Area", 
																		"Set the gamemode and area", 
																		"mutatorOption_scr_gamemodeandarea", 
																		"scr_gamemodeandarea", 
																		CoD.GameOptions.GameModeAndArea,
																		nil, 
																		UpdateGameModeSetting ) )
	table.insert( GlobalOptions, CoD.OptionsUtility.CreateDvarSettings( 
																		menu, 
																		"Truck Drive Mode", 
																		"Choose between the 2007 or Urban's Assault drive mode.\n\n^22007^7 has infinite boost, but using too much will blow your engine. There is also no air control.\n\nThe ^2Urban Assault^7 allows for air control, which can help with landing jumps. Earn boost by earning stars, which can be earned by doing stunts or destroying objects.\nCompleting your spectacle star earns you a Monster Spectacle, which gives you an extra tank of boost.", 
																		"mutatorOption_scr_enable_ua", 
																		"scr_enable_ua", {
                                                                        {
                                                                            option = "2007", 
                                                                            value = 0,
                                                                            default = true
                                                                        },
                                                                        {
                                                                            option = "Urban Assault",
                                                                            value = 1
                                                                        } 
                                                                        }, 
                                                                        nil, 
																		UpdateDvarSetting ) )
	--[[
	table.insert(GlobalOptions, CoD.OptionsUtility.CreateNamedSettings(
																		menu, 
																		"MENU_HIT_MARKERS",
																		"MENU_HIT_MARKERS_HINT", 
																		"mutatorOption_hitmarkers", 
																		"allowhitmarkers", 
																		{
																			{
																				option = "T6_MENU_DISABLED_CAPS", 
																				value = 0,
																				default = true
																			},
																			{
																				option = "T6_MENU_ENABLED_CAPS",
																				value = 1
																			} 
																		} 
																		) )
	table.insert(GlobalOptions, CoD.OptionsUtility.CreateNamedSettings(
																		menu, 
																		"Headshots Only",
																		"ZMUI_HEADSHOTS_ONLY_DESC", 
																		"mutatorOption_headshotsonly", 
																		"headshotsonly", 
																		{
																			{
																				option = "T6_MENU_DISABLED_CAPS", 
																				value = 0,
																				default = true
																			},
																			{
																				option = "T6_MENU_ENABLED_CAPS",
																				value = 1
																			} 
																		} 
																		) )
	table.insert(GlobalOptions, CoD.OptionsUtility.CreateNamedSettings(
																		menu, 
																		"Start Round",
																		"Set the starting round.", 
																		"mutatorOption_startRound", 
																		"startRound", 
																		{
																			{
																				option = "1", 
																				value = 1, 
																				default = true
																			},
																			{
																				option = "5",
																				value = 5
																			},
																			{
																				option = "10", 
																				value = 10
																			},
																			{
																				option = "15", 
																				value = 15
																			},
																			{
																				option = "20", 
																				value = 20
																			}
																		} 
																		) )
	table.insert(GlobalOptions, CoD.OptionsUtility.CreateNamedSettings(
																		menu, 
																		"Magic",
																		"ZMUI_MAGIC_DESC", 
																		"mutatorOption_magic", 
																		"magic", 
																		{
																			{
																				option = "T6_MENU_DISABLED_CAPS", 
																				value = 0
																			},
																			{
																				option = "T6_MENU_ENABLED_CAPS",
																				value = 1,
																				default = true
																			}
																		} 
																		) )
	table.insert(GlobalOptions, CoD.OptionsUtility.CreateNamedSettings(
																		menu, 
																		"Health",
																		"The amount of health players start off with.", 
																		"mutatorOption_playerMaxHealth", 
																		"playerMaxHealth", 
																		{
																			{
																				option = "50 (1 Hit)", 
																				value = 50
																			},
																			{
																				option = "100 (2 Hits)",
																				value = 100,
																				default = true
																			},
																			{
																				option = "150 (3 Hits)",
																				value = 150
																			},
																			{
																				option = "200 (4 Hits)",
																				value = 200
																			},
																			{
																				option = "250 (5 Hits)",
																				value = 250
																			},
																			{
																				option = "300 (6 Hits)",
																				value = 300
																			}
																		} 
																	  ) )
	table.insert( PointOptions,  {
								option = "Let 'Start Round' decide",
								value = 0,
								default = true
							} )
	for AddPoints = 50, 5000, 50 do
		table.insert( PointOptions, {
			option = tostring( AddPoints * 10 ),
			value = AddPoints
		})
	end
	table.insert(GlobalOptions, CoD.OptionsUtility.CreateNamedSettings(
																		menu, 
																		"Starting Points",
																		"Set the amount of points that players will start with. The 'Let 'Start Round' decide' option will dictate the points players start with.", 
																		"mutatorOption_scorelimit", 
																		"scorelimit", 
																		PointOptions 
																		) )
	for PerkLimit1 = 0, 3, 1 do
		table.insert( PerkLimitOptions, {
			option = tostring( PerkLimit1 ),
			value = PerkLimit1
		})
	end
	table.insert( PerkLimitOptions,  {
								option = "4",
								value = 4,
								default = true
							} )
	for PerkLimit2 = 5, 12, 1 do
		table.insert( PerkLimitOptions, {
			option = tostring( PerkLimit2 ),
			value = PerkLimit2
		})
	end
	table.insert(GlobalOptions, CoD.OptionsUtility.CreateNamedSettings(
																		menu, 
																		"Perk Limit",
																		"Set the perk limit of players. Any perk not part of Black Ops 2 Zombies will be removed.", 
																		"mutatorOption_destroyTime", 
																		"destroyTime", 
																		PerkLimitOptions 
																		) )
	table.insert(GlobalOptions, CoD.OptionsUtility.CreateNamedSettings(
																		menu, 
																		"Dive To Prone",
																		"Enables or disables the 'Dive To Prone' movement mechanic.", 
																		"mutatorOption_autoDestroyTime", 
																		"autoDestroyTime", 
																		{
																			{
																				option = "T6_MENU_DISABLED_CAPS", 
																				value = 0
																			},
																			{
																				option = "T6_MENU_ENABLED_CAPS",
																				value = 1,
																				default = true
																			}
																		} 
																		) )
	]]
	return GlobalOptions
end)

LUI.createMenu.MJGamesettings = function (controller)
	local self = CoD.Menu.NewForUIEditor("MJGamesettings")
	if PreLoadCallback then
		PreLoadCallback(self, controller)
	end
	self.soundSet = "MultiplayerMain"
	self:setOwner(controller)

	self:setLeftRight(true, true, 0, 0)
	self:setTopBottom(true, true, 0, 0)

	self:playSound("menu_open", controller)

	self.buttonModel = Engine.CreateModel(Engine.GetModelForController(controller), "GametypeSettings.buttonPrompts")
	self.anyChildUsesUpdateState = true

	-- init the host player's info for this splitscreen player.
	--if IsPlayerAGuest( controller ) then
		InitUnlockInfo( nil, controller )
	--end

	self.BlackBG = LUI.UIImage.new()
	self.BlackBG:setLeftRight(true, true, 0, 0)
	self.BlackBG:setTopBottom(true, true, 0, 0)
	self.BlackBG:setImage(RegisterImage("uie_fe_cp_background"))
	self:addElement(self.BlackBG)

	self.GameSettingsBackground = CoD.GameSettings_Background.new(self, controller)
	self.GameSettingsBackground:setLeftRight(true, true, 0, 0)
	self.GameSettingsBackground:setTopBottom(true, true, 0, 0)
	self.GameSettingsBackground.MenuFrame.titleLabel:setText(Engine.Localize( "MENU_GENERAL_CAPS"))
	self.GameSettingsBackground.GameSettingsSelectedItemInfo.GameModeInfo:setAlpha(0)
	self.GameSettingsBackground.GameSettingsSelectedItemInfo.GameModeName:setAlpha(0)
	self.GameSettingsBackground.MenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText(Engine.Localize( "MENU_GENERAL_CAPS" ) )
	self.GameSettingsBackground.MenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon.FeatureIcon:setImage(RegisterImage("uie_t7_mp_icon_header_customgames"))
	self:addElement(self.GameSettingsBackground)

	self.Options = CoD.Competitive_SettingsList.new(self, controller)
	self.Options:setLeftRight(true, false, 26, 741)
	self.Options:setTopBottom(true, false, 135, 720)
	self.Options.id = "Options"
	self.Options.Title.DescTitle:setText("")
	self.Options.ButtonList:setVerticalCount(14)
	self.Options.ButtonList:setVerticalCounter(CoD.verticalCounter)
	self:addElement(self.Options)
	
	self.TabList = CoD.FE_TabBar.new(self, controller)
	self.TabList:setLeftRight(true, false, 0, 2496)
	self.TabList:setTopBottom(true, false, 84, 123)
	self.TabList.Tabs.grid:setWidgetType(CoD.WeaponGroupsTabWidget)
	self.TabList.Tabs.grid:setDataSource("MJGameTabs")
	self.TabList.Tabs.grid:setHorizontalCount(16)
	self:registerEventHandler("list_active_changed", function (Sender, Event)
		if Sender.dataSourceName ~= nil and Sender.title ~= nil then
			self.Options.Title.DescTitle:setText(Engine.Localize(Sender.title))
			self.Options.ButtonList:setDataSource(Sender.dataSourceName)
		end
		return nil
	end)

	self:addElement(self.TabList)

	self.FEMenuLeftGraphics = CoD.FE_Menu_LeftGraphics.new(self, controller)
	self.FEMenuLeftGraphics:setLeftRight(false, false, -621, -569)
	self.FEMenuLeftGraphics:setTopBottom(true, false, 84, 701)
	self:addElement(self.FEMenuLeftGraphics)

	self.Pixel200 = LUI.UIImage.new()
	self.Pixel200:setLeftRight(false, false, 565.87, 601.87)
	self.Pixel200:setTopBottom(true, false, 652.75, 656.75)
	self.Pixel200:setImage(RegisterImage("uie_t7_menu_frontend_pixelist"))
	self.Pixel200:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	self:addElement(self.Pixel200)
	
	self.LineSide = LUI.UIImage.new()
	self.LineSide:setLeftRight(false, false, 576, 579)
	self.LineSide:setTopBottom(true, true, 85, -38)
	self.LineSide:setImage(RegisterImage("uie_t7_menu_frontend_lineside"))
	self.LineSide:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	self:addElement(self.LineSide)
	
	--[[local CPDifficultyInGameChangeWarning = CoD.CPDifficultyInGameChangeWarning.new(self, controller)
	CPDifficultyInGameChangeWarning:setLeftRight(false, false, -576, -272)
	CPDifficultyInGameChangeWarning:setTopBottom(true, false, 352.5, 468.5)
	self:addElement(CPDifficultyInGameChangeWarning)
	self.CPDifficultyInGameChangeWarning = CPDifficultyInGameChangeWarning]]
	
	self.FETitleLineSingle = CoD.FE_TitleLineSingle.new(self, controller)
	self.FETitleLineSingle:setLeftRight(true, true, 1164, 3.99)
	self.FETitleLineSingle:setTopBottom(false, true, -1.75, 2.25)
	self:addElement(self.FETitleLineSingle)
	
	self.pixelU = LUI.UIImage.new()
	self.pixelU:setLeftRight(false, false, 565, 601)
	self.pixelU:setTopBottom(true, false, 552.25, 555.75)
	self.pixelU:setImage(RegisterImage("uie_t7_menu_frontend_pixelist"))
	self.pixelU:setMaterial(LUI.UIImage.GetCachedMaterial("uie_feather_add"))
	self:addElement(self.pixelU)
	
	self.pixelU1 = LUI.UIImage.new()
	self.pixelU1:setLeftRight(false, false, 565, 601)
	self.pixelU1:setTopBottom(true, false, 596.25, 599.75)
	self.pixelU1:setImage(RegisterImage("uie_t7_menu_frontend_pixelist"))
	self.pixelU1:setMaterial(LUI.UIImage.GetCachedMaterial("uie_feather_add"))
	self:addElement(self.pixelU1)
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter(0)
			end
		}
	}

	 self.StateTable = {
		{
			stateName = "cpzm",
			condition = function(self, ItemRef, UpdateTable)
				return IsCampaignZombies()
			end
		}
	}
	self:mergeStateConditions(self.StateTable)

	self:registerEventHandler("menu_loaded", function(Sender, Event)
		local success = nil
		SetElementStateByElementName(self, "MenuFrame", controller, "Update")
		PlayClipOnElement(self, {elementName = "MenuFrame", clipName = "Intro"},controller)
		PlayClip(self, "Intro", controller)
		ShowHeaderIconOnly(self)

		if not success then
			success = Sender:dispatchEventToChildren(Event)
		end

		return success
	end)

	self:AddButtonCallbackFunction(self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function (ItemRef, self, controller, ButtonModel)
		GoBack(self, controller)
		CustomGameSettingsMenuClosed( self, controller )
		ClearSavedState(self, controller)
		SetPerControllerTableProperty(controller, "disableGameSettingsOptions", nil)
		return true
	end, function (ItemRef, self, controller)
		CoD.Menu.SetButtonLabel(self, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK")
		return true
	end, false)

	self.GameSettingsBackground.MenuFrame:setModel(self.buttonModel, controller)

	self:processEvent({
		name = "menu_loaded", 
		controller = controller
	})

	self:processEvent({
		name = "update_state", 
		menu = self
	})

	if not self:restoreState() then
		self.Options:processEvent({
			name = "gain_focus", 
			controller = controller
		})
	end
	LUI.OverrideFunction_CallOriginalSecond(self, "close", function (Sender)
		Sender.BlackBG:close()
		Sender.GameSettingsBackground:close()
		Sender.Options:close()
		Sender.TabList:close()
		Sender.FEMenuLeftGraphics:close()
		Sender.Pixel200:close()
		Sender.LineSide:close()
		Sender.FETitleLineSingle:close()
		Sender.pixelU:close()
		Sender.pixelU1:close()
		Engine.UnsubscribeAndFreeModel(Engine.GetModel(Engine.GetModelForController(controller), "GametypeSettings.buttonPrompts"))
	end)
	if PostLoadFunc then
		PostLoadFunc(self, controller)
	end
	return self
end

