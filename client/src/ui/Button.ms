// Button: a panel that's clickable.
Button = new Panel
Button._name = "Button"
Button.caption = ""
Button.captionFont = mediumFont
Button.sprite = null
Button.action = null
Button.key = ""			// shortcut key (character), or list of keys
Button.keyButton = {}
Button.make = function(caption, parent, left, bottom, width, height)
	p = super.make(parent, left, bottom, width, height)
	p.__isa = self
	p.caption = caption
	if caption.len == 1 then p.key = caption
	return p
end function

Button.checkKey = function(k)
	if not Button.keyButton.hasIndex(k) then return false
	btn = Button.keyButton[k]
	btn.sprite.tint = btn.pressedColor
	wait 0.2
	btn.sprite.tint = btn.color
	btn.action
end function

Button.drawToScratch = function
	scratch.fillRect 0, 0, self.width, self.height, color.white
	globals.gfx = scratch
	self.captionFont.printRight self.caption, self.width-4, 4, 1, color.black
	globals.gfx = display(5)
end function

Button.makeSprite = function
	self.drawToScratch
	if self.sprite == null then self.sprite = new events.EventSprite
	self.sprite.image = scratch.getImage(0, 0, self.width, self.height)
	self.sprite.tint = self.color
	self.sprite.x = self.midX
	self.sprite.y = self.midY
	self.sprite.button = self
	self.sprite.onClick = function; self.button.onClick; end function
	self.sprite.onDrag = function; self.button.onDrag; end function
	self.sprite.onDragEnd = function; self.button.onDragEnd; end function
end function
Button.redrawSprite = function
	if not self.sprite then return
	self.drawToScratch
	self.sprite.image = scratch.getImage(0, 0, self.width, self.height)
end function

Button.present = function
	if self.sprite == null then self.makeSprite
	if not spriteDisp.sprites.contains(self.sprite) then self.sprite.start
	if self.key isa list then
		for k in self.key
			Button.keyButton[k] = self
		end for
	else
		Button.keyButton[self.key] = self
	end if
	super.present
end function

Button.move = function(dx, dy)
	self.left += dx; self.bottom += dy
	if self.sprite then
		self.sprite.x += dx; self.sprite.y += dy
	end if
end function

Button.dismiss = function
	if self.sprite != null then self.sprite.stop
	if self.key isa list then
		for k in self.key
			Button.keyButton.remove k
		end for
	else
		Button.keyButton.remove self.key
	end if
	if self.key then Button.keyButton.remove self.key
	super.dismiss
end function

Button.color = function; return self.style.buttonColor; end function
Button.pressedColor = function
	return color.lerp(self.color, color.black, 0.1)
end function

Button.onClick = function
	self.sprite.tint = self.pressedColor
end function

Button.onDrag = function
	if self.contains(mouse) then
		self.sprite.tint = self.pressedColor
	else
		self.sprite.tint = self.color
	end if
end function

Button.onDragEnd = function
	self.sprite.tint = self.color
	if self.contains(mouse) then self.action
end function

return Button
