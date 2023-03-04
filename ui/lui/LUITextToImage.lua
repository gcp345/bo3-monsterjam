LUI.UITextToImage = InheritFrom( LUI.UIElement )
LUI.UITextToImage.setPrefix = function ( self, text )
	self.imagePrefix = text
end
LUI.UITextToImage.setProperties = function ( self, count, horizontalSize, verticalSize, spacing )
	if not horizontalSize then
		horizontalSize = 40
	end
	if not verticalSize then
		verticalSize = 40
	end
	if not spacing then
		spacing = 1
	end
	if not self.images then
		self.images = {}
	end
	self.horizontalSize = horizontalSize
	self.verticalSize = verticalSize
	self.spacing = spacing
	if self.images and #self.images > 0 then
		for i = 1, #self.images do
			self.images[ i ]:close()
		end
	end
	for i = 1, count do
		local image = LUI.UIImage.new()
		image:setLeftRight( true, false, ( ( horizontalSize * spacing ) * ( i - 1 ) ), ( horizontalSize * spacing ) * ( i + 1 ) )
		image:setTopBottom( true, false, 0, verticalSize )
		image:setImage( RegisterImage( "blacktransparent" ) )
		self:addElement( image )
		self.images[ i ] = image
	end
end
LUI.UITextToImage.setText = function ( self, str, isLocalizedString )
	if not isLocalizedString then
		isLocalizedString = false
	end
	if not self.images then
		self.images = {}
	end
	local letters = {}
	if isLocalizedString == true then
		for i = 2, string.len( str ) - 1 do
			local letter = string.lower( str:sub( i, i ) )
			letters[ i - 1 ] = letter
		end
	else
		for i = 1, string.len( str ) do
			local letter = string.lower( str:sub( i, i ) )
			letters[ i ] = letter
		end
	end
	if #letters > #self.images then
		self:setProperties( #str, self.horizontalSize or 40, self.verticalSize or 40, self.spacing or 0 )
	end
	for i = 1, #letters do
		local letter = letters[ i ]
		if letter == "!" then
			letter = "exclamation"
		elseif letter == "?" then
			letter = "question"
		elseif letter == "." then
			letter = "period"
		elseif letter == "," then
			letter = "comma"
		elseif letter == ":" then
			letter = "colon"
		elseif letter == "'" then
			letter = "apostrophe"
		elseif letter == '\"' then
			letter = "quotation"
		end

		if not self.imagePrefix then
			self:setPrefix( "uie_t7_hud_letter_" )
		end

		local image = self.imagePrefix .. letter

		if letter == " " then
			self.images[ i ]:setImage( RegisterImage( "blacktransparent" ) )
		elseif image == self.imagePrefix then
			self.images[ i ]:setImage( RegisterImage( "blacktransparent" ) )
		else
			self.images[ i ]:setImage( RegisterImage( image ) )
		end
	end
end
LUI.UITextToImage.close = function ( self )
	if self.images and #self.images > 0 then
		for i = 1, #self.images do
			self.images[ i ]:close()
		end
	end

	self:closeElementInC()
end
LUI.UITextToImage.new = function ( defaultAnimationState )
	local self = LUI.UIElement.new( defaultAnimationState )
	self:setClass( LUI.UITextToImage )
	self.anyChildUsesUpdateState = true

	self.images = {}

	return self
end

LUI.UITextToImage.id = "UITextToImage"