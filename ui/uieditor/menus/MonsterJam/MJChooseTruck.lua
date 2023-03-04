require( "ui.uieditor.widgets.BubbleGumBuffs.BubbleGumBuffGumShadow" )
require( "ui.uieditor.widgets.Lobby.Common.FE_ButtonPanelShaderContainer" )
require( "ui.uieditor.widgets.MenuSpecificWidgets.Scorestreaks.scorestreakVignetteContainer" )
require( "ui.uieditor.widgets.BackgroundFrames.GenericMenuFrame" )
require( "ui.uieditor.widgets.BubbleGumBuffs.BubblegumBuffSelectFootnote" )
require( "ui.uieditor.widgets.BubbleGumBuffs.BubbleGumGridItemButton" )
require( "ui.uieditor.widgets.Scrollbars.verticalCounter" )
require( "ui.uieditor.widgets.Scorestreaks.scorestreaks_TitleBox" )
require( "ui.uieditor.widgets.Lobby.Common.FE_TabBar" )
require( "ui.uieditor.widgets.TabbedWidgets.WeaponGroupsTabWidget" )
require( "ui.uieditor.widgets.PC.Utility.XCamMouseControl" )
require( "ui.uieditor.widgets.Prestige.Prestige_PermanentUnlockTokensWidget" )
require( "ui.uieditor.widgets.CAC.cac_lock" )

require( "ui.uieditor.widgets.MonsterJam.MonsterJamTruckSelectionButton" )

DataSources.TruckTabType = ListHelper_SetupDataSource( "TruckTabType", function ( f245_arg0 )
	local f245_local0 = {}
	table.insert( f245_local0, {
		models = {
			tabIcon = CoD.buttonStrings.shoulderl
		},
		properties = {
			m_mouseDisabled = true
		}
	} )
	table.insert( f245_local0, {
		models = {
			tabName = Engine.Localize( "UI_MENU_TRUCK_CATEGORY_STOCK" ),
			breadcrumbCount = Engine.WeaponGroupNewItemCount( f245_arg0, "primary", "", Enum.eModes.MODE_CAMPAIGN )
		},
		properties = {
			filter = "primary"
		}
	} )
	--[[
	if IsProgressionEnabled( f245_arg0 ) and not IsInPermanentUnlockMenu( f245_arg0 ) then
		table.insert( f245_local0, {
			models = {
				tabName = Engine.Localize( "UI_MENU_TRUCK_CATEGORY_CUSTOM" ),
				breadcrumbCount = Engine.WeaponGroupNewItemCount( f245_arg0, "secondary", "", Enum.eModes.MODE_CAMPAIGN )
			},
			properties = {
				filter = "secondary"
			}
		} )
	end
	]]
	table.insert( f245_local0, {
		models = {
			tabIcon = CoD.buttonStrings.shoulderr
		},
		properties = {
			m_mouseDisabled = true
		}
	} )
	return f245_local0
end, true )

local function TruckSelectTabChanged( self, element, controller )
	local itemGroup = element.filter
	CoD.perController[controller].weaponCategory = itemGroup
	DataSources.Unlockables.setCurrentFilterItem( itemGroup )
	self.selectionList:updateDataSource()
end

local function SelectTruck( self, element, menu, controller )
	DisableNavigation( self, "selectionList" )

	if self.doingTruckIntro == false then
		self.doingTruckIntro = true
	else
		ClearMenuSavedState( menu )
		SendClientScriptMenuChangeNotify( controller, menu, false )
		GoBack( self, controller )
		Engine.SendClientScriptNotify( controller, "CustomClass_truckExit" .. CoD.GetLocalClientAdjustedNum( controller ) )
		return
	end

	Engine.SendClientScriptNotify( controller, "CustomClass_truckChoosen" .. CoD.GetLocalClientAdjustedNum( controller ) )

	local itemIndexModel = element:getModel( controller, "itemIndex" )
	local itemIndex = 0
	if itemIndexModel then
		itemIndex = Engine.GetModelValue( itemIndexModel )
	end

	self:playSound( "truckselect" .. itemIndex, controller )

	Engine.SetClassItem( controller, 1, "primary", itemIndex )
	Engine.Exec( controller, "saveLoadout" )

	menu._timer = LUI.UITimer.new(4500, "showFullTruckSelection", true)
	menu:addElement(menu._timer)

	menu:registerEventHandler("showFullTruckSelection", function(element, event)
		ClearMenuSavedState( menu )
		SendClientScriptMenuChangeNotify( controller, menu, false )
		GoBack( self, controller )
		Engine.SendClientScriptNotify( controller, "CustomClass_truckExit" .. CoD.GetLocalClientAdjustedNum( controller ) )
	end )
