require( "ui.uieditor.widgets.HUD.core_MapWidget.MapWidget_PanelVignetteRight" )
require( "ui.uieditor.widgets.HUD.CP_DamageWidget.DamageWidgetContainer" )
require( "ui.uieditor.widgets.HUD.core_AmmoWidget.AmmoWidgetContainer" )
require( "ui.uieditor.widgets.HUD.core_AmmoWidget.AmmoWidgetEMP" )
require( "ui.uieditor.widgets.HUD.CP_DamageWidget.DamageWidgetEMP" )
require( "ui.uieditor.widgets.CPSystems.CommsSystem.CommsSystemWidget" )
require( "ui.uieditor.widgets.DynamicContainerWidget" )
require( "ui.uieditor.widgets.HUD.CP_PartyList.PartyListContainerParent" )
require( "ui.uieditor.widgets.CPSystems.TacticalMode.RepulsorIndicator" )
require( "ui.uieditor.widgets.Scoreboard.CP.ScoreboardWidgetCP" )
require( "ui.uieditor.widgets.Chat.inGame.IngameChatClientContainer" )
require( "ui.uieditor.widgets.CPSystems.EnemyTarget.EnemyTargetInternal" )
require( "ui.uieditor.widgets.CPSystems.IncomingExplosive.IncomingExplosiveInternal" )
require( "ui.uieditor.widgets.CPSystems.Revive.BleedOut.bleedOutWidget" )
require( "ui.uieditor.widgets.CPSystems.SpikeLauncher.SpikeCounter.SpikeLauncherSpikeCounter" )
require( "ui.uieditor.widgets.CPSystems.TacticalMode.TacticalModeWidget" )
require( "ui.uieditor.widgets.CPSystems.WeakPoints.weakpointIndicator" )

require( "ui.uieditor.widgets.MonsterJam.BoostGuage.BoostWidget" )
require( "ui.uieditor.widgets.MonsterJam.BoostGuage.BoostWidgetUA" )
require( "ui.uieditor.widgets.MonsterJam.Position.PositionWidget" )
require( "ui.uieditor.widgets.MonsterJam.Laps.LapWidget" )
require( "ui.uieditor.widgets.MonsterJam.Notification.TruckNotify" )
require( "ui.uieditor.widgets.MonsterJam.Notification.StartRaceNotify" )
require( "ui.uieditor.widgets.MonsterJam.Notification.MonsterSpectacleNotify" )
require( "ui.uieditor.widgets.MonsterJam.Score.ScoreWidget" )

require( "ui.uieditor.menus.EndGameRank" )
require( "ui.uieditor.menus.EndGameResults" )
require( "ui.uieditor.menus.MonsterJam.UnlockInfo" )

