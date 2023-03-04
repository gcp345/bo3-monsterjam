require( "lua.Shared.LobbyData" )
require( "ui.T6.lobby.lobbymenubuttons" )

--[[LuaUtils.GetDefaultMap = function (f27_arg0)
	local f27_local0 = f0_local0.LobbyMainModeToEModes(f27_arg0.mainMode)
	if f27_local0 == Enum.eModes.MODE_CAMPAIGN then
		if Engine.IsCampaignModeZombies() then
			return "cp_mi_sing_sgen"
		else
			return "cp_mi_eth_prologue"
		end
	elseif f27_local0 == Enum.eModes.MODE_MULTIPLAYER then
		if Engine.IsMpStillDownloading() then
			return "mp_freerun_01"
		elseif f27_arg0.id == LobbyData.UITargets.UI_FRLOBBYONLINEGAME.id or f27_arg0.id == LobbyData.UITargets.UI_FRLOBBYLANGAME.id then
			return "mp_freerun_01"
		else
			return "mp_sector"
		end
	elseif f27_local0 == Enum.eModes.MODE_ZOMBIES then
		return "zm_zod"
	else
		return ""
	end
end]]

function Engine.IsCPInProgress()
	return true
end

CoD.LobbyMenus = {}
CoD.LobbyMenus.History = {}
CoD.LobbyMenus.AddButtons = function ( controller, hostModelName, buttonsTable, func )
	local f1_local0 = Engine.GetModel( DataSources.LobbyRoot.getModel( controller ), hostModelName )
	local f1_local1 = nil
	if f1_local0 ~= nil then
		f1_local1 = Engine.GetModelValue( f1_local0 )
	end
	if func ~= nil then
		func( controller, buttonsTable, f1_local1 )
	else
		print( "Error: No function provided to CoD.LobbyMenus.AddButtons" )
	end
end

CoD.LobbyMenus.AddButtonsMPCPZM = function ( controller, hostModelName, buttonsTable, mpFunc, cpFunc, zmFunc )
	if Engine.GetModeName() == "CP" then
		CoD.LobbyMenus.AddButtons( controller, hostModelName, buttonsTable, cpFunc )
	elseif Engine.GetModeName() == "MP" then
		CoD.LobbyMenus.AddButtons( controller, hostModelName, buttonsTable, mpFunc )
	elseif Engine.GetModeName() == "ZM" then
		CoD.LobbyMenus.AddButtons( controller, hostModelName, buttonsTable, zmFunc )
	else
		print( "Error: no mode name set but AddButtonsMPCPZM called." )
	end
end

CoD.LobbyMenus.UpdateHistory = function ( controller, button )
	CoD.LobbyMenus.History[LobbyData.GetLobbyNav()] = button
end

local IsCPDemo = function ()
	return Dvar.ui_execdemo_cp:get()
end

local IsGamescomDemo = function ()
	return Dvar.ui_execdemo_gamescom:get()
end

local IsBetaDemo = function ()
	return Dvar.ui_execdemo_beta:get()
end

local SetButtonState = function ( button, state )
	if state == nil then
		return 
	elseif state == CoD.LobbyButtons.DISABLED then
		button.disabled = true
	elseif state == CoD.LobbyButtons.HIDDEN then
		button.hidden = true
	end
end

