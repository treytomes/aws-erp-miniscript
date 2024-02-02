// Frame: Contains content with swoopy corner(s) and side/top/bottom bars.
// Currently, this always uses a medium-thickness top/bottom (if any),
// a wide left side, and no right.  We can generalize it more later.
Frame = new Panel
Frame.topPanel = null
Frame.leftPanel = null
Frame.bottomPanel = null
Frame.rightPanel = null
Frame.make = function(parent, left, bottom, width, height)
	p = super.make(parent, left, bottom, width, height)
	p.__isa = self
	return p
end function
Frame.configure = function(hasTop, hasBottom, hasLeft=true, hasRight=false)
	if hasTop then
		left = self.left
		if hasLeft then left += self.style.leftBarWidth + self.style.swoopExtra[0]
		right = self.right
		if hasRight then right -= self.style.rightBarWidth + self.style.swoopExtra[0]
		bottom = self.top - self.style.topBarHeight
		self.topPanel = Panel.make(self, left, bottom, right-left, self.style.topBarHeight)
	end if
	if hasBottom then
		left = self.left
		if hasLeft then left += self.style.leftBarWidth + self.style.swoopExtra[0]
		right = self.right
		if hasRight then right -= self.style.rightBarWidth + self.style.swoopExtra[0]
		self.bottomPanel = Panel.make(self, left, self.bottom, right-left, self.style.topBarHeight)
	end if
	if hasLeft then
		top = self.top
		if hasTop then top -= self.style.topBarHeight + self.style.swoopExtra[1]
		bottom = self.bottom
		if hasBottom then bottom += self.style.bottomBarHeight + self.style.swoopExtra[1]
		self.leftPanel = Panel.make(self, self.left, bottom, self.style.leftBarWidth, top-bottom)
	end if
	if hasRight then
		top = self.top
		if hasTop then top -= self.style.topBarHeight + self.style.swoopExtra[1]
		bottom = self.bottom
		if hasBottom then bottom += self.style.bottomBarHeight + self.style.swoopExtra[1]
		left = self.right - self.style.rightBarWidth
		self.rightPanel = Panel.make(self, left, bottom, self.style.rightBarWidth, top-bottom)
	end if
	gap = self.style.spacing
	if hasTop and hasLeft then
		Swoop.make 0, self, self.left, self.leftPanel.top + gap,
			self.topPanel.left - gap - self.left, self.top - self.leftPanel.top - gap
	end if
	if hasBottom and hasLeft then
		Swoop.make 2, self, self.left, self.bottom,
			self.bottomPanel.left - gap - self.left, self.leftPanel.bottom - gap - self.bottom
	end if
end function

return Frame
