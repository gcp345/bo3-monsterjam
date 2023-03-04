require( "UI.SubscriptionUtils" )
require( "ui.lui.LUITextToImage" )

require( "ui.uieditor.widgets.UIShadowText" )

local function IsCrossCountry()
	if Dvar.ui_gametype:get() == "znml" then
		return 0
	end
	return 1
end

local function GetCurrentTime(CurrentGameTime, StartTime, PausedTime)
	return CurrentGameTime - StartTime - PausedTime
end

function NumbersToTime( stringReturn )
	local minutes = math.floor( stringReturn / 60000 )
	local seconds = math.floor( (stringReturn - minutes * 60000) / 1000 )
	local msText = stringReturn % 1000
	if seconds < 10 then
		seconds = "0" .. seconds
	end
	if msText < 10 then
		msText = "00" .. msText
	elseif msText < 100 then
		msText = "0" .. msText
	end
	return minutes .. ":" .. seconds .. ":" .. msText
end

CoD.ScoreWidget = InheritFrom( LUI.UIElement )
CoD.ScoreWidget.Prematch = 0
CoD.ScoreWidget.Started = 1
CoD.ScoreWidget.Finished = 2
CoD.ScoreWidget.Paused = 3

--lilrifa is a chad for this
local function CreateAndSetupTimer(self, menu, controller)
	if IsCrossCountry() == 0 then
		return
	end

	menu:subscribeToModel(Engine.CreateModel(Engine.GetGlobalModel(), "fastRestart"), function(ModelRef)
		self.TimeCount:setText( Engine.Localize( NumbersToTime( 0 ) ) )
	end, false)

	menu._timer = LUI.UITimer.new(1, "update_game_timer", false)
	menu:addElement(menu._timer)
	
	LUI.OverrideFunction_CallOriginalFirst(menu, "close", function()
		menu._timer:close()
	end)

	menu:registerEventHandler("update_game_timer", function(element, event)
		local StartTimeModel = Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckTimeStart" )
		local StateModel = Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckTimeState" )

		if StartTimeModel and StateModel then
			local StartTime = Engine.GetModelValue(StartTimeModel)
			local State = Engine.GetModelValue(StateModel)
			local PausedTime = 0

			if StartTime ~= nil and StartTime ~= 0 then
				if State == CoD.ScoreWidget.Started then
					local currentTime = GetCurrentTime(Engine.CurrentGameTime(), StartTime, PausedTime)
					if currentTime < 0 then
						currentTime = 0
					end

					self.TimeCount:setText( Engine.Localize( NumbersToTime( currentTime ) ) )
					--Engine.SetModelValue(CurrentTimeModel, currentTime)
				elseif State == CoD.ScoreWidget.Finished then
					local FinishTimeModel = Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckTimeFinish" )
					if FinishTimeModel then
						self.TimeCount:setText( Engine.Localize( NumbersToTime( Engine.GetModelValue( FinishTimeModel ) ) ) )
						--Engine.SetModelValue(CurrentTimeModel, Engine.GetModelValue(FinishTimeModel))
					end
				elseif State == CoD.ScoreWidget.Paused then
					if GetCurrentTime(Engine.CurrentGameTime(), StartTime, PausedTime) < 0 then
						local currentTime = 0
					end
				else
					self.TimeCount:setText( Engine.Localize( NumbersToTime( 0 ) ) )
					--Engine.SetModelValue(CurrentTimeModel, 0)
				end
			end
		end
	end)
end

