require( "UI.SubscriptionUtils" )
require( "ui.lui.LUITextToImage" )

CoD.MonsterSpectacleNotify = InheritFrom( LUI.UIElement )
function CoD.MonsterSpectacleNotify.new( menu, controller )
	local self = LUI.UIElement.new()
	self:setLeftRight( false, false, -128, 128 )
	self:setTopBottom( true, false, -75, 300 )

	self:setUseStencil( false )
	self:setClass( CoD.MonsterSpectacleNotify )
	self.id = "MonsterSpectacleNotify"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self.spectacleStar = LUI.UIImage.new()
	self.spectacleStar:setLeftRight( false, false, -128, 128 )
	self.spectacleStar:setTopBottom( false, false, -103, 103 )
	self.spectacleStar:setAlpha( 1 )
	self.spectacleStar:setImage( RegisterImage( "ui_mj_ua_mega_spectacle" ) )
	self:addElement( self.spectacleStar )

	self.spectacleStarFlipBook = LUI.UIImage.new()
	self.spectacleStarFlipBook:setLeftRight( false, false, -128, 128 )
	self.spectacleStarFlipBook:setTopBottom( false, false, -103, 103 )
	self.spectacleStarFlipBook:setAlpha( 0 )
	self.spectacleStarFlipBook:setImage( RegisterImage( "ui_mj_ua_mega_spectacle_flipbook" ) )
	self.spectacleStarFlipBook:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_flipbook" ) )
	self.spectacleStarFlipBook:setShaderVector( 0, 0, 12, 0, 0 )
	self.spectacleStarFlipBook:setShaderVector( 1, 0, 0, 0, 0 )
	self:addElement( self.spectacleStarFlipBook )

	self.spectacleText = LUI.UITextToImage.new()
	self.spectacleText:setLeftRight( false, false, -470, 305 )
	self.spectacleText:setTopBottom( false, false, 11, 86 )
	self.spectacleText:setPrefix( "ui_mj_hud_letter_" )
	self.spectacleText:setAlpha( 1 )
	self.spectacleText:setProperties( 17, 91.667, 72, 0.6 )
	self.spectacleText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.spectacleText:setText( Engine.Localize( "UI_MENU_MONSTER_SPECTACLE" ), true )
	self:addElement( self.spectacleText )

	self:subscribeToGlobalModel( controller, "PerController", "scriptNotify", function( model )
		if IsParamModelEqualToString( model, "monster_spectacle" ) then
			self:playClip( "ShowText" )
		end
	end )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function()
				self:setupElementClipCounter( 3 )

				self.spectacleStar:completeAnimation()
				self.spectacleStar:setAlpha( 0 )
				self.clipFinished( self.spectacleStar, {} )

				self.spectacleStarFlipBook:completeAnimation()
				self.spectacleStarFlipBook:setAlpha( 0 )
				self.clipFinished( self.spectacleStarFlipBook, {} )

				self.spectacleText:completeAnimation()
				self.spectacleText:setAlpha( 0 )
				self.clipFinished( self.spectacleText, {} )
			end,
			ShowText = function()
				self:setupElementClipCounter( 3 )

				self.spectacleStar:completeAnimation()
				self.spectacleStar:setAlpha( 0 )
				self.spectacleStar:setScale( 0 )
				local HandleSpectacleStarFade = function (Element, Event)
					if not Event.interrupted then
						Element:beginAnimation("keyframe", 500, true, true, CoD.TweenType.Linear)
					end
					Element:setAlpha(1)
					Element:setScale(1)
					Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
						if not Event.interrupted then
							Element:beginAnimation("keyframe", 1, true, true, CoD.TweenType.Linear)
						end
						Element:setAlpha(0)
						if Event.interrupted then
							self.clipFinished(Element, Event)
						else
							Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
								if not Event.interrupted then
									Element:beginAnimation("keyframe", 750, true, true, CoD.TweenType.Linear)
								end
								if Event.interrupted then
									self.clipFinished(Element, Event)
								else
									Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
										if not Event.interrupted then
											Element:beginAnimation("keyframe", 1, true, true, CoD.TweenType.Linear)
										end
										Element:setAlpha(1)
										if Event.interrupted then
											self.clipFinished(Element, Event)
										else
											Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
												if not Event.interrupted then
													Element:beginAnimation("keyframe", 500, true, true, CoD.TweenType.Linear)
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
							end)
						end
					end)
				end

				HandleSpectacleStarFade( self.spectacleStar, {} )

				self.spectacleStarFlipBook:completeAnimation()
				self.spectacleStarFlipBook:setAlpha( 0 )
				self.spectacleStarFlipBook:setScale( 0 )
				self.spectacleStarFlipBook:setShaderVector( 1, 0, 0, 0, 0 )
				local HandleSpectacleStarFlipBookFade = function (Element, Event)
					if not Event.interrupted then
						Element:beginAnimation("keyframe", 500, true, true, CoD.TweenType.Linear)
					end
					Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
						if not Event.interrupted then
							Element:beginAnimation("keyframe", 1, true, true, CoD.TweenType.Linear)
						end
						Element:setAlpha(1)
						Element:setScale(1)
						if Event.interrupted then
							self.clipFinished(Element, Event)
						else
							Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
								Element:setShaderVector( 1, 20, 0, 0, 0 )
								if not Event.interrupted then
									Element:beginAnimation("keyframe", 750, true, true, CoD.TweenType.Linear)
								end
								if Event.interrupted then
									self.clipFinished(Element, Event)
								else
									Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
										if not Event.interrupted then
											Element:beginAnimation("keyframe", 1, true, true, CoD.TweenType.Linear)
										end
										Element:setAlpha(0)
										if Event.interrupted then
											self.clipFinished(Element, Event)
										else
											Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
												if not Event.interrupted then
													Element:beginAnimation("keyframe", 500, true, true, CoD.TweenType.Linear)
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
							end)
						end
					end)
				end

				HandleSpectacleStarFlipBookFade( self.spectacleStarFlipBook, {} )

				self.spectacleText:completeAnimation()
				self.spectacleText:setAlpha( 0 )
				self.spectacleText:setScale( 0 )
				local HandlespectacleTextFade = function (Element, Event)
					if not Event.interrupted then
						Element:beginAnimation("keyframe", 1100, true, true, CoD.TweenType.Linear)
					end
					Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
						if not Event.interrupted then
							Element:beginAnimation("keyframe", 150, true, true, CoD.TweenType.Linear)
						end
						Element:setAlpha(1)
						Element:setScale(1)
						if Event.interrupted then
							self.clipFinished(Element, Event)
						else
							Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
								if not Event.interrupted then
									Element:beginAnimation("keyframe", 500, true, true, CoD.TweenType.Linear)
								end
								if Event.interrupted then
									self.clipFinished(Element, Event)
								else
									Element:registerEventHandler("transition_complete_keyframe", function (Element, Event)
										if not Event.interrupted then
											Element:beginAnimation("keyframe", 500, true, true, CoD.TweenType.Linear)
										end
										Element:setAlpha(0)
										Element:setScale(2)
										if Event.interrupted then
											self.clipFinished(Element, Event)
										else
											Element:registerEventHandler("transition_complete_keyframe", self.clipFinished)
										end
									end)
								end
							end)
						end
					end)
				end

				HandlespectacleTextFade( self.spectacleText, {} )
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function( element )
		element.spectacleStar:close()
		element.spectacleStarFlipBook:close()
		element.spectacleText:close()
	end )

	return self
end