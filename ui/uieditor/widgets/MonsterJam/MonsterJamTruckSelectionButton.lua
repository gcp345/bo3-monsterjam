require( "ui.uieditor.widgets.CAC.GridItemButtonNew" )
require( "ui.uieditor.widgets.CAC.DLCLabel" )
require( "ui.uieditor.widgets.BubbleGumBuffs.BubbleGumDLCTextPopup" )
require( "ui.uieditor.widgets.CAC.MenuChooseClass.ItemWidgets.HintTextArrow" )

function IsTruckEquiped( f189_arg0, f189_arg1, f189_arg2 )
	local truckSelectionIndex = CoD.GetClassItem( f189_arg2, 1, "primary" )
	local f189_local0 = CoD.perController[f189_arg2].weaponCategory
	if LuaUtils.FindItemInArray( CoD.CACUtility.BGBBuffGroups, f189_local0 ) then
		return IsBubbleGumBuffEquipped( f189_arg0, f189_arg1, f189_arg2 )
	end
	local f189_local1 = CoD.CACUtility.GetSlotListWithSlot( f189_local0 )
	local f189_local2 = f189_arg1:getModel()
	if f189_local2 then
		local f189_local3 = Engine.GetModel( f189_local2, "itemIndex" )
		local f189_local4 = Engine.GetModel( f189_local2, "upgradeItemIndex" )
		local f189_local5 = f189_local3
		if f189_local4 and IsCACItemUpgraded( f189_arg0, f189_arg1, f189_arg2 ) then
			f189_local5 = f189_local4
		end
		if f189_local5 then
			local f189_local6 = Engine.GetModelValue( f189_local5 )
			--[[for f189_local10, f189_local11 in ipairs( f189_local1 ) do
				if CoD.CACUtility.GetItemEquippedInSlot( f189_local11, f189_arg2 ) == f189_local6 then
					return true
				end
			end]]
			if f189_local6 == truckSelectionIndex then
				return true
			end
		end
	end
	return false
end

