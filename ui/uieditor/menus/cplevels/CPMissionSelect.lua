require( "ui.uieditor.menus.CPLevels.CPResetPopup" )
require( "ui.uieditor.widgets.MenuSpecificWidgets.MissionProgression.CPMissionSelect_ListProgressionButton" )
require( "ui.uieditor.widgets.BackgroundFrames.GenericMenuFrame" )
require( "ui.uieditor.widgets.Lobby.Common.FE_Menu_LeftGraphics" )
require( "ui.uieditor.widgets.CPLevels.CPMissionInfo" )
require( "ui.uieditor.widgets.CPLevels.CP_FrameBox" )
require( "ui.uieditor.widgets.ZMInventory.ZMMapSelection.List1ButtonLarge_ZM" )

DataSources.CPMJMapsList = ListHelper_SetupDataSource( "CPMJMapsList", function ( controller, menu )
	local mapsList = {}
	--[[if CoD.perController[controller].choosingZMPlaylist then
		local f400_local1 = Engine.GetPlaylistCategories()
		local mapsTable = CoD.PlaylistCategoryFilter or ""
		local f400_local3 = FindPlaylistCategory( f400_local1, Engine.ProfileInt( controller, "playlist_" .. mapsTable ) )
		local f400_local4 = 0
		for f400_local8, f400_local9 in ipairs( f400_local1 ) do
			if f400_local9.filter == mapsTable then
				f400_local4 = f400_local4 + f400_local9.playerCount
			end
		end
		f400_local5 = function ( f401_arg0 )
			local f401_local0 = ""
			if Engine.DvarBool( nil, "groupCountsVisible" ) == true then
				f401_local0 = Engine.Localize( "MENU_CATEGORY_USER_COUNT", CoD.separateNumberWithCommas( f401_arg0.playerCount ), CoD.separateNumberWithCommas( f400_local4 ) )
			else
				local f401_local1 = 0
				if f400_local4 > 0 then
					f401_local1 = math.floor( f401_arg0.playerCount / f400_local4 * 100 + 0.5 )
				end
				f401_local0 = Engine.Localize( "MENU_CATEGORY_USER_PERCENT", f401_local1 )
			end
			local f401_local1 = f401_arg0.playlists[1]
			local f401_local2 = true
			local f401_local3
			if f401_local1 then
				f401_local3 = Engine.IsPlaylistLocked( controller, f401_local1.index )
				if f401_local3 then
					if IsDvarValueEqualTo( "ui_freeDLC1", "1" ) and Engine.GetDLCBitForMapName( f401_arg0.ref ) == CoD.DLCBits.CONTENT_DLC1 then
						f401_local3 = false
					else
						f401_local3 = true
					end
				end
			else
				f401_local3 = true
			end
			if f401_local1 then
				f401_local2 = f401_local3 and not ShowPurchasableMap( controller, f401_arg0.ref )
			end
			if f401_local2 then
				return nil
			end
			local f401_local4 = f401_arg0.description
			if f401_local3 then
				f401_local4 = CoD.StoreUtility.AddUpsellToDescriptionIfNeeded( controller, f401_arg0.ref, f401_arg0.description )
			end
			local f401_local5 = Engine.IsMapValid( f401_arg0.ref )
			local f401_local6 = {
				models = {
					displayText = CoD.StoreUtility.PrependPurchaseIconIfNeeded( controller, f401_arg0.ref, Engine.ToUpper( f401_arg0.name ) ) or "",
					mapName = Engine.ToUpper( f401_arg0.name ) or "",
					Image = f401_arg0.icon or "playlist_standard",
					mapDescription = f401_local4,
					playingCount = f401_local0
				}
			}
			local f401_local7 = {
				id = f401_arg0.ref,
				mapId = f401_arg0.ref,
				category = f401_arg0,
				playlist = f401_local1,
				selectIndex = f401_arg0 == f400_local3,
				disabled = f401_local5 and f401_local3
			}
			local f401_local8
			if not f401_local5 then
				local f401_local9 = f401_local3
				f401_local8 = ShowPurchasableMap( controller, f401_arg0.ref )
			else
				f401_local8 = false
			end
			f401_local7.purchasable = f401_local8
			f401_local6.properties = f401_local7
			return f401_local6
		end
		
		for f400_local9, f400_local11 in ipairs( f400_local1 ) do
			if f400_local11.filter == mapsTable then
				local f400_local10 = f400_local5( f400_local11 )
				if f400_local10 then
					table.insert( mapsList, f400_local10 )
				end
			end
		end
		if not menu.updateLobbyButtonsSubscription then
			menu.updateLobbyButtonsSubscription = menu:subscribeToModel( Engine.CreateModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyButtonUpdate" ), function ()
				menu:updateDataSource( true )
			end, false )
		end
	else]]
		if Mods_Enabled() then
			local mapsTable = Engine.Mods_Lists_GetInfoEntries( LuaEnums.USERMAP_BASE_PATH, 0, Engine.Mods_Lists_GetInfoEntriesCount( LuaEnums.USERMAP_BASE_PATH ) )
			if mapsTable then
				for id = 0, #mapsTable, 1 do
					local mapData = mapsTable[id]
					if LUI.startswith( mapData.internalName, "cp_mj_" ) then
						table.insert( mapsList, {
							models = {
								displayText = string.sub( mapData.name, 1, 32 ),
								Image = mapData.ugcName,
								mapName = mapData.name,
								mapDescription = mapData.description
							},
							properties = {
								mapId = mapData.ugcName,
								classified = false
							}
						} )
					end
				end
			end
		--end
	end
	return mapsList
end, true )