local function setupClipsPerState( self, element )

	-- save the elements positions
	local LeftAnchor, RightAnchor, LeftOffset, RightOffset = element:getLocalLeftRight()
	local TopAnchor, BottomAnchor, TopOffset, BottomOffset = element:getLocalTopBottom()

	element.clipsPerState = {
		DefaultState = {
			DefaultClip = function()
				self:setupElementClipCounter( 1 )

				element:completeAnimation()
				element:setLeftRight( LeftAnchor, RightAnchor, LeftOffset, RightOffset )
				element:setTopBottom( TopAnchor, BottomAnchor, TopOffset, BottomOffset )
				element:setAlpha( 0.0 )
				element:setScale( 1.0 )
				self.clipFinished( element, {} )
			end,
			FadeIn = function()
				self:setupElementClipCounter( 1 )

				element:completeAnimation()
				element:setLeftRight( LeftAnchor, RightAnchor, LeftOffset + 1000, RightOffset + 1000 )
				element:setTopBottom( TopAnchor, BottomAnchor, TopOffset, BottomOffset )
				element:setAlpha( 0.0 )
				element:setScale( 1.0 )

				local HandleTextFade = function (Element, Event)
					if not Event.interrupted then
						Element:beginAnimation("keyframe", 200, true, true, CoD.TweenType.Linear)
					end
					Element:setLeftRight( LeftAnchor, RightAnchor, LeftOffset, RightOffset )
					Element:setAlpha(1.0)
					Element:registerEventHandler("transition_complete_keyframe", function (Sender, Event)
						if not Event.interrupted then
							Sender:beginAnimation("keyframe", 50, true, true, CoD.TweenType.Linear)
						end
						Element:setScale(0.5)
						if Event.interrupted then
							self.clipFinished(Sender, Event)
						else
							Sender:registerEventHandler("transition_complete_keyframe", function (Sender, Event)
								if not Event.interrupted then
									Sender:beginAnimation("keyframe", 50, true, true, CoD.TweenType.Linear)
								end
								Element:setScale(1.0)
								if Event.interrupted then
									self.clipFinished(Element, Event)
								else
									Element:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end)
						end
					end)
				end

				HandleTextFade( element, {} )
			end,
			FadeOut = function()
				self:setupElementClipCounter( 1 )

				element:completeAnimation()
				element:setLeftRight( LeftAnchor, RightAnchor, LeftOffset, RightOffset )
				element:setTopBottom( TopAnchor, BottomAnchor, TopOffset, BottomOffset )
				element:setAlpha( 1.0 )
				element:setScale( 1.0 )
				element:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				element:setLeftRight( LeftAnchor, RightAnchor, LeftOffset - 1000, RightOffset - 1000 )
				element:setAlpha( 0.0 )
				element:setScale( 1.0 )
				element:registerEventHandler( "transition_complete_keyframe", function( Sender, Event )
					self.clipFinished( Sender, Event )
				end)
			end,
			CashOrCancel = function()
				self:setupElementClipCounter( 1 )

				element:completeAnimation()
				element:setLeftRight( LeftAnchor, RightAnchor, LeftOffset, RightOffset )
				element:setTopBottom( TopAnchor, BottomAnchor, TopOffset, BottomOffset )
				element:setAlpha( 1.0 )
				element:setScale( 1.0 )
				element:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Linear )
				element:setAlpha( 0.0 )
				element:registerEventHandler( "transition_complete_keyframe", function( Sender, Event )
					self.clipFinished( Sender, Event )
				end)
			end
		}
	}
end

CoD.ScoreWidget.Hide = 0
CoD.ScoreWidget.Show = 1
CoD.ScoreWidget.CashIn = 2
CoD.ScoreWidget.Cancel = 3

CoD.ScoreWidget.BitToTrick = {}
CoD.ScoreWidget.BitToTrick[ 1 ] = "MonsterSmash"
CoD.ScoreWidget.BitToTrick[ 2 ] = "Smash"
CoD.ScoreWidget.BitToTrick[ 3 ] = "Crush"
CoD.ScoreWidget.BitToTrick[ 4 ] = "AirTime"
CoD.ScoreWidget.BitToTrick[ 5 ] = "Donut"
CoD.ScoreWidget.BitToTrick[ 6 ] = "Wheelie"

