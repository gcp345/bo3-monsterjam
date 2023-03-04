require( "UI.SubscriptionUtils" )

require( "ui.uieditor.widgets.UIShadowText" )

CoD.LapWidget = InheritFrom( LUI.UIElement )
function CoD.LapWidget.new( menu, controller )
	local self = LUI.UIElement.new()
	self:setLeftRight( false, false, 372, 640 )
	self:setTopBottom( false, false, -360, -215.5 )

	self:setUseStencil( false )
	self:setClass( CoD.LapWidget )
	self.id = "LapWidget"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	if Dvar.ui_gametype:get() == "znml" or Dvar.ui_gametype:get() == "freestyle" then
		return self
	end

	self.LapBG = LUI.UIImage.new()
	self.LapBG:setLeftRight( false, true, -150, 100 )
	self.LapBG:setTopBottom( true, false, 5, 75 )
	self.LapBG:setImage( RegisterImage( "ui_mj_lap_bg" ) )
	self:addElement( self.LapBG )

	self.Lap = LUI.UIImage.new()
	self.Lap:setLeftRight( false, true, -60, 5 )
	self.Lap:setTopBottom( true, false, 44.75, 70 )
	self.Lap:setImage( RegisterImage( "ui_mj_lap" ) )
	self:addElement( self.Lap )

	self.LapSizeText = CoD.UIShadowText.new()
	self.LapSizeText:setLeftRight( false, true, 85, -30 )
	self.LapSizeText:setTopBottom( true, false, 6, 50 )
	self.LapSizeText:setText( "/ 3" )
	self.LapSizeText:setTTF( "fonts/Molde-Condensed-BoldItalic.ttf" )
	self:addElement( self.LapSizeText )
	self.LapSizeText:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckLapsTotal" ), function( model )
		local ModelValue = Engine.GetModelValue( model )
		if ModelValue then
			self.LapSizeText:setText( "/ " .. ModelValue )
		end 
	end )

	SubscribeToModelAndUpdateState( controller, menu, self.LapSizeText, "MonsterTruckLapsTotal" )

	self.LapText = CoD.UIShadowText.new()
	self.LapText:setLeftRight( false, true, 25, -75 )
	self.LapText:setTopBottom( true, false, 6, 70 )
	self.LapText:setText( "1" )
	self.LapText:setTTF( "fonts/Molde-Condensed-BoldItalic.ttf" )
	self:addElement( self.LapText )
	self.LapText:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckLaps" ), function( model )
		local ModelValue = Engine.GetModelValue( model )
		if ModelValue then
			self.LapText:setText( ModelValue )
		end 
	end )

	SubscribeToModelAndUpdateState( controller, menu, self.LapText, "MonsterTruckLaps" )

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

				self.LapBG:completeAnimation()
				self.LapBG:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.LapBG:setAlpha( 1 )
				self.LapBG:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.Lap:completeAnimation()
				self.Lap:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.Lap:setAlpha( 1 )
				self.Lap:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.LapSizeText:completeAnimation()
				self.LapSizeText:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.LapSizeText:setAlpha( 1 )
				self.LapSizeText:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.LapText:completeAnimation()
				self.LapText:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.LapText:setAlpha( 1 )
				self.LapText:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)
			end
		},
		Hidden = {
			DefaultClip = function()
				self:setupElementClipCounter( 4 )

				self.LapBG:completeAnimation()
				self.LapBG:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.LapBG:setAlpha( 0 )
				self.LapBG:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.Lap:completeAnimation()
				self.Lap:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.Lap:setAlpha( 0 )
				self.Lap:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.LapSizeText:completeAnimation()
				self.LapSizeText:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.LapSizeText:setAlpha( 0 )
				self.LapSizeText:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.LapText:completeAnimation()
				self.LapText:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.LapText:setAlpha( 0 )
				self.LapText:registerEventHandler( "transition_complete_keyframe", function( element, event )
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
		element.LapBG:close()
		element.Lap:close()
		element.LapSizeText:close()
		element.LapText:close()
	end )

	return self
end