require("ui.uieditor.widgets.Lobby.Common.FE_TabBar")
require( "ui.uieditor.widgets.Lobby.Common.FE_ButtonPanelShaderContainer" )
require( "ui.uieditor.widgets.MenuSpecificWidgets.Scorestreaks.scorestreakVignetteContainer" )
require("ui.uieditor.widgets.Lobby.Common.FE_Menu_LeftGraphics")
require("ui.uieditor.widgets.Scrollbars.verticalCounter")
require("ui.uieditor.widgets.CharacterCustomization.list1ButtonNewStyle")
require("ui.uieditor.widgets.BackgroundFrames.GenericMenuFrame")
require("ui.uieditor.widgets.Lobby.Common.FE_TitleLineSingle")
require( "ui.uieditor.widgets.Controls.Slider_Small" )

DataSources.MJStats = ListHelper_SetupDataSource( "MJStats", function ( controller, UIList )
	local function strTok( str_word, token )
		local index = 1
		local elements = {}
		for word in string.gmatch( str_word, '([^' .. token .. ']+)' ) do
			elements[ index ] = word
			index = index + 1
		end
		return elements
	end
	local stats = {}
	local unlockData = Engine.CreateModel( Engine.GetModelForController( controller ), "truck_unlocks_data" )
	if unlockData then
		local str = Engine.GetModelValue( unlockData )
		if str then
			local unlockArray = strTok( str, "," )
			for index = 51, #unlockArray, 1 do
				local value = unlockArray[ index ] or "0"
				table.insert( stats, {
					models = {
						displayText = Engine.Localize( "UI_MENU_STATS_" .. index, value )
					}
				} )
			end
		end
	end

	if not UIList.statsSubscription then
		UIList.statsSubscription = UIList:subscribeToModel( unlockData, function ()
			UIList:updateDataSource( true )
		end, false )
	end
	return stats
end )

LUI.createMenu.MJStats = function (controller)
	local self = CoD.Menu.NewForUIEditor("MJStats")
	if PreLoadCallback then
		PreLoadCallback(self, controller)
	end
	self.soundSet = "MultiplayerMain"
	self:setOwner(controller)

	self:setLeftRight(true, true, 0, 0)
	self:setTopBottom(true, true, 0, 0)
	self.buttonModel = Engine.CreateModel(Engine.GetModelForController(controller), "MJStats.buttonPrompts")
	local menu = self
	self.anyChildUsesUpdateState = true

	self:playSound("menu_open", controller)

	-- init the host player's info for this splitscreen player.
	--if IsPlayerAGuest( controller ) then
		InitUnlockInfo( nil, controller )
	--end

	local BlackBG = LUI.UIImage.new()
	BlackBG:setLeftRight(true, true, 0, 0)
	BlackBG:setTopBottom(true, true, 0, 0)
	BlackBG:setImage(RegisterImage("black"))
	BlackBG:setAlpha( 0.4 )
	self:addElement(BlackBG)
	self.BlackBG = BlackBG

	local LeftPanel = CoD.FE_ButtonPanelShaderContainer.new( menu, controller )
	LeftPanel:setLeftRight( true, true, 0, 0 )
	LeftPanel:setTopBottom( true, true, 0, 0 )
	LeftPanel:setRGB( 0.5, 0.5, 0.5 )
	self:addElement( LeftPanel )
	self.LeftPanel = LeftPanel
	
	local scorestreakVignetteContainer = CoD.scorestreakVignetteContainer.new( menu, controller )
	scorestreakVignetteContainer:setLeftRight( true, false, 0, 1280 )
	scorestreakVignetteContainer:setTopBottom( true, false, 0, 720 )
	self:addElement( scorestreakVignetteContainer )
	self.scorestreakVignetteContainer = scorestreakVignetteContainer

	local GenericMenuFrame0 = CoD.GenericMenuFrame.new( menu, controller )
	GenericMenuFrame0:setLeftRight( true, true, 0, 0 )
	GenericMenuFrame0:setTopBottom( true, true, 0, 0 )
	GenericMenuFrame0.titleLabel:setText( Engine.Localize( "MENU_STATS_CAPS" ) )
	GenericMenuFrame0.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText( Engine.Localize( "MENU_STATS_CAPS" ) )
	GenericMenuFrame0.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon.FeatureIcon:setImage( RegisterImage( "uie_t7_mp_icon_header_option" ) )
	self:addElement( GenericMenuFrame0 )
	self.GenericMenuFrame0 = GenericMenuFrame0

	local statList = LUI.UIList.new( menu, controller, 2, 0, nil, false, false, 0, 0, false, false )
	statList:makeFocusable()
	statList:setLeftRight( true, false, 64, 344 )
	statList:setTopBottom( true, false, 134, 540 )
	statList:setWidgetType( CoD.list1ButtonNewStyle )
	statList:setVerticalCount( 12 )
	statList:setVerticalCounter( CoD.verticalCounter )
	statList:setVerticalScrollbar( CoD.verticalScrollbar )
	statList:setDataSource( "MJStats" )
	statList:registerEventHandler( "gain_focus", function ( element, event )
		local f2_local0 = nil
		if element.gainFocus then
			f2_local0 = element:gainFocus( event )
		elseif element.super.gainFocus then
			f2_local0 = element.super:gainFocus( event )
		end
		return f2_local0
	end )
	statList:registerEventHandler( "lose_focus", function ( element, event )
		local f3_local0 = nil
		if element.loseFocus then
			f3_local0 = element:loseFocus( event )
		elseif element.super.loseFocus then
			f3_local0 = element.super:loseFocus( event )
		end
		return f3_local0
	end )

	self:addElement( statList )
	self.statList = statList

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end
		}
	}

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
	GenericMenuFrame0:setModel( self.buttonModel, controller )
	statList.id = "statList"
	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )
	self:processEvent( {
		name = "update_state",
		menu = menu
	} )
	if not self:restoreState() then
		self.statList:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end

	LUI.OverrideFunction_CallOriginalSecond(self, "close", function (element)
		element.GenericMenuFrame0:close()
		Engine.UnsubscribeAndFreeModel(Engine.GetModel(Engine.GetModelForController(controller), "MJStats.buttonPrompts"))
	end)
	if PostLoadFunc then
		PostLoadFunc(self, controller)
	end
	return self
end