LUI.createMenu.CPMissionSelect = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "CPMissionSelect" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self.soundSet = "MultiplayerMain"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "CPMissionSelect.buttonPrompts" )
	local menu = self
	self.anyChildUsesUpdateState = true

	-- init the host player's info for this splitscreen player.
	--if IsPlayerAGuest( controller ) then
		InitUnlockInfo( nil, controller )
	--end
	
	local Smoke = LUI.UIImage.new()
	Smoke:setLeftRight( true, true, 0, 0 )
	Smoke:setTopBottom( true, true, 0, 0 )
	Smoke:setImage( RegisterImage( "uie_fe_cp_background" ) )
	self:addElement( Smoke )
	self.Smoke = Smoke
	
	local MapList = LUI.UIList.new( menu, controller, 2, 0, nil, false, false, 0, 0, false, false )
	MapList:makeFocusable()
	MapList:setLeftRight( true, false, 79, 313 )
	MapList:setTopBottom( true, false, 144, 618 )
	MapList:setDataSource( "CPMJMapsList" )
	MapList:setWidgetType( CoD.List1ButtonLarge_ZM )
	MapList:setVerticalCount( 14 )
	MapList:registerEventHandler( "gain_focus", function ( element, event )
		local f2_local0 = nil
		if element.gainFocus then
			f2_local0 = element:gainFocus( event )
		elseif element.super.gainFocus then
			f2_local0 = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return f2_local0
	end )
	MapList:registerEventHandler( "lose_focus", function ( element, event )
		local f3_local0 = nil
		if element.loseFocus then
			f3_local0 = element:loseFocus( event )
		elseif element.super.loseFocus then
			f3_local0 = element.super:loseFocus( event )
		end
		return f3_local0
	end )
	menu:AddButtonCallbackFunction( MapList, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( f4_arg0, f4_arg1, f4_arg2, f4_arg3 )
		LaunchSelectedCPMission( self, f4_arg0, f4_arg2 )
		return true
	end, function ( f5_arg0, f5_arg1, f5_arg2 )
		CoD.Menu.SetButtonLabel( f5_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		return true
	end, false )
	self:addElement( MapList )
	self.MapList = MapList
	
	local MenuFrame = CoD.GenericMenuFrame.new( menu, controller )
	MenuFrame:setLeftRight( true, true, 0, 0 )
	MenuFrame:setTopBottom( true, true, 0, 0 )
	MenuFrame.titleLabel:setText( Engine.Localize( "MENU_CHOOSE_MAP_CAPS" ) )
	MenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText( Engine.Localize( "MENU_CHOOSE_MAP_CAPS" ) )
	self:addElement( MenuFrame )
	self.MenuFrame = MenuFrame
	
	local FEMenuLeftGraphics = CoD.FE_Menu_LeftGraphics.new( menu, controller )
	FEMenuLeftGraphics:setLeftRight( true, false, 19, 71 )
	FEMenuLeftGraphics:setTopBottom( true, false, 84, 701 )
	self:addElement( FEMenuLeftGraphics )
	self.FEMenuLeftGraphics = FEMenuLeftGraphics
	
	local CPMissionInfo = CoD.CPMissionInfo.new( menu, controller )
	CPMissionInfo:setLeftRight( true, false, 322, 1191 )
	CPMissionInfo:setTopBottom( true, false, 136, 553.28 )
	self:addElement( CPMissionInfo )
	self.CPMissionInfo = CPMissionInfo

	self.CPMissionInfo.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self.CPMissionInfo:setupElementClipCounter( 11 )
				self.CPMissionInfo.Description:completeAnimation()
				self.CPMissionInfo.Description:setAlpha( 0.55 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.Description, {} )
				self.CPMissionInfo.Description0:completeAnimation()
				self.CPMissionInfo.Description0:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.Description0, {} )
				self.CPMissionInfo.Image0:completeAnimation()
				self.CPMissionInfo.Image0:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.Image0, {} )
				self.CPMissionInfo.CPMapPerformanceRecord:completeAnimation()
				self.CPMissionInfo.CPMapPerformanceRecord:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.CPMapPerformanceRecord, {} )
				self.CPMissionInfo.CPMissionTitle:completeAnimation()
				self.CPMissionInfo.CPMissionTitle:setAlpha( 1 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.CPMissionTitle, {} )
				self.CPMissionInfo.CPMapInfoWidget:completeAnimation()
				self.CPMissionInfo.CPMapInfoWidget:setAlpha( 1 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.CPMapInfoWidget, {} )
				self.CPMissionInfo.ClassifiedText:completeAnimation()
				self.CPMissionInfo.ClassifiedText:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.ClassifiedText, {} )
				self.CPMissionInfo.CPMapPerformanceRecordClassified:completeAnimation()
				self.CPMissionInfo.CPMapPerformanceRecordClassified:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.CPMapPerformanceRecordClassified, {} )
				self.CPMissionInfo.difficulty:completeAnimation()
				self.CPMissionInfo.difficulty:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.difficulty, {} )
				self.CPMissionInfo.CompletedDifficultyLabel:completeAnimation()
				self.CPMissionInfo.CompletedDifficultyLabel:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.CompletedDifficultyLabel, {} )
				self.CPMissionInfo.CompletedDifficultyImage:completeAnimation()
				self.CPMissionInfo.CompletedDifficultyImage:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.CompletedDifficultyImage, {} )
			end
		},
		Classified = {
			DefaultClip = function ()
				self.CPMissionInfo:setupElementClipCounter( 11 )
				self.CPMissionInfo.Description:completeAnimation()
				self.CPMissionInfo.Description:setAlpha( 0.55 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.Description, {} )
				self.CPMissionInfo.Description0:completeAnimation()
				self.CPMissionInfo.Description0:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.Description0, {} )
				self.CPMissionInfo.Image0:completeAnimation()
				self.CPMissionInfo.Image0:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.Image0, {} )
				self.CPMissionInfo.CPMapPerformanceRecord:completeAnimation()
				self.CPMissionInfo.CPMapPerformanceRecord:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.CPMapPerformanceRecord, {} )
				self.CPMissionInfo.CPMissionTitle:completeAnimation()
				self.CPMissionInfo.CPMissionTitle:setAlpha( 1 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.CPMissionTitle, {} )
				self.CPMissionInfo.CPMapInfoWidget:completeAnimation()
				self.CPMissionInfo.CPMapInfoWidget:setAlpha( 1 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.CPMapInfoWidget, {} )
				self.CPMissionInfo.ClassifiedText:completeAnimation()
				self.CPMissionInfo.ClassifiedText:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.ClassifiedText, {} )
				self.CPMissionInfo.CPMapPerformanceRecordClassified:completeAnimation()
				self.CPMissionInfo.CPMapPerformanceRecordClassified:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.CPMapPerformanceRecordClassified, {} )
				self.CPMissionInfo.difficulty:completeAnimation()
				self.CPMissionInfo.difficulty:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.difficulty, {} )
				self.CPMissionInfo.CompletedDifficultyLabel:completeAnimation()
				self.CPMissionInfo.CompletedDifficultyLabel:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.CompletedDifficultyLabel, {} )
				self.CPMissionInfo.CompletedDifficultyImage:completeAnimation()
				self.CPMissionInfo.CompletedDifficultyImage:setAlpha( 0 )
				self.CPMissionInfo.clipFinished( self.CPMissionInfo.CompletedDifficultyImage, {} )
			end
		}
	}
	
	local CPFrameBox = CoD.CP_FrameBox.new( menu, controller )
	CPFrameBox:setLeftRight( true, false, 322, 909 )
	CPFrameBox:setTopBottom( true, false, 136, 417 )
	self:addElement( CPFrameBox )
	self.CPFrameBox = CPFrameBox
	
	CPMissionInfo:linkToElementModel( MapList, nil, false, function ( model )
		CPMissionInfo:setModel( model, controller )
	end )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( f17_arg0, f17_arg1, f17_arg2, f17_arg3 )
		GoBack( self, f17_arg2 )
		return true
	end, function ( f18_arg0, f18_arg1, f18_arg2 )
		CoD.Menu.SetButtonLabel( f18_arg1, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK" )
		return true
	end, false )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, nil, function ( f19_arg0, f19_arg1, f19_arg2, f19_arg3 )
		return true
	end, function ( f20_arg0, f20_arg1, f20_arg2 )
		CoD.Menu.SetButtonLabel( f20_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "" )
		return false
	end, false )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_START, "O", function ( f21_arg0, f21_arg1, f21_arg2, f21_arg3 )
		if ShouldShowCampaignResetOption( f21_arg2 ) then
			OpenPopup( self, "CPResetPopup", f21_arg2 )
			return true
		else
			
		end
	end, function ( f22_arg0, f22_arg1, f22_arg2 )
		CoD.Menu.SetButtonLabel( f22_arg1, Enum.LUIButton.LUI_KEY_START, "MENU_OPTIONS" )
		if ShouldShowCampaignResetOption( f22_arg2 ) then
			return true
		else
			return false
		end
	end, false )
	MapList.id = "MapList"
	MenuFrame:setModel( self.buttonModel, controller )
	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )
	self:processEvent( {
		name = "update_state",
		menu = menu
	} )
	if not self:restoreState() then
		self.MapList:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.MapList:close()
		element.MenuFrame:close()
		element.FEMenuLeftGraphics:close()
		element.CPMissionInfo:close()
		element.CPFrameBox:close()
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "CPMissionSelect.buttonPrompts" ) )
	end )
	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end

