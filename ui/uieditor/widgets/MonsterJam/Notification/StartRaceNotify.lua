require( "UI.SubscriptionUtils" )

SoundSet.RaceSounds = {
	countdown1and2 = "mus_mj_countdown1and2",
	countdown3 = "mus_mj_countdown3",
	countdowngo = "mus_mj_countdowngo"
}

CoD.StartRaceNotify = InheritFrom( LUI.UIElement )
CoD.StartRaceNotify.BlendTime = 900


function CoD.StartRaceNotify.new( menu, controller )
	local self = LUI.UIElement.new()
	self:setLeftRight( true, false, 0, 220.5 )
	self:setTopBottom( false, false, -276.5, -148.5 )

	self:setUseStencil( false )
	self:setClass( CoD.StartRaceNotify )
	self.id = "StartRaceNotify"
	self.soundSet = "RaceSounds"
	self.anyChildUsesUpdateState = true

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self.Container = LUI.UIElement.new()
	self.Container:setLeftRight( true, true, 0, 0 )
	self.Container:setTopBottom( true, true, 0, 0 )
	self:addElement( self.Container )

	self.Container.CountDown3 = LUI.UIImage.new()
	self.Container.CountDown3:setLeftRight( false, false, -128, 128 )
	self.Container.CountDown3:setTopBottom( false, false, -100, 156 )
	self.Container.CountDown3:setImage( RegisterImage( "ui_mj_event_3" ) )
	self.Container.CountDown3:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Container:addElement( self.Container.CountDown3 )

	self.Container.CountDown2 = LUI.UIImage.new()
	self.Container.CountDown2:setLeftRight( false, false, -128, 128 )
	self.Container.CountDown2:setTopBottom( false, false, -100, 156 )
	self.Container.CountDown2:setImage( RegisterImage( "ui_mj_event_2" ) )
	self.Container.CountDown2:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Container:addElement( self.Container.CountDown2 )

	self.Container.CountDown1 = LUI.UIImage.new()
	self.Container.CountDown1:setLeftRight( false, false, -128, 128 )
	self.Container.CountDown1:setTopBottom( false, false, -100, 156 )
	self.Container.CountDown1:setImage( RegisterImage( "ui_mj_event_1" ) )
	self.Container.CountDown1:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Container:addElement( self.Container.CountDown1 )

	self.Container.CountDownGo = LUI.UIImage.new()
	self.Container.CountDownGo:setLeftRight( false, false, -128, 128 )
	self.Container.CountDownGo:setTopBottom( false, false, -100, 156 )
	self.Container.CountDownGo:setImage( RegisterImage( "ui_mj_event_go" ) )
	self.Container.CountDownGo:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Container:addElement( self.Container.CountDownGo )

	self:subscribeToGlobalModel( controller, "PerController", "scriptNotify", function( model )
		if IsParamModelEqualToString( model, "start_race" ) then
			local notifyData = CoD.GetScriptNotifyData( model )
			self:playClip( "StartRace" )
			self.Container:playClip( "StartRace" )
		end
	end )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function()
				self:setupElementClipCounter( 1 )

				self.Container:completeAnimation()
				self.Container:setAlpha( 0 )
				self.clipFinished( self.Container, {} )
			end,
			StartRace = function()
				self:setupElementClipCounter( 1 )

				self.Container:completeAnimation()
				self.Container:setAlpha( 0 )
				local HandleCountDownContainer = function ( Element, Event ) -- 3 fade in
					if not Event.interrupted then
						Element:beginAnimation( "keyframe", 500, true, true, CoD.TweenType.Linear )
					end
					Element:setAlpha( 1 )
					self:playSound( "countdown1and2", controller )
					Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event ) -- 3 fade out
						if not Event.interrupted then
							Element:beginAnimation( "keyframe", 500, true, true, CoD.TweenType.Linear )
						end
						Element:setAlpha( 0 )
						if Event.interrupted then
							self.clipFinished( Element, Event )
						else
							Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event ) -- 2 fade in
								if not Event.interrupted then
									Element:beginAnimation( "keyframe", 500, true, true, CoD.TweenType.Linear )
								end
								Element:setAlpha( 1 )
								self:playSound( "countdown1and2", controller )
								if Event.interrupted then
									self.clipFinished( Element, Event )
								else
									Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event ) -- 2 fade out
										if not Event.interrupted then
											Element:beginAnimation( "keyframe", 500, true, true, CoD.TweenType.Linear )
										end
										Element:setAlpha( 0 )
										if Event.interrupted then
											self.clipFinished( Element, Event )
										else
											Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event ) -- 1 fade in
												if not Event.interrupted then
													Element:beginAnimation( "keyframe", 500, true, true, CoD.TweenType.Linear )
												end
												Element:setAlpha( 1 )
												self:playSound( "countdown3", controller )
												if Event.interrupted then
													self.clipFinished( Element, Event )
												else
													Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event ) -- 1 fade out
														if not Event.interrupted then
															Element:beginAnimation( "keyframe", 500, true, true, CoD.TweenType.Linear )
														end
														Element:setAlpha( 0 )
														if Event.interrupted then
															self.clipFinished( Element, Event )
														else
															Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event ) -- GO fade in
																if not Event.interrupted then
																	Element:beginAnimation( "keyframe", 500, true, true, CoD.TweenType.Linear )
																end
																Element:setAlpha( 1 )
																self:playSound( "countdowngo", controller )
																if Event.interrupted then
																	self.clipFinished( Element, Event )
																else
																	Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event ) -- GO fade out
																		if not Event.interrupted then
																			Element:beginAnimation( "keyframe", 500, true, true, CoD.TweenType.Linear )
																		end
																		Element:setAlpha( 0 )
																		if Event.interrupted then
																			self.clipFinished( Element, Event )
																		else
																			Element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
																		end
																	end )
																end
															end )
														end
													end )
												end
											end )
										end
									end )
								end
							end )
						end
					end )
				end

				HandleCountDownContainer( self.Container, {} )
			end
		}
	}

	-- this handles our scaling
	self.Container.clipsPerState = {
		DefaultState = {
			DefaultClip = function()
				self.Container:setupElementClipCounter( 4 )

				self.Container.CountDown3:completeAnimation()
				self.Container.CountDown3:setScale( 0 )
				self.Container.clipFinished( self.Container.CountDown3, {} )

				self.Container.CountDown2:completeAnimation()
				self.Container.CountDown2:setScale( 0 )
				self.Container.clipFinished( self.Container.CountDown2, {} )

				self.Container.CountDown1:completeAnimation()
				self.Container.CountDown1:setScale( 0 )
				self.Container.clipFinished( self.Container.CountDown1, {} )

				self.Container.CountDownGo:completeAnimation()
				self.Container.CountDownGo:setScale( 0 )
				self.Container.clipFinished( self.Container.CountDownGo, {} )
			end,
			StartRace = function()
				self.Container:setupElementClipCounter( 4 )

				self.Container.CountDown3:completeAnimation()
				self.Container.CountDown3:setScale( 0 )
				local HandleCountDown3 = function ( Element, Event )
					if not Event.interrupted then
						Element:beginAnimation( "keyframe", CoD.StartRaceNotify.BlendTime, true, true, CoD.TweenType.Linear )
					end
					Element:setScale( 2 )
					Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event )
						if not Event.interrupted then
							Element:beginAnimation( "keyframe", 25, true, true, CoD.TweenType.Linear )
						end
						Element:setScale( 0 )
						if Event.interrupted then
							self.Container.clipFinished( Element, Event )
						else
							Element:registerEventHandler( "transition_complete_keyframe", self.Container.clipFinished )
						end
					end )
				end

				HandleCountDown3( self.Container.CountDown3, {} )

				self.Container.CountDown2:completeAnimation()
				self.Container.CountDown2:setScale( 0 )
				local HandleCountDown2 = function ( Element, Event )
					if not Event.interrupted then
						Element:beginAnimation( "keyframe", 1000, true, true, CoD.TweenType.Linear )
					end
					Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event )
						if not Event.interrupted then
							Element:beginAnimation( "keyframe", CoD.StartRaceNotify.BlendTime, true, true, CoD.TweenType.Linear )
						end
						Element:setScale( 2 )
						if Event.interrupted then
							self.Container.clipFinished( Element, Event )
						else
							Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event )
								if not Event.interrupted then
									Element:beginAnimation( "keyframe", 25, true, true, CoD.TweenType.Linear )
								end
								Element:setScale( 0 )
								if Event.interrupted then
									self.Container.clipFinished( Element, Event )
								else
									Element:registerEventHandler( "transition_complete_keyframe", self.Container.clipFinished )
								end
							end )
						end
					end )
				end

				HandleCountDown2( self.Container.CountDown2, {} )

				self.Container.CountDown1:completeAnimation()
				self.Container.CountDown1:setScale( 0 )
				local HandleCountDown1 = function ( Element, Event )
					if not Event.interrupted then
						Element:beginAnimation( "keyframe", 2000, true, true, CoD.TweenType.Linear )
					end
					Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event )
						if not Event.interrupted then
							Element:beginAnimation( "keyframe", CoD.StartRaceNotify.BlendTime, true, true, CoD.TweenType.Linear )
						end
						Element:setScale( 2 )
						if Event.interrupted then
							self.Container.clipFinished( Element, Event )
						else
							Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event )
								if not Event.interrupted then
									Element:beginAnimation( "keyframe", 25, true, true, CoD.TweenType.Linear )
								end
								Element:setScale( 0 )
								if Event.interrupted then
									self.Container.clipFinished( Element, Event )
								else
									Element:registerEventHandler( "transition_complete_keyframe", self.Container.clipFinished )
								end
							end )
						end
					end )
				end

				HandleCountDown1( self.Container.CountDown1, {} )

				self.Container.CountDownGo:completeAnimation()
				self.Container.CountDownGo:setScale( 0 )
				local HandleCountDownGo = function ( Element, Event )
					if not Event.interrupted then
						Element:beginAnimation( "keyframe", 3000, true, true, CoD.TweenType.Linear )
					end
					Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event )
						if not Event.interrupted then
							Element:beginAnimation( "keyframe", CoD.StartRaceNotify.BlendTime, true, true, CoD.TweenType.Linear )
						end
						Element:setScale( 2 )
						if Event.interrupted then
							self.Container.clipFinished( Element, Event )
						else
							Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event )
								if not Event.interrupted then
									Element:beginAnimation( "keyframe", 25, true, true, CoD.TweenType.Linear )
								end
								Element:setScale( 0 )
								if Event.interrupted then
									self.Container.clipFinished( Element, Event )
								else
									Element:registerEventHandler( "transition_complete_keyframe", self.Container.clipFinished )
								end
							end )
						end
					end )
				end

				HandleCountDownGo( self.Container.CountDownGo, {} )
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function( element )
		element.Container.CountDown3:close()
		element.Container.CountDown2:close()
		element.Container.CountDown1:close()
		element.Container.CountDownGo:close()
		element.Container:close()
	end )

	return self
end