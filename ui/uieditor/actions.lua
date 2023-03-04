require("ui.uieditor.actionsOg")

local IO = require( "io" )

--[[
function OpenMutatorsMenu(self, element, controller, param, menu)
	menu:openPopup("ZMMutators", controller)
end

function OpenZMChangeGameMode(self, element, controller, param, menu)
	menu:openPopup("ZMChangeGameMode", controller)
end

function OpenSetupGameZM(f173_arg0, f173_arg1, f173_arg2, f173_arg3, f173_arg4)
	CoD.LobbyBase.OpenSetupGame(f173_arg4, f173_arg2, "GameSettingsFlyoutZM")
end

function SetLobbyMaxClientsForGameMode( gamemode )
	if CoD.isCampaign or Engine.IsCampaignModeZombies() then
		Engine.SetDvar("sv_maxclients", 4)
		Engine.SetDvar("com_maxclients", 4)
		Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_GAME, 4)
		Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_PRIVATE, 4)
	elseif CoD.isZombie then
		if IsGameModeVar( "use_8_player", "YES", gamemode ) then
			Engine.SetDvar("sv_maxclients", 8)
			Engine.SetDvar("com_maxclients", 8)
			Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_GAME, 8)
			Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_PRIVATE, 8)
		else
			Engine.SetDvar("sv_maxclients", 4)
			Engine.SetDvar("com_maxclients", 4)
			Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_GAME, 4)
			Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_PRIVATE, 4)
		end
	else
		Engine.SetDvar("sv_maxclients", 18)
		Engine.SetDvar("com_maxclients", 18)
		Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_GAME, 18)
		Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_PRIVATE, 18)
	end
end

function GameModeSelected( element, controller )
	Engine.Exec( controller, "resetCustomGametype" )
	local oldTeamBased = CoDShared.IsGametypeTeamBased()
	local curGameType = GetCurrentUIGameType( controller )
	if curGameType == "" then
		return 
	end
	Engine.SetGametype( curGameType )
	if oldTeamBased ~= CoDShared.IsGametypeTeamBased() then
		Engine.SetDvar( "bot_friends", 0 )
		Engine.SetDvar( "bot_enemies", 0 )
	end

	SetLobbyMaxClientsForGameMode( curGameType )

	Engine.Exec( controller, "xupdatepartystate" )
	Engine.SetProfileVar( controller, CoD.profileKey_gametype, curGameType )
	Engine.PartyHostClearUIState()
	Engine.CommitProfileChanges( controller )
	Engine.SystemNeedsUpdate( nil, "lobby" )
	Engine.LobbyVM_CallFunc( "OnGametypeSettingsChange", {
		lobbyType = Enum.LobbyType.LOBBY_TYPE_GAME,
		lobbyModule = Enum.LobbyModule.LOBBY_MODULE_HOST
	} )
end

function GameModeSelectedCommunity( element, f1276_arg1, controller )
	if f1276_arg1.oldTeamBased ~= nil and f1276_arg1.oldTeamBased ~= CoDShared.IsGametypeTeamBased() then
		Engine.SetDvar( "bot_friends", 0 )
		Engine.SetDvar( "bot_enemies", 0 )
	end
	Engine.Exec( controller, "xupdatepartystate" )
	Engine.PartyHostClearUIState()
	Engine.CommitProfileChanges( controller )
	Engine.SystemNeedsUpdate( nil, "lobby" )
	Engine.LobbyVM_CallFunc( "OnGametypeSettingsChange", {
		lobbyType = Enum.LobbyType.LOBBY_TYPE_GAME,
		lobbyModule = Enum.LobbyModule.LOBBY_MODULE_HOST
	} )
end

function CreateNeedMorePlayersPopUp()
	CoD.OverlayUtility.Overlays.NeedMorePlayers = {
		menuName = "SystemOverlay_Compact",
		title = "NOT ENOUGH PLAYERS",
		description = "You need more than 1 player to start the game!",
		categoryType = CoD.OverlayUtility.OverlayTypes.Info,
		listDatasource = function()
			DataSources.NeedMorePlayers_List = DataSourceHelpers.ListSetup("NeedMorePlayers_List", function ( menu )
				return {
					{
						models = {
							displayText = Engine.Localize( "MENU_OK" )
						},
						properties = {
							action = function( self, element, controller, actionParam, menu )
								GoBack( menu, controller )
							end
						}
					}
				}
			end, true, nil )
			return "NeedMorePlayers_List"
		end,
		[CoD.OverlayUtility.GoBackPropertyName] = CoD.OverlayUtility.DefaultGoBack
	}