DataSources.StartMenuGameOptions = ListHelper_SetupDataSource( "StartMenuGameOptions", function ( f89_arg0 )
	local f89_local0 = {}
	if Engine.IsDemoPlaying() then
		local f89_local1 = Engine.GetDemoSegmentCount()
		local f89_local2 = Engine.IsDemoHighlightReelMode()
		local f89_local3 = Engine.IsDemoClipPlaying()
		if not IsDemoRestrictedBasicMode() then
			table.insert( f89_local0, {
				models = {
					displayText = Engine.ToUpper( Engine.Localize( "MENU_UPLOAD_CLIP", f89_local1 ) ),
					action = StartMenuUploadClip,
					disabledFunction = IsUploadClipButtonDisabled
				},
				properties = {
					hideHelpItemLabel = true
				}
			} )
		end
		if f89_local2 then
			table.insert( f89_local0, {
				models = {
					displayText = Engine.ToUpper( Engine.Localize( "MENU_DEMO_CUSTOMIZE_HIGHLIGHT_REEL" ) ),
					action = StartMenuOpenCustomizeHighlightReel,
					disabledFunction = IsCustomizeHighlightReelButtonDisabled
				}
			} )
		end
		table.insert( f89_local0, {
			models = {
				displayText = Engine.ToUpper( Engine.ToUpper( Engine.Localize( "MENU_JUMP_TO_START" ) ) ),
				action = StartMenuJumpToStart,
				disabledFunction = IsJumpToStartButtonDisabled
			},
			properties = {
				hideHelpItemLabel = true
			}
		} )
		local f89_local4 = nil
		if f89_local3 then
			f89_local4 = Engine.ToUpper( Engine.Localize( "MENU_END_CLIP" ) )
		else
			f89_local4 = Engine.ToUpper( Engine.Localize( "MENU_END_FILM" ) )
		end
		table.insert( f89_local0, {
			models = {
				displayText = Engine.ToUpper( f89_local4 ),
				action = StartMenuEndDemo
			}
		} )
	elseif CoD.isCampaign then
		table.insert( f89_local0, {
			models = {
				displayText = "MENU_RESUMEGAME_CAPS",
				action = StartMenuGoBack_ListElement
			}
		} )
		if Engine.IsLobbyHost( Enum.LobbyType.LOBBY_TYPE_GAME ) and ((Engine.SessionModeIsMode( CoD.SESSIONMODE_SYSTEMLINK ) == true) or Engine.SessionModeIsMode( CoD.SESSIONMODE_OFFLINE ) == true) then
			table.insert( f89_local0, {
				models = {
					displayText = "MENU_RESTART_LEVEL_CAPS",
					action = RestartGame
				}
			} )
		end
		if Engine.IsLobbyHost( Enum.LobbyType.LOBBY_TYPE_GAME ) == true then
			table.insert( f89_local0, {
				models = {
					displayText = "MENU_END_GAME_CAPS",
					action = QuitGame_MP
				}
			} )
		else
			table.insert( f89_local0, {
				models = {
					displayText = "MENU_QUIT_GAME_CAPS",
					action = QuitGame_MP
				}
			} )
		end
	elseif CoD.isMultiplayer then
		if Engine.Team( f89_arg0, "name" ) ~= "TEAM_SPECTATOR" and Engine.GetGametypeSetting( "disableClassSelection" ) ~= 1 then
			table.insert( f89_local0, {
				models = {
					displayText = "MPUI_CHOOSE_CLASS_BUTTON_CAPS",
					action = ChooseClass
				}
			} )
		end
		if Engine.GameModeIsMode( CoD.GAMEMODE_PUBLIC_MATCH ) == false and Engine.GameModeIsMode( CoD.GAMEMODE_LEAGUE_MATCH ) == false and not Engine.IsVisibilityBitSet( f89_arg0, Enum.UIVisibilityBit.BIT_ROUND_END_KILLCAM ) and not Engine.IsVisibilityBitSet( f89_arg0, Enum.UIVisibilityBit.BIT_FINAL_KILLCAM ) and CoD.IsTeamChangeAllowed() then
			table.insert( f89_local0, {
				models = {
					displayText = "MPUI_CHANGE_TEAM_BUTTON_CAPS",
					action = ChooseTeam
				}
			} )
		end
		if f89_arg0 == 0 then
			local f89_local2 = "MENU_QUIT_GAME_CAPS"
			if Engine.IsLobbyHost( Enum.LobbyType.LOBBY_TYPE_GAME ) and not CoD.isOnlineGame() then
				f89_local2 = "MENU_END_GAME_CAPS"
			end
			table.insert( f89_local0, {
				models = {
					displayText = f89_local2,
					action = QuitGame_MP
				}
			} )
		end
	elseif CoD.isZombie then
		table.insert( f89_local0, {
			models = {
				displayText = "MENU_RESUMEGAME_CAPS",
				action = StartMenuGoBack_ListElement
			}
		} )
		if Engine.IsLobbyHost( Enum.LobbyType.LOBBY_TYPE_GAME ) and ((Engine.SessionModeIsMode( CoD.SESSIONMODE_SYSTEMLINK ) == true) or Engine.SessionModeIsMode( CoD.SESSIONMODE_OFFLINE ) == true) then
			table.insert( f89_local0, {
				models = {
					displayText = "MENU_RESTART_LEVEL_CAPS",
					action = RestartGame
				}
			} )
		end
		if Engine.IsLobbyHost( Enum.LobbyType.LOBBY_TYPE_GAME ) == true then
			table.insert( f89_local0, {
				models = {
					displayText = "MENU_END_GAME_CAPS",
					action = QuitGame_MP
				}
			} )
		else
			table.insert( f89_local0, {
				models = {
					displayText = "MENU_QUIT_GAME_CAPS",
					action = QuitGame_MP
				}
			} )
		end
	end
	return f89_local0
end, true )

