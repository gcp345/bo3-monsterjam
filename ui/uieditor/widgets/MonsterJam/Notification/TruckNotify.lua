require( "UI.SubscriptionUtils" )
require( "ui.lui.LUITextToImage" )


local function GetTruckLogo( index )
	local logoImage = Engine.TableLookup( nil, "gamedata/tables/common/truck_data.csv", 4, index, 2 )
	if logoImage then
		return logoImage
	end
	return "ui_mj_graphics_logo_locked"
end

CoD.TruckNotify = InheritFrom( LUI.UIElement )
function CoD.TruckNotify.new( menu, controller )
	local self = LUI.UIElement.new()
	self:setLeftRight( true, false, 0, 220.5 )
	self:setTopBottom( false, false, -276.5, -148.5 )

	self:setUseStencil( false )
	self:setClass( CoD.TruckNotify )
	self.id = "TruckNotify"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self.TruckLogo = LUI.UIImage.new()
	self.TruckLogo:setLeftRight( false, false, -100, 105 )
	self.TruckLogo:setTopBottom( false, false, -65, 18 )
	self.TruckLogo:setAlpha( 0 )
	self.TruckLogo:setImage( RegisterImage( "blacktransparent" ) )
	self.TruckLogo:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self:addElement( self.TruckLogo )

	self.NotifyText = LUI.UITextToImage.new()
	self.NotifyText:setLeftRight( false, false, -105, 105 )
	self.NotifyText:setTopBottom( false, false, 5, 40 )
	self.NotifyText:setPrefix( "ui_mj_hud_letter_" )
	self.NotifyText:setAlpha( 0 )
	self.NotifyText:setProperties( 1, 32, 40, 0.65625 )
	self.NotifyText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self:addElement( self.NotifyText )

	self:subscribeToGlobalModel( controller, "PerController", "scriptNotify", function( model )
		if IsParamModelEqualToString( model, "truck_notify" ) then
			local notifyData = CoD.GetScriptNotifyData( model )
			local logo = GetTruckLogo( notifyData[ 1 ] ) or "ui_mj_graphics_logo_locked"
			local text = Engine.Localize( Engine.GetIString( notifyData[ 2 ], "CS_LOCALIZED_STRINGS" ) ) or ""
			self.TruckLogo:setImage( RegisterImage( logo ) )
			self.NotifyText:setText( text, true )
			self:playClip( "ShowText" )
		end
	end )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function()
				self:setupElementClipCounter( 2 )

				self.TruckLogo:completeAnimation()
				self.TruckLogo:setAlpha( 0 )
				self.clipFinished( self.TruckLogo, {} )

				self.NotifyText:completeAnimation()
				self.NotifyText:setAlpha( 0 )
				self.clipFinished( self.NotifyText, {} )
			end,
			ShowText = function()
				self:setupElementClipCounter( 2 )

				self.TruckLogo:completeAnimation()
				self.TruckLogo:setAlpha( 0 )
				local HandleTruckLogoFade = function (Element, Event)
					if not Event.interrupted then
						Element:beginAnimation("keyframe", 1500, true, true, CoD.TweenType.Linear)
					end
					Element:setAlpha(1)
					Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
						if not Event.interrupted then
							Element:beginAnimation("keyframe", 3000, true, true, CoD.TweenType.Linear)
						end
						if Event.interrupted then
							self.clipFinished(Element, Event)
						else
							Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
								if not Event.interrupted then
									Element:beginAnimation("keyframe", 1500, true, true, CoD.TweenType.Linear)
								end
								Element:setAlpha(0)
								if Event.interrupted then
									self.clipFinished(Element, Event)
								else
									Element:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end)
						end
					end)
				end

				HandleTruckLogoFade( self.TruckLogo, {} )

				self.NotifyText:completeAnimation()
				self.NotifyText:setAlpha( 0 )
				local HandleNotifyFade = function (Element, Event)
					if not Event.interrupted then
						Element:beginAnimation("keyframe", 1500, true, true, CoD.TweenType.Linear)
					end
					Element:setAlpha(1)
					Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
						if not Event.interrupted then
							Element:beginAnimation("keyframe", 3000, true, true, CoD.TweenType.Linear)
						end
						if Event.interrupted then
							self.clipFinished(Element, Event)
						else
							Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
								if not Event.interrupted then
									Element:beginAnimation("keyframe", 1500, true, true, CoD.TweenType.Linear)
								end
								Element:setAlpha(0)
								if Event.interrupted then
									self.clipFinished(Element, Event)
								else
									Element:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end)
						end
					end)
				end

				HandleNotifyFade( self.NotifyText, {} )
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function( element )
		element.TruckLogo:close()
		element.NotifyText:close()
	end )

	return self
end