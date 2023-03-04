require( "lua.lobby.process.lobbyprocessnavigateog" )


Lobby.ProcessNavigate.SwitchLobbiesGetDefaultGametype = function (f5_arg0, f5_arg1)
	local f5_local0 = "crosscountry"
	--[[if f5_arg1.mainMode == Enum.LobbyMainMode.LOBBY_MAINMODE_CP then
		if LuaUtils.IsCPZMTarget(f5_arg1.id) then
			f5_local0 = "znml"
		elseif LuaUtils.IsDOATarget(f5_arg1.id) then
			f5_local0 = "znml"
		end
	elseif f5_arg1.mainMode == Enum.LobbyMainMode.LOBBY_MAINMODE_MP then
		if f5_arg1.id == LobbyData.UITargets.UI_FRLOBBYONLINEGAME.id or f5_arg1.id == LobbyData.UITargets.UI_FRLOBBYLANGAME.id then
			f5_local0 = "fr"
		else
			f5_local0 = "tdm"
		end
	elseif f5_arg1.mainMode == Enum.LobbyMainMode.LOBBY_MAINMODE_ZM then
		f5_local0 = "znml"
	end]]
	return f5_local0
end

Lobby.ProcessNavigate.SwitchLobbiesGetMap = function (f9_arg0, f9_arg1)
	local f9_local0 = nil
	if Engine.IsCampaignGame() then
		f9_local0 = Engine.ProfileValueAsString(f9_arg0, "map_cp")
	elseif Engine.IsMultiplayerGame() then
		if f9_arg1.id == LobbyData.UITargets.UI_FRLOBBYONLINEGAME.id or f9_arg1.id == LobbyData.UITargets.UI_FRLOBBYLANGAME.id then
			f9_local0 = Engine.ProfileValueAsString(f9_arg0, "map_fr")
		else
			f9_local0 = Engine.ProfileValueAsString(f9_arg0, "map")
		end
	elseif Engine.IsZombiesGame() then
		f9_local0 = Engine.ProfileValueAsString(f9_arg0, "map_zm")
	end
	if not Lobby.ProcessNavigate.SwitchLobbiesIsMapValid(f9_local0) then
		f9_local0 = LuaUtils.GetDefaultMap(f9_arg1)
	end
	return f9_local0
end