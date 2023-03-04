require( "UI.SubscriptionUtils" )
require( "ui.lui.LUITextToImage" )

require( "ui.uieditor.widgets.MonsterJam.EndGameResultsRow")

local function PreLoadFunc( self, controller )
	self.disableDarkenElement = true
	self.disableBlur = true
end

LUI.createMenu.EndGameResults = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "EndGameResults" )

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self.soundSet = "ChooseDecal"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	local menu = self
	self.anyChildUsesUpdateState = true

	self.EndGameList = LUI.UIList.new( menu, controller, 1, 0, nil, false, false, 0, 0, false, false )
	self.EndGameList:setLeftRight( false, false, -400, 400 )
	self.EndGameList:setTopBottom( false, false, -230, 220 )
	self.EndGameList:setWidgetType( CoD.EndGameResultsRow )
	self.EndGameList:setVerticalCount( 6 )
	self.EndGameList:setSpacing( 5 )
	self.EndGameList:setDataSource( "ScoreboardResults" )
	self:addElement( self.EndGameList )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.EndGameList:close()
	end )

	return self
end