end

function CreateTooManyPlayersPopUp()
	CoD.OverlayUtility.Overlays.TooManyPlayers = {
		menuName = "SystemOverlay_Compact",
		title = "TOO MANY PLAYERS",
		description = "You have too many players in the lobby!",
		categoryType = CoD.OverlayUtility.OverlayTypes.Info,
		listDatasource = function()
			DataSources.TooManyPlayers_List = DataSourceHelpers.ListSetup("TooManyPlayers_List", function ( menu )
				return {
					{
						models = {
							displayText = Engine.Localize( "MENU_OK" )
						},
						properties = {
							action = function( self, element, controller, actionParam, menu )
								GoBack( menu, controller )
							end
						}
					}
				}
			end, true, nil )
			return "TooManyPlayers_List"
		end,
		[CoD.OverlayUtility.GoBackPropertyName] = CoD.OverlayUtility.DefaultGoBack
	}
end

function CreateUnbalancedPopUp()
	CoD.OverlayUtility.Overlays.Unbalanced = {
		menuName = "SystemOverlay_Compact",
		title = "UNBALANCED TEAMS",
		description = "Hey, this isn't fair! Balance the teams or set Team Assignment to Auto-Balance!",
		categoryType = CoD.OverlayUtility.OverlayTypes.Info,
		listDatasource = function()
			DataSources.Unbalanced_List = DataSourceHelpers.ListSetup("Unbalanced_List", function ( menu )
				return {
					{
						models = {
							displayText = Engine.Localize( "MENU_TEAM_ASSIGNMENT_AUTO" )
						},
						properties = {
							action = function( self, element, controller, actionParam, menu )
								GoBack( menu, controller )
								Engine.SetGametypeSetting( "teamAssignment", LuaEnums.TEAM_ASSIGNMENT.AUTO )
								CustomGameSettingsMenuClosed( menu, controller )
								CoD.LobbyBase.LaunchGame( menu, controller, Enum.LobbyType.LOBBY_TYPE_GAME )
							end
						}
					},
					{
						models = {
							displayText = Engine.Localize( "MENU_OK" )
						},
						properties = {
							action = function( self, element, controller, actionParam, menu )
								GoBack( menu, controller )
							end
						}
					},
				}
			end, true, nil )
			return "Unbalanced_List"
		end,
		[CoD.OverlayUtility.GoBackPropertyName] = CoD.OverlayUtility.DefaultGoBack
	}
end

function LobbyLANLaunchGame( self, element, controller )
	local shouldLaunch, reason = CanLaunchGame()
	if not shouldLaunch then
		if reason == "NOT_ENOUGH_PLAYERS" then
			if not CoD.OverlayUtility.Overlays.NeedMorePlayers then
				CreateNeedMorePlayersPopUp()
			end
			CoD.OverlayUtility.CreateOverlay( controller, self, "NeedMorePlayers" )
		elseif reason == "TOO_MANY_PLAYERS" then
			if not CoD.OverlayUtility.Overlays.TooManyPlayers then
				CreateTooManyPlayersPopUp()
			end
			CoD.OverlayUtility.CreateOverlay( controller, self, "TooManyPlayers" )
		elseif reason == "UNBALANCED" then
			if not CoD.OverlayUtility.Overlays.Unbalanced then
				CreateUnbalancedPopUp()
			end
			CoD.OverlayUtility.CreateOverlay( controller, self, "Unbalanced" )
		end
		return
	end
	if CoD.isZombie and Engine.GetLobbyClientCount( Enum.LobbyType.LOBBY_TYPE_GAME ) <= 1 then
		Engine.SetDvar( "ui_useloadingmovie", "1" )
	end
	CoD.LobbyBase.LaunchGame( self, controller, Enum.LobbyType.LOBBY_TYPE_GAME )
end

