// Clock panel
clock = Panel.make(root, 168, 0, 960-168, 640)
clock.title = "Clock"
clock.style.color = "#cc4499"
clock.style.textColor = "#cc88ff"
clock.header = Frame.make(clock, null, clock.top - 200)
clock.header.configure false, true, true, false
Block.make clock.header.leftPanel
Block.make clock.header.bottomPanel
title = InfoBlock.make("CLOCK", clock.header,
	clock.header.right - 200, clock.top - 30, 200, 30)
title.font = largeFont
title.inverted = true

clock.topDisplay = Panel.make(clock, clock.left + 160, clock.header.bottom + 50, 400, clock.header.height - 50)
clock.topDisplay.present = function
	gfx.fillRect self.left, self.bottom, self.width, self.height, color.black
	now = dateTime.val
	y = self.top - largeFont.lineHeight * 3
	x = self.left + 20
	largeFont.print dateTime.str(now, "dddd"), x, y, 2, self.style.textColor
	y = y - largeFont.lineHeight * 2
	largeFont.print dateTime.str(now, "MMMM d, yyyy"), x, y, 1, self.style.textColor
end function

clock.main = Panel.make(clock, clock.left, 0, clock.width, clock.header.bottom)
clock.main.present = function
	gfx.fillRect self.left, self.bottom, self.width, self.height, color.black
	s = dateTime.now.split[1]
	largeFont.printCentered s, self.midX, self.midY - 50, 6, self.style.textColor
	self.curTimeShown = s
end function

clock.onUpdate = function
	s = dateTime.now.split[1]
	if s != self.main.curTimeShown then self.main.present
end function

return clock
