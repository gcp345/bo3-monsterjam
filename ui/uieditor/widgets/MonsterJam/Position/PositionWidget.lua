require( "UI.SubscriptionUtils" )

require( "ui.uieditor.widgets.UIShadowText" )

-- putting this here because we can't creeate this on the fly
SoundSet.Positions = {
	rank1 = "mus_mj_finishplace",
	rank2 = "mus_mj_finishplace",
	rank3 = "mus_mj_finishplace",
	rank4 = "mus_mj_finishnoplace",
	rank5 = "mus_mj_finishnoplace",
	rank6 = "mus_mj_finishnoplace",
	slider_anim = "mus_mj_slider_animate"
}

CoD.PositionWidget = InheritFrom( LUI.UIElement )
function CoD.PositionWidget.new( menu, controller )
	local self = LUI.UIElement.new()
	self:setLeftRight( false, false, -640, -372 )
	self:setTopBottom( false, false, -360, -215.5 )

	self:setUseStencil( false )
	self:setClass( CoD.PositionWidget )
	self.id = "PositionWidget"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	if Dvar.ui_gametype:get() == "znml" or Dvar.ui_gametype:get() == "freestyle" then
		return self
	end

	self.PositionBG = LUI.UIImage.new()
	self.PositionBG:setLeftRight( true, false, -100, 150 )
	self.PositionBG:setTopBottom( true, false, 5, 75 )
	self.PositionBG:setImage( RegisterImage( "ui_mj_position_bg" ) )
	self:addElement( self.PositionBG )

	self.Position = LUI.UIImage.new()
	self.Position:setLeftRight( true, false, 40, 105 )
	self.Position:setTopBottom( true, false, 44.75, 70 )
	self.Position:setImage( RegisterImage( "ui_mj_position" ) )
	self:addElement( self.Position )

	self.PositionSizeText = CoD.UIShadowText.new()
	self.PositionSizeText:setLeftRight( true, false, 50, 130 )
	self.PositionSizeText:setTopBottom( true, false, 6, 50 )
	self.PositionSizeText:setText( "/ 6" )
	self.PositionSizeText:setTTF( "fonts/Molde-Condensed-BoldItalic.ttf" )
	self:addElement( self.PositionSizeText )
	self.PositionSizeText:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckPosTotal" ), function( model )
		local ModelValue = Engine.GetModelValue( model )
		if ModelValue then
			self.PositionSizeText:setText( "/ " .. ModelValue )
		end 
	end )

	SubscribeToModelAndUpdateState( controller, menu, self.PositionSizeText, "MonsterTruckPosTotal" )

	self.PositionText = CoD.UIShadowText.new()
	self.PositionText:setLeftRight( true, false, 7.5, 85 )
	self.PositionText:setTopBottom( true, false, 6, 70 )
	self.PositionText:setText( "1" )
	self.PositionText:setTTF( "fonts/Molde-Condensed-BoldItalic.ttf" )
	self:addElement( self.PositionText )
	self.PositionText:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckPos" ), function( model )
		local ModelValue = Engine.GetModelValue( model )
		if ModelValue then
			self.PositionText:setText( ModelValue )
		end 
	end )

	SubscribeToModelAndUpdateState( controller, menu, self.PositionText, "MonsterTruckPos" )

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
				self:setupElementClipCounter( 4 )

				self.PositionBG:completeAnimation()
				self.PositionBG:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.PositionBG:setAlpha( 1 )
				self.PositionBG:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.Position:completeAnimation()
				self.Position:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.Position:setAlpha( 1 )
				self.Position:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.PositionSizeText:completeAnimation()
				self.PositionSizeText:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.PositionSizeText:setAlpha( 1 )
				self.PositionSizeText:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.PositionText:completeAnimation()
				self.PositionText:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.PositionText:setAlpha( 1 )
				self.PositionText:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)
			end
		},
		Hidden = {
			DefaultClip = function()
				self:setupElementClipCounter( 4 )

				self.PositionBG:completeAnimation()
				self.PositionBG:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.PositionBG:setAlpha( 0 )
				self.PositionBG:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.Position:completeAnimation()
				self.Position:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.Position:setAlpha( 0 )
				self.Position:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.PositionSizeText:completeAnimation()
				self.PositionSizeText:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.PositionSizeText:setAlpha( 0 )
				self.PositionSizeText:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.PositionText:completeAnimation()
				self.PositionText:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.PositionText:setAlpha( 0 )
				self.PositionText:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)
			end
		}
	}
	
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
		element.PositionBG:close()
		element.Position:close()
		element.PositionSizeText:close()
		element.PositionText:close()
	end )

	return self
end