local AddButton = function ( controller, options, button, isLargeButton )
	button.disabled = false
	button.hidden = false
	button.selected = false
	button.warning = false
	if button.defaultState ~= nil then
		if button.defaultState == CoD.LobbyButtons.DISABLED then
			button.disabled = true
		elseif button.defaultState == CoD.LobbyButtons.HIDDEN then
			button.hidden = true
		end
	end
	if button.disabledFunc ~= nil then
		button.disabled = button.disabledFunc( controller )
	end
	if button.visibleFunc ~= nil then
		button.hidden = not button.visibleFunc( controller )
	end
	if IsBetaDemo() then
		SetButtonState( button, button.demo_beta )
	elseif IsGamescomDemo() then
		SetButtonState( button, button.demo_gamescom )
	end
	if button.hidden then
		return 
	end
	local LobbyNav = LobbyData.GetLobbyNav()
	if button.selectedFunc ~= nil then
		button.selected = button.selectedFunc( button.selectedParam )
	elseif CoD.LobbyMenus.History[LobbyNav] ~= nil then
		button.selected = CoD.LobbyMenus.History[LobbyNav] == button.customId
	end
	if button.newBreadcrumbFunc then
		local f8_local1 = button.newBreadcrumbFunc
		if type( f8_local1 ) == "string" then
			f8_local1 = LUI.getTableFromPath( f8_local1 )
		end
		if f8_local1 then
			button.isBreadcrumbNew = f8_local1( controller )
		end
	end
	if button.warningFunc ~= nil then
		button.warning = button.warningFunc( controller )
	end
	if button.starterPack == CoD.LobbyButtons.STARTERPACK_UPGRADE then
		button.starterPackUpgrade = true
		if IsStarterPack() then
			button.disabled = false
		end
	end
	table.insert( options, {
		optionDisplay = button.stringRef,
		action = button.action,
		param = button.param,
		customId = button.customId,
		isLargeButton = isLargeButton,
		isLastButtonInGroup = false,
		disabled = button.disabled,
		selected = button.selected,
		isBreadcrumbNew = button.isBreadcrumbNew,
		warning = button.warning,
		requiredChunk = button.selectedParam,
		starterPackUpgrade = button.starterPackUpgrade,
		unloadMod = button.unloadMod
	} )
end

local AddLargeButton = function ( controller, options, button )
	AddButton( controller, options, button, true )
end

local AddSmallButton = function ( controller, options, button )
	AddButton( controller, options, button, false )
end

local AddSpacer = function ( options )
	if 0 < #options then
		options[#options].isLastButtonInGroup = true
	end
end

CoD.LobbyMenus.ModeSelect = function ( controller, options, isLeader )
	if Engine.GetLobbyNetworkMode() == Enum.LobbyNetworkMode.LOBBY_NETWORKMODE_LIVE then
		if isLeader == 1 then
			if LuaUtils.IsGamescomBuild() then
				AddSpacer( options )
				AddSmallButton( controller, options, CoD.LobbyButtons.PLAY_LOCAL )
				AddSpacer( options )
			else
				Lobby_SetMaxLocalPlayers( 4 )
				AddLargeButton( controller, options, CoD.LobbyButtons.CP_ONLINE )
				--AddLargeButton( controller, options, CoD.LobbyButtons.MP_ONLINE )
				--AddLargeButton( controller, options, CoD.LobbyButtons.ZM_ONLINE )
				--AddLargeButton( controller, options, CoD.LobbyButtons.BONUSMODES_ONLINE )
				AddSpacer( options )
				AddSmallButton( controller, options, CoD.LobbyButtons.PLAY_LOCAL )
				AddSpacer( options )
			end
		end
		if CoD.isPC then
			AddSmallButton( controller, options, CoD.LobbyButtons.STEAM_STORE )
		else
			AddSmallButton( controller, options, CoD.LobbyButtons.STORE )
		end
	else
		if isLeader == 1 then
			if LuaUtils.IsGamescomBuild() and not Dvar.ui_disable_lan:get() then
				AddLargeButton( controller, options, CoD.LobbyButtons.MP_LAN )
				AddSmallButton( controller, options, CoD.LobbyButtons.FIND_LAN_GAME )
				AddSpacer( options )
			else
				Lobby_SetMaxLocalPlayers( 4 )
				AddLargeButton( controller, options, CoD.LobbyButtons.CP_LAN )
				--AddLargeButton( controller, options, CoD.LobbyButtons.MP_LAN )
				--AddLargeButton( controller, options, CoD.LobbyButtons.ZM_LAN )
				--AddLargeButton( controller, options, CoD.LobbyButtons.BONUSMODES_LAN )
				AddSpacer( options )
				if not Dvar.ui_disable_lan:get() then
					AddSmallButton( controller, options, CoD.LobbyButtons.FIND_LAN_GAME )
					AddSpacer( options )
				end
				AddSmallButton( controller, options, CoD.LobbyButtons.PLAY_ONLINE )
				AddSpacer( options )
			end
		end
		if CoD.isPC then
			AddSmallButton( controller, options, CoD.LobbyButtons.STEAM_STORE )
		end
	end
	if CoD.isPC then
		if Mods_Enabled() and isLeader == 1 then
			AddLargeButton( controller, options, CoD.LobbyButtons.MODS_LOAD )
		end
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
	end
end

CoD.LobbyMenus.DOAButtonsOnline = function ( controller, options, isLeader )
	if isLeader == 1 then
		AddLargeButton( controller, options, CoD.LobbyButtons.CP_DOA_START_GAME )
		AddLargeButton( controller, options, CoD.LobbyButtons.CP_DOA_JOIN_PUBLIC_GAME )
		AddLargeButton( controller, options, CoD.LobbyButtons.CP_DOA_CREATE_PUBLIC_GAME )
		AddSpacer( options )
		AddLargeButton( controller, options, CoD.LobbyButtons.CP_DOA_LEADERBOARD )
	else
		AddLargeButton( controller, options, CoD.LobbyButtons.CP_DOA_LEADERBOARD )
	end
end

CoD.LobbyMenus.DOAButtonsPublicGame = function ( controller, options, isLeader )
	AddLargeButton( controller, options, CoD.LobbyButtons.ZM_READY_UP )
	AddLargeButton( controller, options, CoD.LobbyButtons.CP_DOA_LEADERBOARD )
end

CoD.LobbyMenus.DOAButtonsLAN = function ( controller, options, isLeader )
	if isLeader == 1 then
		AddLargeButton( controller, options, CoD.LobbyButtons.CP_DOA_START_GAME )
	end
end

CoD.LobbyMenus.CPZMButtonsOnline = function ( controller, options, isLeader )
	if IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	elseif isLeader == 1 then
		AddLargeButton( controller, options, CoD.LobbyButtons.CP_JOIN_PUBLIC_GAME )
		AddLargeButton( controller, options, CoD.LobbyButtons.CP_SELECT_MISSION )
	end
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_SELECT_TRUCK )
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_VIEW_STATS )
	--InitUnlockInfo( nil, controller )
