require( "UI.SubscriptionUtils" )

CoD.BoostGuageWidget = InheritFrom( LUI.UIElement )
function CoD.BoostGuageWidget.new( menu, controller )

	local self = LUI.UIElement.new()
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )

	self:setUseStencil( false )
	self:setClass( CoD.BoostGuageWidget )
	self.id = "BoostGuageWidget"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self.BgSmk = LUI.UIImage.new()
	self.BgSmk:setLeftRight( false,false,-86.5,168 )
	self.BgSmk:setTopBottom( false,false,4,124 )
	self.BgSmk:setAlpha( 0 )
	self.BgSmk:setRGB( 0.95, 0.26, 0 )
	self.BgSmk:setImage( RegisterImage( "ui_mj_boost_guage_bg_smk" ) )
	self:addElement( self.BgSmk )

	self.Bg = LUI.UIImage.new()
	self.Bg:setLeftRight( false,false,-86.5,168 )
	self.Bg:setTopBottom( false,false,4,124 )
	self.Bg:setAlpha( 1 )
	self.Bg:setImage( RegisterImage( "ui_mj_boost_guage_bg" ) )
	self:addElement( self.Bg )

	self.Bar = LUI.UIImage.new()
	self.Bar:setLeftRight( false,false,-86.5,168 )
	self.Bar:setTopBottom( false,false,4,124 )
	self.Bar:setAlpha( 1 )
	self.Bar:setImage( RegisterImage( "ui_mj_boost_guage_infinite" ) )
	self.Bar:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.Bar:setShaderVector( 0, 1, 0, 0, 0 )
	self.Bar:setShaderVector( 1, 0, 0, 0, 0 )
	self.Bar:setShaderVector( 2, 1, 0, 0, 0 )
	self.Bar:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.Bar )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function( element )
		element.BgSmk:close()
		element.Bg:close()
		element.Bar:close()
	end )

	return self
end