end

local function GetTruckLogo( index )
	local logoImage = Engine.TableLookup( nil, "gamedata/tables/common/truck_data.csv", 4, index, 2 )
	if logoImage then
		return logoImage
	end
	return "ui_mj_graphics_logo_locked"
end

local function ChangeTruckLogo( self, element, controller )
	local isItemNotLocked = not IsCACItemLocked( self, element, controller )
	local f505_local3 = element:getModel( controller, "itemIndex" )
	if f505_local3 then
		local f505_local4 = Engine.GetModelValue( f505_local3 )
		if isItemNotLocked then
			self.LockedBg:setAlpha( 0.0 )
			self.LockedText:setText( "" )
			self.TruckLogo:setImage( RegisterImage( GetTruckLogo( f505_local4 ) ) )
		else
			self.LockedBg:setAlpha( 0.4 )
			self.LockedText:setText( Engine.Localize( "UI_MENU_HTU_TRUCK_INDEX_" .. f505_local4 ) )
			self.TruckLogo:setImage( RegisterImage( "ui_mj_graphics_logo_locked" ) )
		end
	end
end

if not SoundSet.ChooseTruck then
	-- putting this here because we can't creeate this on the fly
	SoundSet.ChooseTruck = {
		list_up = "uin_truck_selection_scroll",
		list_down = "uin_truck_selection_scroll",
		list_left = "uin_truck_selection_scroll",
		list_right = "uin_truck_selection_scroll",
		list_action = "uin_paint_decal_select",
		tab_changed = "uin_paint_decal_cat_nav",
		menu_go_back = "uin_back",
		menu_enter = "cac_open_wpn_cust_sub",
		item_select = "cac_equipment_add_equipment",
		item_locked = "cac_cmn_deny",
		gain_focus = "cac_grid_nav",
		menu_open = "cac_grid_equip_item",
		action = "cac_grid_equip_item",
		menu_no_selection = "cac_cmn_backout",

		-- truck selections
		truckselect1 = "vox_sd_truck_select_gravedigger",
		truckselect2 = "vox_sd_truck_select_monstertmutt",
		truckselect3 = "vox_sd_truck_select_bountyhunter",
		truckselect4 = "vox_sd_truck_select_bulldozer",
		truckselect5 = "vox_sd_truck_select_bluethunder",
		truckselect6 = "vox_sd_truck_select_kingkrunch",
		truckselect7 = "vox_sd_truck_select_destroyer",
		truckselect8 = "vox_sd_truck_select_blacksmith",
		truckselect9 = "vox_sd_truck_select_eltoro",
		truckselect10 = "vox_sd_truck_select_suzuki",
		truckselect11 = "vox_sd_truck_select_predator",
		truckselect12 = "vox_sd_truck_select_maxd",
		truckselect13 = "vox_sd_truck_select_scarletbandit",
		truckselect14 = "vox_sd_truck_select_curse",
		truckselect15 = "vox_sd_truck_select_avenger",
		truckselect16 = "vox_sd_truck_select_pastrana",
		truckselect17 = "vox_sd_truck_select_ironoutlaw",
		truckselect18 = "vox_sd_truck_select_brutus",
		truckselect19 = "vox_sd_truck_select_monstertmutt",
		truckselect20 = "vox_sd_truck_select_gravedigger",
		truckselect21 = "vox_sd_truck_select_stone",
		truckselect22 = "vox_sd_truck_select_spike",
		truckselect23 = "vox_sd_truck_select_ironoutlaw",
		truckselect24 = "vox_sd_truck_select_war",
		truckselect25 = "vox_sd_truck_select_spitfire",
		truckselect26 = "vox_sd_truck_select_jurassic",
		truckselect27 = "vox_sd_truck_select_stallion",
		truckselect28 = "vox_sd_truck_select_devastator",
		truckselect29 = "vox_sd_truck_select_backwards",
		truckselect30 = "vox_sd_truck_select_airforce",
		truckselect31 = "vox_sd_truck_select_original"
	}
