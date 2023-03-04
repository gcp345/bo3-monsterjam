require( "ui.uieditor.widgets.ZMInventory.ZMMapSelection.List1ButtonLarge_ZM" )
require( "ui.uieditor.widgets.Scrollbars.verticalScrollbar" )
require( "ui.uieditor.widgets.verticalScrollingTextBox" )
require( "ui.uieditor.widgets.Scrollbars.verticalCounter" )
require( "ui.uieditor.widgets.BackgroundFrames.GenericMenuFrame" )
require( "ui.uieditor.widgets.ZMInventory.ZMMapSelection.ZMMissionTile" )
require( "ui.uieditor.widgets.Lobby.Common.FE_TitleLine" )
require( "ui.uieditor.widgets.DLC_Free_weekend" )
require( "ui.uieditor.widgets.Lobby.Common.FE_Menu_LeftGraphics" )
require( "ui.uieditor.widgets.ZMInventory.ZMMapSelection.ZMLobbyEEWidget" )

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
								mapId = mapData.ugcName
							}
						} )
					end
				end
			end
		--end
	end
	return mapsList
end, true )

local PreLoadFunc = function ( menu, controller )
	menu.preLoadImageModel = Engine.CreateModel( Engine.GetModelForController( controller ), "ZMMapSelectionPreloadImage" )
end

local PostLoadFunc = function ( menu, controller )
	menu.StreamedImagePreloader:subscribeToModel( menu.preLoadImageModel, function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue and CoD.GetMapValue( modelValue, "dlc_pack", 0 ) == 7 then
			menu.StreamedImagePreloader:setImage( RegisterImage( MapNameToMapLoadingImage( modelValue ) ) )
		end
	end, false )
	LUI.OverrideFunction_CallOriginalSecond( menu, "close", function ( element )
		Engine.UnsubscribeAndFreeModel( element.preLoadImageModel )
	end )
end