DataSources.ScoreboardResults = {
	prepare = function ( controller, UIList, FilterFunc )
		local f872_local0 = Engine.CreateModel( Engine.CreateModel( Engine.GetModelForController( controller ), "CodCaster" ), "showCodCasterScoreboard" )
		UIList.scoreboardInfoModel = Engine.GetModel( Engine.GetGlobalModel(), "scoreboard.team1" )
		if UIList.teamCountSubscription then
			UIList:removeSubscription( UIList.teamCountSubscription )
		end
		UIList.teamCountSubscription = UIList:subscribeToModel( Engine.GetModel( UIList.scoreboardInfoModel, "count" ), function ()
			UIList:updateDataSource( nil, true, true )
			Engine.ForceNotifyModelSubscriptions( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ) )
		end, false )
	end,
	getCount = function ( UIList )
		local f875_local0 = CoD.ScoreboardUtility.MinRowsToShowOnEachTeam
		if Engine.GetCurrentTeamCount() < 2 and not Engine.IsZombiesGame() and not Engine.IsCampaignGame() then
			f875_local0 = CoD.ScoreboardUtility.MinRowsToShowOnEachTeamForFFA
		end
		return math.max( Engine.GetModelValue( Engine.GetModel( UIList.scoreboardInfoModel, "count" ) ), f875_local0 )
	end,
	getItem = function ( controller, UIList, ItemIndex )
		local client = Engine.GetModelValue( Engine.GetModel( Engine.GetModel( Engine.GetGlobalModel(), "scoreboard.team1" ), "count" ) ) - ItemIndex
		if client < 0 then
			client = ItemIndex - 1
		end
		return Engine.GetModel( UIList.scoreboardInfoModel, client )
	end
}

local PreLoadFunc = function ( self, controller )
	Engine.CreateModel( Engine.GetModelForController( controller ), "playerAbilities.repulsorIndicatorDirection" )
	Engine.CreateModel( Engine.GetModelForController( controller ), "playerAbilities.repulsorIndicatorIntensity" )
	Engine.CreateModel( Engine.GetModelForController( controller ), "playerAbilities.proximityIndicatorDirection" )
	Engine.CreateModel( Engine.GetModelForController( controller ), "playerAbilities.proximityIndicatorIntensity" )
end