-- this is so we can keep up with what GSC does
-- if we add new tricks we just need to adjust stuff above, none is always the last index
CoD.ScoreWidget.BitToTrick[ #CoD.ScoreWidget.BitToTrick + 1 ] = "None"

local function CreateAndSetupScore( self, menu, controller )
	setupClipsPerState( self, self.PointTypeSmash )
	setupClipsPerState( self, self.PointTypeMonsterSmash )
	setupClipsPerState( self, self.PointTypeCrush )
	setupClipsPerState( self, self.PointTypeDonut )
	setupClipsPerState( self, self.PointTypeAirTime )
	setupClipsPerState( self, self.PointTypeWheelie )
	setupClipsPerState( self, self.PointTypeNone )
	setupClipsPerState( self, self.PointTypeFirstTime )

	self.currentTrick = self.PointTypeNone
	self.scoreState = CoD.ScoreWidget.Hide
	self.currentPoints = 0
	self.multiplier = 1

	menu:subscribeToModel(Engine.CreateModel(Engine.GetGlobalModel(), "fastRestart"), function(ModelRef)
		if self.currentTrick then
			self.currentTrick:playClip( "CashOrCancel" )
		end
		self.currentTrick = self.PointTypeNone
		self.scoreState = CoD.ScoreWidget.Hide
		self.currentPoints = 0
		self.multiplier = 1
	end, false)

	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckScoreState" ), function( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue then
			self.scoreState = modelValue
			if self.scoreState == CoD.ScoreWidget.CashIn then
				local TotalPoints = self.currentPoints * self.multiplier
				self.PointTypeCounterFake:setText( TotalPoints )
				self.PointTypeCounterFake:playClip( "CashIn" )
				if self.currentTrick then
					self.currentTrick:playClip( "CashOrCancel" )
				end
				self.currentPoints = 0
				self.multiplier = 1
				self.currentTrick = self.PointTypeNone
			elseif self.scoreState == CoD.ScoreWidget.Cancel then
				self.PointTypeCounterFake:setText( "0" )
				self.PointTypeCounterFake:playClip( "Cancel" )
				if self.currentTrick then
					self.currentTrick:playClip( "CashOrCancel" )
				end
				self.currentPoints = 0
				self.multiplier = 1
				self.currentTrick = self.PointTypeNone
			end
		end
	end )

	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckScoreType" ), function( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue and #CoD.ScoreWidget.BitToTrick > 0 then
			if modelValue <= #CoD.ScoreWidget.BitToTrick and modelValue > 0 then
				local element = self[ "PointType" .. CoD.ScoreWidget.BitToTrick[ modelValue ] ]
				if element then
					if self.currentTrick then
						self.currentTrick:playClip( "FadeOut" )
					end
					self.currentTrick = element
					element:playClip( "FadeIn" )
				end
			else
				if self.currentTrick then
					self.currentTrick:playClip( "FadeOut" )
				end
				self.currentTrick = self.PointTypeNone
			end
		end
	end )

	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckScoreMultiplier" ), function( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue then
			if modelValue == 1 then
				self.PointTypeMultiplier:setText( "" )
				self.multiplier = 1
			elseif modelValue > 1 then
				self.PointTypeMultiplier:setText( "x" .. modelValue )
				self.multiplier = modelValue
			else
				self.PointTypeMultiplier:setText( "" )
			end
		end
	end )

	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckScore" ), function( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue then
			if modelValue > 0 then
				self.PointTypeCounter:setText( modelValue )
				self.currentPoints = modelValue
			else
				self.PointTypeCounter:setText( "" )
			end
		end
	end )

	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckScoreTotal" ), function( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue then
			self.ScoreCount:setText( modelValue )
		end
	end )

	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckScoreFTB" ), function( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue then
			if modelValue == 1 then
				self.PointTypeFirstTime:playClip( "FadeIn" )
			else
				self.PointTypeFirstTime:playClip( "CashOrCancel" )
			end
		end
	end )
end

local function PostLoadFunc( self, menu, controller )
	CreateAndSetupTimer( self, menu, controller )
	CreateAndSetupScore( self, menu, controller )