function LobbyOnlineCustomLaunchGame_SelectionList( self, element, controller )
	local shouldLaunch, reason = CanLaunchGame()
	if not shouldLaunch then
		if reason == "NOT_ENOUGH_PLAYERS" then
			if not CoD.OverlayUtility.Overlays.NeedMorePlayers then
				CreateNeedMorePlayersPopUp()
			end
			CoD.OverlayUtility.CreateOverlay( controller, self, "NeedMorePlayers" )
		elseif reason == "TOO_MANY_PLAYERS" then
			if not CoD.OverlayUtility.Overlays.TooManyPlayers then
				CreateTooManyPlayersPopUp()
			end
			CoD.OverlayUtility.CreateOverlay( controller, self, "TooManyPlayers" )
		elseif reason == "UNBALANCED" then
			if not CoD.OverlayUtility.Overlays.Unbalanced then
				CreateUnbalancedPopUp()
			end
			CoD.OverlayUtility.CreateOverlay( controller, self, "Unbalanced" )
		end
		return
	end
	if CoD.isZombie and Engine.GetLobbyClientCount( Enum.LobbyType.LOBBY_TYPE_GAME ) <= 1 then
		Engine.SetDvar( "ui_useloadingmovie", "1" )
	end
	CoD.LobbyBase.LaunchGame( self, controller, Enum.LobbyType.LOBBY_TYPE_GAME )
end

function CanLaunchGame()
	local canLaunch = true
	local reason = ""
	local lobbyClients = Engine.LobbyGetSessionClients( Enum.LobbyModule.LOBBY_MODULE_HOST, Enum.LobbyType.LOBBY_TYPE_GAME )
	local minPlayers = GetGameModeVar( "minPlayers" )
	local maxPlayers = GetGameModeVar( "maxPlayers" )

	local currentClients = 0

	for index, client in ipairs(lobbyClients.sessionClients) do
		currentClients = currentClients + 1
	end

	if currentClients > maxPlayers then
		canLaunch = false
		reason = "TOO_MANY_PLAYERS"
	elseif currentClients < minPlayers then
		canLaunch = false
		reason = "NOT_ENOUGH_PLAYERS"
	elseif CoDShared.IsGametypeTeamBased() == true and Engine.GetGametypeSetting("teamAssignment") ~= LuaEnums.TEAM_ASSIGNMENT.AUTO and Dvar.ui_gametype:get() ~= "zcleansed" then
		if lobbyClients ~= nil then
			local alliesCount = 0
			local axisCount = 0
			for index, client in ipairs(lobbyClients.sessionClients) do
				if client.team == Enum.team_t.TEAM_ALLIES then
					alliesCount = alliesCount + 1
				end
				if client.team == Enum.team_t.TEAM_AXIS then
					axisCount = axisCount + 1
				end
			end
			if 1 < math.abs(alliesCount - axisCount) then
				canLaunch = false
				reason = "UNBALANCED"
			end
		end
	end

	return canLaunch, reason
end]]

