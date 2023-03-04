require("ui.uieditor.conditionsOg")

--[[
function IsLobbyWithTeamAssignment()
	local f450_local0 = Engine.GetModelValue( Engine.CreateModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNav" ) )
	local f450_local1
	if ( f450_local0 ~= LobbyData.UITargets.UI_MPLOBBYONLINECUSTOMGAME.id and f450_local0 ~= LobbyData.UITargets.UI_MPLOBBYLANGAME.id and ( f450_local0 ~= LobbyData.UITargets.UI_ZMLOBBYONLINECUSTOMGAME.id and f450_local0 ~= LobbyData.UITargets.UI_ZMLOBBYLANGAME.id)) or Dvar.ui_gametype:get() == "zcleansed" then
		f450_local1 = false
	else
		f450_local1 = true
	end
	return f450_local1
end

function ShouldHidePaintJobOptionInZM( f650_arg0, f650_arg1, f650_arg2 )
	return true
end

function Paintjobs_IsEnabled( f683_arg0, f683_arg1 )
	return false
end

function Gunsmith_IsEnabled( f651_arg0, f651_arg1 )
	return false
end

function Gunsmith_IsCrossbow( menu, element, controller )
	local weaponGroupName = CoD.CraftUtility.GetWeaponGroupName( controller )
	local weaponName = Engine.GetItemRef( CoD.GetCustomization( controller, "weapon_index" ), Enum.eModes.MODE_MULTIPLAYER )
	if ( weaponGroupName == "weapon_pistol" or weaponGroupName == "weapon_special" ) and weaponName == "t6_crossbow_upgraded" then
		return true
	else
		return false
	end
end

function Gunsmith_IsSpecialWeapon( menu, element, controller )
	local weaponGroupName = CoD.CraftUtility.GetWeaponGroupName( controller )
	local isSpecialWeapon = false
	local weaponName = Engine.GetItemRef( CoD.GetCustomization( controller, "weapon_index" ), Enum.eModes.MODE_MULTIPLAYER )
	if weaponGroupName == "weapon_launcher" or weaponGroupName == "weapon_knife" or weaponName == "special_discgun" or weaponName == "knife_ballistic" or weaponName == "t6_knife_ballistic_upgraded" then
		isSpecialWeapon = true
	end
	return isSpecialWeapon
end

function IsGameModeVar( attribute, statement, gamemode )
	if not gamemode then
		gamemode = Dvar.ui_gametype:get()
	end
    local lookUpString = Engine.StructTableLookupString( CoDShared.gametypesStructTable, "name", gamemode, attribute )
    if lookUpString then
        return lookUpString == statement
    else
        return false
    end
end

function GetGameModeVar( attribute, gamemode )
	if not gamemode then
		gamemode = Dvar.ui_gametype:get()
	end
    local lookUpNumber = Engine.StructTableLookupString( CoDShared.gametypesStructTable, "name", gamemode, attribute )
    if lookUpNumber then
        return tonumber( lookUpNumber )
    else
        return 0
    end
end
]]