end

CoD.LobbyMenus.CPZMButtonsPublicGame = function ( controller, options, isLeader )
--	AddSmallButton( controller, options, CoD.LobbyButtons.CP_MISSION_OVERVIEW )
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_SELECT_TRUCK )
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_VIEW_STATS )
	--InitUnlockInfo( nil, controller )
end

CoD.LobbyMenus.CPZMButtonsLAN = function ( controller, options, isLeader )
	if IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	elseif isLeader == 1 then
		AddSmallButton( controller, options, CoD.LobbyButtons.MJ_STARTGAME )
		AddSpacer( options )
		AddLargeButton( controller, options, CoD.LobbyButtons.CP_SELECT_MISSION )
		AddSpacer( options )
--		AddLargeButton( controller, options, CoD.LobbyButtons.CP_CHOOSE_DIFFICULTY )
	end
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_SELECT_TRUCK )
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_VIEW_STATS )
	--InitUnlockInfo( nil, controller )
end

CoD.LobbyMenus.CP2ButtonsLANCUSTOM = function ( controller, options, isLeader )
	if IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	elseif isLeader == 1 then
		AddSmallButton( controller, options, CoD.LobbyButtons.MJ_STARTGAME )
		AddSpacer( options )
--		AddSmallButton( controller, options, CoD.LobbyButtons.CP_MISSION_OVERVIEW )
		AddLargeButton( controller, options, CoD.LobbyButtons.CP_SELECT_MISSION )
		AddSmallButton( controller, options, CoD.LobbyButtons.CP_EDIT_GAME_RULES )
		AddSpacer( options )
--		AddLargeButton( controller, options, CoD.LobbyButtons.CP_CHOOSE_DIFFICULTY )
	else
--		AddSmallButton( controller, options, CoD.LobbyButtons.CP_MISSION_OVERVIEW )
	end
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_SELECT_TRUCK )
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_VIEW_STATS )
	--InitUnlockInfo( nil, controller )
