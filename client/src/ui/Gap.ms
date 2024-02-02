// Gap: a special panel that represents a flexible gap in a layout of subpanels.
Gap = new Block
Gap._name = "Gap"
Gap.make = function(parent)
	p = super.make(parent)
	p.__isa = self
	return p
end function

// Extending the Panel to use Gaps!
Panel.layout = function
	gapCount = 0
	lastGap = null
	if self.width > self.height then
		// lay out children horizontally
		remainder = self.width - self.style.spacing * (self.children.len - 1)
		for child in self.children
			child.bottom = self.bottom; child.height = self.height
			child.left = 0
			if child.width == null then child.width = self.style.buttonWidth
			if child isa Gap then
				gapCount += 1
				lastGap = child
			else
				remainder -= child.width
			end if
		end for
		perGapWidth = floor(remainder / gapCount)
		gapsLeft = gapCount
		x = self.left
		for child in self.children
			if child isa Gap then
				if gapsLeft == 1 then child.width = remainder else child.width = perGapWidth
				remainder -= perGapWidth
				gapsLeft -= 1
			end if
			child.left = x
			x += child.width + self.style.spacing
		end for		
	else
		// lay out children vertically
		remainder = self.height - self.style.spacing * (self.children.len - 1)
		for child in self.children
			child.left = self.left; child.width = self.width
			child.bottom = 0
			if child.height == null then child.height = self.style.buttonHeight
			if child isa Gap then
				gapCount += 1
				lastGap = child
			else
				remainder -= child.height
			end if
		end for
		perGapHeight = floor(remainder / gapCount)
		gapsLeft = gapCount
		y = self.top
		for child in self.children
			if child isa Gap then
				if gapsLeft == 1 then child.height = remainder else child.height = perGapHeight
				remainder -= perGapHeight
				gapsLeft -= 1
			end if
			child.setTop y
			y -= child.height + self.style.spacing
		end for
	end if
end function

return Gap
