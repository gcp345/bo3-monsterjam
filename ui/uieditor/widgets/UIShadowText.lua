CoD.UIShadowText = InheritFrom( LUI.UIElement )

function CoD.UIShadowText.new( menu, controller )
	local self = LUI.UIElement.new()
	self:setClass( CoD.UIShadowText )
	self.id = "UIShadowText"
	self.soundSet = "none"
	self.anyChildUsesUpdateState = true

	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )

	local TextShadow = LUI.UIText.new()
	TextShadow:setRGB( 0.15, 0.15, 0.15 )
	TextShadow:setMaterial( LUI.UIImage.GetCachedMaterial( "sw4_2d_uie_font_cached_glow" ) )
	TextShadow:setTTF( "fonts/morrissans.ttf" )
	-- 1st param is what part it affects (values 0-2) (2 is "inside" of the font (the actual text itself))
	-- 2nd param is the size of the glow
	-- 3rd param is ??? (nothing based off of testing)
	-- 4th param is ??? (nothing based off of testing)
	-- 5th param is ??? (nothing based off of testing)
	TextShadow:setShaderVector(0, 0.2, 0, 0, 0)
	TextShadow:setShaderVector(1, 0.07, 0, 0, 0)
	TextShadow:setShaderVector(2, 0.8, 0, 0, 0) -- This value causes the "inside" of the font to appear, if you set the 1 to 0 you will only see the outline/shadow

	self:addElement( TextShadow )
	self.TextShadow = TextShadow

	local Text = LUI.UIText.new()
	Text:setRGB( 1.0, 1.0, 1.0 )
	Text:setTTF( "fonts/morrissans.ttf" )

	self:addElement( Text )
	self.Text = Text

	self.setText = function( self, text )
		TextShadow:setText( text )
		Text:setText( text )
	end

	self.setTTF = function( self, font )
		TextShadow:setTTF( font )
		Text:setTTF( font )
	end

	self.setRGB = function( self, r, g, b )
		Text:setRGB( r, g, b )
	end

	self.setAlignment = function( self, alignment )
		TextShadow:setAlignment( alignment )
		Text:setAlignment( alignment )
	end

	self.setScale = function( self, scale )
		TextShadow:setScale( scale )
		Text:setScale( scale )
	end

	self.setLeftRight = function( self, la, ra, ln, rn )
		TextShadow:setLeftRight( la, ra, ln + 1, rn + 1 )
		Text:setLeftRight( la, ra, ln, rn )
	end

	self.setTopBottom = function( self, ta, ba, tl, bl )
		TextShadow:setTopBottom( ta, ba, tl + 1, bl + 1 )
		Text:setTopBottom( ta, ba, tl, bl )
	end

	return self
end