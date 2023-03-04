require( "UI.SubscriptionUtils" )

-- SoundSet is located in PositionWidget.

CoD.EndGameResultsRow = InheritFrom( LUI.UIElement )
function CoD.EndGameResultsRow.new( menu, controller )

	local self = LUI.UIElement.new()
	self:setLeftRight( true, false, 0, 730 )
	self:setTopBottom( true, false, 0, 70 )

	self:setUseStencil( false )
	self:setClass( CoD.EndGameResultsRow )
	self.id = "EndGameResultsRow"
	self.soundSet = "Positions"
	self.anyChildUsesUpdateState = true

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self.delayTime = 0
	self.hasAnimated = false

	self.Parent = LUI.UIElement.new()
	self.Parent:setLeftRight( true, true, 0, 0 )
	self.Parent:setTopBottom( true, true, 0, 0 )
	self:addElement( self.Parent )

	self.RowImage = LUI.UIImage.new()
	self.RowImage:setLeftRight( true, true, 0, 0 )
	self.RowImage:setTopBottom( true, true, 0, 0 )
	self.RowImage:setImage( RegisterImage( "ui_mj_scoreboard_row_other_odd" ) )
	self.RowImage:linkToElementModel( self, "clientNumScoreInfoUpdated", true, function ( modelRef )
		local clientNumScoreInfoUpdated = Engine.GetModelValue( modelRef )
		if clientNumScoreInfoUpdated then
			local Position = tonumber( GetScoreboardPlayerScoreColumn( controller, 0, clientNumScoreInfoUpdated ) )
			if Position then
				self.delayTime = Position * 500
				if IsScoreboardPlayerSelf( self, controller ) then
					self.RowImage:setImage( RegisterImage( "ui_mj_scoreboard_row_self" ) )
					return
				end
				local isEven = Position % 2 == 0
				if isEven == true then
					self.RowImage:setImage( RegisterImage( "ui_mj_scoreboard_row_other_even" ) )
				else
					self.RowImage:setImage( RegisterImage( "ui_mj_scoreboard_row_other_odd" ) )
				end
			end
		end
	end )
	self.Parent:addElement( self.RowImage )

	self.RankImage = LUI.UIImage.new()
	self.RankImage:setLeftRight( true, false, -68, 76 )
	self.RankImage:setTopBottom( true, false, -40, 64 )
	self.RankImage:setImage( RegisterImage( "ui_mj_scoreboard_row_other" ) )
	self.RankImage:linkToElementModel( self, "clientNumScoreInfoUpdated", true, function ( modelRef )
		local clientNumScoreInfoUpdated = Engine.GetModelValue( modelRef )
		if clientNumScoreInfoUpdated then
			local Position = tonumber( GetScoreboardPlayerScoreColumn( controller, 0, clientNumScoreInfoUpdated ) )
			if Position then
				if Position == 1 then
					self.RankImage:setImage( RegisterImage( "ui_mj_scoreboard_row_first" ) )
				else
					self.RankImage:setImage( RegisterImage( "ui_mj_scoreboard_row_other" ) )
				end
			end
		end
	end )
	self.Parent:addElement( self.RankImage )

	self.RankText = LUI.UIText.new()
	self.RankText:setLeftRight( true, false, -6, 70 )
	self.RankText:setTopBottom( true, false, 0, 50 )
	self.RankText:setTTF( "fonts/Molde-Condensed-BoldItalic.ttf" )
	self.RankText:setText( "0" )
	self.RankText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.RankText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_TOP )
	self.RankText:linkToElementModel( self, "clientNumScoreInfoUpdated", true, function ( modelRef )
		local clientNumScoreInfoUpdated = Engine.GetModelValue( modelRef )
		if clientNumScoreInfoUpdated then
			local Position = tonumber( GetScoreboardPlayerScoreColumn( controller, 0, clientNumScoreInfoUpdated ) )
			if Position then
				if Position == 1 then
					self.RankText:setText( "" )
				else
					self.RankText:setText( Engine.Localize( Position ) )
				end
			end
		end
	end )
	self.Parent:addElement( self.RankText )

	self.PlayerName = LUI.UIText.new()
	self.PlayerName:setLeftRight( true, false, 41, 294 )
	self.PlayerName:setTopBottom( true, false, 16, 50 )
	self.PlayerName:setTTF( "fonts/Molde-Condensed-BoldItalic.ttf" )
	self.PlayerName:setText( "" )
	self.PlayerName:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.PlayerName:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_TOP )
	self.PlayerName:linkToElementModel( self, "clientNum", true, function ( modelRef )
		local clientNum = Engine.GetModelValue( modelRef )
		if clientNum then
			self.PlayerName:setText( Engine.ToUpper( GetClientNameAndClanTag( controller, clientNum ) ) )
		end
	end )
	self.Parent:addElement( self.PlayerName )

	self.StatusText = LUI.UIText.new()
	self.StatusText:setLeftRight( false, true, 234, -60 )
	self.StatusText:setTopBottom( true, false, 16, 50 )
	self.StatusText:setTTF( "fonts/Molde-Condensed-BoldItalic.ttf" )
	self.StatusText:setText( "" )
	self.StatusText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.StatusText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_TOP )
	self.StatusText:linkToElementModel( self, "clientNumScoreInfoUpdated", true, function ( modelRef )
		local clientNumScoreInfoUpdated = Engine.GetModelValue( modelRef )
		if clientNumScoreInfoUpdated then
			local Position = tonumber( GetScoreboardPlayerScoreColumn( controller, 0, clientNumScoreInfoUpdated ) )
			if Position then
				if Dvar.ui_gametype:get() == "eliminator" then
					if Position == 1 then
						self.StatusText:setText( "FINISHED" )
					else
						self.StatusText:setText( "ELIMINATED" )
					end
				elseif Dvar.ui_gametype:get() == "circuit" or Dvar.ui_gametype:get() == "head2head" then
					local Time = GetScoreboardPlayerScoreColumn( controller, 5, clientNumScoreInfoUpdated )
					--self.StatusText:setText( NumbersToTime( Time ) )
					self.StatusText:setText( Time )
				end
				if self.hasAnimated == false then
					self:playClip( "PlayAnim" )
					self.hasAnimated = true
				end
			end
		end
	end )
	self.Parent:addElement( self.StatusText )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function()
				self:setupElementClipCounter( 1 )

				self.Parent:completeAnimation()
				self.Parent:setLeftRight( true, true, -1080, -1080 )
				self.clipFinished( self.Parent, {} )
			end,
			PlayAnim = function()
				self:setupElementClipCounter( 1 )

				self.Parent:completeAnimation()
				self.Parent:setLeftRight( true, true, -1080, -1080 )
				local HandleParent = function ( Element, Event )
					if not Event.interrupted then
						Element:beginAnimation( "keyframe", self.delayTime, true, true, CoD.TweenType.Linear )
					end
					Element:registerEventHandler( "transition_complete_keyframe", function ( Element, Event )
						if not Event.interrupted then
							Element:beginAnimation( "keyframe", 250, true, true, CoD.TweenType.Linear )
						end
						self:playSound( "slider_anim", controller )
						Element:setLeftRight( true, true, 0, 0 )
						if Event.interrupted then
							self.clipFinished( Element, Event )
						else
							Element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
						end
					end )
				end

				HandleParent( self.Parent, {} )
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.RowImage:close()
	end )

	return self
end