end

CoD.LobbyMenus.CPButtonsOnline = function ( controller, options, isLeader )
	if IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	elseif isLeader == 1 then
		--AddLargeButton( controller, options, CoD.LobbyButtons.CP_JOIN_PUBLIC_GAME )
		AddLargeButton( controller, options, CoD.LobbyButtons.MJ_CUSTOM_GAMES )
		AddSpacer( options )
	end
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_SELECT_TRUCK )
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_VIEW_STATS )
	--InitUnlockInfo( nil, controller )
	--Engine.SetDvar("sv_maxclients", 6)
	--Engine.SetDvar("com_maxclients", 6)
	--Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_GAME, 6)
	--Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_PRIVATE, 6)
end

CoD.LobbyMenus.CPButtonsPublicGame = function ( controller, options, isLeader )
--	AddSmallButton( controller, options, CoD.LobbyButtons.CP_MISSION_OVERVIEW )
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_SELECT_TRUCK )
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_VIEW_STATS )
	--Engine.SetDvar("sv_maxclients", 6)
	--Engine.SetDvar("com_maxclients", 6)
	--Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_GAME, 6)
	--Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_PRIVATE, 6)
	--InitUnlockInfo( nil, controller )
end

CoD.LobbyMenus.CPButtonsCustomGame = function ( controller, options, isLeader )
	if IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	elseif isLeader == 1 then
		AddSmallButton( controller, options, CoD.LobbyButtons.MJ_STARTGAME )
		AddSpacer( options )
--		AddSmallButton( controller, options, CoD.LobbyButtons.CP_MISSION_OVERVIEW )
		AddLargeButton( controller, options, CoD.LobbyButtons.CP_SELECT_MISSION )
		AddSmallButton( controller, options, CoD.LobbyButtons.CP_EDIT_GAME_RULES )
		AddSpacer( options )
--		AddLargeButton( controller, options, CoD.LobbyButtons.CP_CHOOSE_DIFFICULTY )
	else
--		AddSmallButton( controller, options, CoD.LobbyButtons.CP_MISSION_OVERVIEW )
	end
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_SELECT_TRUCK )
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_VIEW_STATS )
	--Engine.SetDvar("sv_maxclients", 6)
	--Engine.SetDvar("com_maxclients", 6)
	--Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_GAME, 6)
	--Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_PRIVATE, 6)
	--InitUnlockInfo( nil, controller )
end

CoD.LobbyMenus.CPButtonsLAN = function ( controller, options, isLeader )
	if IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	elseif isLeader == 1 then
		AddSmallButton( controller, options, CoD.LobbyButtons.MJ_STARTGAME )
		AddSpacer( options )
		AddLargeButton( controller, options, CoD.LobbyButtons.CP_SELECT_MISSION )
		AddSmallButton( controller, options, CoD.LobbyButtons.CP_EDIT_GAME_RULES )
		AddSpacer( options )
--		AddLargeButton( controller, options, CoD.LobbyButtons.CP_CHOOSE_DIFFICULTY )
	else
--		AddSmallButton( controller, options, CoD.LobbyButtons.CP_MISSION_OVERVIEW )
	end
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_SELECT_TRUCK )
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_VIEW_STATS )
	--Engine.SetDvar("sv_maxclients", 6)
	--Engine.SetDvar("com_maxclients", 6)
	--Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_GAME, 6)
	--Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_PRIVATE, 6)
	--InitUnlockInfo( nil, controller )
end

CoD.LobbyMenus.CPButtonsLANCUSTOM = function ( controller, options, isLeader )
	if IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	elseif isLeader == 1 then
		AddSmallButton( controller, options, CoD.LobbyButtons.MJ_STARTGAME )
		AddSpacer( options )
--		AddSmallButton( controller, options, CoD.LobbyButtons.CP_MISSION_OVERVIEW )
		AddLargeButton( controller, options, CoD.LobbyButtons.CP_SELECT_MISSION )
		AddSmallButton( controller, options, CoD.LobbyButtons.CP_EDIT_GAME_RULES )
		AddSpacer( options )
