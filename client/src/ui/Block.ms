// Block: a panel that just draws a solid color
Block = new Panel
Block._name = "Block"
Block.make = function(parent, left, bottom, width, height)
	p = super.make(parent, left, bottom, width, height)
	p.__isa = self
	return p
end function

Block.present = function
	gfx.fillRect self.left, self.bottom, self.width, self.height, self.style.blockColor
	super.present
end function

return Block
