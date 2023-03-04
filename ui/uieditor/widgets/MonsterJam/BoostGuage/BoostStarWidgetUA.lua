require( "UI.SubscriptionUtils" )

CoD.BoostStarWidgetUA = InheritFrom( LUI.UIElement )
function CoD.BoostStarWidgetUA.new( menu, controller, requiredStars )

	local self = LUI.UIElement.new()
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )

	self:setUseStencil( false )
	self:setClass( CoD.BoostStarWidgetUA )
	self.id = "BoostStarWidgetUA"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self.stars = requiredStars or 1

	self.starbg = LUI.UIImage.new()
	self.starbg:setLeftRight( true, true, 0, 0 )
	self.starbg:setTopBottom( true, true, 0, 0 )
	self.starbg:setImage( RegisterImage( "ui_mj_ua_boost_nostar" ) )
	self:addElement( self.starbg )

	self.star = LUI.UIImage.new()
	self.star:setLeftRight( true, true, 0, 0 )
	self.star:setTopBottom( true, true, 0, 0 )
	self.star:setImage( RegisterImage( "ui_mj_ua_boost_star" ) )
	self:addElement( self.star )

	self.StateTable = {
		{
			stateName = "Show",
			condition = function( menu, element, event )
				return IsModelValueGreaterThanOrEqualTo( controller, "MonsterTruckSpectaclePoints", self.stars )
			end
		}
	}

	self:mergeStateConditions( self.StateTable )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function()
				self:setupElementClipCounter( 1 )

				self.star:beginAnimation( "keyframe", 75, false, false, CoD.TweenType.Bounce )
				self.star:setScale( 0 )
				self.star:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )
			end
		},
		Show = {
			DefaultClip = function()
				self:setupElementClipCounter( 1 )

				self.star:beginAnimation( "keyframe", 75, false, false, CoD.TweenType.Bounce )
				self.star:setScale( 1 )
				self.star:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end )
			end
		}
	}

	SubscribeToModelAndUpdateState( controller, menu, self, "MonsterTruckSpectaclePoints" )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function( element )
		element.starbg:close()
		element.star:close()
	end )

	return self
end