--		AddLargeButton( controller, options, CoD.LobbyButtons.CP_CHOOSE_DIFFICULTY )
	else
--		AddSmallButton( controller, options, CoD.LobbyButtons.CP_MISSION_OVERVIEW )
	end
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_SELECT_TRUCK )
	AddSmallButton( controller, options, CoD.LobbyButtons.MJ_VIEW_STATS )
	--Engine.SetDvar("sv_maxclients", 6)
	--Engine.SetDvar("com_maxclients", 6)
	--Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_GAME, 6)
	--Engine.SetLobbyMaxClients(Enum.LobbyType.LOBBY_TYPE_PRIVATE, 6)
	--InitUnlockInfo( nil, controller )
end

CoD.LobbyMenus.MPButtonsMain = function ( controller, options, isLeader )
	if isLeader == 1 then
		AddLargeButton( controller, options, CoD.LobbyButtons.MP_PUBLIC_MATCH )
		AddLargeButton( controller, options, CoD.LobbyButtons.MP_ARENA )
		AddLargeButton( controller, options, CoD.LobbyButtons.MP_CUSTOM_GAMES )
		AddLargeButton( controller, options, CoD.LobbyButtons.THEATER_MP )
	end
	AddSpacer( options )
	if CoD.isPC then
		AddLargeButton( controller, options, CoD.LobbyButtons.STEAM_STORE )
	else
		AddLargeButton( controller, options, CoD.LobbyButtons.STORE )
	end
end

CoD.LobbyMenus.MPButtonsOnline = function ( controller, options, isLeader )
	if isLeader == 1 then
		AddLargeButton( controller, options, CoD.LobbyButtons.MP_FIND_MATCH )
		AddSpacer( options )
	end
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_CAC_NO_WARNING )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_SPECIALISTS_NO_WARNING )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_SCORESTREAKS )
	if (Dvar.ui_execdemo_beta:get() or IsStarterPack()) and IsStoreAvailable() then
		if CoD.isPC then
			AddLargeButton( controller, options, CoD.LobbyButtons.STEAM_STORE )
		else
			AddLargeButton( controller, options, CoD.LobbyButtons.STORE )
		end
	end
	if Engine.DvarBool( nil, "inventory_test_button_visible" ) then
		AddLargeButton( controller, options, CoD.LobbyButtons.MP_INVENTORY_TEST )
	end
	AddSpacer( options )
	if not DisableBlackMarket() then
		AddSmallButton( controller, options, CoD.LobbyButtons.BLACK_MARKET )
	end
end

CoD.LobbyMenus.MPButtonsOnlinePublic = function ( controller, options, isLeader )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_CAC )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_SPECIALISTS )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_SCORESTREAKS )
	if Engine.DvarBool( nil, "inventory_test_button_visible" ) then
		AddLargeButton( controller, options, CoD.LobbyButtons.MP_INVENTORY_TEST )
	end
	local f27_local0 = Engine.GetPlaylistInfoByID( Engine.GetPlaylistID() )
	if f27_local0 then
		local f27_local1 = f27_local0.playlist.category
		if f27_local1 == Engine.GetPlaylistCategoryIdByName( "core" ) or f27_local1 == Engine.GetPlaylistCategoryIdByName( "hardcore" ) then
			AddSpacer( options )
			AddSmallButton( controller, options, CoD.LobbyButtons.MP_PUBLIC_LOBBY_LEADERBOARD )
		end
	end
	if not DisableBlackMarket() then
		AddSpacer( options )
		AddSmallButton( controller, options, CoD.LobbyButtons.BLACK_MARKET )
	end
end

CoD.LobbyMenus.MPButtonsModGame = function ( controller, options, isLeader )
	if Engine.IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	else
		AddLargeButton( controller, options, CoD.LobbyButtons.MP_CAC )
		AddLargeButton( controller, options, CoD.LobbyButtons.MP_SPECIALISTS )
		AddLargeButton( controller, options, CoD.LobbyButtons.MP_SCORESTREAKS )
	end
end

