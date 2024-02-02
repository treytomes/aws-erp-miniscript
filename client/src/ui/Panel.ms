Panel = {}
Panel._name = "Panel"
Panel.parent = null		// reference to parent
Panel.children = null	// list of children
Panel.left = 0
Panel.bottom = 0
Panel.width = 0
Panel.height = 0
Panel.style = Style
Panel.area = function; return self.width * self.height; end function
Panel.right = function; return self.left + self.width; end function
Panel.top = function; return self.bottom + self.height; end function
Panel.midX = function; return self.left + self.width/2; end function
Panel.midY = function; return self.bottom + self.height/2; end function
Panel.onUpdate = null

Panel.make = function(parent, left, bottom, width, height)
	p = new Panel
	if parent != null then
		parent.addChild p
		if left == null then left = parent.left
		if bottom == null then bottom = parent.bottom
		if width == null then width = parent.right - left
		if height == null then height = parent.top - bottom
		p.style = new parent.style
	end if
	p.left = left
	p.bottom = bottom
	p.width = width
	p.height = height
	p.children = []
	return p
end function

Panel.unparent = function
	if self.parent then self.parent.children.removeVal self
	self.parent = null
end function

Panel.addChild = function(child)
	child.unparent
	child.parent = self
	self.children.push child
end function

Panel.offset = function(dx, dy)
	return Panel.make(self.left + dx, self.bottom + dy, self.width, self.height)
end function

Panel.grow = function(dwidth, dheight)
	return Panel.make(self.left, self.bottom, self.width + dwidth, self.height + dheight)
end function

Panel.setTop = function(newTop, shiftBottom=true)
	if shiftBottom then self.bottom = newTop - self.height else self.height = newTop - self.bottom
end function

Panel.setRight = function(newRight, shiftLeft=true)
	if shiftLeft then self.left = newRight - self.width else self.width = newRight - self.left
end function

Panel.contains = function(pt)
	return pt.x >= self.left and pt.x < self.left + self.width and
	  pt.y >= self.bottom and pt.y < self.bottom + self.height
end function

Panel.debugDraw = function(g)
	if g == null then g = gfx
	g.drawRect self.left, self.bottom, self.width, self.height
	s = mapName(self.__isa)
	g.print s, self.left+3, self.bottom+3, g.color, "small"
	for child in self.children
		child.debugDraw g
	end for
end function

Panel.present = function
	for child in self.children
		child.present
	end for
end function

Panel.dismiss = function
	gfx.fillRect self.left, self.bottom, self.width, self.height, color.black
	for child in self.children
		child.dismiss
	end for
end function

Panel.destroy = function
	for child in self.children
		child.destroy
		child.parent = null
	end for
	children = null
	p = self.parent
	if p then
		self.parent = null
		p.children.removeVal self
	end if
end function

return Panel
