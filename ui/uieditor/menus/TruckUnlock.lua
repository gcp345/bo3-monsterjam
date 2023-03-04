local function PreLoadFunc( self, controller )
	self.disableDarkenElement = true
	self.disableBlur = true
end

if not SoundSet.Unlock then
	-- putting this here because we can't creeate this on the fly
	SoundSet.Unlock = {
		list_up = "uin_truck_selection_scroll",
		list_down = "uin_truck_selection_scroll",
		list_left = "uin_truck_selection_scroll",
		list_right = "uin_truck_selection_scroll"
	}
end

-- SoundSet is located in PositionWidget.

LUI.createMenu.TruckUnlock = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "TruckUnlock" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self.soundSet = "Unlock"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	local menu = self
	self.anyChildUsesUpdateState = true

	local bg = LUI.UIImage.new()
	bg:setLeftRight(false,false,-255,255)
	bg:setTopBottom(false,false,-247,262)
	bg:setAlpha(1)
	bg:setImage(RegisterImage("ui_mj_item_unlocked"))
	self:addElement(bg)

	local truckImage = LUI.UIImage.new()
	truckImage:setLeftRight(false,false,-150,150)
	truckImage:setTopBottom(false,false,-150,150)
	truckImage:setAlpha(1)
	truckImage:setImage(RegisterImage("ui_tg_mj_graphics_truck_maxd"))
	self:addElement(truckImage)

	local text = LUI.UIText.new()
	text:setLeftRight(false,false,-500,500)
	text:setTopBottom(false,false,-180,-150)
	text:setAlpha(1)
	text:setText( "NEW TRUCK UNLOCKED!" )
	self:addElement(text)

	return self 
end