CoD.LobbyMenus.MPButtonsCustomGame = function ( controller, options, isLeader )
	if IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	elseif isLeader == 1 then
		AddSmallButton( controller, options, CoD.LobbyButtons.MP_CUSTOM_START_GAME )
		AddSmallButton( controller, options, CoD.LobbyButtons.MP_CUSTOM_SETUP_GAME )
		AddSpacer( options )
	end
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_CAC )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_SPECIALISTS )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_SCORESTREAKS )
	AddSpacer( options )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_CODCASTER_SETTINGS )
	if Engine.DvarBool( nil, "inventory_test_button_visible" ) then
		AddLargeButton( controller, options, CoD.LobbyButtons.MP_INVENTORY_TEST )
	end
	AddSpacer( options )
	AddSmallButton( controller, options, CoD.LobbyButtons.MP_CUSTOM_LOBBY_LEADERBOARD )
end

CoD.LobbyMenus.MPButtonsArena = function ( controller, options, isLeader )
	if isLeader == 1 then
		AddLargeButton( controller, options, CoD.LobbyButtons.MP_ARENA_FIND_MATCH )
		AddLargeButton( controller, options, CoD.LobbyButtons.MP_ARENA_SELECT_ARENA )
		AddSpacer( options )
	end
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_CAC )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_SPECIALISTS )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_SCORESTREAKS )
	if not DisableBlackMarket() then
		AddSpacer( options )
		AddSmallButton( controller, options, CoD.LobbyButtons.BLACK_MARKET )
	end
end

CoD.LobbyMenus.MPButtonsArenaGame = function ( controller, options, isLeader )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_CAC )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_SPECIALISTS )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_SCORESTREAKS )
	if not DisableBlackMarket() then
		AddSpacer( options )
		AddSmallButton( controller, options, CoD.LobbyButtons.BLACK_MARKET )
	end
end

CoD.LobbyMenus.MPButtonsLAN = function ( controller, options, isLeader )
	if IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	elseif isLeader == 1 then
		AddSmallButton( controller, options, CoD.LobbyButtons.MP_CUSTOM_START_GAME )
		AddSmallButton( controller, options, CoD.LobbyButtons.MP_CUSTOM_SETUP_GAME )
		AddSpacer( options )
	end
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_CAC )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_SPECIALISTS )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_SCORESTREAKS )
	AddSpacer( options )
	AddLargeButton( controller, options, CoD.LobbyButtons.MP_CODCASTER_SETTINGS )
	if Engine.DvarBool( nil, "inventory_test_button_visible" ) then
		AddLargeButton( controller, options, CoD.LobbyButtons.MP_INVENTORY_TEST )
	end
end

CoD.LobbyMenus.ZMButtonsOnline = function ( controller, options, isLeader )
	if IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	elseif isLeader == 1 then
		AddLargeButton( controller, options, CoD.LobbyButtons.ZM_SOLO_GAME )
		AddLargeButton( controller, options, CoD.LobbyButtons.ZM_FIND_MATCH )
		AddLargeButton( controller, options, CoD.LobbyButtons.ZM_CUSTOM_GAMES )
		AddLargeButton( controller, options, CoD.LobbyButtons.THEATER_ZM )
		AddSpacer( options )
	end
	AddLargeButton( controller, options, CoD.LobbyButtons.ZM_BUBBLEGUM_BUFFS )
	AddLargeButton( controller, options, CoD.LobbyButtons.ZM_MEGACHEW_FACTORY )
	AddLargeButton( controller, options, CoD.LobbyButtons.ZM_GOBBLEGUM_RECIPES )
	AddLargeButton( controller, options, CoD.LobbyButtons.ZM_BUILD_KITS )
end

CoD.LobbyMenus.ZMButtonsPublicGame = function ( controller, options )
	if IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	else
		AddLargeButton( controller, options, CoD.LobbyButtons.ZM_READY_UP )
		AddLargeButton( controller, options, CoD.LobbyButtons.ZM_BUBBLEGUM_BUFFS )
		AddLargeButton( controller, options, CoD.LobbyButtons.ZM_BUILD_KITS )
	end
end