end

local PreLoadFunc = function ( self, controller )
	--CoD.perController[controller].everythingUnlocked = true
	CoD.perController[controller].weaponCategory = "primary"
	DataSources.Unlockables.setCurrentFilterItem( "primary" )
	self.restoreState = function ( element )
		local f2_local0 = Engine.GetBubbleGumBuff( controller, Engine.GetEquippedBubbleGumPack( controller ), CoD.perController[controller].bgbIndex )
		element.TabList.Tabs.grid:findItem( nil, {
			filter = Engine.GetItemGroup( f2_local0 )
		}, true, nil )
		element.selectionList:findItem( {
			itemIndex = f2_local0
		}, nil, true, nil )
	end
	local truckIndex = CoD.GetClassItem( controller, 1, "primary" )
	if not truckIndex then
		Engine.SetClassItem( controller, 1, "primary", 1 )
	end
end

local PostLoadFunc = function ( self, controller )
	self.weaponCategoryList = self.TabList
	local UpdateOnStoreCloseModel = Engine.CreateModel( Engine.GetGlobalModel(), "UpdateOnStoreClose" )
	self:subscribeToModel( UpdateOnStoreCloseModel, function ( model )
		if Engine.GetModelValue( model ) == 0 then
			return 
		else
			CoD.UnlockablesTable = CoD.GetUnlockablesTable( controller, nil, Enum.eModes.MODE_CAMPAIGN )
			self.selectionList:updateDataSource()
			self.TabList.Tabs.grid:updateDataSource()
			Engine.SetModelValue( model, 0 )
		end
	end, false )
	LUI.OverrideFunction_CallOriginalFirst( self, "close", function ( element )
		Engine.UnsubscribeAndFreeModel( UpdateOnStoreCloseModel )
		if self._timer then
			self._timer:close()
		end
	end )
end

