require( "UI.SubscriptionUtils" )
require( "ui.lui.LUITextToImage" )

-- move to localized strings but this is for testing purposes only.
local function GetPosString( pos )
	if Dvar.ui_gametype:get() == "eliminator" then
		if pos == 1 then
			return "WINNER!"
		else
			return "ELIMINATED!"
		end
	else
		if pos == 1 then
			return "WINNER!"
		elseif pos == 2 then
			return "SMASHED!"
		elseif pos == 3 then
			return "ANNIHILATED!"
		else
			return "LOSER!"
		end
	end
end

local function PreLoadFunc( self, controller )
	self.disableDarkenElement = true
	self.disableBlur = true
end

-- SoundSet is located in PositionWidget.

LUI.createMenu.EndGameRank = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "EndGameRank" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self.soundSet = "Positions"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	local menu = self
	self.anyChildUsesUpdateState = true

	-- no need to update elements since this is a one and done thing
	self.PositionImage = LUI.UIImage.new()
	self.PositionImage:setLeftRight( false, false, -148, 148 )
	self.PositionImage:setTopBottom( false, false, -248, 8 )
	self.PositionImage:setImage( RegisterImage( "blacktransparent" ) )
	self.PositionImage:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckPos" ), function( model )
		local ModelValue = Engine.GetModelValue( model )
		if ModelValue and ModelValue > 0 then
			self.PositionImage:setImage( RegisterImage( "ui_mj_position_ranks_" .. ModelValue ) )
			self:playSound( "rank" .. ModelValue, controller )
		end 
	end )
	self:addElement( self.PositionImage )

	self.PositionText = LUI.UITextToImage.new()
	self.PositionText:setLeftRight( false, false, -108, 64 )
	self.PositionText:setTopBottom( false, false, 0, 128 )
	self.PositionText:setPrefix( "ui_mj_hud_letter_" )
	self.PositionText:setProperties( 10, 61, 70, 0.6 )
	self.PositionText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.PositionText:setText( "", false )
	self.PositionText:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "MonsterTruckPos" ), function( model )
		local ModelValue = Engine.GetModelValue( model )
		if ModelValue and ModelValue > 0 then
			self.PositionText:setText( GetPosString( ModelValue ), false )
		end 
	end )
	self:addElement( self.PositionText )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.PositionImage:close()
		element.PositionText:close()
	end )

	return self
end