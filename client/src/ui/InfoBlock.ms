// InfoBlock: a block that shows some text
InfoBlock = new Panel
InfoBlock.font = mediumFont
InfoBlock.inverted = false	// if true, draw colored text on black background
InfoBlock.make = function(text, parent, left, bottom, width, height)
	p = super.make(parent, left, bottom, width, height)
	p.__isa = self
	p.text = text
	return p
end function

InfoBlock.present = function
	gfx.color = self.style.infoBlockColor * (not self.inverted) + color.black * self.inverted
	gfx.fillRect self.left, self.bottom, self.width, self.height
	textColor = self.style.infoBlockColor * self.inverted + color.black * (not self.inverted)
	self.font.printCentered self.text, self.midX, self.midY - self.font.lineHeight/2, 1, textColor
end function

return InfoBlock
