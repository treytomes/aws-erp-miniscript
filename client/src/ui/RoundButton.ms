// RoundButton: a button with round endcaps.
// Height should be 24, 32, or 48 for best roundness.
RoundButton = new Button
RoundButton.make = function(caption, parent, left, bottom, width, height)
	p = super.make(caption, parent, left, bottom, width, height)
	p.__isa = self
	return p
end function

RoundButton.drawToScratch = function
	globals.gfx = scratch
	gfx.fillRect 0, 0, self.width, self.height, color.black
	pic = oval24
	if self.height >= 32 then pic = oval32
	if self.height >= 48 then pic = oval48
	pic.draw gfx, 0, 0, self.width, self.height
	self.captionFont.printRight self.caption, self.width-self.height/2, 4, 1, color.black
	globals.gfx = display(5)
end function

return RoundButton