local PostLoadFunc = function ( self, controller )
	local WorldSpaceIndicatorsModel = DataSources.WorldSpaceIndicators.getModel( controller )
	local GetWeakPointIndicatorModel = function ( f3_arg0, f3_arg1, f3_arg2, f3_arg3 )
		local f3_local0 = Engine.GetModel( Engine.GetModelForController( controller ), "WorldSpaceIndicators" )
		if f3_local0 then
			local f3_local1 = Engine.CreateModel( f3_local0, "weakpoint_" .. f3_arg0 .. "_" .. f3_arg1 )
			if f3_local1 then
				LUI.CreateModelAndInitialize( f3_local1, "status", Enum.WeakpointWidgetStates.WEAKPOINT_STATE_DEFAULT )
				local f3_local2 = CoD.weakpointIndicator.new( self, controller )
				f3_local2:setModel( f3_local1 )
				f3_local2:setupWeakpointIndicator( controller, f3_arg0, f3_arg1, f3_arg2, f3_arg3 )
				LUI.OverrideFunction_CallOriginalFirst( f3_local2, "close", function ()
					Engine.UnsubscribeAndFreeModel( f3_local1 )
				end )
				return f3_local2
			end
		end
	end
	
	self.weakpoints = {}
	self:subscribeToGlobalModel( controller, "PerController", "scriptNotify", function ( model )
		local modelValue = Engine.GetModelValue( model )
		local notifyData = {
			controller = controller,
			name = modelValue,
			data = CoD.GetScriptNotifyData( model )
		}
		if modelValue == "weakpoint_update" then
			local entNum = notifyData.data[2]
			local boneName = Engine.GetIString( notifyData.data[3], "CS_LOCALIZED_STRINGS" )
			if notifyData.data[1] == 0 then
				if self.weakpoints[entNum] and self.weakpoints[entNum][boneName] then
					local statusModel = self.weakpoints[entNum][boneName]:getModel( controller, "status" )
					if statusModel then
						Engine.SetModelValue( statusModel, Enum.WeakpointWidgetStates.WEAKPOINT_STATE_CLOSING )
					end
					local weakPointElement = self.weakpoints[entNum][boneName]
					weakPointElement:addElement( LUI.UITimer.newElementTimer( 1500, true, weakPointElement.close, weakPointElement ) )
					self.weakpoints[entNum][boneName] = nil
				end
			elseif notifyData.data[1] == 1 then
				if not self.weakpoints[entNum] then
					self.weakpoints[entNum] = {}
				end
				if not self.weakpoints[entNum][boneName] then
					local weakpointIndicatorModel = GetWeakPointIndicatorModel( entNum, boneName, notifyData.data[4], notifyData.data[5] )
					if weakpointIndicatorModel then
						self.weakpoints[entNum][boneName] = weakpointIndicatorModel
						self.fullscreenContainer:addElement( weakpointIndicatorModel )
						weakpointIndicatorModel:processEvent( {
							name = "update_state",
							controller = controller,
							menu = self
						} )
					end
				end
			elseif notifyData.data[1] == 2 then
				if self.weakpoints[entNum] and self.weakpoints[entNum][boneName] then
					self.weakpoints[entNum][boneName]:playClip( "Damaged" )
				end
			elseif notifyData.data[1] == 3 and self.weakpoints[entNum] and self.weakpoints[entNum][boneName] then
				self.weakpoints[entNum][boneName]:playClip( "Repulsed" )
			end
			return true
		else
			
		end
	end )
	if WorldSpaceIndicatorsModel then
		Engine.SetModelValue( Engine.CreateModel( WorldSpaceIndicatorsModel, "hackingPercent" ), 0 )
		local newModels = {
			{
				name = "targetState",
				defaultValue = Enum.EnemyTargetStates.ENEMY_TARGET_NONE
			}
		}
		local index = 0
		local createAnother = true
		while createAnother do
			local newWidgetModel = Engine.CreateModel( WorldSpaceIndicatorsModel, "enemyTargets." .. index )
			for _, models in ipairs( newModels ) do
				LUI.CreateModelAndInitialize( newWidgetModel, models.name, models.defaultValue )
			end
			local EnemyTargetModel = CoD.EnemyTargetInternal.new( self, controller )
			EnemyTargetModel:setModel( newWidgetModel )
			createAnother = EnemyTargetModel:setupCybercomLockon( index, controller )
			self.fullscreenContainer:addElement( EnemyTargetModel )
			EnemyTargetModel:processEvent( {
				name = "update_state",
				controller = controller
			} )
			index = index + 1
		end
	end
	if WorldSpaceIndicatorsModel then
		local newModels = {
			{
				name = "distance",
				defaultValue = 0
			},
			{
				name = "explosivesImage",
				defaultValue = "uie_img_t7_hud_widget_ammo_1_icon_grenade"
			},
			{
				name = "timeLeftPerc",
				defaultValue = -1
			},
			{
				name = "visible",
				defaultValue = false
			}
		}
		local index = 0
		local createAnother = true
		while createAnother do
			local newWidgetModel = Engine.CreateModel( WorldSpaceIndicatorsModel, "explosivesWarnings." .. index )
			for _, models in ipairs( newModels ) do
				LUI.CreateModelAndInitialize( newWidgetModel, models.name, models.defaultValue )
			end
			local IncomingExplosiveModel = CoD.IncomingExplosiveInternal.new( self, controller )
			IncomingExplosiveModel:setModel( newWidgetModel )
			IncomingExplosiveModel:setPriority( 100 )
			createAnother = IncomingExplosiveModel:setupIncomingExplosive( index, controller )
			self.fullscreenContainer:addElement( IncomingExplosiveModel )
			IncomingExplosiveModel:processEvent( {
				name = "update_state",
				controller = controller
			} )
			index = index + 1
		end
	end
	CoD.TacticalModeUtility.CreateTacticalModeWidgets( self, controller )
	CoD.TacticalModeUtility.CreateShooterSpottedWidgets( self, controller )
	if Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.viewmodelWeaponName" ) ~= nil then
		self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.viewmodelWeaponName" ), function ( model )
			if IsCurrentViewmodelWeaponName( controller, "spike_launcher" ) then
				self.spikeLauncherCounter = CoD.SpikeLauncherSpikeCounter.new( self, controller )
				self:addElement( self.spikeLauncherCounter )
				self.spikeLauncherCounter:dispatchEventToChildren( {
					name = "update_state",
					controller = controller
				} )
			elseif self.spikeLauncherCounter ~= nil then
				self.spikeLauncherCounter:close()
				self.spikeLauncherCounter = nil
			end
		end )
	end
	local oldClose = self.close
	self.close = function ( element )
		oldClose( element )
		if element.spikeLauncherCounter ~= nil then
			element.spikeLauncherCounter:close()
		end
	end
	if WorldSpaceIndicatorsModel then
		local AssignPlayerNamesToBleedoutPrompts = function ( f8_arg0 )
			local f8_local0 = f8_arg0:getFirstChild()
			while f8_local0 do
				if LUI.startswith( f8_local0.id, "bleedOutItem" ) then
					local f8_local1 = f8_local0:getModel( controller, "playerName" )
					if f8_local1 then
						Engine.SetModelValue( f8_local1, Engine.GetGamertagForClient( controller, f8_local0.bleedOutClient ) )
					end
				end
				f8_local0 = f8_local0:getNextSibling()
			end
		end
		
		local clientNum = 0
		local createAnother = true
		while createAnother do
			local bleedOutModel = Engine.CreateModel( WorldSpaceIndicatorsModel, "bleedOutModel" .. clientNum )
			Engine.SetModelValue( Engine.CreateModel( bleedOutModel, "playerName" ), Engine.GetGamertagForClient( controller, clientNum ) )
			Engine.SetModelValue( Engine.CreateModel( bleedOutModel, "prompt" ), "CPUI_REVIVE" )
			Engine.SetModelValue( Engine.CreateModel( bleedOutModel, "clockPercent" ), 0 )
			Engine.SetModelValue( Engine.CreateModel( bleedOutModel, "bleedOutPercent" ), 0 )
			Engine.SetModelValue( Engine.CreateModel( bleedOutModel, "stateFlags" ), 0 )
			Engine.SetModelValue( Engine.CreateModel( bleedOutModel, "arrowAngle" ), 0 )
			local bleedOutWidget = CoD.bleedOutWidget.new( self, controller )
			bleedOutWidget.bleedOutClient = clientNum
			bleedOutWidget.id = "bleedOutItem" .. clientNum
			bleedOutWidget:setLeftRight( true, false, 0, 0 )
			bleedOutWidget:setTopBottom( true, false, 0, 0 )
			bleedOutWidget:setModel( bleedOutModel )
			createAnother = bleedOutWidget:setupBleedOutWidget( controller, clientNum )
			self.fullscreenContainer:addElement( bleedOutWidget )
			self.fullscreenContainer:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "playerConnected" ), function ( model )
				AssignPlayerNamesToBleedoutPrompts( self.fullscreenContainer )
			end )
			clientNum = clientNum + 1
		end
	end
	
	self.m_inputDisabled = true