LUI.createMenu.MJChooseTruck = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "MJChooseTruck" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self.soundSet = "ChooseTruck"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "MJChooseTruck.buttonPrompts" )
	local menu = self
	self.anyChildUsesUpdateState = true

	-- init the host player's info for this splitscreen player.
	--if IsPlayerAGuest( controller ) then
		InitUnlockInfo( nil, controller )
	--end

	self.doingTruckIntro = false
	
	local LeftPanel = CoD.FE_ButtonPanelShaderContainer.new( menu, controller )
	LeftPanel:setLeftRight( true, false, 64, 658 )
	LeftPanel:setTopBottom( true, false, 84, 738 )
	LeftPanel:setRGB( 0.5, 0.5, 0.5 )
	self:addElement( LeftPanel )
	self.LeftPanel = LeftPanel
	
	local scorestreakVignetteContainer = CoD.scorestreakVignetteContainer.new( menu, controller )
	scorestreakVignetteContainer:setLeftRight( true, false, 0, 1280 )
	scorestreakVignetteContainer:setTopBottom( true, false, 0, 720 )
	self:addElement( scorestreakVignetteContainer )
	self.scorestreakVignetteContainer = scorestreakVignetteContainer
	
	local BannerTab = LUI.UIImage.new()
	BannerTab:setLeftRight( true, true, 0, 0 )
	BannerTab:setTopBottom( false, false, -275, -237 )
	BannerTab:setRGB( 0, 0, 0 )
	self:addElement( BannerTab )
	self.BannerTab = BannerTab
	
	local GenericMenuFrame0 = CoD.GenericMenuFrame.new( menu, controller )
	GenericMenuFrame0:setLeftRight( true, true, 0, 0 )
	GenericMenuFrame0:setTopBottom( true, true, 0, 0 )
	GenericMenuFrame0.titleLabel:setText( Engine.Localize( "UI_MENU_TRUCKSELECT" ) )
	GenericMenuFrame0.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText( Engine.Localize( "UI_MENU_TRUCKSELECT" ) )
	GenericMenuFrame0.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon.FeatureIcon:setImage( RegisterImage( "uie_t7_mp_icon_header_truck" ) )
	self:addElement( GenericMenuFrame0 )
	self.GenericMenuFrame0 = GenericMenuFrame0
	
	local BubblegumBuffSelectFootnote = CoD.BubblegumBuffSelectFootnote.new( menu, controller )
	BubblegumBuffSelectFootnote:setLeftRight( false, false, 60, 524 )
	BubblegumBuffSelectFootnote:setTopBottom( false, true, -170, -74 )
	BubblegumBuffSelectFootnote:mergeStateConditions( {
		{
			stateName = "RequiresDLC",
			condition = function ( menu, element, event )
				return IsCACItemFromDLC( menu, element, controller ) and IsBGBItemLocked( menu, element, controller )
			end
		}
	} )
	BubblegumBuffSelectFootnote:linkToElementModel( BubblegumBuffSelectFootnote, "itemIndex", true, function ( model )
		menu:updateElementState( BubblegumBuffSelectFootnote, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "itemIndex"
		} )
	end )
	self:addElement( BubblegumBuffSelectFootnote )
	self.BubblegumBuffSelectFootnote = BubblegumBuffSelectFootnote

	local LockedBg = LUI.UIImage.new()
	LockedBg:setLeftRight( false, false, 92.5, 578 )
	LockedBg:setTopBottom( false, false, -175, 254.5 )
	LockedBg:setImage( RegisterImage( "black" ) )
	LockedBg:setAlpha( 0.0 )
	self:addElement( LockedBg )
	self.LockedBg = LockedBg

	local LockedText = LUI.UIText.new()
	LockedText:setLeftRight( false, false, 110.5, 549.5 )
	LockedText:setTopBottom( false, false, -92.5, -31.5 )
	LockedText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	LockedText:setText( "" )
	self:addElement( LockedText )
	self.LockedText = LockedText

	local TruckLogo = LUI.UIImage.new()
	TruckLogo:setLeftRight( false, true, -410, 0 )
	TruckLogo:setTopBottom( false, true, -166, 0 )
	TruckLogo:setImage( RegisterImage( "ui_mj_graphics_logo_locked" ) )
	self:addElement( TruckLogo )
	self.TruckLogo = TruckLogo
	
	local selectionList = LUI.UIList.new( menu, controller, 7, 0, nil, true, false, 0, 0, false, false )
	selectionList:makeFocusable()
	selectionList:setLeftRight( true, false, 77, 645 )
	selectionList:setTopBottom( true, false, 152, 605 )
	selectionList:setWidgetType( CoD.MonsterJamTruckSelectionButton )
	selectionList:setHorizontalCount( 5 )
	selectionList:setVerticalCount( 4 )
	selectionList:setSpacing( 7 )
	selectionList:setVerticalCounter( CoD.verticalCounter )
	selectionList:setDataSource( "Unlockables" )
	selectionList:linkToElementModel( selectionList, "itemIndex", true, function ( model )
		local f12_local0 = selectionList
		local f12_local1 = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "itemIndex"
		}
		CoD.Menu.UpdateButtonShownState( f12_local0, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
	end )
	selectionList:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNetworkMode" ), function ( model )
		local f13_local0 = selectionList
		local f13_local1 = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.lobbyNetworkMode"
		}
		CoD.Menu.UpdateButtonShownState( f13_local0, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
	end )
	selectionList:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNav" ), function ( model )
		local f14_local0 = selectionList
		local f14_local1 = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.lobbyNav"
		}
		CoD.Menu.UpdateButtonShownState( f14_local0, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
	end )
	selectionList:registerEventHandler( "list_item_gain_focus", function ( element, event )
		local retVal = nil
		if IsCACItemNew( element, controller ) and not IsBGBItemLocked( menu, element, controller ) then
			SetCACWeaponAsOld( self, element, controller )
			UpdateSelfElementState( menu, element, controller )
			FocusWeapon( self, element, controller )
			ChangeTruckLogo( self, element, controller )
		else
			FocusWeapon( self, element, controller )
			ChangeTruckLogo( self, element, controller )
		end
		return retVal
	end )
	selectionList:registerEventHandler( "gain_focus", function ( element, event )
		local f17_local0 = nil
		if element.gainFocus then
			f17_local0 = element:gainFocus( event )
		elseif element.super.gainFocus then
			f17_local0 = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return f17_local0
	end )
	selectionList:registerEventHandler( "lose_focus", function ( element, event )
		local f18_local0 = nil
		if element.loseFocus then
			f18_local0 = element:loseFocus( event )
		elseif element.super.loseFocus then
			f18_local0 = element.super:loseFocus( event )
		end
		return f18_local0
	end )
	menu:AddButtonCallbackFunction( selectionList, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( f19_arg0, f19_arg1, f19_arg2, f19_arg3 )
		if IsCACItemLocked( f19_arg1, f19_arg0, f19_arg2 ) then
			self:playSound( "item_locked", controller )
			return false
		else
			SelectTruck( self, f19_arg0, f19_arg1 ,f19_arg2 )
			
			return true
		end
	end, function ( f20_arg0, f20_arg1, f20_arg2 )
		CoD.Menu.SetButtonLabel( f20_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		return true
	end, true )
	self:addElement( selectionList )
	self.selectionList = selectionList
	
	local TabList = CoD.FE_TabBar.new( menu, controller )
	TabList:setLeftRight( true, false, 0, 2496 )
	TabList:setTopBottom( true, false, 84, 123 )
	TabList.Tabs.grid:setWidgetType( CoD.WeaponGroupsTabWidget )
	TabList.Tabs.grid:setDataSource( "TruckTabType" )
	TabList:registerEventHandler( "list_active_changed", function ( element, event )
		local f23_local0 = nil
	 	TruckSelectTabChanged( self, element, controller )
		return f23_local0
	end )
	self:addElement( TabList )
	self.TabList = TabList
	
	local LineSide0 = LUI.UIImage.new()
	LineSide0:setLeftRight( true, false, 51, 53 )
	LineSide0:setTopBottom( true, false, 76, 675 )
	LineSide0:setImage( RegisterImage( "uie_t7_menu_frontend_lineside" ) )
	LineSide0:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( LineSide0 )
	self.LineSide0 = LineSide0
	
	local LineDot = LUI.UIImage.new()
	LineDot:setLeftRight( true, false, 30, 58 )
	LineDot:setTopBottom( true, false, 607, 611 )
	LineDot:setImage( RegisterImage( "uie_t7_menu_frontend_pixelframe" ) )
	LineDot:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( LineDot )
	self.LineDot = LineDot
	
	local LineDot0 = LUI.UIImage.new()
	LineDot0:setLeftRight( true, false, 30, 58 )
	LineDot0:setTopBottom( true, false, 147, 151 )
	LineDot0:setImage( RegisterImage( "uie_t7_menu_frontend_pixelframe" ) )
	LineDot0:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( LineDot0 )
	self.LineDot0 = LineDot0
	
	local XCamMouseControl = CoD.XCamMouseControl.new( menu, controller )
	XCamMouseControl:setLeftRight( false, true, -470.5, -64 )
	XCamMouseControl:setTopBottom( true, true, 259, -180 )
	self:addElement( XCamMouseControl )
	self.XCamMouseControl = XCamMouseControl
	
	local PermanentUnlockTokensWidget = CoD.Prestige_PermanentUnlockTokensWidget.new( menu, controller )
	PermanentUnlockTokensWidget:setLeftRight( false, true, -362, -81 )
	PermanentUnlockTokensWidget:setTopBottom( true, false, 39, 84 )
	PermanentUnlockTokensWidget:setAlpha( ShowIfInPermanentUnlockMenu( 0 ) )
	PermanentUnlockTokensWidget.tokenLabel:setTTF( "fonts/escom.ttf" )
	self:addElement( PermanentUnlockTokensWidget )
	self.PermanentUnlockTokensWidget = PermanentUnlockTokensWidget
	
	BubblegumBuffSelectFootnote:linkToElementModel( selectionList, nil, false, function ( model )
		BubblegumBuffSelectFootnote:setModel( model, controller )
	end )
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end
		}
	}
	self:registerEventHandler( "menu_opened", function ( element, event )
		local f33_local0 = nil
		SendClientScriptMenuChangeNotify( controller, menu, true )
		SetGlobalModelValueTrue( "inTruckSelectionMenu" )
		if not f33_local0 then
			f33_local0 = element:dispatchEventToChildren( event )
		end
		return f33_local0
	end )
	self:registerEventHandler( "menu_loaded", function ( element, event )
		local f34_local0 = nil
		if IsInPermanentUnlockMenu( controller ) then
			ShowHeaderKickerAndIcon( menu )
			SendClientScriptMenuChangeNotify( controller, menu, true )
			SetElementStateByElementName( self, "GenericMenuFrame0", controller, "Update" )
			PlayClipOnElement( self, {
				elementName = "GenericMenuFrame0",
				clipName = "intro"
			}, controller )
			PlayClip( self, "into", controller )
		else
			ShowHeaderIconOnly( menu )
			SendClientScriptMenuChangeNotify( controller, menu, true )
			SetElementStateByElementName( self, "GenericMenuFrame0", controller, "Update" )
			PlayClipOnElement( self, {
				elementName = "GenericMenuFrame0",
				clipName = "intro"
			}, controller )
			PlayClip( self, "into", controller )
		end
		if not f34_local0 then
			f34_local0 = element:dispatchEventToChildren( event )
		end
		return f34_local0
	end )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( f36_arg0, f36_arg1, f36_arg2, f36_arg3 )
		GoBack( self, f36_arg2 )
		SendClientScriptMenuChangeNotify( f36_arg2, f36_arg1, false )
		return true
	end, function ( f37_arg0, f37_arg1, f37_arg2 )
		CoD.Menu.SetButtonLabel( f37_arg1, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK" )
		return true
	end, true )
	menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_RSTICK_PRESSED, nil, function ( f38_arg0, f38_arg1, f38_arg2, f38_arg3 )
		if CACShowRotatePrompt( self, f38_arg0, f38_arg2 ) then
			return true
		else
			
		end
	end, function ( f39_arg0, f39_arg1, f39_arg2 )
		if CACShowRotatePrompt( self, f39_arg0, f39_arg2 ) then
			CoD.Menu.SetButtonLabel( f39_arg1, Enum.LUIButton.LUI_KEY_RSTICK_PRESSED, "PLATFORM_EMBLEM_ROTATE_LAYER" )
			return true
		else
			return false
		end
	end, false )
	LUI.OverrideFunction_CallOriginalFirst( self, "close", function ( element )
		SetGlobalModelValueFalse( "inTruckSelectionMenu" )
		if self._timer then
			self._timer:close()
		end
	end )
	GenericMenuFrame0:setModel( self.buttonModel, controller )
	selectionList.id = "selectionList"
	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )
	self:processEvent( {
		name = "update_state",
		menu = menu
	} )
	if not self:restoreState() then
		self.selectionList:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.LeftPanel:close()
		element.scorestreakVignetteContainer:close()
		element.GenericMenuFrame0:close()
		element.BubblegumBuffSelectFootnote:close()
		element.selectionList:close()
		element.TruckLogo:close()
		element.TabList:close()
		element.XCamMouseControl:close()
		element.PermanentUnlockTokensWidget:close()
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "MJChooseTruck.buttonPrompts" ) )
	end )
	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end