LUI.createMenu.ZMMapSelection = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "ZMMapSelection" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self.soundSet = "MultiplayerMain"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "ZMMapSelection.buttonPrompts" )
	local f5_local1 = self
	self.anyChildUsesUpdateState = true
	
	local Bkg = LUI.UIImage.new()
	Bkg:setLeftRight( true, false, 0, 1280 )
	Bkg:setTopBottom( true, false, -16.5, 720 )
	Bkg:setRGB( 0, 0, 0 )
	Bkg:setAlpha( 0.95 )
	self:addElement( Bkg )
	self.Bkg = Bkg
	
	local TitleBackground = LUI.UIImage.new()
	TitleBackground:setLeftRight( true, false, 0, 1280 )
	TitleBackground:setTopBottom( true, false, 0, 95 )
	TitleBackground:setRGB( 0.14, 0.12, 0.12 )
	TitleBackground:setAlpha( 0 )
	self:addElement( TitleBackground )
	self.TitleBackground = TitleBackground
	
	local FooterBackground = LUI.UIImage.new()
	FooterBackground:setLeftRight( true, true, 0, 0 )
	FooterBackground:setTopBottom( false, true, -57, 0 )
	FooterBackground:setRGB( 0.14, 0.12, 0.12 )
	FooterBackground:setAlpha( 0 )
	self:addElement( FooterBackground )
	self.FooterBackground = FooterBackground
	
	local Title = LUI.UIText.new()
	Title:setLeftRight( true, true, 64, 0 )
	Title:setTopBottom( true, false, 38, 85 )
	Title:setAlpha( 0 )
	Title:setText( Engine.Localize( "MPUI_MAPS_CAPS" ) )
	Title:setTTF( "fonts/escom.ttf" )
	Title:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	Title:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_TOP )
	self:addElement( Title )
	self.Title = Title
	
	local MapList = LUI.UIList.new( f5_local1, controller, 2, 0, nil, false, false, 0, 0, false, false )
	MapList:makeFocusable()
	MapList:setLeftRight( true, false, 64, 344 )
	MapList:setTopBottom( true, false, 134, 540 )
	MapList:setWidgetType( CoD.List1ButtonLarge_ZM )
	MapList:setVerticalCount( 12 )
	MapList:setVerticalCounter( CoD.verticalCounter )
	MapList:setVerticalScrollbar( CoD.verticalScrollbar )
	MapList:setDataSource( "CPMJMapsList" )
	MapList:linkToElementModel( MapList, "disabled", true, function ( model )
		local f6_local0 = MapList
		local f6_local1 = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "disabled"
		}
		CoD.Menu.UpdateButtonShownState( f6_local0, f5_local1, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
	end )
	MapList:registerEventHandler( "list_item_gain_focus", function ( element, event )
		local f7_local0 = nil
		SetElementPropertyOnPerControllerTable( controller, "zmLobbyEEMapRef", element, "mapId" )
		UpdateElementDataSource( self, "ZMLobbyEEList" )
		SetControllerModelValue( controller, "ZMMapSelectionPreloadImage", element.mapId )
		return f7_local0
	end )
	MapList:registerEventHandler( "gain_focus", function ( element, event )
		local f8_local0 = nil
		if element.gainFocus then
			f8_local0 = element:gainFocus( event )
		elseif element.super.gainFocus then
			f8_local0 = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, f5_local1, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		CoD.Menu.UpdateButtonShownState( element, f5_local1, controller, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE )
		return f8_local0
	end )
	MapList:registerEventHandler( "lose_focus", function ( element, event )
		local f9_local0 = nil
		if element.loseFocus then
			f9_local0 = element:loseFocus( event )
		elseif element.super.loseFocus then
			f9_local0 = element.super:loseFocus( event )
		end
		return f9_local0
	end )
	f5_local1:AddButtonCallbackFunction( MapList, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( element, menu, controller, model )
		LaunchSelectedCPMission( self, element, controller )
		return true
	end, function ( f11_arg0, f11_arg1, f11_arg2 )
		if IsPerControllerTablePropertyValue( f11_arg2, "choosingZMPlaylist", true ) and IsElementPropertyValue( f11_arg0, "purchasable", true ) then
			CoD.Menu.SetButtonLabel( f11_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
			return true
		elseif IsPerControllerTablePropertyValue( f11_arg2, "choosingZMPlaylist", true ) and not IsDisabled( f11_arg0, f11_arg2 ) then
			CoD.Menu.SetButtonLabel( f11_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
			return true
		elseif IsElementPropertyValue( f11_arg0, "purchasable", true ) then
			CoD.Menu.SetButtonLabel( f11_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
			return true
		elseif not IsDisabled( f11_arg0, f11_arg2 ) then
			CoD.Menu.SetButtonLabel( f11_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
			return true
		else
			return false
		end
	end, false )
	f5_local1:AddButtonCallbackFunction( MapList, controller, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE, nil, function ( f12_arg0, f12_arg1, f12_arg2, f12_arg3 )
		if IsDvarValueEqualTo( "ui_freeDLC1", "1" ) and ShouldShowDLCWidget( f12_arg2, "mp_rise" ) and IsElementPropertyValue( f12_arg0, "purchasable", true ) then
			OpenPurchaseMapPackConfirmation( f12_arg2, f12_arg0, "ZMMapSelect", f12_arg1 )
			return true
		else
			
		end
	end, function ( f13_arg0, f13_arg1, f13_arg2 )
		if IsDvarValueEqualTo( "ui_freeDLC1", "1" ) and ShouldShowDLCWidget( f13_arg2, "mp_rise" ) and IsElementPropertyValue( f13_arg0, "purchasable", true ) then
			CoD.Menu.SetButtonLabel( f13_arg1, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE, "" )
			return false
		else
			return false
		end
	end, false )
	self:addElement( MapList )
	self.MapList = MapList
	
	local MapPreview = LUI.UIImage.new()
	MapPreview:setLeftRight( true, false, 450.38, 1216 )
	MapPreview:setTopBottom( true, false, 131, 453 )
	self:addElement( MapPreview )
	self.MapPreview = MapPreview
	
	local SecTitleBG0 = LUI.UIImage.new()
	SecTitleBG0:setLeftRight( true, false, 447.87, 1216 )
	SecTitleBG0:setTopBottom( true, false, 463.39, 500 )
	SecTitleBG0:setImage( RegisterImage( "uie_t7_menu_cp_vault_sec_titlebig_bg" ) )
	self:addElement( SecTitleBG0 )
	self.SecTitleBG0 = SecTitleBG0
	
	local MissionBriefTitle = LUI.UIText.new()
	MissionBriefTitle:setLeftRight( true, false, 469.38, 802.34 )
	MissionBriefTitle:setTopBottom( true, false, 469.84, 493.84 )
	MissionBriefTitle:setText( Engine.Localize( "MENU_MISSION_BRIEFING_CAPS" ) )
	MissionBriefTitle:setTTF( "fonts/RefrigeratorDeluxe-Regular.ttf" )
	MissionBriefTitle:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	MissionBriefTitle:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_TOP )
	self:addElement( MissionBriefTitle )
	self.MissionBriefTitle = MissionBriefTitle
	
	local MissionBriefText = CoD.verticalScrollingTextBox.new( f5_local1, controller )
	MissionBriefText:setLeftRight( true, false, 469.38, 1211 )
	MissionBriefText:setTopBottom( true, false, 503.23, 675.23 )
	MissionBriefText.textBox:setTTF( "fonts/RefrigeratorDeluxe-Regular.ttf" )
	MissionBriefText.textBox:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( MissionBriefText )
	self.MissionBriefText = MissionBriefText
	
	local Banner = LUI.UIImage.new()
	Banner:setLeftRight( true, false, 450.38, 1216 )
	Banner:setTopBottom( true, false, 395.5, 453 )
	Banner:setRGB( 0, 0, 0 )
	Banner:setAlpha( 0.7 )
	self:addElement( Banner )
	self.Banner = Banner
	
	local Backing = LUI.UIImage.new()
	Backing:setLeftRight( true, false, 450.38, 1216 )
	Backing:setTopBottom( true, false, 395.5, 452.77 )
	Backing:setRGB( 0.32, 0.32, 0.32 )
	Backing:setAlpha( 0.05 )
	self:addElement( Backing )
	self.Backing = Backing
	
	local PlayCount = LUI.UIText.new()
	PlayCount:setLeftRight( true, false, 876.04, 1211 )
	PlayCount:setTopBottom( true, false, 375.5, 394.5 )
	PlayCount:setTTF( "fonts/UnitedSansSmCdMd.ttf" )
	PlayCount:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	PlayCount:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_TOP )
	self:addElement( PlayCount )
	self.PlayCount = PlayCount
	
	local MenuFrame = CoD.GenericMenuFrame.new( f5_local1, controller )
	MenuFrame:setLeftRight( true, true, 0, 0 )
	MenuFrame:setTopBottom( true, true, -2, -2 )
	MenuFrame.titleLabel:setText( Engine.Localize( "MPUI_MAPS_CAPS" ) )
	MenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText( Engine.Localize( "MPUI_MAPS_CAPS" ) )
	MenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon.FeatureIcon:setImage( RegisterImage( "uie_t7_mp_icon_header_bubblebuffs" ) )
	self:addElement( MenuFrame )
	self.MenuFrame = MenuFrame
	
	local ZMMissionTile = CoD.ZMMissionTile.new( f5_local1, controller )
	ZMMissionTile:setLeftRight( true, false, 463.38, 757.34 )
	ZMMissionTile:setTopBottom( true, false, 405, 444 )
	self:addElement( ZMMissionTile )
	self.ZMMissionTile = ZMMissionTile
	
	local FETitleLineL = CoD.FE_TitleLine.new( f5_local1, controller )
	FETitleLineL:setLeftRight( true, true, 450.38, -64 )
	FETitleLineL:setTopBottom( false, false, 90.77, 96 )
	self:addElement( FETitleLineL )
	self.FETitleLineL = FETitleLineL
	
	local DLCFreeweekend = CoD.DLC_Free_weekend.new( f5_local1, controller )
	DLCFreeweekend:setLeftRight( true, false, 74, 447.87 )
	DLCFreeweekend:setTopBottom( true, false, 494, 660 )
	DLCFreeweekend.DLCFreeTitleAndText.Title:setText( Engine.Localize( "MENU_DLC1_TRY_AWAKENING_FREE" ) )
	DLCFreeweekend.DLCFreeTitleAndText.Body:setText( Engine.Localize( "MENU_DLC1_ZM_TRY_AWAKENING_FREE_DESC" ) )
	DLCFreeweekend:mergeStateConditions( {
		{
			stateName = "Visible",
			condition = function ( menu, element, event )
				local f14_local0 = IsDvarValueEqualTo( "ui_freeDLC1", "1" )
				if f14_local0 then
					f14_local0 = ShouldShowDLCWidget( controller, "mp_rise" )
					if f14_local0 then
						f14_local0 = IsPerControllerTablePropertyValue( controller, "choosingZMPlaylist", true )
					end
				end
				return f14_local0
			end
		}
	} )
	self:addElement( DLCFreeweekend )
	self.DLCFreeweekend = DLCFreeweekend
	
	local FEMenuLeftGraphics = CoD.FE_Menu_LeftGraphics.new( f5_local1, controller )
	FEMenuLeftGraphics:setLeftRight( true, false, 19, 71 )
	FEMenuLeftGraphics:setTopBottom( true, false, 86, 703.25 )
	self:addElement( FEMenuLeftGraphics )
	self.FEMenuLeftGraphics = FEMenuLeftGraphics
	
	local FETitleLineL0 = CoD.FE_TitleLine.new( f5_local1, controller )
	FETitleLineL0:setLeftRight( true, true, 450.38, -64 )
	FETitleLineL0:setTopBottom( false, false, 141.77, 147 )
	FETitleLineL0.Image0:setAlpha( 0 )
	FETitleLineL0.Image1:setAlpha( 0 )
	FETitleLineL0.Image2:setAlpha( 0 )
	self:addElement( FETitleLineL0 )
	self.FETitleLineL0 = FETitleLineL0
	
	local FETitleLineL00 = CoD.FE_TitleLine.new( f5_local1, controller )
	FETitleLineL00:setLeftRight( true, true, 450.38, -64 )
	FETitleLineL00:setTopBottom( false, false, 134.77, 140 )
	FETitleLineL00.Image0:setAlpha( 0 )
	FETitleLineL00.Image1:setAlpha( 0 )
	FETitleLineL00.Image2:setAlpha( 0 )
	self:addElement( FETitleLineL00 )
	self.FETitleLineL00 = FETitleLineL00
	
	local FETitleLineL1 = CoD.FE_TitleLine.new( f5_local1, controller )
	FETitleLineL1:setLeftRight( true, true, 450.38, -64 )
	FETitleLineL1:setTopBottom( false, false, -231.23, -226 )
	self:addElement( FETitleLineL1 )
	self.FETitleLineL1 = FETitleLineL1
	
	local ZMLobbyEEList = LUI.UIList.new( f5_local1, controller, -8, 0, nil, false, false, 0, 0, false, false )
	ZMLobbyEEList:makeFocusable()
	ZMLobbyEEList:setLeftRight( false, true, -331.49, -63.49 )
	ZMLobbyEEList:setTopBottom( false, true, -324, -264 )
	ZMLobbyEEList:setAlpha( 0.9 )
	ZMLobbyEEList:setWidgetType( CoD.ZMLobbyEEWidget )
	ZMLobbyEEList:setHorizontalCount( 5 )
	ZMLobbyEEList:setSpacing( -8 )
	ZMLobbyEEList:setDataSource( "ZMLobbyEEMapSelect" )
	self:addElement( ZMLobbyEEList )
	self.ZMLobbyEEList = ZMLobbyEEList
	
	local StreamedImagePreloader = LUI.UIImage.new()
	StreamedImagePreloader:setLeftRight( true, false, 1280, 1408 )
	StreamedImagePreloader:setTopBottom( true, false, 351.75, 479.75 )
	StreamedImagePreloader:setAlpha( 0 )
	StreamedImagePreloader:setupUIStreamedImage( 0 )
	self:addElement( StreamedImagePreloader )
	self.StreamedImagePreloader = StreamedImagePreloader
	
	MapPreview:linkToElementModel( MapList, "Image", true, function ( model )
		local Image = Engine.GetModelValue( model )
		if Image then
			MapPreview:setImage( RegisterImage( MapImageToModPreview( Image ) ) )
		end
	end )
	MissionBriefText:linkToElementModel( MapList, "mapDescription", true, function ( model )
		local mapDescription = Engine.GetModelValue( model )
		if mapDescription then
			MissionBriefText.textBox:setText( Engine.Localize( mapDescription ) )
		end
	end )
	PlayCount:linkToElementModel( MapList, "playingCount", true, function ( model )
		local playingCount = Engine.GetModelValue( model )
		if playingCount then
			PlayCount:setText( Engine.Localize( playingCount ) )
		end
	end )
	ZMMissionTile:linkToElementModel( MapList, "mapName", true, function ( model )
		local mapName = Engine.GetModelValue( model )
		if mapName then
			ZMMissionTile.MapName:setText( Engine.Localize( mapName ) )
		end
	end )
	MapList.navigation = {
		right = ZMLobbyEEList
	}
	ZMLobbyEEList.navigation = {
		left = MapList
	}
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				Banner:completeAnimation()
				self.Banner:setAlpha( 0.65 )
				self.clipFinished( Banner, {} )
				PlayCount:completeAnimation()
				self.PlayCount:setAlpha( 1 )
				self.clipFinished( PlayCount, {} )
			end
		},
		Playlists = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				Banner:completeAnimation()
				self.Banner:setAlpha( 0.65 )
				self.clipFinished( Banner, {} )
				PlayCount:completeAnimation()
				self.PlayCount:setAlpha( 1 )
				self.clipFinished( PlayCount, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "Playlists",
			condition = function ( menu, element, event )
				return IsPerControllerTablePropertyValue( controller, "choosingZMPlaylist", true )
			end
		}
	} )
	CoD.Menu.AddNavigationHandler( f5_local1, self, controller )
	f5_local1:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( f22_arg0, f22_arg1, f22_arg2, f22_arg3 )
		GoBack( self, f22_arg2 )
		return true
	end, function ( f23_arg0, f23_arg1, f23_arg2 )
		CoD.Menu.SetButtonLabel( f23_arg1, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK" )
		return true
	end, false )
	MapList.id = "MapList"
	MenuFrame:setModel( self.buttonModel, controller )
	ZMLobbyEEList.id = "ZMLobbyEEList"
	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )
	self:processEvent( {
		name = "update_state",
		menu = f5_local1
	} )
	if not self:restoreState() then
		self.MapList:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.MapList:close()
		element.MissionBriefText:close()
		element.MenuFrame:close()
		element.ZMMissionTile:close()
		element.FETitleLineL:close()
		element.DLCFreeweekend:close()
		element.FEMenuLeftGraphics:close()
		element.FETitleLineL0:close()
		element.FETitleLineL00:close()
		element.FETitleLineL1:close()
		element.ZMLobbyEEList:close()
		element.MapPreview:close()
		element.PlayCount:close()
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "ZMMapSelection.buttonPrompts" ) )
	end )
	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end