function NavigateCheckForFirstTime( self, element, controller, param, menu )
	if CheckNavRestrictions( self, element, controller, menu ) then
		return 
	elseif param.targetName == "MPLobbyMain" then
		if Engine.PushAnticheatMessageToUI( controller, LuaEnums.ANTICHEAT_MESSAGE_GROUPS.MP ) then
			DisplayAnticheatMessage( self, controller, LuaEnums.ANTICHEAT_MESSAGE_GROUPS.MP, "", "" )
			return 
		end
		for f180_local0 = 0, LuaEnums.MAX_CONTROLLER_COUNT - 1, 1 do
			if CheckIfFeatureIsBanned( f180_local0, LuaEnums.FEATURE_BAN.LIVE_MP ) then
				LuaUtils.UI_ShowErrorMessageDialog( controller, GetFeatureBanInfo( f180_local0, LuaEnums.FEATURE_BAN.LIVE_MP ) )
				return 
			end
		end
		if Engine.GetUsedControllerCount() > 1 then
			for f180_local1 = 0, LuaEnums.MAX_CONTROLLER_COUNT - 1, 1 do
				if CheckIfFeatureIsBanned( f180_local1, LuaEnums.FEATURE_BAN.MP_SPLIT_SCREEN ) then
					LuaUtils.UI_ShowErrorMessageDialog( controller, GetFeatureBanInfo( f180_local1, LuaEnums.FEATURE_BAN.MP_SPLIT_SCREEN ) )
					return 
				end
			end
		end
	end
	if param.targetName == "CPLobbyOnline" then
		for f180_local0 = 0, LuaEnums.MAX_CONTROLLER_COUNT - 1, 1 do
			if CheckIfFeatureIsBanned( f180_local0, LuaEnums.FEATURE_BAN.LIVE_CP ) then
				LuaUtils.UI_ShowErrorMessageDialog( controller, GetFeatureBanInfo( f180_local0, LuaEnums.FEATURE_BAN.LIVE_CP ) )
				return 
			end
		end
		if Engine.GetUsedControllerCount() > 1 then
			for f180_local1 = 0, LuaEnums.MAX_CONTROLLER_COUNT - 1, 1 do
				if CheckIfFeatureIsBanned( f180_local1, LuaEnums.FEATURE_BAN.CP_SPLIT_SCREEN ) then
					LuaUtils.UI_ShowErrorMessageDialog( controller, GetFeatureBanInfo( f180_local1, LuaEnums.FEATURE_BAN.CP_SPLIT_SCREEN ) )
					return 
				end
			end
		end
	end
	if IsFirstTimeSetup( controller, param.mode ) then
		param.firstTimeFlowAction( self, element, controller, param.targetName, menu )
	else
		NavigateToLobby_SelectionList( self, element, controller, param.targetName, menu )
	end
	--Engine.SetDvar( "sv_maxclients", 6 )
	--Engine.SetDvar( "com_maxclients", 6 )
	--Engine.SetLobbyMaxClients( Enum.LobbyType.LOBBY_TYPE_GAME, 6 )
	--Engine.SetLobbyMaxClients( Enum.LobbyType.LOBBY_TYPE_PRIVATE, 6 )
	--InitUnlockInfo( menu, controller )
end

function OpenMJGamesettingsMenu( self, element, controller, param, menu )
	menu:openPopup("MJGamesettings", controller)
end

function OpenMJTruckSelection( self, element, controller, param, menu )
	OpenTruckSelection( menu, controller )
end

function OpenMJStats( self, element, controller, param, menu )
	menu:openPopup("MJStats", controller)
end

function OpenTruckSelection( self, controller )
	if not CoD.LobbyBase.LeaderActivity.CHOOSING_TRUCK then
		CoD.LobbyBase.LeaderActivity.CHOOSING_TRUCK = {
			index = 14,
			str = "UI_MENU_SELECTING_TRUCK"
		}
	end
	CoD.LobbyBase.SetLeaderActivity( controller, CoD.LobbyBase.LeaderActivity.CHOOSING_TRUCK )
	local menu = OpenOverlay( self, "MJChooseTruck", controller )
	LUI.OverrideFunction_CallOriginalFirst( menu, "close", function ()
		CoD.LobbyBase.ResetLeaderActivity( controller )
	end )
end

function CanLaunchGame()
	local canLaunch = true
	local LaunchReason = ""

	local mapName = Dvar.ui_mapname:get()
	if mapName then
	end
end