end

LUI.createMenu.T7Hud_CP = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "T7Hud_CP" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self.soundSet = "HUD"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "T7Hud_CP.buttonPrompts" )
	local menu = self
	self.anyChildUsesUpdateState = true

	InitUnlockInfo( self, controller )

	if Engine.DvarInt( nil, "scr_enable_ua" ) == 0 then
		self.MJBoostGuage = CoD.BoostWidget.new( menu, controller )
		self.MJBoostGuage:setLeftRight(false,false,0,972.5)
		self.MJBoostGuage:setTopBottom(false,false,0,492)
	else
		self.MJBoostGuage = CoD.BoostWidgetUA.new( menu, controller )
		self.MJBoostGuage:setLeftRight(false,false,372,640)
		self.MJBoostGuage:setTopBottom(false,false,250,330)
	end
	self:addElement( self.MJBoostGuage )

	local MJPosition = CoD.PositionWidget.new( menu, controller )
	MJPosition:setLeftRight(false,false,-640,-372)
	MJPosition:setTopBottom(false,false,-360,-215.5)
	self:addElement( MJPosition )
	self.MJPosition = MJPosition

	local MJLaps = CoD.LapWidget.new( menu, controller )
	MJLaps:setLeftRight( false, false, 372, 640 )
	MJLaps:setTopBottom( false, false, -360, -215.5 )
	self:addElement( MJLaps )
	self.MJLaps = MJLaps

	local MJScore = CoD.ScoreWidget.new( menu, controller )
	MJScore:setLeftRight( false, false, -150, 150 )
	MJScore:setTopBottom( true, false, 0, 250 )
	self:addElement( MJScore )
	self.MJScore = MJScore

	local MJTruckNotify = CoD.TruckNotify.new( menu, controller )
	MJTruckNotify:setLeftRight( true, false, 0, 220.5 )
	MJTruckNotify:setTopBottom( false, false, -276.5, -148.5 )
	self:addElement( MJTruckNotify )
	self.MJTruckNotify = MJTruckNotify

	local MJRaceNotify = CoD.StartRaceNotify.new( menu, controller )
	MJRaceNotify:setLeftRight( false, false, -150, 150 )
	MJRaceNotify:setTopBottom( true, false, 0, 250 )
	self:addElement( MJRaceNotify )
	self.MJRaceNotify = MJRaceNotify

	local MMSNotify = CoD.MonsterSpectacleNotify.new( menu, controller )
	MMSNotify:setLeftRight( false, false, -450, 450 )
	MMSNotify:setTopBottom( true, false, 75, 300 )
	self:addElement( MMSNotify )
	self.MMSNotify = MMSNotify
	
	local PanelVignetteRight = CoD.MapWidget_PanelVignetteRight.new( menu, controller )
	PanelVignetteRight:setLeftRight( false, false, 31, 660 )
	PanelVignetteRight:setTopBottom( false, false, -362, 54 )
	PanelVignetteRight:setAlpha( 0 )
	self:addElement( PanelVignetteRight )
	self.PanelVignetteRight = PanelVignetteRight
	
	local DamageWidgetContainer = CoD.DamageWidgetContainer.new( menu, controller )
	DamageWidgetContainer:setLeftRight( true, false, 18, 284 )
	DamageWidgetContainer:setTopBottom( false, true, -132, -26 )
	self:addElement( DamageWidgetContainer )
	self.DamageWidgetContainer = DamageWidgetContainer
	
	local AmmoWidgetContainer = CoD.AmmoWidgetContainer.new( menu, controller )
	AmmoWidgetContainer:setLeftRight( false, true, -421, -23 )
	AmmoWidgetContainer:setTopBottom( false, true, -156, -32 )
	self:addElement( AmmoWidgetContainer )
	self.AmmoWidgetContainer = AmmoWidgetContainer
	
	local EMPWeaponInfo = CoD.AmmoWidgetEMP.new( menu, controller )
	EMPWeaponInfo:setLeftRight( false, true, -341, 0 )
	EMPWeaponInfo:setTopBottom( false, true, -171, 0 )
	self:addElement( EMPWeaponInfo )
	self.EMPWeaponInfo = EMPWeaponInfo
	
	local EMPScoreInfo = CoD.DamageWidgetEMP.new( menu, controller )
	EMPScoreInfo:setLeftRight( true, false, 0, 341 )
	EMPScoreInfo:setTopBottom( false, true, -171, 0 )
	self:addElement( EMPScoreInfo )
	self.EMPScoreInfo = EMPScoreInfo
	
	local CommsSystemWidget = CoD.CommsSystemWidget.new( menu, controller )
	CommsSystemWidget:setLeftRight( false, true, -420, -20 )
	CommsSystemWidget:setTopBottom( true, false, 32, 532 )
	CommsSystemWidget:setXRot( -17 )
	CommsSystemWidget:setYRot( -21 )
	self:addElement( CommsSystemWidget )
	self.CommsSystemWidget = CommsSystemWidget
	
	local fullscreenContainer = CoD.DynamicContainerWidget.new( menu, controller )
	fullscreenContainer:setLeftRight( false, false, -640, 640 )
	fullscreenContainer:setTopBottom( false, false, -360, 360 )
	self:addElement( fullscreenContainer )
	self.fullscreenContainer = fullscreenContainer
	
	local PartyListContainerParent0 = CoD.PartyListContainerParent.new( menu, controller )
	PartyListContainerParent0:setLeftRight( false, true, -289, -23 )
	PartyListContainerParent0:setTopBottom( false, true, -244, -132 )
	PartyListContainerParent0:registerEventHandler( "hud_boot", function ( element, event )
		local f11_local0 = nil
		if not f11_local0 then
			f11_local0 = element:dispatchEventToChildren( event )
		end
		return f11_local0
	end )
	self:addElement( PartyListContainerParent0 )
	self.PartyListContainerParent0 = PartyListContainerParent0
	
	local RepulsorIndicator = CoD.RepulsorIndicator.new( menu, controller )
	RepulsorIndicator:setLeftRight( false, false, -96, 96 )
	RepulsorIndicator:setTopBottom( false, false, -192, 192 )
	RepulsorIndicator.IndicatorOn:setImage( RegisterImage( "uie_t7_hud_hit_direction_yellow_on" ) )
	RepulsorIndicator.IndicatorGlow:setImage( RegisterImage( "uie_t7_hud_hit_direction_glow_yellow" ) )
	RepulsorIndicator:subscribeToGlobalModel( controller, "PlayerAbilities", "repulsorIndicatorDirection", function ( model )
		local repulsorIndicatorDirection = Engine.GetModelValue( model )
		if repulsorIndicatorDirection then
			RepulsorIndicator:setZRot( Multiple( 90, repulsorIndicatorDirection ) )
		end
	end )
	RepulsorIndicator:mergeStateConditions( {
		{
			stateName = "Glow",
			condition = function ( menu, element, event )
				return IsModelValueGreaterThanOrEqualTo( controller, "playerAbilities.repulsorIndicatorIntensity", 2 )
			end
		},
		{
			stateName = "On",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "playerAbilities.repulsorIndicatorIntensity", 1 )
			end
		}
	} )
	RepulsorIndicator:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "playerAbilities.repulsorIndicatorIntensity" ), function ( model )
		menu:updateElementState( RepulsorIndicator, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "playerAbilities.repulsorIndicatorIntensity"
		} )
	end )
	self:addElement( RepulsorIndicator )
	self.RepulsorIndicator = RepulsorIndicator
	
	local ProximityIndicator = CoD.RepulsorIndicator.new( menu, controller )
	ProximityIndicator:setLeftRight( false, false, -96, 96 )
	ProximityIndicator:setTopBottom( false, false, -192, 192 )
	ProximityIndicator:subscribeToGlobalModel( controller, "PlayerAbilities", "proximityIndicatorDirection", function ( model )
		local proximityIndicatorDirection = Engine.GetModelValue( model )
		if proximityIndicatorDirection then
			ProximityIndicator:setZRot( Multiple( 90, proximityIndicatorDirection ) )
		end
	end )
	ProximityIndicator:mergeStateConditions( {
		{
			stateName = "Glow",
			condition = function ( menu, element, event )
				return IsModelValueGreaterThanOrEqualTo( controller, "playerAbilities.proximityIndicatorIntensity", 2 )
			end
		},
		{
			stateName = "On",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "playerAbilities.proximityIndicatorIntensity", 1 )
			end
		}
	} )
	ProximityIndicator:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "playerAbilities.proximityIndicatorIntensity" ), function ( model )
		menu:updateElementState( ProximityIndicator, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "playerAbilities.proximityIndicatorIntensity"
		} )
	end )
	self:addElement( ProximityIndicator )
	self.ProximityIndicator = ProximityIndicator
	
	local ScoreboardWidgetCP = CoD.ScoreboardWidgetCP.new( menu, controller )
	ScoreboardWidgetCP:setLeftRight( false, false, -503, 503 )
	ScoreboardWidgetCP:setTopBottom( true, false, 97, 623 )
	ScoreboardWidgetCP.ScoreboardFactionScoresListCP0.Team1:setVerticalCount( 6 )
	ScoreboardWidgetCP.ScoreboardFactionScoresListCP0.Team1:setDataSource( "ScoreboardResults" )
	self:addElement( ScoreboardWidgetCP )
	self.ScoreboardWidgetCP = ScoreboardWidgetCP
	
	local IngameChatClientContainer = CoD.IngameChatClientContainer.new( menu, controller )
	IngameChatClientContainer:setLeftRight( true, false, 0, 360 )
	IngameChatClientContainer:setTopBottom( true, false, -2.5, 717.5 )
	self:addElement( IngameChatClientContainer )
	self.IngameChatClientContainer = IngameChatClientContainer
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end
		},
		Prologue = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				AmmoWidgetContainer:completeAnimation()
				AmmoWidgetContainer.AmmoWidget:completeAnimation()
				self.AmmoWidgetContainer.AmmoWidget:setXRot( 0 )
				self.AmmoWidgetContainer.AmmoWidget:setYRot( 0 )
				self.clipFinished( AmmoWidgetContainer, {} )
				CommsSystemWidget:completeAnimation()
				self.CommsSystemWidget:setLeftRight( false, true, -414, -14 )
				self.CommsSystemWidget:setTopBottom( true, false, 36, 536 )
				self.CommsSystemWidget:setXRot( 0 )
				self.CommsSystemWidget:setYRot( 0 )
				self.clipFinished( CommsSystemWidget, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "Prologue",
			condition = function ( menu, element, event )
				return HideCyberCoreWidget( controller )
			end
		}
	} )
	ScoreboardWidgetCP.id = "ScoreboardWidgetCP"
	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )
	self:processEvent( {
		name = "update_state",
		menu = menu
	} )
	if not self:restoreState() then
		self.ScoreboardWidgetCP:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.PanelVignetteRight:close()
		element.DamageWidgetContainer:close()
		element.AmmoWidgetContainer:close()
		element.EMPWeaponInfo:close()
		element.EMPScoreInfo:close()
		element.CommsSystemWidget:close()
		element.fullscreenContainer:close()
		element.PartyListContainerParent0:close()
		element.RepulsorIndicator:close()
		element.ProximityIndicator:close()
		element.ScoreboardWidgetCP:close()
		element.IngameChatClientContainer:close()
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "T7Hud_CP.buttonPrompts" ) )
	end )
	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end