CoD.LobbyMenus.ZMButtonsCustomGame = function ( controller, options, isLeader )
	if IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	elseif isLeader == 1 then
		AddLargeButton( controller, options, CoD.LobbyButtons.ZM_START_CUSTOM_GAME )
		AddLargeButton( controller, options, CoD.LobbyButtons.ZM_CHANGE_MAP )
		AddSpacer( options )
		AddLargeButton( controller, options, CoD.LobbyButtons.ZM_CHANGE_RANKED_SETTTINGS )
		if CoD.isPC and IsServerBrowserEnabled() then
			AddLargeButton( controller, options, CoD.LobbyButtons.ZM_SERVER_SETTINGS )
		end
		AddSpacer( options )
	end
	AddLargeButton( controller, options, CoD.LobbyButtons.ZM_BUBBLEGUM_BUFFS )
	AddLargeButton( controller, options, CoD.LobbyButtons.ZM_BUILD_KITS )
end

CoD.LobbyMenus.ZMButtonsLAN = function ( controller, options, isLeader )
	if IsStarterPack() then
		AddSmallButton( controller, options, CoD.LobbyButtons.QUIT )
		return 
	elseif isLeader == 1 then
		AddLargeButton( controller, options, CoD.LobbyButtons.ZM_START_LAN_GAME )
		AddLargeButton( controller, options, CoD.LobbyButtons.ZM_CHANGE_MAP )
		AddSpacer( options )
	end
	AddLargeButton( controller, options, CoD.LobbyButtons.ZM_BUBBLEGUM_BUFFS )
	AddLargeButton( controller, options, CoD.LobbyButtons.ZM_BUILD_KITS )
end

CoD.LobbyMenus.FRButtonsOnlineGame = function ( controller, options, isLeader )
	AddLargeButton( controller, options, CoD.LobbyButtons.FR_START_RUN_ONLINE )
	AddLargeButton( controller, options, CoD.LobbyButtons.FR_CHANGE_MAP )
	AddSpacer( options )
	AddLargeButton( controller, options, CoD.LobbyButtons.FR_LEADERBOARD )
end

CoD.LobbyMenus.FRButtonsLANGame = function ( controller, options, isLeader )
	AddLargeButton( controller, options, CoD.LobbyButtons.FR_START_RUN_LAN )
	AddLargeButton( controller, options, CoD.LobbyButtons.FR_CHANGE_MAP )
end

CoD.LobbyMenus.ButtonsTheaterGame = function ( controller, options, isLeader )
	if isLeader == 1 then
		AddSmallButton( controller, options, CoD.LobbyButtons.TH_START_FILM )
		AddSmallButton( controller, options, CoD.LobbyButtons.TH_SELECT_FILM )
		AddSmallButton( controller, options, CoD.LobbyButtons.TH_CREATE_HIGHLIGHT )
	end
end