--element contains all of the information we need
function LaunchSelectedCPMission( self, element, controller )
	local modeAbbr = Engine.GetModeName()
	if Engine.IsCampaignModeZombies() then
		modeAbbr = modeAbbr .. "2"
	end
	if modeAbbr == "Invalid" then
		if LUI.DEV ~= nil then
			error( "Invalid mode in matchmaking" )
		else
			return 
		end
	end
	local cpLobbyModel = Engine.GetModelValue( Engine.GetModel( Engine.GetGlobalModel(), "cpLobby" ) )
	local cpLobby = Engine.GetLobbyNetworkMode() == Enum.LobbyNetworkMode.LOBBY_NETWORKMODE_LIVE
	local isPublic = false
	local menu = "LobbyOnlineCustomGame"
	if cpLobby == true then
		if cpLobbyModel == "public" then
			isPublic = true
			menu = "LobbyOnlinePublicGame"
		elseif cpLobbyModel == "custom" then
			menu = "LobbyOnlineCustomGame"
		end
	else
		menu = "LobbyLANCustomGame"
	end
	menu = modeAbbr .. menu
	SetupAvailibleGamemodes( self, element, controller )
	SetSelectedCPMission( self, element, controller )
	if isPublic then
		Engine.SetPlaylistID( GetPlaylistIDForSelectedCPMission( self, element, controller ) )
	end
	local f422_local5 = Engine.GetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNav" ) )
	if f422_local5 ~= LobbyData.UITargets.UI_CPLOBBYONLINECUSTOMGAME.id and f422_local5 ~= LobbyData.UITargets.UI_CP2LOBBYONLINECUSTOMGAME.id and f422_local5 ~= LobbyData.UITargets.UI_CPLOBBYLANCUSTOMGAME.id and f422_local5 ~= LobbyData.UITargets.UI_CP2LOBBYLANCUSTOMGAME.id then
		NavigateToLobby( self, menu, false, controller )
	end
	GoBack( self, controller )
end

