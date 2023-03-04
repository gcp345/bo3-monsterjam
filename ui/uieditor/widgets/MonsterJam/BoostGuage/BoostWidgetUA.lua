require( "UI.SubscriptionUtils" )

require( "ui.uieditor.widgets.MonsterJam.BoostGuage.BoostStarWidgetUA" )

CoD.BoostWidgetUA = InheritFrom( LUI.UIElement )
function CoD.BoostWidgetUA.new( menu, controller )

	local self = LUI.UIElement.new()

	self:setUseStencil( false )
	self:setClass( CoD.BoostWidgetUA )
	self.id = "BoostWidgetUA"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self.bg = LUI.UIImage.new()
	self.bg:setLeftRight(false,false,-121,100)
	self.bg:setTopBottom(false,false,-18,64)
	self.bg:setAlpha(1)
	self.bg:setImage(RegisterImage("ui_mj_ua_boost_guage"))
	self:addElement(self.bg)

	self.boostbig = LUI.UIImage.new()
	self.boostbig:setLeftRight(false,false,-109,81)
	self.boostbig:setTopBottom(false,false,-10,27.5)
	self.boostbig:setAlpha(1)
	self.boostbig:setImage(RegisterImage("ui_mj_ua_boost_top"))
	self.boostbig:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.boostbig:setShaderVector( 0, 1, 0, 0, 0 )
	self.boostbig:setShaderVector( 1, 0, 0, 0, 0 )
	self.boostbig:setShaderVector( 2, 1, 0, 0, 0 )
	self.boostbig:setShaderVector( 3, 0, 0, 0, 0 )
	self.boostbig:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckBoostTank1" ), function( model )
		local ModelValue = Engine.GetModelValue( model )
		if ModelValue then
			self.boostbig:beginAnimation( "keyframe", 75, false, false, CoD.TweenType.Linear )
			self.boostbig:setShaderVector( 0, CoD.GetVectorComponentFromString( ModelValue, 1 ), CoD.GetVectorComponentFromString( ModelValue, 2 ), CoD.GetVectorComponentFromString( ModelValue, 3 ), CoD.GetVectorComponentFromString( ModelValue, 4 ) )
			self.boostbig:registerEventHandler( "transition_complete_keyframe", nil )
		end
	end )

	SubscribeToModelAndUpdateState( controller, menu, self.boostbig, "MonsterTruckBoostTank1" )
	self:addElement(self.boostbig)

	self.boostsmall = LUI.UIImage.new()
	self.boostsmall:setLeftRight(false,false,-87,59)
	self.boostsmall:setTopBottom(false,false,42,56)
	self.boostsmall:setAlpha(1)
	self.boostsmall:setImage(RegisterImage("ui_mj_ua_boost_bottom"))
	self.boostsmall:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.boostsmall:setShaderVector( 0, 1, 0, 0, 0 )
	self.boostsmall:setShaderVector( 1, 0, 0, 0, 0 )
	self.boostsmall:setShaderVector( 2, 1, 0, 0, 0 )
	self.boostsmall:setShaderVector( 3, 0, 0, 0, 0 )
	self.boostsmall:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckBoostTank2" ), function( model )
		local ModelValue = Engine.GetModelValue( model )
		if ModelValue then
			self.boostsmall:beginAnimation( "keyframe", 75, false, false, CoD.TweenType.Linear )
			self.boostsmall:setShaderVector( 0, CoD.GetVectorComponentFromString( ModelValue, 1 ), CoD.GetVectorComponentFromString( ModelValue, 2 ), CoD.GetVectorComponentFromString( ModelValue, 3 ), CoD.GetVectorComponentFromString( ModelValue, 4 ) )
			self.boostsmall:registerEventHandler( "transition_complete_keyframe", nil )
		end
	end )

	SubscribeToModelAndUpdateState( controller, menu, self.boostsmall, "MonsterTruckBoostTank2" )
	self:addElement(self.boostsmall)

	self.boostsmallglow = LUI.UIImage.new()
	self.boostsmallglow:setLeftRight(false,false,-108,78)
	self.boostsmallglow:setTopBottom(false,false,34,64)
	self.boostsmallglow:setAlpha(0)
	self.boostsmallglow:setImage(RegisterImage("ui_mj_ua_boost_bottom_glow"))
	self:addElement(self.boostsmallglow)

	self.star1 = CoD.BoostStarWidgetUA.new( menu, controller, 1 )
	self.star1:setLeftRight(false,false,-116,-68)
	self.star1:setTopBottom(false,false,-64,-16)
	self.star1:setAlpha(1)
	self:addElement(self.star1)

	self.star2 = CoD.BoostStarWidgetUA.new( menu, controller, 2 )
	self.star2:setLeftRight(false,false,-86,-38)
	self.star2:setTopBottom(false,false,-90,-42)
	self.star2:setAlpha(1)
	self:addElement(self.star2)

	self.star3 = CoD.BoostStarWidgetUA.new( menu, controller, 3 )
	self.star3:setLeftRight(false,false,-42,6)
	self.star3:setTopBottom(false,false,-110,-62)
	self.star3:setAlpha(1)
	self:addElement(self.star3)

	self.star4 = CoD.BoostStarWidgetUA.new( menu, controller, 4 )
	self.star4:setLeftRight(false,false,10,58)
	self.star4:setTopBottom(false,false,-116,-68)
	self.star4:setAlpha(1)
	self:addElement(self.star4)

	self.star5 = CoD.BoostStarWidgetUA.new( menu, controller, 5 )
	self.star5:setLeftRight(false,false,56,104)
	self.star5:setTopBottom(false,false,-114,-66)
	self.star5:setAlpha(1)
	self:addElement(self.star5)

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
		},
		{
			stateName = "Glow",
			condition = function( menu, element, event )
				return IsModelValueEqualTo( controller, "MonsterTruckBoostIsSecondTank", 1 )
			end
		}
	}

	self:mergeStateConditions( self.StateTable )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function()
				self:setupElementClipCounter( 8 )

				self.bg:completeAnimation()
				self.bg:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.bg:setAlpha( 1 )
				self.bg:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.boostbig:completeAnimation()
				self.boostbig:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.boostbig:setAlpha( 1 )
				self.boostbig:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.boostsmall:completeAnimation()
				self.boostsmall:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.boostsmall:setAlpha( 1 )
				self.boostsmall:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.star1:completeAnimation()
				self.star1:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.star1:setAlpha( 1 )
				self.star1:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.star2:completeAnimation()
				self.star2:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.star2:setAlpha( 1 )
				self.star2:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.star3:completeAnimation()
				self.star3:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.star3:setAlpha( 1 )
				self.star3:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.star4:completeAnimation()
				self.star4:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.star4:setAlpha( 1 )
				self.star4:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.star5:completeAnimation()
				self.star5:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.star5:setAlpha( 1 )
				self.star5:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )
			end
		},
		Hidden = {
			DefaultClip = function()
				self:setupElementClipCounter( 9 )

				self.bg:completeAnimation()
				self.bg:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.bg:setAlpha( 0 )
				self.bg:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.boostbig:completeAnimation()
				self.boostbig:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.boostbig:setAlpha( 0 )
				self.boostbig:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.boostsmall:completeAnimation()
				self.boostsmall:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.boostsmall:setAlpha( 0 )
				self.boostsmall:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.boostsmallglow:completeAnimation()
				self.boostsmallglow:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.boostsmallglow:setAlpha( 0 )
				self.boostsmallglow:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.star1:completeAnimation()
				self.star1:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.star1:setAlpha( 0 )
				self.star1:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.star2:completeAnimation()
				self.star2:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.star2:setAlpha( 0 )
				self.star2:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.star3:completeAnimation()
				self.star3:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.star3:setAlpha( 0 )
				self.star3:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.star4:completeAnimation()
				self.star4:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.star4:setAlpha( 0 )
				self.star4:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )

				self.star5:completeAnimation()
				self.star5:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.star5:setAlpha( 0 )
				self.star5:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )
			end
		},
		Glow = {
			DefaultClip = function()
				self:setupElementClipCounter( 1 )

				self.boostsmallglow:completeAnimation()
				self.boostsmallglow:setAlpha( 0.0 )
				local HandleTextFade = function (Element, Event)
					if not Event.interrupted then
						Element:beginAnimation("keyframe", 1000, true, true, CoD.TweenType.Linear)
					end
					Element:setAlpha( 1 )
					Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
						if not Event.interrupted then
							Element:beginAnimation("keyframe", 1000, true, true, CoD.TweenType.Linear)
						end
						Element:setAlpha( 0 )
						if Event.interrupted then
							self.clipFinished(Element, Event)
						else
							Element:registerEventHandler("transition_complete_keyframe", self.clipFinished)
						end
					end)
				end

				HandleTextFade( self.boostsmallglow, {} )
				self.nextClip = "DefaultClip"
			end
		}
	}

	SubscribeToModelAndUpdateState( controller, menu, self, "MonsterTruckBoostIsSecondTank" )
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
		element.bg:close()
		element.boostbig:close()
		element.boostsmall:close()
		element.boostsmallglow:close()
		element.star1:close()
		element.star2:close()
		element.star3:close()
		element.star4:close()
		element.star5:close()
	end )

	return self
end