local targetButtons = {
	[LobbyData.UITargets.UI_MAIN.id] = CoD.LobbyMenus.ModeSelect,
	[LobbyData.UITargets.UI_MODESELECT.id] = CoD.LobbyMenus.ModeSelect,
	[LobbyData.UITargets.UI_CPLOBBYLANGAME.id] = CoD.LobbyMenus.CPButtonsLAN,
	[LobbyData.UITargets.UI_CPLOBBYLANCUSTOMGAME.id] = CoD.LobbyMenus.CPButtonsLANCUSTOM,
	[LobbyData.UITargets.UI_CPLOBBYONLINE.id] = CoD.LobbyMenus.CPButtonsOnline,
	[LobbyData.UITargets.UI_CPLOBBYONLINEPUBLICGAME.id] = CoD.LobbyMenus.CPButtonsPublicGame,
	[LobbyData.UITargets.UI_CPLOBBYONLINECUSTOMGAME.id] = CoD.LobbyMenus.CPButtonsCustomGame,
	[LobbyData.UITargets.UI_CP2LOBBYLANGAME.id] = CoD.LobbyMenus.CPZMButtonsLAN,
	[LobbyData.UITargets.UI_CP2LOBBYLANCUSTOMGAME.id] = CoD.LobbyMenus.CPButtonsLANCUSTOM,
	[LobbyData.UITargets.UI_CP2LOBBYONLINE.id] = CoD.LobbyMenus.CPZMButtonsOnline,
	[LobbyData.UITargets.UI_CP2LOBBYONLINEPUBLICGAME.id] = CoD.LobbyMenus.CPZMButtonsPublicGame,
	[LobbyData.UITargets.UI_CP2LOBBYONLINECUSTOMGAME.id] = CoD.LobbyMenus.CPButtonsCustomGame,
	[LobbyData.UITargets.UI_DOALOBBYLANGAME.id] = CoD.LobbyMenus.DOAButtonsLAN,
	[LobbyData.UITargets.UI_DOALOBBYONLINE.id] = CoD.LobbyMenus.DOAButtonsOnline,
	[LobbyData.UITargets.UI_DOALOBBYONLINEPUBLICGAME.id] = CoD.LobbyMenus.DOAButtonsPublicGame,
	[LobbyData.UITargets.UI_MPLOBBYLANGAME.id] = CoD.LobbyMenus.MPButtonsLAN,
	[LobbyData.UITargets.UI_MPLOBBYMAIN.id] = CoD.LobbyMenus.MPButtonsMain,
	[LobbyData.UITargets.UI_MPLOBBYONLINE.id] = CoD.LobbyMenus.MPButtonsOnline,
	[LobbyData.UITargets.UI_MPLOBBYONLINEPUBLICGAME.id] = CoD.LobbyMenus.MPButtonsOnlinePublic,
	[LobbyData.UITargets.UI_MPLOBBYONLINEMODGAME.id] = CoD.LobbyMenus.MPButtonsModGame,
	[LobbyData.UITargets.UI_MPLOBBYONLINECUSTOMGAME.id] = CoD.LobbyMenus.MPButtonsCustomGame,
	[LobbyData.UITargets.UI_MPLOBBYONLINEARENA.id] = CoD.LobbyMenus.MPButtonsArena,
	[LobbyData.UITargets.UI_MPLOBBYONLINEARENAGAME.id] = CoD.LobbyMenus.MPButtonsArenaGame,
	[LobbyData.UITargets.UI_FRLOBBYONLINEGAME.id] = CoD.LobbyMenus.FRButtonsOnlineGame,
	[LobbyData.UITargets.UI_FRLOBBYLANGAME.id] = CoD.LobbyMenus.FRButtonsLANGame,
	[LobbyData.UITargets.UI_ZMLOBBYLANGAME.id] = CoD.LobbyMenus.ZMButtonsLAN,
	[LobbyData.UITargets.UI_ZMLOBBYONLINE.id] = CoD.LobbyMenus.ZMButtonsOnline,
	[LobbyData.UITargets.UI_ZMLOBBYONLINEPUBLICGAME.id] = CoD.LobbyMenus.ZMButtonsPublicGame,
	[LobbyData.UITargets.UI_ZMLOBBYONLINECUSTOMGAME.id] = CoD.LobbyMenus.ZMButtonsCustomGame,
	[LobbyData.UITargets.UI_MPLOBBYONLINETHEATER.id] = CoD.LobbyMenus.ButtonsTheaterGame,
	[LobbyData.UITargets.UI_ZMLOBBYONLINETHEATER.id] = CoD.LobbyMenus.ButtonsTheaterGame
}
CoD.LobbyMenus.AddButtonsForTarget = function ( controller, id )
	local buttonFunc = targetButtons[id]
	local model = nil
	if Engine.IsLobbyActive( Enum.LobbyType.LOBBY_TYPE_GAME ) then
		model = Engine.GetModel( DataSources.LobbyRoot.getModel( controller ), "gameClient.isHost" )
	else
		model = Engine.GetModel( DataSources.LobbyRoot.getModel( controller ), "privateClient.isHost" )
	end
	local isLeader = nil
	if model ~= nil then
		isLeader = Engine.GetModelValue( model )
	else
		isLeader = 1
	end
	local result = {}
	buttonFunc( controller, result, isLeader )
	return result
end