function NavigateToLobby_SelectionList( self, element, controller, param, menu )
	if CheckNavRestrictions( self, element, controller, menu ) then
		return 
	elseif param == "MPLobbyMain" then
		if Engine.PushAnticheatMessageToUI( controller, LuaEnums.ANTICHEAT_MESSAGE_GROUPS.MP ) then
			DisplayAnticheatMessage( self, controller, LuaEnums.ANTICHEAT_MESSAGE_GROUPS.MP, "", "" )
			return 
		end
		for f357_local0 = 0, LuaEnums.MAX_CONTROLLER_COUNT - 1, 1 do
			if CheckIfFeatureIsBanned( f357_local0, LuaEnums.FEATURE_BAN.LIVE_MP ) then
				LuaUtils.UI_ShowErrorMessageDialog( controller, GetFeatureBanInfo( f357_local0, LuaEnums.FEATURE_BAN.LIVE_MP ) )
				return 
			end
		end
		if Engine.GetUsedControllerCount() > 1 then
			for f357_local1 = 0, LuaEnums.MAX_CONTROLLER_COUNT - 1, 1 do
				if CheckIfFeatureIsBanned( f357_local1, LuaEnums.FEATURE_BAN.MP_SPLIT_SCREEN ) then
					LuaUtils.UI_ShowErrorMessageDialog( controller, GetFeatureBanInfo( f357_local1, LuaEnums.FEATURE_BAN.MP_SPLIT_SCREEN ) )
					return 
				end
			end
		end
	end
	if param == "ZMLobbyOnline" then
		if Engine.PushAnticheatMessageToUI( controller, LuaEnums.ANTICHEAT_MESSAGE_GROUPS.ZM ) then
			DisplayAnticheatMessage( self, controller, LuaEnums.ANTICHEAT_MESSAGE_GROUPS.ZM, "", "" )
			return 
		end
		for f357_local0 = 0, LuaEnums.MAX_CONTROLLER_COUNT - 1, 1 do
			if CheckIfFeatureIsBanned( f357_local0, LuaEnums.FEATURE_BAN.LIVE_ZM ) then
				LuaUtils.UI_ShowErrorMessageDialog( controller, GetFeatureBanInfo( f357_local0, LuaEnums.FEATURE_BAN.LIVE_ZM ) )
				return 
			end
		end
		if Engine.GetUsedControllerCount() > 1 then
			for f357_local1 = 0, LuaEnums.MAX_CONTROLLER_COUNT - 1, 1 do
				if CheckIfFeatureIsBanned( f357_local1, LuaEnums.FEATURE_BAN.ZM_SPLIT_SCREEN ) then
					LuaUtils.UI_ShowErrorMessageDialog( controller, GetFeatureBanInfo( f357_local1, LuaEnums.FEATURE_BAN.ZM_SPLIT_SCREEN ) )
					return 
				end
			end
		end
		local f357_local1 = Engine.StorageGetBuffer( controller, Enum.StorageFileType.STORAGE_ZM_LOADOUTS )
		if f357_local1 then
			local f357_local2 = f357_local1.cacLoadouts
			if f357_local2 then
				local f357_local3 = #f357_local2.variant
				for f357_local4 = 0, f357_local3 - 1, 1 do
					f357_local2.variant[f357_local4].variantIndex:set( f357_local4 )
				end
			end
		end
	end
	if param == "CPLobbyOnline" or param == "CPDOALobbyOnline" or param == "CP2LobbyOnline" then
		for f357_local0 = 0, LuaEnums.MAX_CONTROLLER_COUNT - 1, 1 do
			if CheckIfFeatureIsBanned( f357_local0, LuaEnums.FEATURE_BAN.LIVE_CP ) then
				LuaUtils.UI_ShowErrorMessageDialog( controller, GetFeatureBanInfo( f357_local0, LuaEnums.FEATURE_BAN.LIVE_CP ) )
				return 
			end
		end
		if Engine.GetUsedControllerCount() > 1 then
			for f357_local1 = 0, LuaEnums.MAX_CONTROLLER_COUNT - 1, 1 do
				if CheckIfFeatureIsBanned( f357_local1, LuaEnums.FEATURE_BAN.CP_SPLIT_SCREEN ) then
					LuaUtils.UI_ShowErrorMessageDialog( controller, GetFeatureBanInfo( f357_local1, LuaEnums.FEATURE_BAN.CP_SPLIT_SCREEN ) )
					return 
				end
			end
		end
		Engine.SetModelValue( Engine.CreateModel( Engine.CreateModel( Engine.GetGlobalModel(), "CustomGamesRoot" ), "gameType" ), "crosscountry" )
		Engine.SetGametype( "crosscountry" )
		Engine.Exec( controller, "xupdatepartystate" )
		Engine.SetProfileVar( controller, CoD.profileKey_gametype, "crosscountry" )
		Engine.PartyHostClearUIState()
		Engine.CommitProfileChanges( controller )
		Engine.SystemNeedsUpdate( nil, "lobby" )
		Engine.LobbyVM_CallFunc( "OnGametypeSettingsChange", {
			lobbyType = Enum.LobbyType.LOBBY_TYPE_GAME,
			lobbyModule = Enum.LobbyModule.LOBBY_MODULE_HOST
		} )
	end
	if param == "MPLobbyOnline" then
		for f357_local0 = 0, LuaEnums.MAX_CONTROLLER_COUNT - 1, 1 do
			if CheckIfFeatureIsBanned( f357_local0, LuaEnums.FEATURE_BAN.MP_PUBLIC_MATCH ) then
				LuaUtils.UI_ShowErrorMessageDialog( controller, GetFeatureBanInfo( f357_local0, LuaEnums.FEATURE_BAN.MP_PUBLIC_MATCH ) )
				return 
			end
		end
	end
	if param == "MPLobbyOnlineArena" then
		if Engine.PushAnticheatMessageToUI( controller, LuaEnums.ANTICHEAT_MESSAGE_GROUPS.ARENA ) then
			DisplayAnticheatMessage( self, controller, LuaEnums.ANTICHEAT_MESSAGE_GROUPS.ARENA, "", "" )
			return 
		end
		for f357_local0 = 0, LuaEnums.MAX_CONTROLLER_COUNT - 1, 1 do
			if CheckIfFeatureIsBanned( f357_local0, LuaEnums.FEATURE_BAN.ARENA_GAMEPLAY ) then
				LuaUtils.UI_ShowErrorMessageDialog( controller, GetFeatureBanInfo( f357_local0, LuaEnums.FEATURE_BAN.ARENA_GAMEPLAY ) )
				return 
			end
		end
	end
	if param == "MPLobbyOnlineArenaGame" then
		local f357_local1 = Engine.GetPlaylistMaxPartySize( Engine.GetPlaylistID() )
		if f357_local1 < Engine.GetLobbyClientCount( Enum.LobbyModule.LOBBY_MODULE_HOST, Enum.LobbyType.LOBBY_TYPE_PRIVATE, Enum.LobbyClientType.LOBBY_CLIENT_TYPE_ALL ) then
			LuaUtils.UI_ShowErrorMessageDialog( controller, Engine.Localize( "MENU_ARENA_TOO_MANY_PLAYERS", f357_local1 ) )
			return 
		end
	end
	if param == "FRLobbyOnlineGame" then
		for f357_local0 = 0, LuaEnums.MAX_CONTROLLER_COUNT - 1, 1 do
			if CheckIfFeatureIsBanned( f357_local0, LuaEnums.FEATURE_BAN.FREERUN ) then
				LuaUtils.UI_ShowErrorMessageDialog( controller, GetFeatureBanInfo( f357_local0, LuaEnums.FEATURE_BAN.FREERUN ) )
				return 
			end
		end
	end
	if param == "ZMLobbyOnlineCustomGame" then
		Dvar.zm_private_rankedmatch:set( Engine.GetProfileVarInt( controller, "com_privategame_ranked_zm" ) ~= 0 )
		Engine.SetPlaylistID( 150 )
		Engine.RunPlaylistRules( controller )
	end
	local f357_local0 = LobbyData:UITargetFromName( param )
	if f357_local0.eGameModes == Enum.eGameModes.MODE_GAME_LEAGUE and Engine.DvarBool( nil, "arena_maintenance" ) == true then
		LuaUtils.UI_ShowErrorMessageDialog( controller, "MENU_ARENA_MAINTENANCE_DESC", "MENU_ARENA_MAINTENANCE_CAPS" )
		return 
	end
	local f357_local1 = Engine.DvarBool( 0, "probation_public_enabled" )
	local f357_local2 = Engine.DvarBool( 0, "probation_league_enabled" )
	if f357_local0.isGame and (f357_local0.eGameModes == Enum.eGameModes.MODE_GAME_MATCHMAKING_PLAYLIST or f357_local0.eGameModes == Enum.eGameModes.MODE_GAME_LEAGUE) then
		Engine.ProbationCheckForProbation( controller, f357_local0.eGameModes )
		local f357_local3 = Engine.LobbyClient_GetProbationTime( controller, f357_local0.eGameModes )
		if f357_local3 > 0 then
			local f357_local4 = Engine.SecondsAsTime( f357_local3 )
			if f357_local1 and f357_local0.eGameModes == Enum.eGameModes.MODE_GAME_MATCHMAKING_PLAYLIST then
				LuaUtils.UI_ShowErrorMessageDialog( controller, Engine.Localize( "MENU_PROBATION_GIVEN_PUBLIC_MATCH", f357_local4 ), "MENU_PROBATION_CAPS" )
				return 
			elseif f357_local2 and f357_local0.eGameModes == Enum.eGameModes.MODE_GAME_LEAGUE then
				LuaUtils.UI_ShowErrorMessageDialog( controller, Engine.Localize( "MENU_PROBATION_GIVEN_ARENA_MATCH", f357_local4 ), "MENU_PROBATION_CAPS" )
				return 
			end
		elseif Engine.LobbyHost_AnyClientInProbationForGameMode( f357_local0.eGameModes ) then
			if f357_local1 and f357_local0.eGameModes == Enum.eGameModes.MODE_GAME_MATCHMAKING_PLAYLIST then
				LuaUtils.UI_ShowErrorMessageDialog( controller, "MENU_PROBATION_PARTY_PUBLIC_MATCH" )
				return 
			elseif f357_local2 and f357_local0.eGameModes == Enum.eGameModes.MODE_GAME_LEAGUE then
				LuaUtils.UI_ShowErrorMessageDialog( controller, "MENU_PROBATION_PARTY_ARENA_MATCH" )
				return 
			end
		end
	end
	UpdateDifficulty( self, param, controller )
	NavigateToLobby( menu, param, false, controller )