CoD.MonsterJamTruckSelectionButton = InheritFrom( LUI.UIElement )
CoD.MonsterJamTruckSelectionButton.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self:setUseStencil( false )
	self:setClass( CoD.MonsterJamTruckSelectionButton )
	self.id = "MonsterJamTruckSelectionButton"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 108 )
	self:setTopBottom( true, false, 0, 108 )
	self:makeFocusable()
	self:setHandleMouse( true )
	self.anyChildUsesUpdateState = true
	
	local GridItemButtonNew = CoD.GridItemButtonNew.new( menu, controller )
	GridItemButtonNew:setLeftRight( true, true, 0, 0 )
	GridItemButtonNew:setTopBottom( true, true, 0, 0 )
	GridItemButtonNew.BoxButtonLrgInactiveDiag.Image:setImage( RegisterImage( "blacktransparent" ) )
	GridItemButtonNew.equippedIcon:setTopBottom( false, true, -16, -2 )
	GridItemButtonNew.lockedIcon:setLeftRight( true, true, 0, 0 )
	GridItemButtonNew.lockedIcon:setTopBottom( true, true, 0, 0 )
	GridItemButtonNew.lockedIcon.lockedIcon0:setImage( RegisterImage( "ui_mj_graphics_truck_locked" ) )
	GridItemButtonNew.lockedIcon.lockedIcon:setImage( RegisterImage( "ui_mj_graphics_truck_locked" ) )
	GridItemButtonNew:linkToElementModel( self, nil, false, function ( model )
		GridItemButtonNew:setModel( model, controller )
	end )
	GridItemButtonNew.LabelButton:mergeStateConditions( {
		{
			stateName = "Hidden",
			condition = function ( menu, element, event )
				return AlwaysTrue()
			end
		}
	} )
	GridItemButtonNew:mergeStateConditions( {
		{
			stateName = "Equipped",
			condition = function ( menu, element, event )
				return IsTruckEquiped( menu, element, controller ) and not IsInPermanentUnlockMenu( controller )
			end
		},
		{
			stateName = "New",
			condition = function ( menu, element, event )
				local f3_local0 = IsCACItemNew( element, controller )
				if f3_local0 then
					if not IsInPermanentUnlockMenu( controller ) then
						f3_local0 = not IsBGBItemLocked( menu, element, controller )
					else
						f3_local0 = false
					end
				end
				return f3_local0
			end
		},
		{
			stateName = "RequiresDLC",
			condition = function ( menu, element, event )
				local f4_local0 = IsCACItemFromDLC( menu, element, controller )
				if f4_local0 then
					f4_local0 = IsLive()
					if f4_local0 then
						f4_local0 = IsBGBItemLocked( menu, element, controller )
					end
				end
				return f4_local0
			end
		},
		{
			stateName = "Locked",
			condition = function ( menu, element, event )
				return IsBGBItemLocked( menu, element, controller )
			end
		}
	} )
	GridItemButtonNew:linkToElementModel( GridItemButtonNew, "itemIndex", true, function ( model )
		menu:updateElementState( GridItemButtonNew, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "itemIndex"
		} )
	end )
	GridItemButtonNew:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNetworkMode" ), function ( model )
		menu:updateElementState( GridItemButtonNew, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.lobbyNetworkMode"
		} )
	end )
	GridItemButtonNew:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNav" ), function ( model )
		menu:updateElementState( GridItemButtonNew, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.lobbyNav"
		} )
	end )
	self:addElement( GridItemButtonNew )
	self.GridItemButtonNew = GridItemButtonNew
	
	local DLCLabel0 = CoD.DLCLabel.new( menu, controller )
	DLCLabel0:setLeftRight( false, true, -51, 11 )
	DLCLabel0:setTopBottom( false, true, -51, 1 )
	DLCLabel0:linkToElementModel( self, nil, false, function ( model )
		DLCLabel0:setModel( model, controller )
	end )
	DLCLabel0:mergeStateConditions( {
		{
			stateName = "HasDLC",
			condition = function ( menu, element, event )
				return IsCACItemFromDLC( menu, element, controller ) and not IsBGBItemLocked( menu, element, controller )
			end
		}
	} )
	DLCLabel0:linkToElementModel( DLCLabel0, "itemIndex", true, function ( model )
		menu:updateElementState( DLCLabel0, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "itemIndex"
		} )
	end )
	self:addElement( DLCLabel0 )
	self.DLCLabel0 = DLCLabel0
	
	local BubbleGumDLCTextPopupMega = CoD.BubbleGumDLCTextPopup.new( menu, controller )
	BubbleGumDLCTextPopupMega:setLeftRight( true, false, 0, 300 )
	BubbleGumDLCTextPopupMega:setTopBottom( true, false, 128.29, 160.29 )
	self:addElement( BubbleGumDLCTextPopupMega )
	self.BubbleGumDLCTextPopupMega = BubbleGumDLCTextPopupMega
	
	local BubbleGumDLCTextPopupClassic = CoD.BubbleGumDLCTextPopup.new( menu, controller )
	BubbleGumDLCTextPopupClassic:setLeftRight( true, false, 0, 300 )
	BubbleGumDLCTextPopupClassic:setTopBottom( true, false, 128.29, 160.29 )
	BubbleGumDLCTextPopupClassic:setAlpha( 0 )
	self:addElement( BubbleGumDLCTextPopupClassic )
	self.BubbleGumDLCTextPopupClassic = BubbleGumDLCTextPopupClassic
	
	local HintTextArrow0 = CoD.HintTextArrow.new( menu, controller )
	HintTextArrow0:setLeftRight( false, false, -5, 5 )
	HintTextArrow0:setTopBottom( true, false, 115.39, 125.39 )
	HintTextArrow0:mergeStateConditions( {
		{
			stateName = "NoHintText",
			condition = function ( menu, element, event )
				return AlwaysFalse()
			end
		}
	} )
	self:addElement( HintTextArrow0 )
	self.HintTextArrow0 = HintTextArrow0
	
	self.BubbleGumDLCTextPopupMega:linkToElementModel( self, "dlcIndex", true, function ( model )
		local dlcIndex = Engine.GetModelValue( model )
		if dlcIndex then
			BubbleGumDLCTextPopupMega.textCenterAlign:setText( Engine.Localize( GetBGBDLCStringFromIndex( "ZMUI_BGB_PURCHASE_DLC", dlcIndex ) ) )
		end
	end )
	self.BubbleGumDLCTextPopupClassic:linkToElementModel( self, "dlcIndex", true, function ( model )
		local dlcIndex = Engine.GetModelValue( model )
		if dlcIndex then
			BubbleGumDLCTextPopupClassic.textCenterAlign:setText( Engine.Localize( GetBGBDLCStringFromIndex( "ZMUI_BGB_PURCHASE_DLC_CLASSIC", dlcIndex ) ) )
		end
	end )
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				BubbleGumDLCTextPopupMega:completeAnimation()
				self.BubbleGumDLCTextPopupMega:setAlpha( 0 )
				self.clipFinished( BubbleGumDLCTextPopupMega, {} )
				HintTextArrow0:completeAnimation()
				self.HintTextArrow0:setAlpha( 0 )
				self.clipFinished( HintTextArrow0, {} )
			end,
			GainFocus = function ()
				self:setupElementClipCounter( 0 )
			end,
			Focus = function ()
				self:setupElementClipCounter( 0 )
			end,
			LoseFocus = function ()
				self:setupElementClipCounter( 0 )
			end
		},
		CanBuyDLCMega = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				BubbleGumDLCTextPopupMega:completeAnimation()
				self.BubbleGumDLCTextPopupMega:setAlpha( 0 )
				self.clipFinished( BubbleGumDLCTextPopupMega, {} )
				HintTextArrow0:completeAnimation()
				self.HintTextArrow0:setAlpha( 0 )
				self.clipFinished( HintTextArrow0, {} )
			end,
			GainFocus = function ()
				self:setupElementClipCounter( 2 )
				local BubbleGumDLCTextPopupMegaFrame2 = function ( BubbleGumDLCTextPopupMega, event )
					if not event.interrupted then
						BubbleGumDLCTextPopupMega:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Linear )
					end
					BubbleGumDLCTextPopupMega:setAlpha( 1 )
					if event.interrupted then
						self.clipFinished( BubbleGumDLCTextPopupMega, event )
					else
						BubbleGumDLCTextPopupMega:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				BubbleGumDLCTextPopupMega:completeAnimation()
				self.BubbleGumDLCTextPopupMega:setAlpha( 0 )
				BubbleGumDLCTextPopupMegaFrame2( BubbleGumDLCTextPopupMega, {} )
				local HintTextArrow0Frame2 = function ( HintTextArrow0, event )
					if not event.interrupted then
						HintTextArrow0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Linear )
					end
					HintTextArrow0:setAlpha( 1 )
					if event.interrupted then
						self.clipFinished( HintTextArrow0, event )
					else
						HintTextArrow0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				HintTextArrow0:completeAnimation()
				self.HintTextArrow0:setAlpha( 0 )
				HintTextArrow0Frame2( HintTextArrow0, {} )
			end,
			Focus = function ()
				self:setupElementClipCounter( 2 )
				BubbleGumDLCTextPopupMega:completeAnimation()
				self.BubbleGumDLCTextPopupMega:setAlpha( 1 )
				self.clipFinished( BubbleGumDLCTextPopupMega, {} )
				HintTextArrow0:completeAnimation()
				self.HintTextArrow0:setAlpha( 1 )
				self.clipFinished( HintTextArrow0, {} )
			end,
			LoseFocus = function ()
				self:setupElementClipCounter( 2 )
				local BubbleGumDLCTextPopupMegaFrame2 = function ( BubbleGumDLCTextPopupMega, event )
					if not event.interrupted then
						BubbleGumDLCTextPopupMega:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Linear )
					end
					BubbleGumDLCTextPopupMega:setAlpha( 0 )
					if event.interrupted then
						self.clipFinished( BubbleGumDLCTextPopupMega, event )
					else
						BubbleGumDLCTextPopupMega:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				BubbleGumDLCTextPopupMega:completeAnimation()
				self.BubbleGumDLCTextPopupMega:setAlpha( 1 )
				BubbleGumDLCTextPopupMegaFrame2( BubbleGumDLCTextPopupMega, {} )
				local HintTextArrow0Frame2 = function ( HintTextArrow0, event )
					if not event.interrupted then
						HintTextArrow0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Linear )
					end
					HintTextArrow0:setAlpha( 0 )
					if event.interrupted then
						self.clipFinished( HintTextArrow0, event )
					else
						HintTextArrow0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				HintTextArrow0:completeAnimation()
				self.HintTextArrow0:setAlpha( 1 )
				HintTextArrow0Frame2( HintTextArrow0, {} )
			end
		},
		CanBuyDLCClassic = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				BubbleGumDLCTextPopupMega:completeAnimation()
				self.BubbleGumDLCTextPopupMega:setAlpha( 0 )
				self.clipFinished( BubbleGumDLCTextPopupMega, {} )
				HintTextArrow0:completeAnimation()
				self.HintTextArrow0:setAlpha( 0 )
				self.clipFinished( HintTextArrow0, {} )
			end,
			GainFocus = function ()
				self:setupElementClipCounter( 3 )
				BubbleGumDLCTextPopupMega:completeAnimation()
				self.BubbleGumDLCTextPopupMega:setAlpha( 0 )
				self.clipFinished( BubbleGumDLCTextPopupMega, {} )
				local BubbleGumDLCTextPopupClassicFrame2 = function ( BubbleGumDLCTextPopupClassic, event )
					if not event.interrupted then
						BubbleGumDLCTextPopupClassic:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Linear )
					end
					BubbleGumDLCTextPopupClassic:setAlpha( 1 )
					if event.interrupted then
						self.clipFinished( BubbleGumDLCTextPopupClassic, event )
					else
						BubbleGumDLCTextPopupClassic:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				BubbleGumDLCTextPopupClassic:completeAnimation()
				self.BubbleGumDLCTextPopupClassic:setAlpha( 0 )
				BubbleGumDLCTextPopupClassicFrame2( BubbleGumDLCTextPopupClassic, {} )
				local HintTextArrow0Frame2 = function ( HintTextArrow0, event )
					if not event.interrupted then
						HintTextArrow0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Linear )
					end
					HintTextArrow0:setAlpha( 1 )
					if event.interrupted then
						self.clipFinished( HintTextArrow0, event )
					else
						HintTextArrow0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				HintTextArrow0:completeAnimation()
				self.HintTextArrow0:setAlpha( 0 )
				HintTextArrow0Frame2( HintTextArrow0, {} )
			end,
			Focus = function ()
				self:setupElementClipCounter( 3 )
				BubbleGumDLCTextPopupMega:completeAnimation()
				self.BubbleGumDLCTextPopupMega:setAlpha( 0 )
				self.clipFinished( BubbleGumDLCTextPopupMega, {} )
				BubbleGumDLCTextPopupClassic:completeAnimation()
				self.BubbleGumDLCTextPopupClassic:setAlpha( 1 )
				self.clipFinished( BubbleGumDLCTextPopupClassic, {} )
				HintTextArrow0:completeAnimation()
				self.HintTextArrow0:setAlpha( 1 )
				self.clipFinished( HintTextArrow0, {} )
			end,
			LoseFocus = function ()
				self:setupElementClipCounter( 3 )
				BubbleGumDLCTextPopupMega:completeAnimation()
				self.BubbleGumDLCTextPopupMega:setAlpha( 0 )
				self.clipFinished( BubbleGumDLCTextPopupMega, {} )
				local BubbleGumDLCTextPopupClassicFrame2 = function ( BubbleGumDLCTextPopupClassic, event )
					if not event.interrupted then
						BubbleGumDLCTextPopupClassic:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Linear )
					end
					BubbleGumDLCTextPopupClassic:setAlpha( 0 )
					if event.interrupted then
						self.clipFinished( BubbleGumDLCTextPopupClassic, event )
					else
						BubbleGumDLCTextPopupClassic:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				BubbleGumDLCTextPopupClassic:completeAnimation()
				self.BubbleGumDLCTextPopupClassic:setAlpha( 1 )
				BubbleGumDLCTextPopupClassicFrame2( BubbleGumDLCTextPopupClassic, {} )
				local HintTextArrow0Frame2 = function ( HintTextArrow0, event )
					if not event.interrupted then
						HintTextArrow0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Linear )
					end
					HintTextArrow0:setAlpha( 0 )
					if event.interrupted then
						self.clipFinished( HintTextArrow0, event )
					else
						HintTextArrow0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				HintTextArrow0:completeAnimation()
				self.HintTextArrow0:setAlpha( 1 )
				HintTextArrow0Frame2( HintTextArrow0, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "CanBuyDLCMega",
			condition = function ( menu, element, event )
				local f35_local0 = IsCACItemFromDLC( menu, element, controller )
				if f35_local0 then
					if not IsCACItemDLCPurchased( menu, element, controller ) then
						f35_local0 = IsSelfModelValueEqualTo( element, controller, "group", "bubblegum_consumable" )
					else
						f35_local0 = false
					end
				end
				return f35_local0
			end
		},
		{
			stateName = "CanBuyDLCClassic",
			condition = function ( menu, element, event )
				return IsCACItemFromDLC( menu, element, controller ) and IsBGBItemLocked( menu, element, controller )
			end
		}
	} )
	self:linkToElementModel( self, "itemIndex", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "itemIndex"
		} )
	end )
	self:linkToElementModel( self, "group", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "group"
		} )
	end )
	GridItemButtonNew.id = "GridItemButtonNew"
	self:registerEventHandler( "gain_focus", function ( element, event )
		if element.m_focusable and element.GridItemButtonNew:processEvent( event ) then
			return true
		else
			return LUI.UIElement.gainFocus( element, event )
		end
	end )
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.GridItemButtonNew:close()
		element.DLCLabel0:close()
		element.BubbleGumDLCTextPopupMega:close()
		element.BubbleGumDLCTextPopupClassic:close()
		element.HintTextArrow0:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end