end

function CoD.ScoreWidget.new( menu, controller )
	local self = LUI.UIElement.new()
	self:setLeftRight( false, false, -150, 150 )
	self:setTopBottom( true, false, 0, 250 )

	self:setUseStencil( false )
	self:setClass( CoD.ScoreWidget )
	self.id = "ScoreWidget"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self.PointBG = LUI.UIImage.new()
	self.PointBG:setLeftRight( true, true, 17, 17 )
	self.PointBG:setTopBottom( true, false, -25, 117 )
	self.PointBG:setImage( RegisterImage( "ui_mj_points_bg" ) )
	self.PointBG:setAlpha( IsCrossCountry() )
	self:addElement( self.PointBG )

	self.ScoreCount = CoD.UIShadowText.new()
	self.ScoreCount:setLeftRight( false, false, -156, 156 )
	self.ScoreCount:setTopBottom( true, false, 22, 58 )
	self.ScoreCount:setText( "0" )
	self.ScoreCount:setScale( 1.5 )
	self.ScoreCount:setAlignment( LUI.Alignment.Center )
	self.ScoreCount:setAlpha( IsCrossCountry() )
	self.ScoreCount:setTTF( "fonts/Molde-Condensed-BoldItalic.ttf" )
	self:addElement( self.ScoreCount )

	self.TimeCount = CoD.UIShadowText.new()
	self.TimeCount:setLeftRight( false, false, -156, 156 )
	self.TimeCount:setTopBottom( true, false, 68, 90 )
	self.TimeCount:setText( Engine.Localize( NumbersToTime( 0 ) ) )
	self.TimeCount:setScale( 1.2 )
	self.TimeCount:setRGB( 0.9, 0.8, 0.6 )
	self.TimeCount:setAlignment( LUI.Alignment.Center )
	self.TimeCount:setAlpha( IsCrossCountry() )
	self.TimeCount:setTTF( "fonts/Molde-Condensed-BoldItalic.ttf" )
	self.TimeCount:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckTime" ), function( model )
		local currentTime = Engine.GetModelValue( model )
		if currentTime then
			self.TimeCount:setText( Engine.Localize( NumbersToTime( currentTime ) ) )
		end
	end )
	self:addElement( self.TimeCount )

	self.PointTypeCounter = CoD.UIShadowText.new()
	self.PointTypeCounter:setLeftRight( false, false, -156, 156 )
	self.PointTypeCounter:setTopBottom( true, false, 115, 160 )
	self.PointTypeCounter:setText( "" )
	self.PointTypeCounter:setScale( 1.2 )
	self.PointTypeCounter:setAlignment( LUI.Alignment.Center )
	self.PointTypeCounter:setRGB( 0.9, 0.8, 0.6 )
	self.PointTypeCounter:setAlpha( 1 )
	self.PointTypeCounter:setTTF( "fonts/Molde-Condensed-BoldItalic.ttf" )
	self:addElement( self.PointTypeCounter )

	self.PointTypeCounterFake = CoD.UIShadowText.new()
	self.PointTypeCounterFake:setLeftRight( false, false, -156, 156 )
	self.PointTypeCounterFake:setTopBottom( true, false, 115, 160 )
	self.PointTypeCounterFake:setText( "" )
	self.PointTypeCounterFake:setScale( 1.2 )
	self.PointTypeCounterFake:setAlignment( LUI.Alignment.Center )
	self.PointTypeCounterFake:setRGB( 0.9, 0.8, 0.6 )
	self.PointTypeCounterFake:setAlpha( 1 )
	self.PointTypeCounterFake:setTTF( "fonts/Molde-Condensed-BoldItalic.ttf" )
	self:addElement( self.PointTypeCounterFake )

	-- yes I know I'm going to fix it fuck off
	-- maybe uh look above? admire the timer code?
	self.PointTypeCounterFake.clipsPerState = {
		DefaultState = {
			DefaultClip = function()
				self.PointTypeCounterFake:setupElementClipCounter( 2 )

				self.PointTypeCounterFake.Text:completeAnimation()
				self.PointTypeCounterFake.Text:setAlpha( 1.0 )
				self.PointTypeCounterFake.Text:setScale( 1.0 )
				self.PointTypeCounterFake.Text:setTopBottom( true, false, 115, 160 )
				self.PointTypeCounterFake.Text:setRGB( 0.9, 0.8, 0.6 )
				self.PointTypeCounterFake.clipFinished( self.PointTypeCounterFake.Text, {} )

				self.PointTypeCounterFake.TextShadow:completeAnimation()
				self.PointTypeCounterFake.TextShadow:setAlpha( 1.0 )
				self.PointTypeCounterFake.TextShadow:setScale( 1.0 )
				self.PointTypeCounterFake.TextShadow:setTopBottom( true, false, 115, 160 )
				self.PointTypeCounterFake.TextShadow:setRGB( 0.15, 0.15, 0.15 )
				self.PointTypeCounterFake.clipFinished( self.PointTypeCounterFake.TextShadow, {} )
			end,
			CashIn = function()
				self.PointTypeCounterFake:setupElementClipCounter( 2 )

				self.PointTypeCounterFake.Text:completeAnimation()
				self.PointTypeCounterFake.Text:setAlpha( 1.0 )
				self.PointTypeCounterFake.Text:setScale( 1.0 )
				self.PointTypeCounterFake.Text:setTopBottom( true, false, 115, 160 )
				self.PointTypeCounterFake.Text:setRGB( 0.9, 0.8, 0.6 )
				self.PointTypeCounterFake.Text:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
				self.PointTypeCounterFake.Text:setAlpha( 0.0 )
				self.PointTypeCounterFake.Text:setScale( 2.0 )
				self.PointTypeCounterFake.clipFinished( self.PointTypeCounterFake.Text, {} )

				self.PointTypeCounterFake.TextShadow:completeAnimation()
				self.PointTypeCounterFake.TextShadow:setAlpha( 1.0 )
				self.PointTypeCounterFake.TextShadow:setScale( 1.0 )
				self.PointTypeCounterFake.TextShadow:setTopBottom( true, false, 115, 160 )
				self.PointTypeCounterFake.TextShadow:setRGB( 0.9, 0.8, 0.6 )
				self.PointTypeCounterFake.TextShadow:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
				self.PointTypeCounterFake.TextShadow:setAlpha( 0.0 )
				self.PointTypeCounterFake.TextShadow:setScale( 2.0 )
				self.PointTypeCounterFake.clipFinished( self.PointTypeCounterFake.TextShadow, {} )
			end,
			Cancel = function()
				self.PointTypeCounterFake:setupElementClipCounter( 2 )

				self.PointTypeCounterFake.Text:completeAnimation()
				self.PointTypeCounterFake.Text:setAlpha( 1.0 )
				self.PointTypeCounterFake.Text:setScale( 1.0 )
				self.PointTypeCounterFake.Text:setTopBottom( true, false, 115, 160 )
				self.PointTypeCounterFake.Text:setRGB( 0.9, 0.8, 0.6 )
				self.PointTypeCounterFake.Text:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
				self.PointTypeCounterFake.Text:setAlpha( 0.0 )
				self.PointTypeCounterFake.Text:setTopBottom( true, false, 115 + 100, 160 + 100 )
				self.PointTypeCounterFake.Text:setRGB( 0.9, 0.3, 0.3 )
				self.PointTypeCounterFake.clipFinished( self.PointTypeCounterFake.Text, {} )

				self.PointTypeCounterFake.TextShadow:completeAnimation()
				self.PointTypeCounterFake.TextShadow:setAlpha( 1.0 )
				self.PointTypeCounterFake.TextShadow:setScale( 1.0 )
				self.PointTypeCounterFake.TextShadow:setTopBottom( true, false, 115, 160 )
				self.PointTypeCounterFake.TextShadow:setRGB( 0.9, 0.8, 0.6 )
				self.PointTypeCounterFake.TextShadow:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
				self.PointTypeCounterFake.TextShadow:setAlpha( 0.0 )
				self.PointTypeCounterFake.TextShadow:setTopBottom( true, false, 115 + 100, 160 + 100 )
				self.PointTypeCounterFake.clipFinished( self.PointTypeCounterFake.TextShadow, {} )
			end
		}
	}

	self.PointTypeMultiplier = CoD.UIShadowText.new()
	self.PointTypeMultiplier:setLeftRight( false, false, 0, 150 )
	self.PointTypeMultiplier:setTopBottom( true, false, 115, 150 )
	self.PointTypeMultiplier:setText( "" )
	self.PointTypeMultiplier:setScale( 1 )
	self.PointTypeMultiplier:setAlignment( LUI.Alignment.Center )
	self.PointTypeMultiplier:setRGB( 0.855, 0.98, 0.561 )
	self.PointTypeMultiplier:setAlpha( 1 )
	self.PointTypeMultiplier:setTTF( "fonts/Molde-Condensed-BoldItalic.ttf" )
	self:addElement( self.PointTypeMultiplier )

	self.PointTypeNone = LUI.UIElement.new()
	self.PointTypeNone:setLeftRight( false, false, -150, 150 )
	self.PointTypeNone:setTopBottom( true, false, 0, 250 )
	self:addElement( self.PointTypeNone )

	self.PointTypeSmash = LUI.UITextToImage.new()
	self.PointTypeSmash:setLeftRight( false, false, -135, 135 )
	self.PointTypeSmash:setTopBottom( false, false, 15, 90 )
	self.PointTypeSmash:setPrefix( "ui_mj_hud_letter_" )
	self.PointTypeSmash:setAlpha( 0 )
	self.PointTypeSmash:setProperties( 1, 61, 70, 0.6 )
	self.PointTypeSmash:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.PointTypeSmash:setText( "SMASH!", false )
	self:addElement( self.PointTypeSmash )

	self.PointTypeMonsterSmash = LUI.UITextToImage.new()
	self.PointTypeMonsterSmash:setLeftRight( false, false, -300, 200 )
	self.PointTypeMonsterSmash:setTopBottom( false, false, 15, 90 )
	self.PointTypeMonsterSmash:setPrefix( "ui_mj_hud_letter_" )
	self.PointTypeMonsterSmash:setAlpha( 0 )
	self.PointTypeMonsterSmash:setProperties( 1, 61, 70, 0.6 )
	self.PointTypeMonsterSmash:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.PointTypeMonsterSmash:setText( "MONSTER SMASH!", false )
	self:addElement( self.PointTypeMonsterSmash )

	self.PointTypeCrush = LUI.UITextToImage.new()
	self.PointTypeCrush:setLeftRight( false, false, -135, 135 )
	self.PointTypeCrush:setTopBottom( false, false, 15, 90 )
	self.PointTypeCrush:setPrefix( "ui_mj_hud_letter_" )
	self.PointTypeCrush:setAlpha( 0 )
	self.PointTypeCrush:setProperties( 1, 61, 70, 0.6 )
	self.PointTypeCrush:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.PointTypeCrush:setText( "CRUSH!", false )
	self:addElement( self.PointTypeCrush )

	self.PointTypeDonut = LUI.UITextToImage.new()
	self.PointTypeDonut:setLeftRight( false, false, -135, 135 )
	self.PointTypeDonut:setTopBottom( false, false, 15, 90 )
	self.PointTypeDonut:setPrefix( "ui_mj_hud_letter_" )
	self.PointTypeDonut:setAlpha( 0 )
	self.PointTypeDonut:setProperties( 1, 61, 70, 0.6 )
	self.PointTypeDonut:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.PointTypeDonut:setText( "DONUT!", false )
	self:addElement( self.PointTypeDonut )

	self.PointTypeAirTime = LUI.UITextToImage.new()
	self.PointTypeAirTime:setLeftRight( false, false, -190, 135 )
	self.PointTypeAirTime:setTopBottom( false, false, 15, 90 )
	self.PointTypeAirTime:setPrefix( "ui_mj_hud_letter_" )
	self.PointTypeAirTime:setAlpha( 0 )
	self.PointTypeAirTime:setProperties( 1, 61, 70, 0.6 )
	self.PointTypeAirTime:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.PointTypeAirTime:setText( "AIR TIME!", false )
	self:addElement( self.PointTypeAirTime )

	self.PointTypeWheelie = LUI.UITextToImage.new()
	self.PointTypeWheelie:setLeftRight( false, false, -170, 135 )
	self.PointTypeWheelie:setTopBottom( false, false, 15, 90 )
	self.PointTypeWheelie:setPrefix( "ui_mj_hud_letter_" )
	self.PointTypeWheelie:setAlpha( 0 )
	self.PointTypeWheelie:setProperties( 1, 61, 70, 0.6 )
	self.PointTypeWheelie:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.PointTypeWheelie:setText( "WHEELIE!", false )
	self:addElement( self.PointTypeWheelie )

	self.PointTypeFirstTime = LUI.UITextToImage.new()
	self.PointTypeFirstTime:setLeftRight( false, false, -75, 156 )
	self.PointTypeFirstTime:setTopBottom( false, false, 70, 110 )
	self.PointTypeFirstTime:setPrefix( "ui_mj_hud_letter_" )
	self.PointTypeFirstTime:setAlpha( 0 )
	self.PointTypeFirstTime:setProperties( 1, 15.25, 17.5, 0.6 )
	self.PointTypeFirstTime:setRGB( 0.7, 1, 0.6 )
	self.PointTypeFirstTime:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.PointTypeFirstTime:setText( "FIRST TIME BONUS!", false )
	self:addElement( self.PointTypeFirstTime )

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
				self:setupElementClipCounter( 3 )

				self.PointBG:completeAnimation()
				self.PointBG:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.PointBG:setAlpha( IsCrossCountry() )
				self.PointBG:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.ScoreCount:completeAnimation()
				self.ScoreCount:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.ScoreCount:setAlpha( IsCrossCountry() )
				self.ScoreCount:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.TimeCount:completeAnimation()
				self.TimeCount:beginAnimation( "keyframe", 150, false, false, CoD.TweenType.Linear )
				self.TimeCount:setAlpha( IsCrossCountry() )
				self.TimeCount:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)
			end
		},
		Hidden = {
			DefaultClip = function()
				self:setupElementClipCounter( 3 )

				self.PointBG:completeAnimation()
				self.PointBG:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.PointBG:setAlpha( 0 )
				self.PointBG:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.ScoreCount:completeAnimation()
				self.ScoreCount:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.ScoreCount:setAlpha( 0 )
				self.ScoreCount:registerEventHandler( "transition_complete_keyframe", function( element, event )
					self.clipFinished( element, event )
				end)

				self.TimeCount:completeAnimation()
				self.TimeCount:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.TimeCount:setAlpha( 0 )
				self.TimeCount:registerEventHandler( "transition_complete_keyframe", function( element, event )
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

	if PostLoadFunc then
		PostLoadFunc( self, menu, controller )
	end

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function( element )
		element.PointBG:close()
		element.ScoreCount:close()
		element.TimeCount:close()
		element.PointTypeCounter:close()
		element.PointTypeCounterFake:close()
		element.PointTypeMultiplier:close()
		element.PointTypeNone:close()
		element.PointTypeSmash:close()
		element.PointTypeMonsterSmash:close()
		element.PointTypeCrush:close()
		element.PointTypeDonut:close()
		element.PointTypeAirTime:close()
		element.PointTypeWheelie:close()
		element.PointTypeFirstTime:close()
	end )

	return self
end