end

function GenerateDATLoadError( isWorkshop, searchDirectory )
	local cantLoadString = "USERMAP ERROR"
	if isWorkshop then
		cantLoadString = "STEAM WORKSHOP ERROR"
	end
	CoD.OverlayUtility.Overlays.MapLoadError = {
		menuName = "SystemOverlay_Compact",
		title = cantLoadString,
		description = "The Gamemode data file is missing.\nSearch Directory: " .. searchDirectory .. "\nDo you want to load default options?",
		categoryType = CoD.OverlayUtility.OverlayTypes.Info,
		listDatasource = function()
			DataSources.MapLoadError_List = DataSourceHelpers.ListSetup("MapLoadError_List", function ( menu )
				return {
					{
						models = {
							displayText = Engine.Localize( "UI_MENU_LOAD_DEFAULTS" )
						},
						properties = {
							action = function( self, element, controller, actionParam, menu )
								CreateMapOptions( self, controller, nil )
								GoBack( menu, controller )
							end
						}
					},
					{
						models = {
							displayText = Engine.Localize( "UI_MENU_IGNORE" )
						},
						properties = {
							action = function( self, element, controller, actionParam, menu )
								GoBack( menu, controller )
							end
						}
					},
				}
			end, true, nil )
			return "MapLoadError_List"
		end,
		[CoD.OverlayUtility.GoBackPropertyName] = CoD.OverlayUtility.DefaultGoBack
	}
