// Swoop: swoopy corner piece for a Frame (below).
Swoop = new Panel
Swoop.which = 0		// 0=top left, 1=top right, 2=bot left, 3=bot right
Swoop.make = function(which, parent, left, bottom, width, height)
	if width == null then width = swoopImages[0].width + 12
	if height == null then height = swoopImages[0].height + 12
	p = super.make(parent, left, bottom, width, height)
	p.__isa = self
	p.which = which
	return p
end function

Swoop.present = function
	gfx.color = self.style.swoopColor
	w = swoopImages[0].width	// (it's OK, they're all the same size)
	h = swoopImages[0].height
	vertWidth = 120
	horzHeight = 32
	if self.which == 0 then			// top left
		gfx.drawImage swoopImages[0], self.left, self.top - h, -1, -1,
			0, 0, -1, -1, gfx.color
		gfx.fillRect self.left, self.bottom, vertWidth, self.height - h
		gfx.fillRect self.left + w, self.top - horzHeight, self.width - w, horzHeight
	else if self.which == 1 then	// top right
		// ToDo
	else if self.which == 2 then	// bottom left
		gfx.drawImage swoopImages[2], self.left, self.bottom, -1, -1,
			0, 0, -1, -1, gfx.color
		gfx.fillRect self.left, self.bottom + h, vertWidth, self.height - h
		gfx.fillRect self.left + w, self.bottom, self.width - w, horzHeight
	else if self.which == 3 then	// bottom right
		// ToDo
	end if		
end function

return Swoop
