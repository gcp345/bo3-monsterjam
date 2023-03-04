require( "lua.Shared.LobbyData" )
require( "ui.T6.lobby.presence" )
require( "ui.uieditor.modifyFunctionsOg" )
require( "ui.uieditor.modifyFunctions_helper" )

--[[
function GetScoreboardTeamBackgroundColor( controller, teamID )
	if CoD.IsShoutcaster( controller ) and CoD.ShoutcasterProfileVarBool( controller, "shoutcaster_flip_scorepanel" ) then
		if teamID == Enum.team_t.TEAM_ALLIES then
			teamID = Enum.team_t.TEAM_AXIS
		elseif teamID == Enum.team_t.TEAM_AXIS then
			teamID = Enum.team_t.TEAM_ALLIES
		end
	end
	local faction = GetFactionForTeam( teamID )
	if faction ~= "default" then
		return Engine.GetFactionColor( faction )
	else
		return CoD.Zombie.SingleTeamColor.r, CoD.Zombie.SingleTeamColor.g, CoD.Zombie.SingleTeamColor.b
	end
end

function GetFactionForTeam( teamID )
	if teamID == Enum.team_t.TEAM_AXIS and Dvar.ui_gametype:get() == "zcleansed" then
		return "zombie"
	end
	if not IsGameModeVar( "is_team_based", "YES" ) then
		if teamID == Enum.team_t.TEAM_ALLIES or teamID == Enum.team_t.TEAM_AXIS then
			return "default"
		end
	else
		if Dvar.ui_mapname:get() == "zm_prison" or Dvar.ui_mapname:get() == "zm_cellblock" then
			if teamID == Enum.team_t.TEAM_ALLIES then
				return "guards"
			elseif teamID == Enum.team_t.TEAM_AXIS then
				return "inmates"
			end
		else
			if teamID == Enum.team_t.TEAM_ALLIES then
				return "cdc"
			elseif teamID == Enum.team_t.TEAM_AXIS then
				return "cia"
			end
		end
	end
	return "free"
end

function GetFactionReviveIcon( defaultIcon )
	if Dvar.ui_gametype:get() == "zcleansed" then
		return "whitetransparent"
	end
	if Dvar.ui_mapname:get() == "zm_prison" or Dvar.ui_mapname:get() == "zm_cellblock" then
		if defaultIcon == "t6waypoint_revive_cdc_zm" then
			return "t6waypoint_revive_guards"
		elseif defaultIcon == "t6waypoint_revive_cia_zm" then
			return "t6waypoint_revive_inmates"
		end
	end
	return defaultIcon
end
]]