end

function SetupAvailibleGamemodes( self, element, controller )
	local function FileExists( file_path )
		local file = IO.open( file_path, "r" )

		if file ~= nil and file:seek( "end" ) ~= 0 then
			file:close()
			return true
		else
			return false
		end
	end
	local id = element[ "mapId" ]
	local mapIdStringToNumber = tonumber( id ) -- if there is a single letter in this, it returns 'nil'
	if mapIdStringToNumber ~= nil then -- if this didn't turn into nil, it's a workshop item.
		local customMapID = id
		local formatedName = string.format([[%s]], customMapID)
		local fileLocation = [[../.././workshop/content/311210/]] .. formatedName .. [[/map_settings.dat]]
		if FileExists( fileLocation ) then
			CreateMapOptions( self, controller, fileLocation )
		else
			GenerateDATLoadError( true, "./^3workshop^7/^3content^7/^3311210^7/" .. "^3" .. customMapID .. "^7" .. "" )
			CoD.OverlayUtility.CreateOverlay( controller, self, "MapLoadError" )
		end
	else
		local customMapID = id
		local formatedName = string.format([[%s]], customMapID)
		local fileLocation = [[./usermaps/]] .. formatedName .. [[/zone/map_settings.dat]]
		if FileExists( fileLocation ) then
			CreateMapOptions( self, controller, fileLocation )
		else
			GenerateDATLoadError( false, "./^3usermaps^7/" .. "^3" .. customMapID .. "^7" .. "/^3zone^7/" )
			CoD.OverlayUtility.CreateOverlay( controller, self, "MapLoadError" )
		end
	end
end

function CreateMapOptions( self, controller, searchDirectory )
	local function strTok( str_word, token )
		local index = 1
		local elements = {}
		for word in string.gmatch( str_word, '([^' .. token .. ']+)' ) do
			elements[ index ] = word
			index = index + 1
		end
		return elements
	end

	-- default line to read if there is nothing for IO
	local line = "crosscountry,YES"
	if searchDirectory then
		local file = IO.open( searchDirectory, "r" )
		line = file:read()
	end
	CoD.GameOptions.GameModeAndArea = {}
	local gamemodeArray = strTok( line, "," )
	local isFirstOption = true
	for index = 1, #gamemodeArray, 2 do
		local gameMode = gamemodeArray[ index ]
		local isIncluded = gamemodeArray[ index + 1 ] == "YES"
		if gameMode and isIncluded then
			if isFirstOption then
				local gamemodeandareaarray = strTok( gameMode, "_" )
				Engine.SetModelValue( Engine.CreateModel( Engine.CreateModel( Engine.GetGlobalModel(), "CustomGamesRoot" ), "gameType" ), gamemodeandareaarray[ 1 ] )
				if CoD.perController[ controller ].previousGameType ~= gamemodeandareaarray[ 1 ] then
					CustomGameMarkDirty( controller )
					CoD.perController[ controller ].previousGameType = ""
				else
					CoD.perController[ controller ].previousGameType = ""
				end
				GameModeSelected( nil, controller )
				Engine.SetDvar( "ui_location", gamemodeandareaarray[ 2 ] or "area1" )
			end
			table.insert( CoD.GameOptions.GameModeAndArea, {
										option = Engine.Localize( "UI_RACETYPE_" .. gameMode ), 
										value = gameMode,
										default = isFirstOption
									} )
			isFirstOption = false
		end
	end
end