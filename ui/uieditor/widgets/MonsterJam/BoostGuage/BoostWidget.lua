require( "UI.SubscriptionUtils" )

require( "ui.uieditor.widgets.MonsterJam.BoostGuage.BoostGuageWidget" )

CoD.BoostWidget = InheritFrom( LUI.UIElement )
function CoD.BoostWidget.new( menu, controller )

	local self = LUI.UIElement.new()
	self:setLeftRight( false,true,313,0 )
	self:setTopBottom( false,false,100.5,357.75 )

	self:setUseStencil( false )
	self:setClass( CoD.BoostWidget )
	self.id = "BoostWidget"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self.parent = LUI.UIElement.new()
	self.parent:setLeftRight( true, true, 0, 0 )
	self.parent:setTopBottom( true, true, 0, 0 )
	self:addElement(self.parent)

	self.BarBlown = CoD.BoostGuageWidget.new( menu, controller )
	self.BarBlown:setLeftRight( true, true, 0, 0 )
	self.BarBlown:setTopBottom( true, true, 0, 0 )
	self.BarBlown.Bar:setAlpha( 0.0 )
	self.BarBlown.Bg:setAlpha( 0.0 )
	self.BarBlown.BgSmk:setAlpha( 1.0 )
	self.BarBlown:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckBoostInfinite" ), function( model )
		local ModelValue = Engine.GetModelValue( model )
		if ModelValue then
			local percent = 1 - ModelValue
			if percent <= 0.05 then
				self.BarBlown.BgSmk:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.BarBlown.BgSmk:setAlpha( 0 )
				self.BarBlown.BgSmk:registerEventHandler( "transition_complete_keyframe", nil )
			else
				self.BarBlown.BgSmk:setAlpha( 1 )
			end
		end
	end )
	self.parent:addElement( self.BarBlown )

	SubscribeToModelAndUpdateState( controller, menu, self.BarBlown, "MonsterTruckBoostInfinite" )

	self.BarInfinite = CoD.BoostGuageWidget.new( menu, controller )
	self.BarInfinite:setLeftRight( true, true, 0, 0 )
	self.BarInfinite:setTopBottom( true, true, 0, 0 )
	self.BarInfinite:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckBoostInfinite" ), function( model )
		local ModelValue = Engine.GetModelValue( model )
		if ModelValue then
			local percent = 1 - ModelValue
			self.BarInfinite.BgSmk:setAlpha( percent )
			self.BarInfinite.Bar:beginAnimation( "keyframe", 75, false, false, CoD.TweenType.Linear )
			self.BarInfinite.Bar:setShaderVector( 0, CoD.GetVectorComponentFromString( percent, 1 ), CoD.GetVectorComponentFromString( percent, 2 ), CoD.GetVectorComponentFromString( percent, 3 ), CoD.GetVectorComponentFromString( percent, 4 ) )
			self.BarInfinite.Bar:registerEventHandler( "transition_complete_keyframe", nil )
		end
	end )
	self.parent:addElement( self.BarInfinite )

	SubscribeToModelAndUpdateState( controller, menu, self.BarInfinite, "MonsterTruckBoostInfinite" )

	self.BarFree = CoD.BoostGuageWidget.new( menu, controller )
	self.BarFree:setLeftRight( true, true, 0, 0 )
	self.BarFree:setTopBottom( true, true, 0, 0 )
	self.BarFree.BgSmk:setRGB( 0.3, 0.89, 1 )
	self.BarFree.BgSmk:setAlpha( 0.6 )
	self.BarFree.Bar:setImage( RegisterImage( "ui_mj_boost_guage_free" ) )
	self.BarFree:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckBoostFree" ), function( model )
		local ModelValue = Engine.GetModelValue( model )
		if ModelValue then
			local percent = ModelValue
			self.BarFree.Bar:beginAnimation( "keyframe", 75, false, false, CoD.TweenType.Linear )
			self.BarFree.Bar:setShaderVector( 0, CoD.GetVectorComponentFromString( percent, 1 ), CoD.GetVectorComponentFromString( percent, 2 ), CoD.GetVectorComponentFromString( percent, 3 ), CoD.GetVectorComponentFromString( percent, 4 ) )
			self.BarFree.Bar:registerEventHandler( "transition_complete_keyframe", nil )
		end 
	end )
	self.parent:addElement( self.BarFree )

	SubscribeToModelAndUpdateState( controller, menu, self.BarFree, "MonsterTruckBoostFree" )

	-- handle the main element first
	self.StateTable = {
		{
			stateName = "Hidden",
			condition = function( menu, element, event )
				return Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_AMMO_COUNTER_HIDE ) or
					  Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN ) or
					  Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM ) or
					  Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_EMP_ACTIVE ) or
					  Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_GAME_ENDED ) or
					  Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ) or
					  Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC ) or
					  Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ) or
					  Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_PLAYER_IN_AFTERLIFE ) or
					  Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_SCOPED ) or
					  Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ) or
					  Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE )
			end
		}
	}

	self:mergeStateConditions( self.StateTable )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function()
				self:setupElementClipCounter( 1 )

				self.parent:completeAnimation()
				self.parent:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.parent:setAlpha( 1 )
				self.parent:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)
			end
		},
		Hidden = {
			DefaultClip = function()
				self:setupElementClipCounter( 1 )

				self.parent:completeAnimation()
				self.parent:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.parent:setAlpha( 0 )
				self.parent:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)
			end
		}
	}

	self.parent.StateTable = {
		{
			stateName = "Free",
			condition = function( menu, element, event )
				return IsModelValueGreaterThan( controller, "MonsterTruckBoostFree", 0 ) and IsModelValueEqualTo( controller, "MonsterTruckBoostBlown", 0 )
			end
		},
		{
			stateName = "Infinite",
			condition = function( menu, element, event )
				return IsModelValueEqualTo( controller, "MonsterTruckBoostBlown", 0 ) and IsModelValueEqualTo( controller, "MonsterTruckBoostFree", 0 )
			end
		},
		{
			stateName = "Blown",
			condition = function( menu, element, event )
				return IsModelValueEqualTo( controller, "MonsterTruckBoostBlown", 1 )
			end
		}
	}

	self.parent:mergeStateConditions( self.parent.StateTable )

	self.parent.clipsPerState = {
		DefaultState = {
			DefaultClip = function()
				self.parent:setupElementClipCounter( 3 )

				self.BarInfinite:completeAnimation()
				self.BarInfinite:setAlpha( 0 )
				self.parent.clipFinished( self.BarInfinite, {} )

				self.BarBlown:completeAnimation()
				self.BarBlown:setAlpha( 0 )
				self.parent.clipFinished( self.BarBlown, {} )

				self.BarFree:completeAnimation()
				self.BarFree:setAlpha( 0 )
				self.parent.clipFinished( self.BarFree, {} )
			end
		},
		Free = {
			DefaultClip = function()
				self.parent:setupElementClipCounter( 3 )

				self.BarInfinite:completeAnimation()
				self.BarInfinite:setAlpha( 0 )
				self.parent.clipFinished( self.BarInfinite, {} )

				self.BarBlown:completeAnimation()
				self.BarBlown:setAlpha( 0 )
				self.parent.clipFinished( self.BarBlown, {} )

				self.BarFree:completeAnimation()
				self.BarFree:setAlpha( 1 )
				self.parent.clipFinished( self.BarFree, {} )
			end
		},
		Infinite = {
			DefaultClip = function()
				self.parent:setupElementClipCounter( 3 )

				self.BarInfinite:completeAnimation()
				self.BarInfinite:setAlpha( 1 )
				self.parent.clipFinished( self.BarInfinite, {} )

				self.BarBlown:completeAnimation()
				self.BarBlown:setAlpha( 0 )
				self.parent.clipFinished( self.BarBlown, {} )

				self.BarFree:completeAnimation()
				self.BarFree:setAlpha( 0 )
				self.parent.clipFinished( self.BarFree, {} )
			end
		},
		Blown = {
			DefaultClip = function()
				self.parent:setupElementClipCounter( 3 )

				self.BarInfinite:completeAnimation()
				self.BarInfinite:setAlpha( 1 )
				self.parent.clipFinished( self.BarInfinite, {} )

				self.BarBlown:completeAnimation()
				self.BarBlown:setAlpha( 1 )
				self.parent.clipFinished( self.BarBlown, {} )

				self.BarFree:completeAnimation()
				self.BarFree:setAlpha( 0 )
				self.parent.clipFinished( self.BarFree, {} )
			end
		}
	}

	SubscribeToModelAndUpdateState( controller, menu, self.parent, "MonsterTruckBoostInfinite" )
	SubscribeToModelAndUpdateState( controller, menu, self.parent, "MonsterTruckBoostFree" )
	SubscribeToModelAndUpdateState( controller, menu, self.parent, "MonsterTruckBoostBlown" )

	SubscribeToModelAndUpdateState( controller, menu, self, "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE )
	SubscribeToModelAndUpdateState( controller, menu, self, "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE )
	SubscribeToModelAndUpdateState( controller, menu, self, "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED )
	SubscribeToModelAndUpdateState( controller, menu, self, "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM )
	SubscribeToModelAndUpdateState( controller, menu, self, "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN )
	SubscribeToModelAndUpdateState( controller, menu, self, "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM )
	SubscribeToModelAndUpdateState( controller, menu, self, "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED )
	SubscribeToModelAndUpdateState( controller, menu, self, "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED )
	SubscribeToModelAndUpdateState( controller, menu, self, "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE )
	SubscribeToModelAndUpdateState( controller, menu, self, "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE )
	SubscribeToModelAndUpdateState( controller, menu, self, "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN )
	SubscribeToModelAndUpdateState( controller, menu, self, "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE )
	SubscribeToModelAndUpdateState( controller, menu, self, "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function( element )
		element.BarInfinite:close()
		element.BarFree:close()
	end )

	return self
end